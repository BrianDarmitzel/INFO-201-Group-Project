library(ggplot2)
library(dplyr)
library(plotly)
library(gridExtra)

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
      summarize(
        `Average Emissions Emitted` = sum(`Average Emissions Emitted`) / n(),
        `Average city MPG` = sum(`Average city MPG`) / n(),
        `Average highway MPG` = sum(`Average highway MPG`) / n(),
        `Combined MPG` = sum(`Combined MPG`) / n(),
        `Annual gas Consumption in Barrels` = sum(`Annual gas Consumption in Barrels`) / n(),
        `Tailpipe Emissions in g/mi` = sum(`Tailpipe Emissions in g/mi`) / n(),
        `Annual Fuel Cost` = sum(`Annual Fuel Cost`) / n(),
        `Cost Savings for Gas over 5 Years` = sum(`Cost Savings for Gas over 5 Years`) / n()) %>%
       filter(`Vehicle Manufacturer` == input$car_brand)
    
    table <- data.frame(
      Variable = c("Average Carbon Monoxide Emission Emitted (g/mi)",
                   "Average Tailpipe Emissions (g/mi)",
                   "Average City Fuel Economy (mpg)",
                   "Average Highway Fuel Economy (mpg)",
                   "Average Combined Fuel Economy (mpg)",
                   "Average Annual Gas Consumption in Barrels",
                   "Average Annual Fuel Cost (usd)"),
      Value = c(filtered_table$`Average Emissions Emitted`,
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
      Value = c(filtered_table$`Average Emissions Emitted`,
                filtered_table$`Tailpipe Emissions in g/mi`,
                filtered_table$`Average city MPG`,
                filtered_table$`Average highway MPG`,
                filtered_table$`Combined MPG`,
                filtered_table$`Annual gas Consumption in Barrels`,
                filtered_table$`Annual Fuel Cost`))
    table
  })
  
  output$car_ranking <- renderPlotly({
    p1 <- graph_ranking(input$car_model, "Average city MPG")
    p2 <- graph_ranking(input$car_model, "Average highway MPG")
    p3 <- graph_ranking(input$car_model, "Cost Savings for Gas over 5 Years")
    p4 <- graph_ranking(input$car_model, "Combined MPG")
    p5 <- graph_ranking(input$car_model, "Annual gas Consumption in Barrels")
    p6 <- graph_ranking(input$car_model, "Tailpipe Emissions in g/mi")
    p7 <- graph_ranking(input$car_model, "Annual Fuel Cost")
    p8 <- graph_ranking(input$car_model, "Average Emissions Emitted")
    subplot(p1,p2,p3,p4,p5,p6,p7,p8, margin = 0.05, nrows = 2) %>% 
      layout(showlegend = F)
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
  
  output$ranking_title <- renderText({
    message <- paste0("How the ", input$car_brand, " ", input$car_model,
                      " compares to the average of all cars in our dataset")
  })
  
  output$ranking_description <- renderText({
    message <- "These charts compare the selected car to all other cars that
    we have in our dataset. The values shown on the bars represent how much
    above or below average the selected car is in relation to all other cars in our data.
    If the number shown is worse than the average value of all other cars, then the 
    column will be shown in red. If the number shown is better than the average value of
    all other cars, then it will be shown in blue. For example, a lower MPG and higher gas
    consumption will both be shown as red on the graph, and higher gas savings and lower fuel
    costs will both be shown in blue. "
  })
  
  output$emissions_graph <- renderPlot({
    the_graph <- emissions
    the_graph
  })
}
