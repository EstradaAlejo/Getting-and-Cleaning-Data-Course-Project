
# The goal of this project is to prepare tidy data that can be used for later analysis. For do this, we extracts only the measurements on the mean and standard deviation for each measurement of the raw data. 


## We start reading the features and the activities of the raw data. 
features <- read.table("UCI HAR Dataset/features.txt")  # Read features
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")  #Read activity lebels

``` [R] { Positions <- grep("*mean*|*std*", features[,2])   # Extracts the position of the mean and standard deviation
namesFeatures <- features[Positions,2]     # Select the desired names 
namesFeatures <- gsub('[-()]', '', namesFeatures)
namesFeatures <- gsub('-mean', 'Mean', namesFeatures)
namesFeatures <- gsub('-std', 'Std', namesFeatures) } ```



## Then we read the measurement of the train and the test data files and merged with the activity lebels and the subject for created a tidy data the tidy datas dimension are (7352, 81) for the train data set and (2947 81) for the test data set

trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt") # Read the subject_train
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")   # Read the activities (Y_train)
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")   #Read the train set
x_train <- x_train[Positions]    # Obtain the train set with the desired features
train <- cbind(trainSubjects, trainActivities, x_train)   # Merge


testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt") # Read the subject_test
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt") # Read the test activities (Y_test)
x_test <- read.table("UCI HAR Dataset/test/X_test.txt") #Read the test set
x_test <- x_test[Positions]         # Obtain the test set with the desired features
test <- cbind(testSubjects, testActivities, x_test) # Merge



## Here, we merged the train and the test data set in a unique data frame and assing the names of the columns. The name of the columns are:
### 'subject' 'activity' 'tBodyAccmeanX' 'tBodyAccmeanY' 'tBodyAccmeanZ' 'tBodyAccstdX' 'tBodyAccstdY' 'tBodyAccstdZ' 'tGravityAccmeanX' 'tGravityAccmeanY' 'tGravityAccmeanZ' 'tGravityAccstdX' 'tGravityAccstdY' 'tGravityAccstdZ' 'tBodyAccJerkmeanX' 'tBodyAccJerkmeanY' 'tBodyAccJerkmeanZ' 'tBodyAccJerkstdX' 'tBodyAccJerkstdY' 'tBodyAccJerkstdZ' 'tBodyGyromeanX' 'tBodyGyromeanY' 'tBodyGyromeanZ' 'tBodyGyrostdX' 'tBodyGyrostdY' 'tBodyGyrostdZ' 'tBodyGyroJerkmeanX' 'tBodyGyroJerkmeanY' 'tBodyGyroJerkmeanZ' 'tBodyGyroJerkstdX' 'tBodyGyroJerkstdY' 'tBodyGyroJerkstdZ' 'tBodyAccMagmean' 'tBodyAccMagstd' 'tGravityAccMagmean' 'tGravityAccMagstd' 'tBodyAccJerkMagmean' 'tBodyAccJerkMagstd' 'tBodyGyroMagmean' 'tBodyGyroMagstd' 'tBodyGyroJerkMagmean' 'tBodyGyroJerkMagstd' 'fBodyAccmeanX' 'fBodyAccmeanY' 'fBodyAccmeanZ' 'fBodyAccstdX' 'fBodyAccstdY' 'fBodyAccstdZ' 'fBodyAccmeanFreqX' 'fBodyAccmeanFreqY' 'fBodyAccmeanFreqZ' 'fBodyAccJerkmeanX' 'fBodyAccJerkmeanY' 'fBodyAccJerkmeanZ' 'fBodyAccJerkstdX' 'fBodyAccJerkstdY' 'fBodyAccJerkstdZ' 'fBodyAccJerkmeanFreqX' 'fBodyAccJerkmeanFreqY' 'fBodyAccJerkmeanFreqZ' 'fBodyGyromeanX' 'fBodyGyromeanY' 'fBodyGyromeanZ' 'fBodyGyrostdX' 'fBodyGyrostdY' 'fBodyGyrostdZ' 'fBodyGyromeanFreqX' 'fBodyGyromeanFreqY' 'fBodyGyromeanFreqZ' 'fBodyAccMagmean' 'fBodyAccMagstd' 'fBodyAccMagmeanFreq' 'fBodyBodyAccJerkMagmean' 'fBodyBodyAccJerkMagstd' 'fBodyBodyAccJerkMagmeanFreq' 'fBodyBodyGyroMagmean' 'fBodyBodyGyroMagstd' 'fBodyBodyGyroMagmeanFreq' 'fBodyBodyGyroJerkMagmean' 'fBodyBodyGyroJerkMagstd' 'fBodyBodyGyroJerkMagmeanFreq'

Data <- rbind(train, test)   # Merge train and test dataset
colnames(Data) <- c("subject", "activity", namesFeatures)  # Add the column names
Data$activity <- factor(Data$activity, levels = activity_labels[,1], labels = activity_labels[,2]) #Appropriately
                                                                        #labels the data set with descriptive variable names.
Data$subject <- as.factor(Data$subject) # turn subjects into factors
#write the Data in the file "Data.txt"
write.table(Data, "Data.txt", row.names = FALSE, quote = FALSE)



## The last part of the script is for create a second independient data frame with the mean of each variable for each subject and each activity in the first column and second column respectively.

#Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(reshape2)
melted <- melt(Data, id = c("subject", "activity"))
Means <- dcast(melted, subject + activity ~ variable, mean) 

#write the Data Means in the file "DataMean.txt"
write.table(Means, "DataMean.txt", row.names = FALSE, quote = FALSE)


