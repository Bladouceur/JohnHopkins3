# John Hopkins Course 3 Cleaning Data
# June 2018, Benoit Ladouceur
rm(list=ls()) # clean workspace
# First we need to merge the 2 datasets that were provided


X_train <- read.table("C:/Users/benoi/Documents/FUCIHAR/Dataset/train/X_train.txt")
y_train <- read.table("C:/Users/benoi/Documents/FUCIHAR/Dataset/train/y_train.txt")
subject_train <- read.table("C:/Users/benoi/Documents/FUCIHAR/Dataset/train/subject_train.txt")

X_test <- read.table("C:/Users/benoi/Documents/FUCIHAR/Dataset/test/X_test.txt")
y_test <- read.table("C:/Users/benoi/Documents/FUCIHAR/Dataset/test/y_test.txt")
subject_test <- read.table("C:/Users/benoi/Documents/FUCIHAR/Dataset/test/subject_test.txt")

# merge dataset X
x_all <- rbind(X_train, X_test)

# merge dataset y
y_all <- rbind(y_train, y_test)

# merge dataset X
subject_all <- rbind(subject_train, subject_test)

### Extract the mean and sd for each measurement.

features <- read.table("C:/Users/benoi/Documents/FUCIHAR/Dataset/features.txt")

# use grep to get the column number of the features which contains std or mean
features_mean_std <- grep("std|mean\\(\\)", features$V2)

# create a table with the features that we need
x_extract <- x_all[,features_mean_std]

# change columns names
names(x_extract) <- features[features_mean_std, 2]

# Change activity names

activity_labels <- read.table("C:/Users/benoi/Documents/FUCIHAR/Dataset/activity_labels.txt")

y_all[,1] <- activity_labels[y_all[,1], 2]

names(y_all) <- "activity"

###  Relabel the data set with descriptive variable names.

names(subject_all) <- "subject"

# bind data into one data table
all_data <- cbind(x_extract, y_all, subject_all)

# Create tidy data set
# install.packages("plyr")
library(plyr)

tidy <- ddply(.data = all_data, .variables = c("subject", "activity"), .fun = numcolwise(mean))

write.table(tidy, "tidy.txt", row.names = FALSE)