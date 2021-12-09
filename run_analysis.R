

features <- read.table("UCI HAR Dataset/features.txt")  # Read features
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")  #Read activity lebels


Positions <- grep("*mean*|*std*", features[,2])   # Extracts the position of the mean and standard deviation
namesFeatures <- features[Positions,2]     # Select the desired names 
namesFeatures <- gsub('[-()]', '', namesFeatures)
namesFeatures <- gsub('-mean', 'Mean', namesFeatures)
namesFeatures <- gsub('-std', 'Std', namesFeatures)


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


Data <- rbind(train, test)   # Merge train and test dataset
colnames(Data) <- c("subject", "activity", namesFeatures)  # Add the column names


Data$activity <- factor(Data$activity, levels = activity_labels[,1], labels = activity_labels[,2]) #Appropriately
                                                                          #labels the data set with descriptive variable names.
Data$subject <- as.factor(Data$subject) # turn subjects into factors


#write the Data in the file "Data.txt"
write.table(Data, "Data.txt", row.names = FALSE, quote = FALSE)



#Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(reshape2)
melted <- melt(Data, id = c("subject", "activity"))
Means <- dcast(melted, subject + activity ~ variable, mean) 

#write the Data Means in the file "DataMean.txt"
write.table(Means, "DataMean.txt", row.names = FALSE, quote = FALSE)
