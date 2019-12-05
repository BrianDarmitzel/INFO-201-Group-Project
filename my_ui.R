library(plotly)
library(shinythemes)
library(shiny)
    
# Introduction to our project and our research questions
intro_page <- tabPanel("Introduction",
h3("Introduction:"),
  p("Nearly 50% of Americans live in areas that don't meet federal air
    quality standards. Passenger vehicles are one of the major sources
    of air pollution, producing significant amounts of harmful pollutants
    such as nitrogen oxides and carbon monoxide. These pollutants
    contribute towards serious health related problems."),
  p("Our project aims to spread awareness about how much pollutants are
    produced by vehicles in America by every major vehicle manufacturing
    company. We are using large and reliable datasets for our project
    which will enable us to analyze and provide this information. We hope
    to persuade people to buy more eco-friendly and fuel efficient
    vehicles."),
  h3("Research Questions:"),
  p("- Which car manufacturer makes the most
    'eco-friendly' cars, as in which of these
    manufacturere does the least harm to the
    environment through their cars?"),
  p("- Which car manufacturers make the most
    fuel-efficient cars, and can run the furthest
    on a single gallon of gasoline?"),
)
    
# Create a tab which holds our interactive visualizations
visual_page <- tabPanel("Visualizations",
  h2("Fuel Economy Visualiztion"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "viz_type",
        label = h3("Types of MPG"),
        choices = c("City", "Highway", "Combined"),
        selected = "City")),

    mainPanel(
      plotlyOutput(outputId = "fuel_econ_plot"))
  ),

  h2("Carbon Monoxide (CO) Emissions Visualization"),
  plotOutput(outputId = "emissions_graph")
)
    
# Create a tab where users can search by car
# manufacturer and see their average emissions
search_page <- tabPanel("Search",
  sidebarLayout(
    sidebarPanel(

      selectInput("car_brand",
        label = h3("Select Car Brand"),
        choices = all_cars$`Vehicle Manufacturer`,
        selected = "Acura"),
      br(), br(), br(), br(), br(), br(), br(), br(), br(), br(), br(),
      selectInput("car_model",
        label = h3("Select Car Model of the Selected Brand"),
        choices = "")
      ),

    mainPanel(
      h3(textOutput(outputId = "description_brand")),
      tableOutput(outputId = "brand_info_table"),
      br(),
      h3(textOutput(outputId = "description_model")),
      tableOutput(outputId = "car_info_table"),
      br()
    )
  ),
  h3(textOutput(outputId = "ranking_title")),
  textOutput(outputId = "ranking_description"),
  plotlyOutput(outputId = "car_ranking")
)

# Create a tab where our conclusion can be seen
closing_page <- tabPanel("Conclusion",
  h3("Conclusion"),
  p("From the Average MPG Visualizations, it is clear that Tesla is way ahead
    of all other manufacturers in terms of fuel-efficiency of its cars.
    Honda, Jaguar, and Mercedes-Benz make the next most fuel-efficient cars.
    Their cars provide the highest mileage, meaning that their cars can cover
    more miles per gallon of gas."),
  p("The CO emissions plot reveals that GMC manufactures cars that emit the
    most amount of Carbon-Monoxide, followed by manufacturers like RAM and
    Spyker. Cars manufactured by these brands are the least
    environmental-friendly and cause the most harm to the environment as
    Carbon-Monoxide is one of the most harmful pollutants."),
  p("Additionally, the search feature helps reveal various factors about
    numerous car models which help determine how eco-friendly a car is.
    The charts also help compare a particular car with all the other cars
    in the dataset. Upon selecting Tesla, it can be seen that all the charts
    for Tesla cars are blue colored indicating Tesla cars are more
    eco-friendly than other car brands."),
  
  p("We think that cars manufactured by Tesla are the most eco-friendly and
    provide the highest mileage because Tesla produces electric and hybrid
    cars that require some or no fuel. Manufacturers like Honda, Jaguar,
    and Mercedes-Benz are also trying to switch to manufacturing electric
    and hybrid cars. Technological advancement has now made it possible to
    produce more eco-friendly cars which consume very little fuel, and more
    and more car manufacturers are moving towards manufacturing such cars.")
)
    
# Create a tab explaining our team / resources
about_page <- tabPanel("About",
  h3("About Us"),
    "Team #6",
  br(),
    "Brian Darmitzel, Rishabh Goyal, Xiying Huang, Shray Arora",
  br(),
    "INFO-201A: Techinical Foudations for Informatics",
  br(),
    "The Information School",
  br(),
    "University of Washington",
  br(),
    "Autumn 2019",
  br(),
  h3("About the Tech"),
  p("This app was developed on Shiny as an extention of R Studio. Our
    data was found online through various government sources, and manipulated
    with R to show what we wanted to present. Our data was mainly manipulated
    with Dplyr, and our graphs were created with Plotly. Our Shiny UI included
    a navbar page layout and used the 'flatly' theme included in shinythemes."),
  h3("Link to the Technical Report"),
  a("Technical Report",
    href = "https://github.com/BrianDarmitzel/INFO-201-Group-Project/wiki/Page-1:-INFO-201-GROUP-PROJECT-TECHNICAL-REPORT:-Introduction-and-Research-Questions")
)


# create UI
my_ui <- fluidPage(theme = shinytheme("flatly"),
  # Create tabs to navigate different sections of our project
  navbarPage("Green Car Research Project",
    intro_page,
    visual_page,
    search_page,
    closing_page,
    about_page
  )
)
