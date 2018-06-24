#Peer-graded Assignment: Getting and Cleaning Data Course Project

# merge test and train data 
x_train  <- read.table("./train/X_train.txt")
x_test   <- read.table("./test/X_test.txt")
x_total <- rbind(x_train, x_test)
y_train  <- read.table("./train/Y_train.txt") 
y_test   <- read.table("./test/Y_test.txt") 
y_total <- rbind(y_train, y_test) 
subject_train <- read.table("./train/subject_train.txt")
subject_test <- read.table("./test/subject_test.txt")
subject_total <- rbind(subject_train, subject_test) 
features <- read.table("./features.txt") 
activity_labels <- read.table("./activity_labels.txt") 

#  Find mean and standard deviation items and create final dataset
new_features <- features[grep(".*mean\\(\\)|std\\(\\)", features[,2], ignore.case = FALSE),]
x_total <- x_total[,new_features[,1]]
colnames(x_total)<-new_features[,2]
final <- cbind(y_total,subject_total, x_total)
colnames(final)[1:2] <- c("activity","subject")

# turn activities & subjects into factors 
final$activity <- factor(final$activity, levels = activity_labels[,1], labels = activity_labels[,2]) 
final$subject  <- as.factor(final$subject) 

# create a summary independent tidy dataset from final dataset 
library(dplyr) 
tidydata <- final %>% group_by(activity, subject) %>% summarize_all(funs(mean)) 
write.table(tidydata, file = "./tidydata.txt", row.names = FALSE, col.names = TRUE) 
