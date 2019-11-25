library(ggplot2)

# load in source files to use in creating graphs
source("vehicles_analysis.r")
source("test_results_analysis.R")

# Creates data for our UI
my_server <- function(input, output) {
  
  output$fuel_econ_plot <- renderPlotly({
    if (input$analysis_var == "city") {
      fuel_econ <- plot_mpg(city_mpg)
    } else {
      fuel_econ <- plot_mpg(highway_mpg)
    }
    fuel_econ
  })
  
  output$car_info_table <- renderTable({
    filtered_table <- summary_info %>%
      filter(Represented.Test.Vehicle.Make == input$summary_info)
    
    table <- data.frame(
      Variable = c("Average Emission Emitted (g/mi)"),
      Value = c(filtered_table$avg_emission))
    table
  })
  
  output$description <- renderText({
    message <- paste0(("Statistics on "), input$summary_info)
    message
  })
  
  output$emissions_graph <- renderPlot({
    the_graph <- emissions
    the_graph
  })
}