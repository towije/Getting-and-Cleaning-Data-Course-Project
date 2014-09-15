rm(list = ls())
library(data.table)

### reading activity anf features labels
actlabs   <- data.table(read.table("UCI HAR Dataset/activity_labels.txt"))
fealabs   <- data.table(read.table("UCI HAR Dataset/features.txt",colClasses = "character"))

### making complete test dataset
test      <- data.table(read.table("UCI HAR Dataset/test/X_test.txt")) # reading features
testYact  <- data.table(read.table("UCI HAR Dataset/test/y_test.txt")) # reading activities
testYsub  <- data.table(read.table("UCI HAR Dataset/test/subject_test.txt")) # reading subjects
testYact[,act:=factor(V1,labels=actlabs$V2)] # adding labels to activities codes
test<-data.table(testYsub,testYact,"S",test) # megring subjects, activities, subset name and features
setnames(test,c("Subject","Activity_code","Activity_name","Set",fealabs$V2)) # naming columns

### making complete train dataset (like above)
train      <- data.table(read.table("UCI HAR Dataset/train/X_train.txt"))
trainYact  <- data.table(read.table("UCI HAR Dataset/train/y_train.txt"))
trainYsub  <- data.table(read.table("UCI HAR Dataset/train/subject_train.txt"))
trainYact[,act:=factor(V1,labels=actlabs$V2)]
train<-data.table(trainYsub,trainYact,"R",train)
setnames(train,c("Subject","Activity_code","Activity_name","Set",fealabs$V2))

### binding test and train datasets
har<-rbind(test,train)

### choosing columns with "mean" or "std" substrings in names
cols<-grep("mean|std",names(har))
### subsetting mean and std dataset
harms<-subset(har,select=c(1:4,cols))

### aggregating features by subject and activity with mean function
harmsa<-harms[,lapply(.SD,mean),by="Subject,Activity_name",.SDcols=5:83]

write.table(harmsa,row.name=FALSE,file="HARMSA.txt")
rm(list=(ls()[ls()!="harmsa"]))
tables()
