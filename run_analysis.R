##Downlaoded unzipped raw dataset folder(UCI HAR Dataset) is under working directory

##====================================##
##Make DataFrame for each Train/Tast set
##====================================##
####the measured data is located in X_test.txt and X_train.txt in ./UCI HAR Dataset/test and ./UCI HAR Dataset/train
####the Row name, which is the subject(person) is located in subject_test.txt and subject_train in each directories
####Activity is coded as number(1~6) in y_test.txt and y_train.txt in each directories
####Code and name of activity is explained in './UCI HAR Dataset/activity_labels.txt'
####The column name is expained in the file './UCI HAR Dataset/features.txt'

###1.read datas
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


##===========================##
##Merging test and training set
##===========================##
####As the data desciption said, data in test set and training set were taken on seperated group of persons.
####And in the data sets, the subject numbers of these two data sets are not overlapped
#######This can be confirmed by this code : unique(subject_test[,1]);unique(subject_train[,1])
####Moreover, Test set and training set shares same column names.
####Therefore, I merge the test and training set just by pasting them by rows(rbind function).
one_data <- rbind(data_test, data_train) ##one_data : merged data set


##=======================================================##
##Extracts mean and standard deviation for each measurement
##=======================================================##
####According to features_info.txt file, the variable that estimate mean and standard deviation from each  measurement
####has a name contain 'mean()' of 'std()'. 
####And there is no variable has same word{'mean()' or 'std()'} as a variable name other than variables for mean and 
####standard deviation.
####Therefore, I extract variables which contain the word 'mean(' and 'std(' by using grep function.

###1.Find column numbers which have 'mean' or 'std'
col_mean <- grep("mean\\(", feature[,2]) +2 ##column number for mean of each measurement.
col_std <- grep("std\\(", feature[,2]) +2 ##column number for mean of each measurement.
##+2 to find number, because I added two column in 'one_data'

###2.Make new data frame which have subjectnumber, activity, means of measurements, standard deviation of measurements
new_data <- data.frame(one_data$subjectnumber, one_data$activity, one_data[,col_mean], one_data[,col_std])

###3.Relabel data frame
colnames(new_data)[1:2] <- c("subject.number", "activity")


##===========================================================================================##
##creates second data set with the average of each variable for each activity and each subject.
##===========================================================================================##
####create emptu dataframe, and then fill this empty dataframe with average of each measurement.
####select of each activity and each subject (which is 6 by 30) loop function is used.
####calcaulation for acerage is done by apply function.

###1.Create empty dataframe
second_data <- data.frame(matrix(rep(0, 6*30*ncol(new_data)),ncol=ncol(new_data)))

###2.calculate average for each activity and each subject, then fill above empty data frame
temp_vector <- rep(0,68) ## temporary vector for recieve calculated average

for (i in 1:6){ ##i=number of activity
	for(j in 1:30){ ##j=number of subject
		temp_vector[1] <- activity_labels[i,2] ##activity
		temp_vector[2] <- j ##subject number
		temp_data <- new_data[which(new_data[,1]==j & new_data[,2]==activity_labels[i,2]),] ##temporary data
		temp_vector[3:68] <- apply(temp_data[3:68], 2, mean) ##calculate average
		second_data[((i-1)*30)+j,] <- temp_vector ##fill empty data frame
	}
}

###4.Make new label for average of each measurement
new_label <- paste("average", colnames(new_data)[3:68], "-")

###5.attach column name
colnames(second_data) <- c("activity","subject",new_label)

