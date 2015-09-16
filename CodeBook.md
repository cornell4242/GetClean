Code Book
========

This codebook describes the variables, the raw data, and transformations performed to clean up the raw data to create the resulting file, <i><b>tidy.txt</b></i>.

### Data Source

Raw data were obtained from [UCI Machine Learning Repository's](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) <i><b>Human Activity Recognition Using Smartphones</b></i> data set.

Data was collected from a group of 30 volunteers (subjects) between the ages of 19 and 48.  
Each subject performed six activities while wearing a smartphone (Samsung Galaxy S II) on the waist:

* WALKING
* WALKING_UPSTAIRS
* WALKING_DOWNSTAIRS
* SITTING
* STANDING
* LAYING

Using its embedded accelerometer and gyroscope, data was captured for 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

Each observation in the data set captures:

* Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration. 
* Triaxial Angular velocity from the gyroscope. 
* A 561-feature vector with time and frequency domain variables. 
* Activity label. 
* Identifier of the subject who carried out the experiment.

The set of variables that were estimated from these signals are: 

*  mean(): Mean value
*  std(): Standard deviation
*  mad(): Median absolute deviation 
*  max(): Largest value in array
*  min(): Smallest value in array
*  sma(): Signal magnitude area
*  energy(): Energy measure. Sum of the squares divided by the number of values. 
*  iqr(): Interquartile range 
*  entropy(): Signal entropy
*  arCoeff(): Autoregression coefficients with Burg order equal to 4
*  correlation(): Correlation coefficient between two signals
*  maxInds(): Index of the frequency component with largest magnitude
*  meanFreq(): Weighted average of the frequency components to obtain a mean frequency
*  skewness(): Skewness of the frequency domain signal 
*  kurtosis(): Kurtosis of the frequency domain signal 
*  bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
*  angle(): Angle between some vectors.

No unit of measures is reported as all features were normalized and bounded within [-1,1].

### Raw Data Files
The data set was randomly partitioned into two sets, where 70% of the volunteers were selected for generating the training data and the remaining 30% the test data.

The raw data set used in this data "scrubbing" consists of a zipped file containing:

- 'README.txt'
- 'features_info.txt': Shows information about the variables used on the feature vector.
- 'features.txt': List of all variables measured in X_train and test
- 'activity_labels.txt': Links the class labels with their activity name.
- 'train/X_train.txt': Training set.
- 'train/y_train.txt': Training labels.
- 'subject_train.txt': Training subject identifiers for each training observation
- 'test/X_test.txt': Test set.
- 'test/y_test.txt': Test labels.
- 'subject_test.txt': Test subject identifiers for each test observation 

<i> Note:  Though there are several other folders containing more granular data in the data set, it was not used in this transformation, and is therefore undocumented.</i>

### Measurement Units

* Units used for the accelerations (total and body) are 'g's (gravity of earth -> 9.80665 m/seg2).
* Gyroscope units are rad/seg.

Data transformation
-------------------

The run_analysis.R script processes the raw data files to create a tidy data
set by performing the following:

### 1. Download, unzip and rename raw data set folder
### 2. Load variable name (features) vector, and activity key
      * create measurementLabels vector from "features.txt"
      * create activity dataframe from "activity_labels.txt" (renaming variables meaningfully)

### 3. Load and merge training and test sets; rename variables meaningfully
      *  merge X_test and X- training data to create totalx
      *  merge y_test and y_training data to create totallabels
      *  merge subject_test and subject_training data to create totalsubject
      *  assign measurementLabels to totalx columns (variables)
      *  assign meaningful variable names to totalsubject and totallabels data frames
      
### 4. Add variable to totallabels, with description of ActivityCode
      *  cross reference totallabels to their activity descriptions in activity data frame
      *  add ActDesc variable to totallabels data frame
      *  for each observation, cross reference activity label and write corresponding activity description to the observation

### 5.  Extract ONLY "mean" and "standard deviation" columns from totalx
      *  Select only data variables (columns) containing "Mean" or "Std" from totalx
      *  create data frame <u>onlyms</u> containing subset of the full totalx columns 

### 6. Merge resulting onlyms, totalsubject, and totallabels 
      *  create "alldata" by executing cbind on (onlyms, totalsubject, and totallabels)
      *  delete the activity code column "alldata" since the descriptive activity column ActDesc already exists in the data frame
      
### 7. Create a tidy data set from the data frame "alldata"
      *  convert SubjectID and ActDesc columns into factor type date
      *  compute mean of all numeric variables by combined (SubjectID and ActDesc) using the aggregate function 
      *  save result to "tidy" data frame, and eliminate the 2 NA-filled columns
      *  resulting "tidy" contains 180 observations, and 88 variables

### 8. Create "tidy.txt"
      *  from the "tidy" data frame, create a "tidy.txt" file 
      *  write it to the working directory
 