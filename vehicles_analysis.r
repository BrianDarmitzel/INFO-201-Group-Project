library("dplyr")
library("ggplot2")

# filtered data set
vehicles_data <- read.csv(unz("data/final_datasets.zip", "final_datasets/vehicles_filtered.csv"))

# Group data by car manufacturer and calculate average
# MPG for their cars on highway and city
model_mpg <- vehicles_data %>% 
  group_by(make) %>% 
  summarise(`Number of Models in Data` = n(),
            `Average City MPG` = sum(City.MGP.for.main.fuel) / n(),
            `Average Highway MPG` = sum(Highway.MPG.for.main.fuel) / n())

# single data frame with only city MPG
city_mpg <- model_mpg %>% 
  arrange(desc(`Average City MPG`)) %>% 
  select(make,`Average City MPG`) %>% 
  top_n(10)

# Single data frame with only highway MPG
highway_mpg <- model_mpg %>% 
  arrange(desc(`Average Highway MPG`)) %>% 
  select(make,`Average Highway MPG`) %>% 
  top_n(10)

# Create a graph of City MPG
city_mpg_plot <- ggplot(data = city_mpg, aes(x = reorder(city_mpg$make, city_mpg$`Average City MPG`),
                                    y = city_mpg$`Average City MPG`)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  geom_text(aes(label = round(city_mpg$`Average City MPG`, 1), hjust = -0.2)) + 
  labs(title = "Average City MPG of Different Car Manufacturers",
       x = "Car Manufacturer", y = "Miles Per Gallon in City") +
  coord_flip() +
  theme_minimal()

# Create a graph of Highway MPG
highway_mpg_plot <- ggplot(data = highway_mpg, aes(x = reorder(highway_mpg$make, highway_mpg$`Average Highway MPG`),
                                             y = highway_mpg$`Average Highway MPG`)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  geom_text(aes(label = round(highway_mpg$`Average Highway MPG`, 1), hjust = -0.2)) + 
  labs(title = "Average Highway MPG of Different Car Manufacturers",
       x = "Car Manufacturer", y = "Miles Per Gallon on Highway") +
  coord_flip() +
  theme_minimal() 

city_mpg_plot
highway_mpg_plot
