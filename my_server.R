library(ggplot2)
library(dplyr)
library(plotly)

# load in source files to use in creating graphs
source("vehicles_analysis.r")
source("test_results_analysis.R")
source("combine_data.R")

# Creates data for our UI
my_server <- function(input, output, session) {
  
  output$fuel_econ_plot <- renderPlotly({
    if (input$viz_type == "city") {
      fuel_econ <- plot_mpg(city_mpg)
    } else {
      fuel_econ <- plot_mpg(highway_mpg)
    }
    fuel_econ
  })
  
  output$brand_info_table <- renderTable({
    filtered_table <- all_cars %>%
      group_by(`Vehicle Manufacturer`) %>%
      summarize(average_emission_emitted = sum(Emission_Emitted) / n(),
                `Average city MPG` = sum(Average.city.MPG) / n(),
                `Average highway MPG` = sum(Average.highway.MPG) / n(),
                `Combined MPG` = sum(Combined.MPG) / n(),
                `Annual gas Consumption in Barrels` = sum(Annual.gas.Consumption.in.Barrels) / n(),
                `Tailpipe Emissions in g/mi` = sum(Tailpipe.Emissions.in.g.mi) / n(),
                `Annual Fuel Cost` = sum(Annual.Fuel.Cost) / n(),
                `Cost Savings for Gas over 5 Years` = sum(Cost.Savings.for.Gas.over.5.Years) / n()) %>%
       filter(`Vehicle Manufacturer` == input$car_brand)
    
    table <- data.frame(
      Variable = c("Average Carbon Monoxide Emission Emitted (g/mi)",
                   "Average Tailpipe Emissions (g/mi)",
                   "Average City Fuel Economy (mpg)",
                   "Average Highway Fuel Economy (mpg)",
                   "Average Combined Fuel Economy (mpg)",
                   "Average Annual Gas Consumption in Barrels",
                   "Average Annual Fuel Cost (usd)"),
      Value = c(filtered_table$average_emission_emitted,
                filtered_table$`Tailpipe Emissions in g/mi`,
                filtered_table$`Average city MPG`,
                filtered_table$`Average highway MPG`,
                filtered_table$`Combined MPG`,
                filtered_table$`Annual gas Consumption in Barrels`,
                filtered_table$`Annual Fuel Cost`))
    table
  })
  
  output$car_info_table <- renderTable({
    filtered_table <- all_cars %>%
      filter(`Vehicle Manufacturer` == input$car_brand,
             `Vehicle Model` == input$car_model)
    
    table <- data.frame(
      Variable = c("Average Carbon Monoxide Emission Emitted (g/mi)",
                   "Average Tailpipe Emissions (g/mi)",
                   "Average City Fuel Economy (mpg)",
                   "Average Highway Fuel Economy (mpg)",
                   "Average Combined Fuel Economy (mpg)",
                   "Average Annual Gas Consumption in Barrels",
                   "Average Annual Fuel Cost (usd)"),
      Value = c(filtered_table$Emission_Emitted,
                filtered_table$Tailpipe.Emissions.in.g.mi,
                filtered_table$Average.city.MPG,
                filtered_table$Average.highway.MPG,
                filtered_table$Combined.MPG,
                filtered_table$Annual.gas.Consumption.in.Barrels,
                filtered_table$Annual.Fuel.Cost))
    table
  })
  
  output$description_brand <- renderText({
    message <- paste0(("Statistics for "), input$car_brand)
    message
  })
  
  output$description_model <- renderText({
    message <- paste0(("Statistics for the "), input$car_brand, " ",input$car_model)
    message
  })
  
  observe({
    updateSelectInput(session, "car_model",
                      choices = all_cars %>%
                        filter(`Vehicle Manufacturer` == input$car_brand) %>%
                        select(`Vehicle Model`) %>%
                        pull()
    )
  })
  
  output$emissions_graph <- renderPlot({
    the_graph <- emissions
    the_graph
  })
}
