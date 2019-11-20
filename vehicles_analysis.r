library("dplyr")
library("ggplot2")
library("stringr")

# filtered data set
vehicles_data <- read.csv(unz("data/filtered_datasets.zip", "filtered_datasets/vehicles_filtered.csv"))

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

  ggplot(data = dataset, aes(x = reorder(dataset[[column[1]]], dataset[[column[2]]]), y = dataset[[column[2]]])) +
    geom_bar(stat = "identity", fill = "steelblue") +
    geom_text(aes(label = round(dataset[[column[2]]], 1), hjust = -0.2)) + 
    labs(title = paste("Average", word(column[2], 2),"MPG of Different Car Manufacturers"),
         x = "Car Manufacturer", y = paste("Miles Per Gallon on", word(column[2], 2))) +
    coord_flip() +
    theme_minimal()
}

plot_mpg(highway_mpg)
plot_mpg(city_mpg)
