library('dplyr')
test_df <- read.csv("data/final_datasets/test_filtered_2009_present.csv")

summary_info <- test_df %>% 
  group_by(Certificate.Manufacturer.Name) %>% 
  summarize(num = n(), emissions_emitted = sum(Rounded.Emission.Result..g.mi., na.rm = TRUE), avg_emission = emissions_emitted/num) %>% 
  arrange(-avg_emission)
View(summary_info)
