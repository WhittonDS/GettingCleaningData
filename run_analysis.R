##run_analysis.R
loadData <- function(){
        
        #You should create one R script called run_analysis.R that does the following. 
        # 1. Merges the training and the test sets to create one data set.
        # 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
        # 3. Uses descriptive activity names to name the activities in the data set
        # 4. Appropriately labels the data set with descriptive variable names. 
        # 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
        
        #install.packages("dplyr")
        library(dplyr)
        #library("data.table")
        #library("reshape2")
        
        setwd("C://Users//jwhitt01//Documents//jjw//Coursera//03 Getting and Cleaning Data/data")
        
        # Load: activities so that they can be used as labels
        activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]
        
        # Load: feature names so they can be used as data column names
        feature_names <- read.table("./UCI HAR Dataset/features.txt")[,2]
        
        # Generate True/False logicals to denote only the measurements on the mean and standard deviation for each measurement.
        mstd_features <- grepl("mean|std", feature_names)
        
        # Load and process X_test, y_test, subject_test into data tables for use later
        test_X <- read.table("./UCI HAR Dataset/test/X_test.txt")
        test_Y <- read.table("./UCI HAR Dataset/test/y_test.txt")
        test_Subj <- read.table("./UCI HAR Dataset/test/subject_test.txt")
        
        names(test_X) = feature_names
        
        # Extract only the measurements on the mean and standard deviation for each measurement.
        test_X = test_X[,mstd_features]
        
        # Load activity labels in a second column
        test_Y[,2] = activity_labels[test_Y[,1]]
        names(test_Y) = c("Activity_ID", "Activity_Label")
        names(test_Subj) = "subject"
        
        # Bind data
        testData <- cbind(as.data.table(test_Subj), test_Y, test_X)
        
        # Load and process train_X & y_train data.
        train_X <- read.table("./UCI HAR Dataset/train/X_train.txt")
        train_Y <- read.table("./UCI HAR Dataset/train/y_train.txt")
        
        train_Subj <- read.table("./UCI HAR Dataset/train/subject_train.txt")
        
        names(train_X) = feature_names
        
        # Extract only the measurements on the mean and standard deviation for each measurement.
        train_X = train_X[,mstd_features]
        
        # Load activity data
        train_Y[,2] = activity_labels[train_Y[,1]]
        names(train_Y) = c("Activity_ID", "Activity_Label")
        names(train_Subj) = "subject"
        
        # Bind data
        trainData <- cbind(as.data.table(train_Subj), train_Y, train_X)
        
        # Merge test and train data
        data = rbind(testData, trainData)
        
        id_labels   = c("subject", "Activity_ID", "Activity_Label")
        data_labels = setdiff(colnames(data), id_labels)
        melt_data      = melt(data, id = id_labels, measure.vars = data_labels)
        
        # Create another independent tidy data set with the average using the mean function to via dcast
        tidy_data   = dcast(melt_data, subject + Activity_Label ~ variable, mean)
        
        # Write out the tidy_data set to a text file in the working directory
        write.table(tidy_data, file = "./tidy_data.txt", row.name=FALSE)
}
