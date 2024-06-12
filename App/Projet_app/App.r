
library(shiny)
library(bslib)
library(DBI)
library(RMySQL)
library(ggplot2)

cn <- dbConnect(drv      = RMySQL::MySQL(), 
                username = "ipssi", 
                password = "Ipssi123?", 
                host     = "mysql-ipssi.alwaysdata.net", 
                port     = 3306,
                dbname   = 'ipssi_r'
                )

df <- dbReadTable(cn, 'data_brut')#reads as a data.frame






# # Define UI for app that draws a histogram ----
# ui <- page_sidebar(
#   # App title ----
#   title = "Projet - Coûts immobiliers",
#   # Sidebar panel for inputs ----
#   sidebar = sidebar(
#     # Input: Slider for the number of bins ----
#     sliderInput(
#       inputId = "bins",
#       label = "Number of bins:",
#       min = 1,
#       max = 50,
#       value = 30
#     )
#   ),
#   # Output: Histogram ----
#   plotOutput(outputId = "distPlot")
# )


# # Define server logic required to draw a histogram ----
# server <- function(input, output) {

#   # Histogram of the Old Faithful Geyser Data ----
#   # with requested number of bins
#   # This expression that generates a histogram is wrapped in a call
#   # to renderPlot to indicate that:
#   #
#   # 1. It is "reactive" and therefore should be automatically
#   #    re-executed when inputs (input$bins) change
#   # 2. Its output type is a plot
#   output$distPlot <- renderPlot({

#     x    <- faithful$waiting
#     bins <- seq(min(x), max(x), length.out = input$bins + 1)

#     hist(x, breaks = bins, col = "#007bc2", border = "white",
#          xlab = "Waiting time to next eruption (in mins)",
#          main = "Histogram of waiting times")

#     })

# }


# Define UI for the Shiny app
# ui <- fluidPage(
#   titlePanel("MySQL Database Connection in Shiny"),
#   mainPanel(
#     tableOutput("db_table")
#   )
# )

ui <- shinyUI(
  navbarPage("Projet R - Immobilier",
      tabPanel("Accueil"),
             
      tabPanel("Jeu de données",
                fluidPage(
                titlePanel("Table de données - Offres immobilières"),
                mainPanel(tableOutput("db_table")))
                ),

      tabPanel("Analyse",
                fluidPage(
                titlePanel("Répartition des prix"),
                    sidebarLayout(sidebarPanel(
                        selectInput("price", "X-axis variable", ""),
                        selectInput("sqft_lot", "Y-axis variable", "")
                      ),
                      mainPanel(
                          plotOutput("plot1",
    click = "plot_click",
    dblclick = "plot_dblclick",
    hover = "plot_hover",
    brush = "plot_brush"
  ),
                      )
                    )
                  )
)
  )
)




# Define server logic for the Shiny app
server <- function(input, output, session) {
  
  # Render the data as a table in the UI
  output$db_table <- renderTable({
    df
  })
  

  # Update the UI with column names for selection
  observe({
    updateSelectInput(session, "price", choices = names(data))
    updateSelectInput(session, "sqft_lot", choices = names(data))
  })
  
  # Render the plot
  output$plot <- renderPlot({
    x <- input$xcol
    y <- input$ycol
    
    if (is.null(x) || is.null(y)) return(NULL)
    
    ggplot(data, aes_string(x = x, y = y)) +
      geom_point() +
      theme_minimal() +
      labs(x = x, y = y)
  })

  # Close the database connection when the app stops
  # onStop(function() {
  #   dbDisconnect(con)
  # })
}



shinyApp(ui = ui, server = server)