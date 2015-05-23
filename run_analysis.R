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
        
        setwd("C://Users//jwhitt01//Documents//jjw//Coursera//03 Getting and Cleaning Data/data")
        
        # Load: activities so that they can be used as labels
        activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]
        
        # Load: feature names so they can be used as data column names
        feature_names <- read.table("./UCI HAR Dataset/features.txt")[,2]
        
        # Generate True/False logicals to denote only the measurements on the mean and standard deviation for each measurement.
        mstd_features <- grepl("mean|std", feature_names)
        
        # Load and process Test data: X_test, y_test, subject_test into data tables for use later
        test_X <- read.table("./UCI HAR Dataset/test/X_test.txt")
        test_Y <- read.table("./UCI HAR Dataset/test/y_test.txt")
        test_Subj <- read.table("./UCI HAR Dataset/test/subject_test.txt")
        
        # Load and process Training data: X_train & y_train data.
        train_X <- read.table("./UCI HAR Dataset/train/X_train.txt")
        train_Y <- read.table("./UCI HAR Dataset/train/y_train.txt")
        train_Subj <- read.table("./UCI HAR Dataset/train/subject_train.txt")        
        
        # Merge Test and Train
        data_x = rbind(test_X, train_X)
        data_y = rbind(test_Y, train_Y)
        data_Subj = rbind(test_Subj, train_Subj)
        
        # Put descriptive names
        names(data_x) = feature_names
        
        # Extract only the measurements on the mean and standard deviation for each measurement.
        data_x = data_x[,mstd_features]        
                
        # Put descriptive activity labels in a second column
        data_y[,2] = activity_labels[data_y[,1]]
        names(data_y) = c("Activity_ID", "Activity_Label")
        names(data_Subj) = "subject"
        
        # Bind data
        data_all <- cbind(as.data.table(data_Subj), data_y, data_x)
        
        # Use Melt to create data in a better format
        id_labels   = c("subject", "Activity_ID", "Activity_Label")
        data_labels = setdiff(colnames(data_all), id_labels)
        melt_data      = melt(data_all, id = id_labels, measure.vars = data_labels)
        
        # Create another independent tidy data set with the average using the mean function to via dcast
        tidy_data   = dcast(melt_data, subject + Activity_Label ~ variable, mean)       
        
        # Write out the tidy_data set to a text file in the working directory
        write.table(tidy_data, file = "./tidy_datav2.txt", row.name=FALSE)
}
