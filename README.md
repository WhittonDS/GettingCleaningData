# GettingCleaningData


        Set the working directory
        
        Load: activities so that they can be used as labels
        Load: feature names so they can be used as data column names
        Generate True/False logicals to denote only the measurements on the mean and standard deviation for each measurement.
        
        On the test data:
                
                Load and process X_test, y_test, subject_test into data tables for use later
                Extract only the measurements on the mean and standard deviation for each measurement.
                test_X = test_X[,mstd_features]
                Load activity labels in a second column
                Bind data

        On the training data:
                Load and process train_X & y_train data.
                Extract only the measurements on the mean and standard deviation for each measurement.
                Load activity data
                Bind data
                Merge test and train data
                
        Create another independent tidy data set with the average using the mean function to via dcast
        Write out the tidy_data set to a text file in the working directory
