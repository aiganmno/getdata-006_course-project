## Getting and Cleaning Data Course Project Code Book

### Steps performed:

1. Zip file with project data files downloaded from 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip' and extracted in R working directory
Result - folder 'UCI HAR Dataset' with 4 txt files and test and train data folders.

2. Overall manual looking through data, finding which files have test subjects, activities, measurements.
Reading files into R and checking summaries (using `str`) with data types and number of columns.
Findings:
  - File 'features.txt' - measurements names in the order of measurement columns
  - File 'activity_labels.txt' - names, codes of measured activities
  - File 'subject_test.txt' - tested subjects for test and train
  - File 'y_test.txt' - tested activities for test and train
  - File 'X_test.txt' - all the measurements (561) taken, number of measurements matching number of measurements (561) from file 'features.txt'.

3. Extracting necessary measurement columns in order to get only means and standard deviation for each measurement. File 'features.txt' has measurement names, so reading them into `features` variable. As features names is column 2, then getting only that one and using method `grepl` filtering out only columns with names containing required `mean()` and `std()` functions.
As a result 2 variables to be used for data merge later:
  - `featureCols` - vector with column numbers for mean and std measurements
  - `featureColsNames` - character vector with labels for mean and std measurements.
Code for those actions:
```{r}
features <- read.table("UCI HAR Dataset//features.txt")
features <- as.character(features[,2])
featureCols <- c(which(grepl("-mean\\(\\)", features)), which(grepl("-std\\(\\)", features)))
featureColsNames <- features[featureCols]
```

4. As meaningful activities labels will be necessary, reading file 'activity_labels.txt' into table variable - `activities` - for later use as well as labeling this table with meaningful names for easier understanding what is what.
Code:
```{r}
activities <- read.table("UCI HAR Dataset//activity_labels.txt")
names(activities) <- c("code","label")
```

5. Reading test data set into variables:
  - `subjectsTest` - tested subjects
  - `yTest` - tested activities codes
  - `xTest` - measurements taken
Code:
```{r}
subjectsTest <- read.table("UCI HAR Dataset//test//subject_test.txt")
yTest <- read.table("UCI HAR Dataset//test//y_test.txt")
xTest <- read.table("UCI HAR Dataset//test//X_test.txt")
```

6. Creating test data table by column binding all data read in step 5. Using variable `featureCols` from step 3 to get only measurements needed from table `xTest`, as well as using variable `featureColsNames` to assign meaningful labels for the measurements columns.
Code:
```{r}
testData <- cbind(subjectsTest, yTest, xTest[,featureCols])
names(testData) <- c("Subject","Activity",featureColsNames)
```

7. Repeting steps 5 and 6 for training data - as a result getting variable `trainData` with train data table in the same format as test data.
Code:
```{r}
subjectsTrain <- read.table("UCI HAR Dataset//train//subject_train.txt")
yTrain <- read.table("UCI HAR Dataset//train//y_train.txt")
xTrain <- read.table("UCI HAR Dataset//train//X_train.txt")
trainData <- cbind(subjectsTrain, yTrain, xTrain[,featureCols])
names(trainData) <- c("Subject","Activity",featureColsNames)
```

8. Merging variables `testData` and `trainData` to acquire full data set using row bind method into variable `allData`:
```{r}
allData <- rbind(testData, trainData)
```

9. Adjusting `Activities` column in order to show meaningful value with activity name instead of number, using `activities` variable from step 4.
Code:
```{r}
allData$Activity <- factor(allData$Activity, levels = activities$code, labels = activities$label)
```

10. Checking result data set if it matches requirements:
```{r}
str(allData)
```

11. Creating summary by subject and activity data set using `aggregate` function, result into `summaryDataSet` variable and checking result using `str` function.
Code:
```{r}
summaryDataSet <- aggregate(allData[,3:66], allData[,1:2], FUN = mean)
str(summaryDataSet)
```

12. Writing summary data set to file:
```{r}
write.table(summaryDataSet, "summaryDataSet.txt", row.name=FALSE)
```

