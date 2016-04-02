###This is CodeBook, Please read README.txt first!!

####Explanation for first two column name  
* activity : name of activity, 6 activities, LAYING, SITTING, STANDING, WALKING, WALKING_DOWNSTAIRS, WALKING_UPSTAIRS  
* subject.number : number of subject, unit = person, 1~30  

####Explanation for the columns from the third  
Theses columns have processed measurment data for motion sensor. Information about data process is in README.txt file, and Information for raw data is in [here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)  
* All columns after third column have a name start with 'average-' this means that these columns values are average of the measurement data in the raw data.  
* second portion of the names are information about the sensor and its preprocessing, to know about these information, read features_info.txt file.

* Some column names(below) have -x, -y, or -z after second part of their name. this mean x-axis, y-axis, and z- axis.
   * tBodyAcc, tGravityAcc, tBodyAccJerk, tBodyGyro,  tBodyGyroJerk, fBodyAcc, fBodyAccJerk, fBodyGyro.  
   *Following variables don't have this part : tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag, fBodyAccMag, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag.  

* The last part of the names means its origin in raw data.
   * mean(): Mean value of the measured data in raw data. so the values in this column are average of mean.  
   * std(): Standard deviation of the measured data in raw data. so the values in this column are average of standard deviation.
