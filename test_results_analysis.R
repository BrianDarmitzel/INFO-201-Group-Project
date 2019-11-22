library("dplyr")
library("stringr")
library("ggplot2")
library("lintr")

# load in filtered data set
test_df <- read.csv(unz("data/filtered_datasets.zip",
                        "filtered_datasets/test_filtered_2009_present.csv"))

# format column
test_df$Represented.Test.Vehicle.Make <- str_to_upper(
  test_df$Represented.Test.Vehicle.Make)

# filter the dataset further
filter_test_df <- test_df %>%
  select(Model.Year,
         Represented.Test.Vehicle.Make,
         Represented.Test.Vehicle.Model,
         Emission.Name,
         Rounded.Emission.Result..g.mi., ) %>%
  filter(Emission.Name == "CO") %>%
  group_by(Model.Year,
           Represented.Test.Vehicle.Make,
           Represented.Test.Vehicle.Model) %>%
  summarize(Emission_Emitted = max(
    Rounded.Emission.Result..g.mi., na.rm = TRUE))

# create a summary dataframe from the filtered dataset
summary_info <- filter_test_df %>%
  group_by(Represented.Test.Vehicle.Make) %>%
  summarize(num = n(),
            total_emissions_emitted = sum(Emission_Emitted, na.rm = TRUE),
            avg_emission = total_emissions_emitted / num)

# get the list of all car manufacturers
select_list <- summary_info %>%
  pull(Represented.Test.Vehicle.Make)

# create a dataframe for the graph
graph_df <- summary_info %>%
  arrange(-avg_emission) %>%
  head(10)

# create the graph
emissions <- ggplot(data = graph_df) +
  geom_col(mapping = aes(
    x = reorder(Represented.Test.Vehicle.Make, avg_emission),
    y = avg_emission)) + coord_flip() +
  labs(
    title = "Top 10 Polluting Car Manufacturers",
    x = "Car Manufacturer",
    y = "Average Carbon Monoxide Emitted (g/mi)"
  )
