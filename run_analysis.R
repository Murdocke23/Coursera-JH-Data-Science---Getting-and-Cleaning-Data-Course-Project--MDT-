#Title: Getting and Cleaning Data Course Project
#Author: Murray Thompson
#Last updated: Sep 17, 2016

#DECRIPTION---------------------------------------------------

#Utilizes data from UCI HAR study found from:
#http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
# The study focused on analyzing movement of 30 subjects while performing 6 activities,
# based on measurements recorded "from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ"
# and subsequently processed for the study.
# this processing resulted in 17 feature vectors, 8 with separate X,Y,and Z directional components, and 9 single-component vectors,
# each with a number of related variables (561 in total)

#This script:
# -combines data from "test" and "train" sets from study into one combined set
# -applies features and activity labels to describe data (based on source documentation from the study)
# -extracts only mean and standard deviation values from the combined set
# -summarizes and exports a new data set providing the average of the extracted values for each combination of subject and activity in the study

#the resulting set is:
#  180 cases: 30 subjects * 6 activities
#  68 variables: subject, activity, and 66 means of feature values 
#            (3*8 XYZ features + 9 other features) * 2 variables (mean and std)



#HELPER FUNCTION TO CRAWL READ TWO SIMILARLY-NAMED FILES AND RETURN A PAIRED LIST OF DATAFRAMES
# is set up to reflect structure of UCI HAR train and test data sets under one root directory
readPairedDatasets <- function (fileRoot, datasetNames, fileName, subRoot) {

    #initialize values
    counter <- 1
    dataframeName <- list()
    
    #set up file path and read data
    for (set in datasetNames) {
      datasetRoot <- paste0(fileRoot, set, subRoot) #set directory (i.e. "UCI HAR Dataset/train/Inertial Signals/")
      
      dataframeName[[counter]] <- paste0(fileName,"_", set) #set name (i.e. "body_gyro_x_train") )

      #set variable dynamically and read in file data
      assign(
        dataframeName[[counter]], 
        read_table(paste0(datasetRoot,fileName,"_",set,".txt"),col_names=FALSE)
      )
      
      counter <- counter + 1
    }
   
    return(list(get(dataframeName[[1]]),get(dataframeName[[2]])))

}


#LOAD REQUIRED LIBRARIES-------------------------------------
#(assumes packages are already installed)
library(readr)
library(data.table)
library(stats)


#GET UCI HAR DATA -------------------------------------

#setup file location variables
datasetsRoot <- "UCI HAR Dataset/"
datasetTypes <- c("train", "test")


#get and combine "main" files within training and test directories into "combined" dataframes
datasetMainFiles <- c("subject","X", "y")

for (file in datasetMainFiles) {
  #get paired data from train and test
  setList <- readPairedDatasets(datasetsRoot, datasetTypes, file, "/")

  #combine paired data from train and test into one dataset
  assign(
    paste0(file,"_combined"),
    rbind(setList[[1]], setList[[2]])
  )
  
  #clean up individual train and test data
  rm(setList)
}


#get and combine "Inertial Signal" files within training and test directories into "combined" dataframes

datasetInertialFiles <- NULL
inertialTypes <- c("body_acc","body_gyro","total_acc")
inertialAxes <- c("x","y","z")
for (iType in inertialTypes) {
  for (iAxis in inertialAxes) {
    newFile <- paste0(iType,"_",iAxis)
    datasetInertialFiles <- c(datasetInertialFiles,newFile)
  }
}

for (file in datasetInertialFiles) {
  #get paired data from train and test
  setList <- readPairedDatasets(datasetsRoot, datasetTypes, file, "/Inertial Signals/")
  
  #combine paired data from train and test into one dataset
  dfName <- paste0(file,"_combined")

  assign(
    dfName,
    rbind(setList[[1]], setList[[2]])
  )
  
  #apply column labels to each Inertial Signal dataset to reflect the type of inertial signal data (to differentiate values when combined)
  measures <- sprintf(paste0(file,"_%03d"),  seq(1,128))
  setnames(get(dfName), measures)
  
  #clean up individual train and test data
  rm(setList)
  
}


#CLEAN UP "Main files" COLUMN LABELS-------------------------------------

#get feature value names
activityCols <- read.delim(paste0(datasetsRoot,"features.txt"),
                           header=FALSE, 
                           sep=" ")[,2]

#clean up value names to make more readable and "R-friendly"
#(parentheses, dashes, and commas in column names sometimes 
# do not play nice with some R functions and aren't required to retain meaning)
# substitutions result in the tpyes of changes:
#  this: "fBodyGyro-mean()-Y" to: "fBodyGyro.mean.Y"
#  this: "angle(X,gravityMean)" to: angle.X_gravityMean
activityCols_cleaned <- gsub(",","_",
                             gsub("\\(|\\-",".",
                                  gsub("\\)","",
                                       gsub("\\(\\)","",
                                            activityCols))))

#apply more descriptive names to columns, based on study details
# **** ALSO: corrects error in study features.txt file, 
# **** repeating "Body" twice in variables for features:
# ****     fBodyAccJerkMag, fBodyGyroMag, and fBodyGyroJerkMag
# ****     (i.e. features.txt file has fBodyBodyAccJerkMag-mean())
#note this does not further affect the "angle" type variables
activityCols_descriptive <- 
  gsub("\\.\\.",".",
  gsub("\\.JerkMag.",".Jerk.Magnitude.",
  gsub("\\.Mag",".Magnitude.",
  gsub("\\.Gyro",".AngularVelocity.",
  gsub("\\.Acc",".Acceleration.",
  gsub("\\.(Body|Gravity)",".\\1.",
  gsub("\\.BodyBody",".Body",
  gsub("^f","frequency.",
  gsub("^t","time.",activityCols_cleaned)))))))))


#apply feature column names
colnames(X_combined) <- activityCols_descriptive

#clean up other main columns
colnames(subject_combined) <- "subject"
colnames(y_combined) <- "activity"




#APPLY DESCRIPTIVE FACTOR TO ACTIVITY VALUES--------------------------------
#get activity label values
activityLabels <- read.delim(paste0(datasetsRoot,"activity_labels.txt"),
                             header=FALSE, 
                             sep=" ")
#apply factor to activities
y_combined$activity <- factor(y_combined$activity, levels=activityLabels[,1], labels=activityLabels[,2])




#COMBINE ALL "COMBINED" DATAFRAMES INTO ONE--------------------------------

#combine all "combined" dataframes into one (as columns with shared rows)
allCombined <- cbind(subject_combined,y_combined, X_combined)

#combine all "combined" dataframes, including intertial raw signal data 
# (including for completeness, but not used further in analysis)
allCombined_withInertial <- cbind(allCombined, 
              total_acc_x_combined, total_acc_y_combined, total_acc_z_combined,
              body_acc_x_combined, body_acc_y_combined, body_acc_z_combined,
              body_gyro_x_combined, body_gyro_y_combined, body_gyro_z_combined
)



#EXTRACT MEANS AND STANDARD DEVIATION VALUES ONLY-------------------------------------
#remove all feature columns not related to mean or standard deviation for the value
#assumptions include: 
#   only the pure 'mean' and 'std' values of each feature is requested, and not 'meanFreq' or 'angle'-type variables that make use of mean values)
#   that this also excludes raw signal data values (that have no identified mean or std values)
allCombined_OnlyMeanStd <- allCombined[, c(TRUE,TRUE,grepl("\\.(mean|std)(\\.|$)", colnames(X_combined)))]




#CREATE INDEPENDENT DATA SET WITH AVERAGES OF VARIABLES-------------------------------
#Assumption is that request "for each activity and each subject"
#is asking for averages related to unique combinations of subject and activity together
#(and not "each subject" and "each activity" independently)
variableAverages_combinedFactors <- aggregate(. ~ subject + activity, 
                     data=allCombined_OnlyMeanStd, 
                     mean)
#export to tab-delimited file
write.table(variableAverages_combinedFactors, "features_mean_and_std_combined_means.txt", sep="\t", row.names = FALSE)





#NOTES AND ALTERNATIVES -------------------------------
#Alternative method to split-apply-combine
#  for average variables for each combination of activity and subject
#  using plyr package:
# 
#library(plyr)
#variableAverages_combinedFactors <- ddply(allCombined_OnlyMeanStd, 
#                                          .(subject, activity), 
#                                          numcolwise(mean))
