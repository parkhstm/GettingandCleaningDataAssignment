###This is CodeBook

####Brief information on dataset
#####Raw data set
The raw dataset is motion-sensor data for 30 persons doing 6 activities(Walking, Walking up/down stairs, sitting, standing, lying)
70% (21 persons) were randomly selected for training set and 30%(9 persons) were selected for test set.
A full description of the raw data set is available in [Here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

#####Processed data set
The processed data set (submitted one) is processed raw data set. processed data set have average value or the processed measurement data of each 30 persons doing each six activities. So, it have 180 rows, which is 30 (persons) by 6 (activities). 
The numeric vlaue from column 3 is  the proccessed measurement data. Among the data of the raw data set, the variables for mean and standard deviation of that each sensor measured are extracted. Because raw data have multiple observations for same person doing same activity, the average of the extracted variables are auqired for the group that has same person and same activity.

