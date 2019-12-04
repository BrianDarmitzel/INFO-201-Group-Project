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
  rename("Average Emissions Emitted" = Emission_Emitted,
         "Average city MPG" = Average.city.MPG,
         "Average highway MPG" = Average.highway.MPG,
         "Combined MPG" = Combined.MPG,
         "Annual gas Consumption in Barrels" = Annual.gas.Consumption.in.Barrels,
         "Tailpipe Emissions in g/mi" = Tailpipe.Emissions.in.g.mi,
         "Annual Fuel Cost" = Annual.Fuel.Cost,
         "Cost Savings for Gas over 5 Years" = Cost.Savings.for.Gas.over.5.Years) %>% 
  select(-Number.of.Models.in.Data)



averages <- lapply(all_cars[3:10], mean)

graph_ranking <- function(car_model, column) {
  cars_avg <- all_cars %>% 
    mutate(result = all_cars[[column]] - averages[[column]])
  
  data <- cars_avg %>% filter(`Vehicle Model` == car_model) %>% select(result)
    
  color_map <- c()
  if(data$result < 0) {
    if(is.element(column, c("Average city MPG","Average highway MPG", "Combined MPG","Cost Savings for Gas over 5 Years"))) {
      color_map[colnames(data)] <- c("data" = "red")
    } else {
      color_map[colnames(data)] <- c("data" = "blue")
    }
    message <- paste(round(data$result, 1), "less<br>than average")
  } else {
    if(is.element(column, c("Average city MPG","Average highway MPG", "Combined MPG","Cost Savings for Gas over 5 Years"))) {
      color_map[colnames(data)] <- c("data" = "blue")
    } else {
      color_map[colnames(data)] <- c("data" = "red")
    }
    message <- paste(round(data$result, 1), "more<br>than average")
  }
  
  plot_ly() %>%
    add_bars(
      x = column,
      y = as.vector(data$result, mode = "numeric"),
      marker = list(color = color_map[[colnames(data)]]),
      text = round(as.vector(data$result, mode = "numeric"), 1),
      hoverinfo = 'message',
      textposition = "auto" 
    ) %>%
    layout(
      yaxis = list(range = c(min(cars_avg[["result"]]), max(cars_avg[["result"]])))
    )
}

p1 <- graph_ranking("FIT EV", "Average city MPG")
p2 <- graph_ranking("FIT EV", "Average highway MPG")
p3 <- graph_ranking("FIT EV", "Combined MPG")
p4 <- graph_ranking("FIT EV", "Cost Savings for Gas over 5 Years")
p5 <- graph_ranking("FIT EV", "Average Emissions Emitted")
p6 <-graph_ranking("FIT EV", "Annual gas Consumption in Barrels")
p7 <-graph_ranking("FIT EV", "Tailpipe Emissions in g/mi")
p8 <-graph_ranking("FIT EV", "Annual Fuel Cost")

subplot(p1,p2,p3,p4,p5,p6,p7,p8, margin = 0.05, nrows = 2) %>% 
  layout(showlegend = F)
