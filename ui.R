shinyUI(
    fluidPage(
        # Application title
        titlePanel("Airline Passengers Forecast"),
        
        sidebarLayout(
            # Sidebar with a slider and selection inputs
            sidebarPanel(
                sliderInput("year",
                            label = "Observed Period (min 5 years period)",
                            min = 1949,  max = 1961, step = 1, value = c(1949, 1961)),
                
                selectInput("interval", label = ("Forecast Period"), 
                            choices = list("1 Year" = 12, "2 Years" = 24,
                                           "3 Years" = 36, "4 Years" = 48, 
                                           "5 Years" = 60), 
                            selected = 12)),
            
            # Show Word Cloud
            mainPanel
            (
            tabsetPanel(
                tabPanel('Trend',
                         list(br(), verbatimTextOutput("output_text1"), plotOutput("airlinePlot"))),
                tabPanel('Forecast',
                         list(br(), verbatimTextOutput("output_text2"), dataTableOutput("prediction"))),
                tabPanel("About", 
                         list(
                             
                             h4('Objective'),
                             p("Objective of this application is to provide an insight into the Airline traffic trend and 
                                estimate comming years trend. With the knowledge of comming trends, Airline can plan its 
                               services better for an improved customer experience."),
                             
                             br(),
                             
                             h4('Observed Data'),
                             p("Observed data is Box & Jenkins airline monthly traffic, observed for the period 1949 to 
                                1960."),
                             p("This data is freely available in R dataset collection under name 'AirPassengers'."),
                             
                             br(),
                             
                             h4('Prediction Model'),
                             p("Prediction model has been built using ARIMA model which is a well known model for
                                time series analysis and prediction."),
                             
                             br(),
                             
                             h4("How To Use"),
                             p("Users have given two options - Observed Period and Forecast Period."),
                             
                             h5("Observed Period"),
                             p("Observed period is number of years that model looks for pattern in the 
                                airline traffic. For example - if observed period is from [1950 to 1955], model will 
                               conider the observed traffic between [1950 to 1955] (both inclusive) and predict the trend/ traffic 
                               from 1955 onwards."),
                             p("Model needs atleast 5 years of observed data and if selected interval is less than 5 years,
                                it will consider 5 years from the starting year."),
                             
                             h5("Forecast Period"),
                             p("Number of years model will forecast airline trend/ traffic, starting from end of observed period")
                         ))
            ))
        )
    )
)
