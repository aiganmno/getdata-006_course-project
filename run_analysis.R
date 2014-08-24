## initial data check
data <- read.table("UCI HAR Dataset//features.txt")
str(data)
data <- read.table("UCI HAR Dataset//activity_labels.txt")
str(data)
data <- read.table("UCI HAR Dataset//test//subject_test.txt")
str(data)
data <- read.table("UCI HAR Dataset//test//y_test.txt")
str(data)
data <- read.table("UCI HAR Dataset//test//X_test.txt")
str(data)
data <- read.table("UCI HAR Dataset//test//Inertial Signals//body_acc_x_test.txt")
str(data)
data <- read.table("UCI HAR Dataset//train//subject_train.txt")
str(data)
data <- read.table("UCI HAR Dataset//train//y_train.txt")
str(data)
data <- read.table("UCI HAR Dataset//train//X_train.txt")
str(data)

## reading measurements names and filtering the columns needed
features <- read.table("UCI HAR Dataset//features.txt")
features <- as.character(features[,2])
featureCols <- c(which(grepl("-mean\\(\\)", features)), which(grepl("-std\\(\\)", features)))
featureColsNames <- features[featureCols]

## reading measured activities codes and labels
activities <- read.table("UCI HAR Dataset//activity_labels.txt")
names(activities) <- c("code","label")

## reading test data set
subjectsTest <- read.table("UCI HAR Dataset//test//subject_test.txt")

yTest <- read.table("UCI HAR Dataset//test//y_test.txt")

xTest <- read.table("UCI HAR Dataset//test//X_test.txt")

testData <- cbind(subjectsTest, yTest, xTest[,featureCols])
names(testData) <- c("Subject","Activity",featureColsNames)

## reading train data set
subjectsTrain <- read.table("UCI HAR Dataset//train//subject_train.txt")

yTrain <- read.table("UCI HAR Dataset//train//y_train.txt")

xTrain <- read.table("UCI HAR Dataset//train//X_train.txt")

trainData <- cbind(subjectsTrain, yTrain, xTrain[,featureCols])
names(trainData) <- c("Subject","Activity",featureColsNames)

## merging test and train
allData <- rbind(testData, trainData)

## naming activities
allData$Activity <- factor(allData$Activity, levels = activities$code, labels = activities$label)

## check result data set
str(allData)

## create summary for each subject and activity using mean function to average mesurements
summaryDataSet <- aggregate(allData[,3:66], allData[,1:2], FUN = mean)
## check result
str(summaryDataSet)

## write summary data set to file summaryDataSet.txt
write.table(summaryDataSet, "summaryDataSet.txt", row.name=FALSE)

