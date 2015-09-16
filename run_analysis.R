#download and unzip file into working directory and rename folder
workingdir<-getwd()
filetoload<- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(filetoload, destfile = "./UCI.zip")
unzip("./UCI.zip")
apropos("rename")
file.rename("./UCI HAR Dataset", "./UCI")
setwd("./UCI")

# load (as character) general data & rename columns of activity 
measurementLabels<- read.table("./features.txt")
measurementLabels <- as.character(measurementLabels$V2)
 
activity<- read.table("./activity_labels.txt") 
names(activity)[1] <- "ActivityCode"
names(activity)[2] <- "ActivityDesc"
activity$ActivityDesc <- as.character(activity$ActivityDesc)

#Load the test files
setwd(paste(workingdir, "/UCI/test", sep = ""))
testsubject <- read.table("./subject_test.txt")
testx<- read.table("./x_test.txt")
testlabels<- read.table("./y_test.txt")

# Load the training pieces
setwd(paste(workingdir, "/UCI/train", sep = ""))
trainsubject <- read.table("./subject_train.txt")
trainx<- read.table("./x_train.txt")
trainlabels<- read.table("./y_train.txt")

# combine test and train corresponding files, first test, then train
totallabels<- rbind(testlabels, trainlabels)
totalsubject<- rbind(testsubject, trainsubject)
totalx<- rbind(testx, trainx)

#cleanup files
rm(testx, testlabels, testsubject, trainlabels, trainx, trainsubject)

#rename variables
names(totalsubject)[1] <- "SubjectID"
names(totallabels)[1] <- "ActivityCode"
names(totalx)<-measurementLabels

# cross reference training labels to their activity descriptions and update
nbig<- nrow(totallabels)
nact<- nrow(activity)
ActDesc<- character(length = nbig)

totallabels<- cbind(totallabels, ActDesc)
totallabels$ActDesc<- as.character(totallabels$ActDesc)

#loop through and add description to each row of the code
for(r in 1:nbig) {  #row of big table
  for (a in 1:nact) {
    if (totallabels[r,1] == activity[a,1]) {
      totallabels[r,2] <- activity[a, 2]
    }
  }
}

# tidy up
rm(a, ActDesc, nact, nbig, r)

# 2 Extract only the measurements on the mean and std dev for each measurement

mncol<- grep("[Mm]ean", measurementLabels)
stdcol<- grep("[Ss]td", measurementLabels)
mscol<- sort(c(mncol, stdcol))

# keep only those columns of the data that are Averages or Means
onlyms<- totalx[, mscol]

# create unified data frame with all relevant data
alldata<- cbind(onlyms, totalsubject, totallabels)
alldata$ActivityCode<- NULL

# 5 From the data set in step 4, create a second, 
#   independent tidy data set with the average of each variable 
#   for each activity and each subject

#convert subject ID & activity descriptions to "factors"
alldata$SubjectID<- as.factor(alldata$SubjectID)
alldata$ActDesc<-as.factor(alldata$ActDesc)

tidy <- aggregate(alldata, by=list(Activity = alldata$ActDesc, Subject = alldata$SubjectID), mean)

#drop 2 meaningless columns
tidy$SubjectID <- NULL
tidy$ActDesc <- NULL

# create a text file of the tidy data 
setwd(workingdir)
write.table(tidy, "tidy.txt", row.names = FALSE)