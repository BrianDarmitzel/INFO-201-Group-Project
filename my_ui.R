library(plotly)

# create UI
my_ui <- fluidPage(
  theme = shinythemes::shinytheme("flatly"),
  # Title of our project
  titlePanel("Green Car Research Project"),
  
  # Create tabs to navigate different sections of our project
  tabsetPanel(
    type = "tabs", id = "nav_bar",
    
    # Introduction to our project and our research questions
    tabPanel("Introduction",
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
    ),
    
    # Create a tab which holds our interactive visualizations
    tabPanel("Visualizations",
             h2("Fuel Economy Visualiztion"),
             sidebarLayout(
               sidebarPanel(
                 selectInput(
                   inputId = "viz_type",
                   label = h3("Types of MPG"),
                   choices = c("city", "highway"),
                   selected = "city")),
               
               mainPanel(
                 plotlyOutput(outputId = "fuel_econ_plot"))
             ),
             h2("Carbon Monoxide (CO) Emissions Visualization"),
             plotOutput(outputId = "emissions_graph")
    ),
    
    # Create a tab where users can search by car
    # manufacturer and see their average emissions
    tabPanel("Search",
             sidebarLayout(
               
               sidebarPanel(
                 selectInput("car_brand",
                             label = h3("Select Car Brand"),
                             choices = all_cars$`Vehicle Manufacturer`),
                 selectInput("car_model",
                             label = h3("Select Car Model of the Selected Brand"),
                             choices = "")
                 ),
               
               mainPanel(
                 h3(textOutput(outputId = "description_brand")),
                 tableOutput(outputId = "brand_info_table"),
                 br(),
                 h3(textOutput(outputId = "description_model")),
                 tableOutput(outputId = "car_info_table")
             )
           )
    ),
    
    # Create a tab where our conclusion can be seen
    tabPanel("Conclusion",
             h3("Conclusion"),
             p("As seen in the CO emissions plot, Mosler, MV, and Hummer are the
          top 3 polluting car manufacturers, while Tesla would be the most
          environmentally friendly car brand in the list. By selecting the
          data from search part, we found a trend that many car brands are
          continually updating. For example, the 2004 BMW emitted 1.6 CO (g/ml)
          while the 2010 BMW only emitted 0.36 CO. This number dramatically
          decrease within six years, which means that some car manufacturers
          did pay attention to the pollution issue and aim to improve the
          engines with the latest technology. For the fuel economy plot,
          Tesla, CODA Automative, and BYD are the top brands who make the
          most fuel efficient cars."),
             p("It is noticed that car brands such as Tesla, CODA Automotive, and
          BYD, are the car manufacturers which make the most eco-friendly and
          fuel efficient cars. We think this is because these car brands
          mostly produce electric and hybrid cars which require some or no
          fuel. Technological advancement has now made it possible to produce
          more eco friendly cars which consume very less fuel, and more and
          more car manufacturers are moving towards manufacturing such
          cars.")
    ),
    
    # Create a tab explaining our team / resources
    tabPanel("About",
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
             h3("Link to the Technical Report"),
             a("https://github.com/BrianDarmitzel/INFO-201-Group-Project/wiki/INFO-201-GROUP-PROJECT-TECHNICAL-REPORT",
               href = "https://github.com/BrianDarmitzel/INFO-201-Group-Project/wiki/INFO-201-GROUP-PROJECT-TECHNICAL-REPORT"),
             h3("Github Repository"),
             a("https://github.com/BrianDarmitzel/INFO-201-Group-Project",
               href = "https://github.com/BrianDarmitzel/INFO-201-Group-Project")
    )
  )
)
