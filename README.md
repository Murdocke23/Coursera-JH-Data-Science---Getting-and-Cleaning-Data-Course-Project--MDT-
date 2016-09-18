This project is a submission for the John Hopkins' Data Science Course "Getting and Cleaning Data" offered through Coursera.

 
Description
=====================================
Utilizes data from UCI HAR study found from:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The study focused on analyzing movement of 30 subjects while performing 6 activities, based on measurements recorded "from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ" and subsequently processed for the study.

This processing resulted in 17 feature vectors, 8 with separate X,Y,and Z directional components, and 9 single-component vectors, each with a number of related variables (561 in total)

The data provided by course instructors can be found here:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip



Assignment Script
====================================

This script:
* combines data from "test" and "train" sets from study into one combined set
* applies features and activity labels to describe data (based on source documentation from the study)
* extracts only mean and standard deviation values from the combined set
* summarizes and exports a new data set providing the average of the extracted values for each combination of subject and activity in the study

The resulting set is:
*  180 cases: 30 subjects * 6 activities
*  68 variables: subject, activity, and 66 means of feature values 
*            (3*8 XYZ features + 9 other features) * 2 variables (mean and std)


Code Book
================================================
In addition 
