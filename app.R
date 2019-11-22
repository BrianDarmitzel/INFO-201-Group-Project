#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(htmltools)
library(ggplot2)

source("vehicles_analysis.r")
source("test_results_analysis.R")

ui <- fluidPage(
  titlePanel("Green Car Research Project"),
  
  tabsetPanel(
    type = "tabs", id = "nav_bar",
   
    tabPanel("Introduction",
      h3("Introduction:"),
      p("Our project aims to spread awareness of the rising air pollution and environmental
        problems stemming from harmful pollutants produced by cars. Reducing pollution
        in the atmosphere is important for both human health and for the environment as a
        whole. By showing which cars are the most eco-friendly and fuel efficient, we hope
        to influence people's decision into which cars do the least harm to the environment,
        and which car manufacturers create the most 'eco-frinedly' vehicles.")),
      h3("Research Questions:"),
      p("- Which car manufacturer makes the most 'eco-friendly' cars, as in which
        of these manufacturere does the least harm to the environment through their cars?"),
      p("- Which car manufacturers make the most fuel-efficient cars, and can run the
        furthest on a single gallon of gasoline?"),
  
    tabPanel("Categories",
      sidebarLayout(
        
        sidebarPanel(
        selectInput(
          inputId = "analysis_var",
          label = h3("Types of MPG"),
          choices = c("city", "highway"),
          selected = "city")),
        
        mainPanel(
        plotOutput(outputId = "plot_city"),
        plotOutput(outputId = "plot_highway"))
      )
    ),
  
    tabPanel("Search",
       sidebarLayout(
         
         sidebarPanel(
         selectInput("summary_info",
           label = h3("Select Car Brand"),
           choices = select_list,
           selected = "VW")),
         
         mainPanel(
         h3(textOutput(outputId = "description")),
         tableOutput(outputId = "car_info_table"),
         p("*we're going to add more information in this table."))
       )
    ),
  
    tabPanel("About",
      h3("Contact Information"),
      tags$div(
        "Brian Darmitzel, Rishabh Goyal, Xiying Huang",
        tags$br(),
        "INFO-201A: Techinical Foudations for Informatics (Autumn, 2019)",
        tags$br(),
        "The Information School",
        tags$br(),
        "University of Washington",
        tags$br(),
        tags$i("November 18, 2019")),
      h3("Github Repository"),
      href = "https://github.com/BrianDarmitzel/INFO-201-Group-Project",
             "https://github.com/BrianDarmitzel/INFO-201-Group-Project")
    )
  )

server <- function(input, output) {
  
  output$plots <- renderPlot({ input$analysis })
  output$plot_city <- renderPlot({
    city_mpg_plot <- plot_mpg(city_mpg)
    city_mpg_plot
  })
  
  output$plot_highway <- renderPlot({
    highway_mpg_plot <- plot_mpg(highway_mpg)
    highway_mpg_plot
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
}

shinyApp(ui = ui, server = server)
