##Read data and
train_x <- read.table("./UCI HAR Dataset/train/X_train.txt")
test_x <- read.table("./UCI HAR Dataset/test/X_test.txt")

train_y <- read.table("./UCI HAR Dataset/train/y_train.txt")
test_y <- read.table("./UCI HAR Dataset/test/y_test.txt")

test_subject <- read.table("./UCI HAR Dataset/test/subject_test.txt")
train_subject <- read.table("./UCI HAR Dataset/train/subject_train.txt")

activity_lables <- read.table("./UCI HAR Dataset/activity_labels.txt")
names(activity_labels) <- c("ActivityID", "Activity")
features <- read.table("./UCI HAR Dataset/features.txt")

#Merge training and test datasets into one
x <- rbind(train_x, test_x)
y <- rbind(train_y, test_y)
subject <- rbind(test_subject, train_subject)
#Rename the column for understandable name
names(subject) <- "SubjectID"
names(y) <- "ActivityID"

#for the main data set X select only mean and standard deviation columns
selectedColumns <- grep("mean()|std()", features[,2])

#take only the subset of wanted columns
x <- x[, selectedColumns]

#rename columns with features label
names(x) <- features[selectedColumns, 2]

#merge data with subject and activities
dat <- cbind(x, subject, y)
dat <- merge(dat, activity_labels, by="ActivityID", all = TRUE)
#remove the first column ActivityID
dat <- dat[,-1]

meltDat <- melt(dat,(id.vars=c("SubjectID","Activity")))
meanData <- dcast(meltDat, SubjectID + Activity ~ variable, mean)
write.table(meanData, "tidy_data.txt", sep = ",")