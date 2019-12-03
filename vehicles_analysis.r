library("dplyr")
library("ggplot2")
library("stringr")
library("lintr")
library("plotly")

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
city_mpg <- fuel_mpg_data %>%
  arrange(desc(`Average city MPG`)) %>%
  select(make, `Average city MPG`) %>%
  top_n(20)

# Single data frame with only highway MPG
highway_mpg <- fuel_mpg_data %>%
  arrange(desc(`Average highway MPG`)) %>%
  select(make, `Average highway MPG`) %>%
  top_n(20)

# Single data frame with combined MPG
combined_mpg <- fuel_mpg_data %>%
  arrange(desc(`Combined MPG`)) %>%
  select(make, `Combined MPG`) %>%
  top_n(20)

# Create a function to create interactive
# graph of City MPG and Highway MPG
plot_mpg <- function(dataset, variable) {
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
