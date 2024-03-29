library("rio")
library("xlsx")
library("dplyr")
library("readxl")

# load all original data sets
vehicles_data <- read.csv(unz("data/original_datasets.zip",
                              "original_datasets/vehicles.csv"))
test_results_2014_present <- read_excel("data/original_datasets.zip")
test_results_2009_2013 <-
  import("data/light-duty-vehicle-test-results-report-2009-2013.xlsx")

# filter out the columns that we do not need for our analysis
test_filtered_2014_present <- test_results_2014_present %>%
  select(
    -`Certified Test Group`, -`Certified Evaporative Family`, -`Vehicle ID`,
    -`Vehicle Configuration Number`, -`Displacement (L)`,
    -`Gross Vehicle Weight Rating (lbs.)`, -`Test Drive`,
    -`Test Drive Description`, -`Transmission Type`,
    -`Transmission Type Description`, -`Transmission type, if other`,
    -`Number of Gears`, -`Transmission Lockup Yes/No?`,
    -`Creeper Gear Yes/No?`, -`Equivalent Test Weight (lbs.)`,
    -`Vehicle Fuel Category`, -`Vehicle Fuel Category Description`,
    -`Test Number`, -`Test Procedure`, -`Test Fuel`,
    -`Certification/In-Use Code`, -`Vehicle Class`, -`Certification Region`,
    -`Emission Standard Level Code`, -`Upward Diesel Adjustment Factor`,
    -`Downward Diesel Adjustment Factor`, -`Reactivity Factor (RAF)`
  )

test_filtered_2009_2013 <- test_results_2009_2013 %>%
  select(
    -`Certified Test Group`, -`Certified Evaporative Family`, -`Vehicle ID`,
    -`Vehicle Configuration Number`, -`Displacement (L)`,
    -`Gross Vehicle Weight Rating (lbs.)`, -`Test Drive`,
    -`Test Drive Description`, -`Transmission Type`,
    -`Transmission Type Description`, -`Transmission type, if other`,
    -`Number of Gears`, -`Transmission Lockup Yes/No?`,
    -`Creeper Gear Yes/No?`, -`Equivalent Test Weight (lbs.)`,
    -`Vehicle Fuel Category`, -`Vehicle Fuel Category Description`,
    -`Test Number`, -`Test Procedure`, -`Test Fuel`,
    -`Certification/In-Use Code`, -`Vehicle Class`, -`Certification Region`,
    -`Emission Standard Level Code`, -`Upward Diesel Adjustment Factor`,
    -`Downward Diesel Adjustment Factor`, -`Reactivity Factor (RAF)`
  )

# combine two datasets into one, and write it out
test_filtered_2009_present <- rbind(test_filtered_2009_2013,
                                    test_filtered_2014_present)
write.csv(test_filtered_2009_present, "data/test_filtered_2009_present.csv",
          row.names = FALSE)

# filter and rename columns
vehicles_filtered <- vehicles_data %>%
  filter(year >= 2009) %>%
  select(
    -city08U, -cityA08U, -comb08U, -combA08U, -cylinders,
    -displ, -drive, -highway08U, -highwayA08U, -hlv,
    -lv2, -lv4, -pv2, -pv4, -trans_dscr, -trany,
    -sCharger, -tCharger, -c240Dscr, -startStop,
    -hpv, -id, -mpgData, -range, -rangeCity, -rangeCityA,
    -rangeHwy, -rangeHwyA, -rangeA, -mfrCode, -charge240b,
    -c240bDscr, -UHighway, -UHighwayA
  ) %>%
  rename(
    "Annual petroleum consumption in barrels for main fuel" = barrels08,
    "Annual petroleum consumption in barrels for alternate fuel" = barrelsA08,
    "Time to charge electric vehicle at 120 V" = charge120,
    "Time to charge electric vehicle at 240 V" = charge240,
    "City MGP for main fuel" = city08,
    "City MPG for alternate fuel" = cityA08,
    "City gas comsumption (gallons/100 miles) in charge depleting mode"
    = cityCD,
    "City electricity consumption in kw-hrs/100 miles" = cityE,
    "EPA city utility factor for PHEV" = cityUF,
    "Tailpipe CO2 in grams/mile for main fuel" = co2,
    "Tailpipe CO2 in grams/mile for alternate fuel" = co2A,
    "Tailpipe CO2 in grams/mile for alternate fuel (2)" = co2TailpipeAGpm,
    "Tailpipe CO2 in grams/mile for main fuel (2)" = co2TailpipeGpm,
    "Combined MPG for main fuel" = comb08,
    "Combined MPG for alternate fuel" = combA08,
    "Combined electricity consumption in kw-hrs/100 miles" = combE,
    "Combined gas usage (gal/100 mi) in charge depleting mode" = combinedCD,
    "EPa combined utility factor for PHEV" = combinedUF,
    "EPA model type index" = engId,
    "Engine description" = eng_dscr,
    "Electric Motor" = evMotor,
    "EPA Fuel Economy Score" = feScore,
    "Annual fuel cost for main fuel" = fuelCost08,
    "Annual fuel cost for alt fuel" = fuelCostA08,
    "Fuel type with main and alternate" = fuelType,
    "For dual vehicles, this will be conventional fuel" = fuelType1,
    "Alternate fuel type" = fuelType2,
    "EPA GHG score" = ghgScore,
    "EPA GHG score on alt fuel" = ghgScoreA,
    "Highway MPG for main fuel" = highway08,
    "Highway MPG for alt fuel" = highwayA08,
    "highway gasoline consumption (gallons/100miles) in charge depleting mode"
    = highwayCD,
    "highway electricity consumption in kw-hrs/100 miles" = highwayE,
    "EPA highway utility factor (share of electricity) for PHEV" = highwayUF,
    "Vehicle operates on gas / electric blend on low charge" = phevBlended,
    "City MPG for main fuel" = UCity,
    "City MPG for alt fuel" = UCityA,
    "EPA Vehicle size class" = VClass,
    "Model year" = year,
    "Cost savings for gas over 5 years comapred to average car" = youSaveSpend,
    "If G or T, this vehicle is subject to gas guzzler tax" = guzzler,
    "Type of alt fuel or advanced tech vehicle" = atvType,
    "EPA composite gasoline-electricity city MPGe for plug-in hybrid vehicles"
    = phevCity,
    "EPA composite gasoline-electricity combined city-highway MPGe for
    plug-in hybrid vehicles" = phevComb
  )

# write out the dataframe
write.csv(vehicles_filtered, "data/vehicles_filtered.csv",
          row.names = FALSE)
