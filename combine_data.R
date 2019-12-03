library("dplyr")
library("stringr")

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

# View(emissions_data)
# View(fuel_economy_data)
# View(brands1)
# View(brands2)
# View(all_brands)
# View(all_cars)

# write.csv(all_brands, "data/filtered_datasets/combined_car_brands.csv",
#           row.names = FALSE)
# write.csv(all_cars, "data/filtered_datasets/combined_car_models.csv",
#           row.names = FALSE)
