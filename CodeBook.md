
Original Study Data
=======================================
The original UCI HAR study was based on accelerometer and gyroscope signals measured by devices worn by 30 volunteers while performing a number of activities over a certain timeframe, with data from each volunteer randomly separated into either a "test" or a "train" data set.

The data from the measurements was processed, producing a large number of feature variables - 561 for each data case.

The original raw inertial signals data, processed data variables, and feature descriptions are available in the "UCI HAR Dataset" directory of this project.


Transformed Study Data
=======================================
This project's script modifies the original study data into a new data set that:
* combines separate "train" and "test" datasets into a single "combined" dataset
* adds more descriptive labels to feature data, as well as descriptive factor values for activity data
* extracts mean and standard deviation values from the combined dataset
* summarizes and exports a new data set providing the average of the extracted values for each combination of subject and activity in the study

The final output represents the mean values of original feature data for all combinations of subjects and activities. Each element is explained more below.


Subject Data
=======================================
Subject numbers indicate individual volunteers participating in the original study, with IDs ranging from 1 to 30.


Activity Data
======================================
Six distinct activities were recorded by the study:
* Walking
* Walking upstairs
* Walking downstairs
* Sitting
* Standing
* Laying


Feature Data 
=================
The original processed data included 561 feature variables for each inertial measurement case. 

This project simplified the set to 66 feature variables -mean and standard deviation of each feature only - and instead of retaining all measurement cases, provides the mean value of those variables for each combination of subject and activity values.

*Original Feature Data*
Original processed study was based on a combination of features with separate X,Y, and Z axis components (8 in total) and those as single values (9 in total)

From the original study README documentation:
--------------------------
>The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

>Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

>Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

>These signals were used to estimate variables of the feature vector for each pattern:  
>'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

---------------------------

The original data also included 5 additional variables that averaged signal sample data, but were not retained for this project's output.

To help increase readability, original variable names were transformed to include more descriptive text based on study information.
**The feature names (followed by their their original feature names in parentheses) are:**
* Time-based features:
** those with separate X,Y,Z components:
*** time.Body.Acceleration (tBodyAcc)
*** time.Gravity.Acceleration (tGravityAcc)
*** time.Body.Acceleration.Jerk (tBodyAccJerk)
*** time.Body.AngularVelocity (tBodyGyro)
*** time.Body.AngularVelocity.Jerk (tBodyGyroJerk)
** those as singular components:
*** time.Body.Acceleration.Magnitude  (tBodyAccMag)
*** time.Gravity.Acceleration.Magnitude (tGravityAccMag)
*** time.Body.Acceleration.Jerk.Magnitude (tBodyAccJerkMag)
*** time.Body.AngularVelocity.Magnitude (tBodyGyroMag)
*** time.Body.AngularVelocity.Jerk.Magnitude (tBodyGyroJerkMag)

*Frequency-based features:
** those with separate X,Y,Z components:
*** frequency.Body.Acceleration (fBodyAcc)
*** frequency.Body.Acceleration.Jerk (fBodyAccJerk)
*** frequency.Body.AngularVelocity (fBodyGyro)
** those as singular components:
*** frequency.Body.Acceleration.Magnitude (fBodyAccMag)
*** frequency.Body.Acceleration.Jerk.Magnitude (fBodyAccJerkMag)
*** frequency.Body.AngularVelocity.Magnitude (fBodyGyroMag)
*** frequency.Body.AngularVelocity.Jerk.Magnitude (fBodyGyroJerkMag)

_Note:_
_The last three features were incorrectly named in the original study's features.txt file (duplicating "Body" in each variable name, and also corrected for when transforming the feature labels to more descriptive labels_

**Feature variables**
The original data set included a set of 17 variables related to each feature, some with separate levels. 

Of the original variables, only two were retained:
* mean
* standard deviation

In the original data, these appeared as "mean()" and "std()" within the feature variable names. In the output data of this project, they appear as as suffixes ".mean" and ".std" added onto to each related feature name, respectively.
(i.e. "time.Body.Acceleration" is represented by "time.Body.Acceleration.mean" and "time.Body.Acceleration.std"  

The values in the output data also represent averages of those feature variables for each subject-activity group.




