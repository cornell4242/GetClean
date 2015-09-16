---
title: "[Getting and Cleaning Data](https://www.coursera.org/course/getdata) Project"
output: html_document
---
## Overview
The purpose of this project is to demonstrate the ability to collect, work with, and clean a data set.
The data linked from the course website represent data collected from the accelerometers from the 
Samsung Galaxy S smartphone. 

Full description available from source: [UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)<p>

[Source of data used for this analysis](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

### Contents of Github repository
* __README.md__: General overview of the project and explanation of how script works, and creates the tidy data set
* __CodeBook.md__: Detailed information about raw and tidy data sets, and details of the cleaning, as well as the creation of the tidy data set
* __run_analysis.R__: R script Which performs the cleaning of the raw data, and creates the tidy data set.
* __tidy.txt__: the resulting independent, tidy data set with the average of each variable for each activity and each subject

## How the R script (run_analysis.R) works
1.  Downloads, unzips and renames source files to working directory from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
2.  Loads key data tables and vectors:  measurement variable labels, activity key 
3.  Loads raw test data (2947 observations) as 3 data tables: (1) subject tested, (2) activity performed, (3) data measurements 
4.  Loads raw training data (7352 observations) as 3 data tables: (1) subject tested, (2) activity performed, (3) data measurements 
5.  Combines test and training tables into 3 respective "total" data tables
5.  Creates meaningful variable names for all variables
6.  Cross references activity code to activity descriptions, and adds descriptive variable to total activity data table
7.  Subsets total data measurement file to include only variables containing  mean ("mean") or standard deviation ("std") in variable descriptions - resulted in 86 variables
8.  Creates "alldata" - a single, unified data frame (cbind) for all 10299 observations containing:  subject ID, Activity, Mean and Standard Deviation variables <u>(a total of 88 variables)</u>
9.  Creates separate "tidy" data set from "alldata" as described in next section

### General description of tidy data set creation

1. Converts subject ID & activity description variables to variable type "factor"
2. Using "alldata", creates "tidy" data set which finds the mean of each numeric variable, aggregating based on each unique Subject ID + Activity
3. Writes the "tidy" data frame to a text file called <u>tidy.txt</u>, which is saved in the working directory  