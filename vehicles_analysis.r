library("dplyr")
library("ggplot2")
library("stringr")
library("lintr")
library("plotly")

source("combine_data.R")

# filtered data set
vehicles_data <- read.csv(
  unz("data/filtered_datasets.zip",
      "filtered_datasets/vehicles_filtered.csv"), stringsAsFactors = F)

# Group data by car manufacturer and calculate average
# MPG for their cars on highway and city
fuel_mpg_data <- vehicles_data %>%
  group_by(make) %>%
  summarise(`Number of Models in Data` = n(),
            `Average city MPG` = sum(City.MGP.for.main.fuel) / n(),
            `Average highway MPG` = sum(Highway.MPG.for.main.fuel) / n(),
            `Combined MPG` = sum(Combined.MPG.for.main.fuel) / n(),
            `Annual gas Consumption in Barrels` = sum(Annual.petroleum.consumption.in.barrels.for.main.fuel) / n(),
            `Tailpipe Emissions in g/mi` = sum(Tailpipe.CO2.in.grams.mile.for.main.fuel..2.) / n(),
            `Annual Fuel Cost` = sum(Annual.fuel.cost.for.main.fuel) / n(),
            `Cost Savings for Gas over 5 Years` = sum(Cost.savings.for.gas.over.5.years.comapred.to.average.car) / n())

# single data frame with only city MPG
city_mpg <- all_cars %>%
  group_by(`Vehicle Manufacturer`) %>%
  summarize(`Average City MPG` = sum(`Average city MPG`) / n()) %>%
  arrange(-`Average City MPG`) %>%
  head(20)

# Single data frame with only highway MPG
highway_mpg <- all_cars %>%
  group_by(`Vehicle Manufacturer`) %>%
  summarize(`Average Highway MPG` = sum(`Average highway MPG`) / n()) %>%
  arrange(-`Average Highway MPG`) %>%
  head(20)

# Single data frame with combined MPG
combined_mpg <- all_cars %>%
  group_by(`Vehicle Manufacturer`) %>%
  summarize(`Average Combined MPG` = sum(`Combined MPG`) / n()) %>%
  arrange(-`Average Combined MPG`) %>%
  head(20)

# Create a function to create interactive
# graph of City MPG and Highway MPG
plot_mpg <- function(dataset) {
  column <- colnames(dataset)

  plot_ly(
    type = "bar",
    x = round(dataset[[column[2]]], 1),
    y = reorder(dataset[[column[1]]], dataset[[column[2]]]),
    marker = list(color = "cadetblue1",
                  line = list(color = "black", width = 1))) %>%
    layout(title = paste("Average", word(column[2], 2),
                         "MPG of Different Manufacturers"),
           xaxis = list(title = paste("Miles Per Gallon driving",
                                      word(column[2], 2))),
           yaxis = list(title = "Car Manufacturer"))
}

#plot_mpg(city_mpg)
#plot_mpg(highway_mpg)

indiv_mod <- vehicles_data %>% 
  group_by(make,model) %>% 
  summarise(`Number of Models in Data` = n(),
            `Average city MPG` = sum(City.MGP.for.main.fuel) / n(),
            `Average highway MPG` = sum(Highway.MPG.for.main.fuel) / n(),
            `Combined MPG` = sum(Combined.MPG.for.main.fuel) / n(),
            `Annual gas Consumption in Barrels` = sum(Annual.petroleum.consumption.in.barrels.for.main.fuel) / n(),
            `Tailpipe Emissions in g/mi` = sum(Tailpipe.CO2.in.grams.mile.for.main.fuel..2.) / n(),
            `Annual Fuel Cost` = sum(Annual.fuel.cost.for.main.fuel) / n(),
            `Cost Savings for Gas over 5 Years` = sum(Cost.savings.for.gas.over.5.years.comapred.to.average.car) / n())
