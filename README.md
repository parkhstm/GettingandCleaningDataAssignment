#####This repository is for the assignment of Getting and Cleaning data lecture.

###List of files in this repo
* README.md : this file, contains list of the files, work flow explaination, and explaination for the script used for analysis.

* CodeBook.md : contains information of the data set. this file indicate all the variables and summaries calculated, along with units, and any other relevant information.

* run_analysis.R : R code file for process the submitted (processed) data from the raw data.

###Brief information on dataset
#####Raw data set
The raw dataset is motion-sensor data for 30 persons doing 6 activities(Walking, Walking up/down stairs, sitting, standing, lying)
This data set had two sub data set. 70% (21 persons) were randomly selected for training set and 30%(9 persons) were selected for test set. A full description of the raw data set is available in [Here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

#####Processed data set
The processed data set (submitted one) is processed raw data set. The test and training data set from the raw data set is **merged**, so this processed data set covers observastions in both test and training set of the raw data set.  Processed data set have **average** value or the processed measurement data of each 30 persons doing each six activities. So, it have 180 rows, which is **30 (persons) by 6 (activities)**. 
The numeric vlaue from column 3 is  the proccessed measurement data. Among the data of the raw data set, the variables for **mean** and **standard deviation** of that each sensor measured are extracted. Because raw data have multiple observations for same person doing same activity, the average of the extracted variables are auqired for the group that has same person and same activity.

###Brief explanation for the process work flow
0. Explanation for each files of raw data
1. Make DataFrame for each Train/Tast set
2. Merging test and training set
3. Extracts mean and standard deviation for each measurement to make new data frame
4. Create second data set with the average of each variable for each activity and each subject from the data set of 3.

###Detail work flow with code explanation
0. Explanation for each files of raw data
 - The measured data is located in X_test.txt and X_train.txt in ./UCI HAR Dataset/test and ./UCI HAR Dataset/train.
 - The Row name, which is the subject(person) is located in subject_test.txt and subject_train in each directories.
 - Activity is coded as number(1~6) in y_test.txt and y_train.txt in each directories.
 - Code and name of activity is explained in './UCI HAR Dataset/activity_labels.txt'.
 - The column name is expained in the file './UCI HAR Dataset/features.txt'.

####1. Make DataFrame for each Train/Tast set
#####1. Read data files.
  1. Name of measurement, activity code and name are coded in seperate file and shared with both test and training set.  
   ```R  
   feature <- read.table("./UCI HAR Dataset/features.txt", stringsAsFactors=F) ##name of measurement(column)
   activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", stringsAsFactors=F) ##activity number(code) and name
   ```  

  2. subject number, activity code for each observation, and measurement data are located in each seperated folder.  
   ```R  
   subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", stringsAsFactors=F) ##subject number of test set
   y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", stringsAsFactors=F) ##activity code of test set
   mdata_test <- read.table("./UCI HAR Dataset/test/X_test.txt", stringsAsFactors=F) ##measured data of test set
   subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", stringsAsFactors=F) ##subject number of train set
   y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", stringsAsFactors=F) ##activity code of train set
   mdata_train <- read.table("./UCI HAR Dataset/train/X_train.txt", stringsAsFactors=F) ##measured data of train set
   ```  

#####2. Make complete data frame with activity name, subject number, and column name.  
  1. Translate numeric activity code to descriptive activity name.  
   ```R  
   activity_test <- activity_labels[match(y_test[,1],activity_labels[,1]),2] #activity name for test set
   activity_train <- activity_labels[match(y_train[,1],activity_labels[,1]),2] #activity name for training set
   ```  

  2.Attach subject number and activity name to measured data.  
   ```R  
   data_test <- data.frame(cbind(subject_test, activity_test, mdata_test))
   data_train <- data.frame(cbind(subject_train, activity_train, mdata_train))
  ```  

  3.Attach column name.  
   ```R  
   colnames(data_test) <- c("subjectnumber","activity",feature[,2])
   colnames(data_train) <- c("subjectnumber","activity",feature[,2])
   ```  

####2. Merging test and training set
  As the data desciption said, data in test set and training set were taken on seperated group of persons. And in the data sets, the subject numbers of these two data sets are not overlapped This can be confirmed by this code`unique(subject_test[,1]);unique(subject_train[,1])`. Moreover, Test set and training set shares same column names. Therefore, I merge the test and training set just by pasting them by rows(`rbind` function).
   ```R
   one_data <- rbind(data_test, data_train) ##one_data : merged data set
   ```

####3. Extracts mean and standard deviation for each measurement to make new data frame
  According to features_info.txt file, the variable that estimate mean and standard deviation from each  measurement has a name contain '**mean()**' of '**std()**'. And there is no variable has same word 'mean()' or 'std()' as a variable name other than variables for mean and standard deviation. Therefore, I extract variables which contain the word 'mean(' and 'std(' by using `grep` function.

  1.Find column numbers which have 'mean' or 'std'.
   ```R
   col_mean <- grep("mean\\(", feature[,2]) +2 ##column number for mean of each measurement.
   col_std <- grep("std\\(", feature[,2]) +2 ##column number for mean of each measurement.
   ##+2 to find number, because I added two column in 'one_data'
   ```
  2.Make new data frame which have subjectnumber, activity, means of measurements, standard deviation of measurements.
   ```R
   new_data <- data.frame(one_data$subjectnumber, one_data$activity, one_data[,col_mean], one_data[,col_std])
   ```
  3.Relabel data frame.
   ```R
   colnames(new_data)[1:2] <- c("subject.number", "activity")
   ```

####4. Creates second data set with the average of each variable for each activity and each subject.
  * Create empty dataframe, and then fill this empty dataframe with average of each measurement.
  * Selection of each activity and each subject (which is 6 by 30) loop function is used.
  * Calcaulation for acerage is done by apply function.

#####1. Create empty dataframe.
   ```R
   second_data <- data.frame(matrix(rep(0, 6*30*ncol(new_data)),ncol=ncol(new_data)))
   ```
#####2. Calculate average for each activity and each subject, then fill above empty data frame.
######1. Create temporary empty vector which get calculated average data during looping function.  
   ```R  
   temp_vector <- rep(0,68) ## temporary vector for recieve calculated average
   ```  
######2. Select each possible combination of subject and activity using loop function, and then calculate average.  
   ```R  
  for (i in 1:6){ ##i=number of activity
   for(j in 1:30){ ##j=number of subject
		      temp_vector[1] <- activity_labels[i,2] ##activity
		      temp_vector[2] <- j ##subject number
		      temp_data <- new_data[which(new_data[,1]==j & new_data[,2]==activity_labels[i,2]),] ##temporary data
	      	temp_vector[3:68] <- apply(temp_data[3:68], 2, mean) ##calculate average
	      	second_data[((i-1)*30)+j,] <- temp_vector ##fill empty data frame
   }
  }
   ```  
#######3. Make new label for average of each measurement.
   * Relabel each column name by adding 'average-'.  
   ```R
   new_label <- paste("average", colnames(new_data)[3:68], "-")
   ```  
######4. Attach column name.
   ```R
   colnames(second_data) <- c("activity","subject",new_label)
   ```  
######5. Write txt file
   ```R
   write.table(second_data, "assignment.txt", sep="\t", row.name=FALSE )
   ```  
   
