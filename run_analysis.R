# This file contains a code for:
#       1. reading Human Activity Recognition data set collected using 
#       smart phone (Smasung) from different files, available here:
#      (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).
#       2. merge into one tidy data set.
#       3. create a text file that give a summary by the mean of each 
#       activity (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, 
#       STANDING, LAYING) and subject (test & train).

### This code written using R version 3.1.1 in RStudio Version 0.98.981  


## Reading files into R:
# -----------------------

# Read features.txt file into testSubTest data frame
features <- read.table("./UCI HAR Dataset/features.txt")

# Read activity_labels.txt file into testSubTest variable
activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt")

# Reading train subject files:
# Read ./train/X_train.txt file into Xtrain data frame
Xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt") # dim(Xtrain): 7352  561
names(Xtrain) <- features$V2 # change columns names by ones in features.txt file

# Reading ./train/y_train.txt file into ytrain data frame
ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt") # dim(ytrain): 7352    1

# Reading ./train/subject_test.txt file into subjectTest data frame
subjectTrain <- read.table("./UCI HAR Dataset/train/subject_train.txt") # dim(subjectTrain): 7352    1

## Reading test subjects files:
# Read ./test/X_train.txt file into Xtrain data frame
Xtest <- read.table("./UCI HAR Dataset/test/X_test.txt") #dim(Xtest): 2947  561
names(Xtest) <- features$V2 # change columns names by ones in features.txt file

# Read ./test/y_train.txt file into ytrain data frame
ytest <- read.table("./UCI HAR Dataset/test/y_test.txt") # dim(ytest): 2947    1

# Read ./test/subject_test.txt file into testSubTest data frame
subjectTest <- read.table("./UCI HAR Dataset/test/subject_test.txt") # dim(subjectTest): 2947    1


# Merges the training and the test sets to create one data set.
# -------------------------------------------------------------
# bind Train Subjects data together
train <- cbind(subjectTrain, ytrain, Xtrain)
# bind Test Subjects data together
test <- cbind(subjectTest, ytest, Xtest)

# bind Test and Train subjects data together
mergedData <- rbind(test, train)

# change the columns' names of the 1st and 2nd columns (subject and activity)
names(mergedData)[1] <- 'subject'
names(mergedData)[2] <- 'activity'

# chanage the activity values to labels using data in activityLabels
mergedData$activity <- factor(mergedData$activity, labels = activityLabels$V2)

# select columns with mean or standard deviation for each measurement
selectedCols <- grep("[Mm]ean|[Ss][Tt][Dd]", names(mergedData))
mergedData2 <- mergedData[, c(1, 2, selectedCols)]


# create a second data set with the average of each variable for each activity 
# and each subject
summarizedData <-aggregate.data.frame(mergedData2[, -c(1:2)], 
                                      by = list(SubjectGroup = mergedData2$subject, 
                                                ActivityGroup = mergedData2$activity), 
                                      subset = 3,
                                      FUN = mean)

# export the data set to text file "summarizedData.txt"
write.table(summarizedData, "summarizedData.txt", row.name = FALSE)