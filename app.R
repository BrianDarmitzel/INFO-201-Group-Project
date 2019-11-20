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
  
 titlePanel("Green car research application"),
  
  tabsetPanel(
    type = "tabs", id = "nav_bar",
   
    tabPanel(
        "Introduction",
        htmlOutput("intro")
        ),
  
    tabPanel(
    "categories",
    sidebarLayout(
      sidebarPanel(
        selectInput(
          inputId = "analysis_var",
          label = h3("Types of MPG"),
          choices = c("city", "highway"),
          selected = "city"
        )),
      
    mainPanel(
      plotOutput(outputId = "plot_city"),
      plotOutput(outputId = "plot_highway")
    ))
    ),
    
  
    tabPanel(
      "Search",
           sidebarLayout(
             sidebarPanel(
               selectInput("summary_info",
                 label = h3("Select vihecle category"),
                 choices = select_list,
                 selected = "VW")
             ),
             mainPanel(
               tableOutput("summary_info")
             )
           )
    ),
  
   tabPanel("About",
           h3("Purpose"),
           tags$div(
             "the description will go here"),
           h3("Contact"),
           tags$div(
             "Brian Darmitzel, Rishabh Goyal, Xiying Huang",
             tags$br(),
             "INFO-201A: Techinical Foudations for Informatics (Autumn, 2019)",
             tags$br(),
             "The Information School",
             tags$br(),
             "University of Washington",
             tags$br(),
             tags$i("November 18, 2019")
           ),
           h3("Github Repository"),
           tags$pre(tags$a(href = "https://github.com/BrianDarmitzel/INFO-201-Group-Project",
                           "https://github.com/BrianDarmitzel/INFO-201-Group-Project"))
  )
))

       

server <- function(input, output) {
  output$intro <- renderUI({"Our project aims to spread awareness regarding the rising air pollution
    due to harmful pollutants emitted by motor vehicles. Reducing pollutants in the air is important
    for human health and the environment. By showing which cars are the most eco-friendly and fuel
    efficient, we hope to influence people's decision into buying cars which do the least harm to the environment."
    })
  
    output$plots <- renderPlot({ input$analysis })
  output$plot_city <- renderPlot({
    city_mpg_plot <- ggplot(data = city_mpg, aes(x = reorder(city_mpg$make, city_mpg$`Average City MPG`),
                                                                               y = city_mpg$`Average City MPG`)) +
    geom_bar(stat = "identity", fill = "steelblue") +
    geom_text(aes(label = round(city_mpg$`Average City MPG`, 1), hjust = -0.2)) +
    labs(title = "Average City MPG of Different Car Manufacturers",
         x = "Car Manufacturer", y = "Miles Per Gallon in City") +
    coord_flip() +
    theme_minimal()
    city_mpg_plot
  })
  
  output$plot_highway <- renderPlot({
    highway_mpg_plot <- ggplot(data = highway_mpg, aes(x = reorder(highway_mpg$make, highway_mpg$`Average Highway MPG`),
                                                       y = highway_mpg$`Average Highway MPG`)) +
      geom_bar(stat = "identity", fill = "steelblue") +
      geom_text(aes(label = round(highway_mpg$`Average Highway MPG`, 1), hjust = -0.2)) +
      labs(title = "Average Highway MPG of Different Car Manufacturers",
           x = "Car Manufacturer", y = "Miles Per Gallon on Highway") +
      coord_flip() +
      theme_minimal()
    highway_mpg_plot
  })

  
}

shinyApp(ui = ui, server = server)


