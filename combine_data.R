library("dplyr")
library("stringr")
library("plotly")

# load in filtered data set
emissions_data <- read.csv(unz("data/filtered_datasets.zip",
                        "filtered_datasets/emissions_data.csv"))

fuel_economy_data <- read.csv(unz("data/filtered_datasets.zip",
                                  "filtered_datasets/vehicles_individual_data.csv"))

# convert values to upper case
fuel_economy_data$make <- str_to_upper(
  fuel_economy_data$make)
fuel_economy_data$model <- str_to_upper(
  fuel_economy_data$model)
emissions_data$Represented.Test.Vehicle.Model <- str_to_upper(
  emissions_data$Represented.Test.Vehicle.Model)

# rename a few columns
emissions_data <- rename(emissions_data, 'Vehicle Manufacturer' = Represented.Test.Vehicle.Make)
fuel_economy_data <- rename(fuel_economy_data, 'Vehicle Manufacturer' = make)
emissions_data <- rename(emissions_data, 'Vehicle Model' = Represented.Test.Vehicle.Model)
fuel_economy_data <- rename(fuel_economy_data, 'Vehicle Model' = model)

brands1 <- emissions_data %>%
  group_by(`Vehicle Manufacturer`) %>%
  summarize(average_emission_emitted = sum(Emission_Emitted)/n())

brands2 <- fuel_economy_data %>%
  group_by(`Vehicle Manufacturer`) %>%
  summarize(`Average city MPG` = sum(Average.city.MPG) / n(),
            `Average highway MPG` = sum(Average.highway.MPG) / n(),
            `Combined MPG` = sum(Combined.MPG) / n(),
            `Annual gas Consumption in Barrels` = sum(Annual.gas.Consumption.in.Barrels) / n(),
            `Tailpipe Emissions in g/mi` = sum(Tailpipe.Emissions.in.g.mi) / n(),
            `Annual Fuel Cost` = sum(Annual.Fuel.Cost) / n(),
            `Cost Savings for Gas over 5 Years` = sum(Cost.Savings.for.Gas.over.5.Years) / n())

all_brands <- merge(x=brands1,y=brands2,by="Vehicle Manufacturer")

all_cars <- merge(x=emissions_data, y=fuel_economy_data, by=c("Vehicle Manufacturer", "Vehicle Model")) %>%
  select(-Number.of.Models.in.Data)



averages <- as.vector(lapply(all_cars[3:10], mean), mode = "numeric")

#graph_ranking <- function(car_model) {
  data <- all_cars %>%
    filter(`Vehicle Model` == "ILX")
  
  columns <- colnames(data)[3:10]
  nums <- data[3:10] - averages
  

  color_map <- c()
  for (x in colnames(nums)[1:8]) {
    print(nums[[x]])

    if(nums[[x]] < 0) {
      color_map[x] <- c("Data" = "red")
    } else {
      color_map[x] <- c("Data" = "blue")
    }
  }
  View(color_map)
  
  plot_ly() %>%
  add_bars(
    x = columns,
    y = as.vector(nums, mode = "numeric"),
    marker = list(color = color_map[columns]),
    name = "placeholder"
  )
#}

graph_ranking("ILX")
