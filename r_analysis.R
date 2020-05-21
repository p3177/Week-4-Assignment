#reading data from training set
xtrain = read.table(file.path("UCI HAR Dataset", "train", "X_train.txt"),header = FALSE)
ytrain = read.table(file.path("UCI HAR Dataset", "train", "y_train.txt"),header = FALSE)
subject_train = read.table(file.path("UCI HAR Dataset", "train", "subject_train.txt"), header = FALSE)

#reading data from testing set
xtest= read.table(file.path("UCI HAR Dataset", "test", "X_test.txt"),header = FALSE)
ytest = read.table(file.path("UCI HAR Dataset", "test", "y_test.txt"),header = FALSE)
subject_test = read.table(file.path("UCI HAR Dataset", "test", "subject_test.txt"), header = FALSE)

#reading features
features = read.table(file.path("UCI HAR Dataset", "features.txt"),header = FALSE)

#reading activity labels
activityLabels = read.table(file.path("UCI HAR Dataset", "activity_labels.txt"),header = FALSE)

#Assigning names to columns of training data
colnames(xtrain) = features[,2]
colnames(ytrain) = "activityId"
colnames(subject_train) = "subjectId"

#Assigning names to columns of testing data
colnames(xtest) = features[,2]
colnames(ytest) = "activityId"
colnames(subject_test) = "subjectId"
colnames(activityLabels) <- c('activityId','activityType')

#Merging the train and test data 
mrg_train = cbind(ytrain, subject_train, xtrain)
mrg_test = cbind(ytest, subject_test, xtest)

#Creating the main data table merging both tables
setAllInOne = rbind(mrg_train, mrg_test)

#selecting mean and standard deviation values
colNames = colnames(setAllInOne)
mean_and_std = (grepl("activityId" , colNames) | grepl("subjectId" , colNames) | grepl("mean.." , colNames) | grepl("std.." , colNames))
setForMeanAndStd <- setAllInOne[ , mean_and_std == TRUE]
setWithActivityNames = merge(setForMeanAndStd, activityLabels, by='activityId', all.x=TRUE)

# New tidy set has to be created 
secTidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]

#The last step is to write the ouput to a text file 
write.table(secTidySet, "TidyDataSet.txt", row.name=FALSE)



