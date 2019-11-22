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

# load in source files to use in creating graphs
source("vehicles_analysis.r")
source("test_results_analysis.R")

# create UI
ui <- fluidPage(

  # Title of our project
  titlePanel("Green Car Research Project"),

  # Create tabs to navigate different sections of our project
  tabsetPanel(
    type = "tabs", id = "nav_bar",

    # Introduction to our project and our research questions
    tabPanel("Introduction",
      h3("Introduction:"),
      p("Our project aims to spread awareness of the rising air
      pollution and environmental problems stemming from harmful
      pollutants produced by cars. Reducing pollution in the atmosphere
      is important for both human health and for the environment as a whole.
      By showing which cars are the most eco-friendly and fuel efficient,
      we hope to influence people's decision into which cars do the least
      harm to the environment, and which car manufacturers create the most
      'eco-frinedly' vehicles."),
      h3("Research Questions:"),
      p("- Which car manufacturer makes the most
       'eco-friendly' cars, as in which of these
        manufacturere does the least harm to the
        environment through their cars?"),
      p("- Which car manufacturers make the most
       fuel-efficient cars, and can run the furthest
       on a single gallon of gasoline?"),
      h3("Conclusion:"),
      p("As shown in the plots, Mosler, MV, and Hummer are the TOP3 polluting car manufacturers,
        while Tesla would be the most environmentally friendly car brand in the list. By selecting
        the data from search part, we found a trend that many car brands are continually updating.
        For example, the 2004 BMW emitted 1.6 CO (g/ml) while the 2010 BMW only emitted 0.36 CO.
        This number dramatically decrease within six years, which means that some car manufacturers
        did pay attention to the pollution issue and aim to improve the engines with the latest technology."),
    ),

    # Create a tab which holds our interactive visualizations
    tabPanel("Categories",
      sidebarLayout(

        sidebarPanel(
        selectInput(
          inputId = "analysis_var",
          label = h3("Types of MPG"),
          choices = c("city", "highway"),
          selected = "city")),

        mainPanel(
          plotlyOutput(outputId = "fuel_econ_plot"))
      )
    ),

    # Create a tab where users can search by car
    # manufacturer and see their average emissions
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

   # Create a tab explaining our team / resources
   tabPanel("About",
     h3("Contact Information"),
     tags$div(
       "Brian Darmitzel, Rishabh Goyal, Xiying Huang, Shray Arora",
       tags$br(),
       "INFO-201A: Techinical Foudations for Informatics (Autumn, 2019)",
       tags$br(),
       "The Information School",
       tags$br(),
       "University of Washington",
       tags$br(),
       tags$i("November 18, 2019")
     ),

     # Link to our github repository
     h3("Github Repository"),
     tags$pre(tags$a(
       href = "https://github.com/BrianDarmitzel/INFO-201-Group-Project",
              "https://github.com/BrianDarmitzel/INFO-201-Group-Project"))
    )
  )
)

# Creates data for our UI
server <- function(input, output) {

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
}

# Launch the app
shinyApp(ui = ui, server = server)
