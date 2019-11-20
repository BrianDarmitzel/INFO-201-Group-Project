install.packages("readxl")
library("readxl")
library("dplyr")

vehicle_df <- read.csv("INFO-201-Group-Project/heavy-duty-vehicle-ghg-2015-present.xlsx",
                       stringsAsFactors = FALSE)