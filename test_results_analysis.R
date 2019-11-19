library('dplyr')
library('stringr')
library("ggplot2")

test_df <- read.csv("data/final_datasets/test_filtered_2009_present.csv", stringsAsFactors = FALSE)

test_df$Represented.Test.Vehicle.Make <- str_to_upper(test_df$Represented.Test.Vehicle.Make)

filter_test_df <- test_df %>% 
  select(Model.Year, Represented.Test.Vehicle.Make, Represented.Test.Vehicle.Model, Emission.Name, Rounded.Emission.Result..g.mi., ) %>% 
  filter(Emission.Name == "CO") %>% 
  group_by(Model.Year, Represented.Test.Vehicle.Make, Represented.Test.Vehicle.Model) %>% 
  summarize(Emission_Emitted = max(Rounded.Emission.Result..g.mi., na.rm = TRUE))
View(filter_test_df)

summary_info <- filter_test_df %>% 
  group_by(Represented.Test.Vehicle.Make) %>% 
  summarize(num = n(), total_emissions_emitted = sum(Emission_Emitted, na.rm = TRUE), avg_emission = total_emissions_emitted/num) %>% 
  filter(num > 20) %>% 
  arrange(-avg_emission) %>% 
  head(10)
View(summary_info)

ggplot(data = summary_info) +
  geom_col(mapping = aes(x = reorder(Represented.Test.Vehicle.Make, avg_emission), y = avg_emission)) +
  coord_flip() +
  labs(
    title = "Top 10 Polluting Car Manufacturers",
    x = "Car Manufacturer",
    y = "Average Carbon Monoxide Emitted (g/mi)"
  )