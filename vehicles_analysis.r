library("rio")
library("xlsx")
library("dplyr")

# original data sets
vehicles_data <- read.csv("data/vehicles_filtered.csv", stringsAsFactors = F)
test_data <- read.csv("data/test_filtered_2009_present.csv", stringsAsFactors = F)
