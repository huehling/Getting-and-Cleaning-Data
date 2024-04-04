# install and load needed packages
install.packages("data.table")
library(data.table)

# load activity labels
activity_labels <- read.table("activity_labels.txt", header = FALSE)

# load data column names
features <- read.table("features.txt", header = FALSE)

# Load X_test & y_test data.
X_test <- read.table("X_test.txt")
y_test <- read.table("y_test.txt")
subject_test <- read.table("subject_test.txt")

# Load X_train & y_train data.
X_train <- read.table("X_train.txt")
y_train <- read.table("y_train.txt")
subject_train <- read.table("subject_train.txt")

# function to calculate mean and standard deviation
extract_features <- grepl("mean|std", features)

# Link features
names(X_test) = features

# Mean and standard deviation per measurement
X_test = X_test[,extract_features]

# Load activity labels
y_test[, 2] <- activity_labels[y_test[, 1], 2]
names(y_test) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"

# Bind data
test_data <- cbind(data.table(subject_test), y_test, X_test)

# Link features
names(X_train) = features

# Mean and standard deviation per measurement
X_train = X_train[,extract_features]

# Load activity data
y_train[, 2] <- activity_labels[y_train[, 1], 2]
names(y_train) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"

# Bind data
train_data <- cbind(data.table(subject_train), y_train, X_train)

# Merge test and train data
data = rbind(test_data, train_data)
id_labels   = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(data), id_labels)
melt_data      = melt(data, id = id_labels, measure.vars = data_labels)

# Apply mean to data
tidy_data   = dcast(melt_data, subject + Activity_Label ~ variable, mean)

write.table(tidy_data, file = "./tidy_data.txt")
