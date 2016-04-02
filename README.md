#####This repository is for the assignment of Getting and Cleaning data lecture.

###List of files in this repo
*README.md : this file, contains list of the files, work flow explaination, and explaination for the script used for analysis.

*CodeBook.md : contains information of the data set. this file indicate all the variables and summaries calculated, along with units, and any other relevant information

*run_analysis.R : R code file for process the submitted (processed) data from the raw data

###Brief information on dataset
#####Raw data set
The raw dataset is motion-sensor data for 30 persons doing 6 activities(Walking, Walking up/down stairs, sitting, standing, lying)
This data set had two sub data set. 70% (21 persons) were randomly selected for training set and 30%(9 persons) were selected for test set. A full description of the raw data set is available in [Here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

#####Processed data set
The processed data set (submitted one) is processed raw data set. The test and training data set from the raw data set is merged, so this processed data set covers observastions in both test and training set of the raw data set.  Processed data set have average value or the processed measurement data of each 30 persons doing each six activities. So, it have 180 rows, which is 30 (persons) by 6 (activities). 
The numeric vlaue from column 3 is  the proccessed measurement data. Among the data of the raw data set, the variables for mean and standard deviation of that each sensor measured are extracted. Because raw data have multiple observations for same person doing same activity, the average of the extracted variables are auqired for the group that has same person and same activity.

###Brief explanation for the process work flow
1. Make DataFrame for each Train/Tast set
2. Merging test and training set
3. Extracts mean and standard deviation for each measurement
4. Create date set from extracted data 
5. Create second data set with the average of each variable for each activity and each subject from the data set of 4.

###Detail work flow with code explanation
1. Make DataFrame for each Train/Tast set
  *Explanation for each files of raw data
  -The measured data is located in X_test.txt and X_train.txt in ./UCI HAR Dataset/test and ./UCI HAR Dataset/train
  -The Row name, which is the subject(person) is located in subject_test.txt and subject_train in each directories
  -Activity is coded as number(1~6) in y_test.txt and y_train.txt in each directories
  -Code and name of activity is explained in './UCI HAR Dataset/activity_labels.txt'
  -The column name is expained in the file './UCI HAR Dataset/features.txt'
 1.read data
feature <- read.table("./UCI HAR Dataset/features.txt", stringsAsFactors=F) ##column name
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", stringsAsFactors=F) ##activity number(code) and name
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", stringsAsFactors=F) ##subject number of test set
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", stringsAsFactors=F) ##activity code of test set
mdata_test <- read.table("./UCI HAR Dataset/test/X_test.txt", stringsAsFactors=F) ##measured data of test set
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", stringsAsFactors=F) ##subject number of train set
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", stringsAsFactors=F) ##activity code of train set
mdata_train <- read.table("./UCI HAR Dataset/train/X_train.txt", stringsAsFactors=F) ##measured data of train set

###2.Make complete data frame with activity name, subject number, and column name
####translate numeric activity code to descriptive activity name
activity_test <- activity_labels[match(y_test[,1],activity_labels[,1]),2]
activity_train <- activity_labels[match(y_train[,1],activity_labels[,1]),2]
####attach subject number and activity name to measured data
data_test <- data.frame(cbind(subject_test, activity_test, mdata_test))
data_train <- data.frame(cbind(subject_train, activity_train, mdata_train))
####attach column name
colnames(data_test) <- c("subjectnumber","activity",feature[,2])
colnames(data_train) <- c("subjectnumber","activity",feature[,2])

2. Merging test and training set
3. Extracts mean and standard deviation for each measurement
4. Create date set from extracted data 
5. Create second data set with the average of each variable for each activity and each subject from the data set of 4.
