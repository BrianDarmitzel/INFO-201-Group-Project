library("dplyr")
library("stringr")
library("ggplot2")
library("lintr")
library("stringr")

source("combine_data.R")

# load in filtered data set
test_df <- read.csv(unz("data/filtered_datasets.zip",
                        "filtered_datasets/test_filtered_2009_present.csv"))

# format column
test_df$Represented.Test.Vehicle.Make <- str_to_upper(
  test_df$Represented.Test.Vehicle.Make)

# filter the dataset further
filter_test_df <- test_df %>%
  select(Represented.Test.Vehicle.Make,
         Represented.Test.Vehicle.Model,
         Emission.Name,
         Rounded.Emission.Result..g.mi., ) %>%
  filter(Emission.Name == "CO") %>%
  group_by(Represented.Test.Vehicle.Make,
           Represented.Test.Vehicle.Model) %>%
  summarize(Emission_Emitted = max(
    Rounded.Emission.Result..g.mi., na.rm = TRUE))

# create a summary dataframe from the filtered dataset
summary_info <- filter_test_df %>%
  group_by(Represented.Test.Vehicle.Make) %>%
  summarize(num = n(),
            total_emissions_emitted = sum(Emission_Emitted, na.rm = TRUE),
            avg_emission = total_emissions_emitted / num)

# create a dataframe for the graph
graph_df <- all_cars %>%
  group_by(`Vehicle Manufacturer`) %>%
  summarize(avg_emission = sum(`Average Emissions Emitted`) / n()) %>%
  arrange(-avg_emission) %>%
  head(20)

# create the graph
emissions <- ggplot(data = graph_df,
                    aes(x = reorder(`Vehicle Manufacturer`, avg_emission),
                        y = avg_emission)) +
  coord_flip() +
  geom_bar(stat="identity", fill="burlywood2") +
  geom_text(aes(label = round(avg_emission, 2)), vjust = 3, size= 3.5) +
  theme_minimal() +
  labs(
    title = "Top 20 Polluting Car Manufacturers",
    x = "Car Manufacturer",
    y = "Average Carbon Monoxide Emitted (g/mi)"
  )

#write.csv(filter_test_df, "data/filtered_datasets/emissions_data.csv",
#          row.names = FALSE)