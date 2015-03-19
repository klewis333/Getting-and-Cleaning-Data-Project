setwd("C:/Users/Karyn/Dropbox/Data Science/R stuff/Getting and Cleaning Data Project")

#Indicates where files are located
proj_files <- file.path("C:/Users/Karyn/Dropbox/Data Science/R stuff/Getting and Cleaning Data Project/UCI HAR Dataset")

#Input the relevant data files as tables
dataActivityTest  <- read.table(file.path(proj_files, "test" , "Y_test.txt" ),header = FALSE)
dataActivityTrain <- read.table(file.path(proj_files, "train", "Y_train.txt"),header = FALSE)

dataSubjectTrain <- read.table(file.path(proj_files, "train", "subject_train.txt"),header = FALSE)
dataSubjectTest  <- read.table(file.path(proj_files, "test" , "subject_test.txt"),header = FALSE)

dataFeaturesTest  <- read.table(file.path(proj_files, "test" , "X_test.txt" ),header = FALSE)
dataFeaturesTrain <- read.table(file.path(proj_files, "train", "X_train.txt"),header = FALSE)

#Merge rows for same variable type
dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataActivity<- rbind(dataActivityTrain, dataActivityTest)
dataFeatures<- rbind(dataFeaturesTrain, dataFeaturesTest)

#name the variables in the concatenated files
names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
dataFeaturesNames <- read.table(file.path(path_rf, "features.txt"),head=FALSE)
names(dataFeatures)<- dataFeaturesNames$V2

#merge all data into a data frame
dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)

#Extract means and sds for each measure and subset data by selected aspects
subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]

selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)

activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)

#Give vars names with descriptive titles
names(Data)<-gsub("^t", "Time", names(Data))
names(Data)<-gsub("^f", "Frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

#tidy things up with a small cleaned data set
library(plyr);
TidyData<-aggregate(. ~subject + activity, Data, mean)
TidyData<-TidyData[order(TidyData$subject,TidyData$activity),]
write.table(TidyData, file = "tidydata.txt",row.name=FALSE)




