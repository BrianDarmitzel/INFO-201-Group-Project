library("dplyr")
library("ggplot2")
library("stringr")
library("plotly")

# filtered data set
vehicles_data <- read.csv(unz("data/filtered_datasets.zip", "filtered_datasets/vehicles_filtered.csv"), stringsAsFactors = F)

# Group data by car manufacturer and calculate average
# MPG for their cars on highway and city
model_mpg <- vehicles_data %>% 
  group_by(make) %>% 
  summarise(`Number of Models in Data` = n(),
            `Average city MPG` = sum(City.MGP.for.main.fuel) / n(),
            `Average highway MPG` = sum(Highway.MPG.for.main.fuel) / n())

# single data frame with only city MPG
city_mpg <- model_mpg %>%
  arrange(desc(`Average city MPG`)) %>% 
  select(make,`Average city MPG`) %>% 
  top_n(10)

# Single data frame with only highway MPG
highway_mpg <- model_mpg %>% 
  arrange(desc(`Average highway MPG`)) %>% 
  select(make,`Average highway MPG`) %>% 
  top_n(10)

# Create a function to graph City MPG and Highway MPG
plot_mpg <- function(dataset, variable) {
  column <- colnames(dataset)

  plot_ly(
    type = "bar",
    x = round(dataset[[column[2]]], 1),
    y = reorder(dataset[[column[1]]], dataset[[column[2]]]),
    text = ~paste("Avgerage MPG:", round(dataset[[column[2]]])),
    marker = list(color = 'deepskyblue',
                  line = list(color = 'black', width = 1))) %>%
    layout(title = paste("Average", word(column[2], 2), "MPG of Different Manufacturers"),
           xaxis = list(title = paste("Miles Per Gallon driving", word(column[2], 2))),
           yaxis = list(title = "Car Manufacturer"))
}

plot_mpg(highway_mpg)
plot_mpg(city_mpg)
# 24.9, 25.2, 26.7, 27.1, 34.6, 62
