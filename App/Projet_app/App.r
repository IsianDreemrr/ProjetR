
library(shiny)
library(bslib)
library(DBI)
library(RMySQL)
library(ggplot2)
library(DT)

theme <- bs_theme(
  bg = "#0b3d91", fg = "white", primary = "#FCC780",
  base_font = font_google("Space Mono"),
  code_font = font_google("Space Mono")
)


cn <- dbConnect(drv      = RMySQL::MySQL(), 
                username = "ipssi", 
                password = "Ipssi123?", 
                host     = "mysql-ipssi.alwaysdata.net", 
                port     = 3306,
                dbname   = 'ipssi_r'
                )

df <- dbReadTable(cn, 'data_brut')#reads as a data.frame


  # Close the database connection when the app stops
  onStop(function() {
    dbDisconnect(con)
  })



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
  theme = bs_theme(),
      tabPanel("Accueil"),
             
      tabPanel("Jeu de données",
      
                fluidPage(
                titlePanel("Table de données - Offres immobilières"),  
                sidebarLayout(sidebarPanel(
                    selectInput("filter_col", "Filter by column", choices = names(df)),
                    textInput("filter_value", "Filter value")
                  ),
                mainPanel(
                  tableOutput("db_table")
                )))),

      tabPanel("Analyse",
                fluidPage(
                titlePanel("Répartition des prix"),
                    sidebarLayout(sidebarPanel(
                        # selectInput("price", "X-axis variable", ""),
                        selectInput("comparaison", "Variable Y", "")
                      ),
                      mainPanel(
                          plotOutput("scatterPlot"),
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
    updateSelectInput(session, "filter_col", choices = names(df))
    # updateSelectInput(session, "price", choices = names(df))
    updateSelectInput(session, "comparaison", choices = names(df))
  })
  
  output$scatterPlot <- renderPlot({
    ycol <- input$comparaison
    if (is.null(ycol)) return(NULL)

    ggplot(df, aes(x = df[[ycol]], y = price)) +
      geom_point() +
      theme_minimal() +
      labs(
        title = paste("Prix selon ",ycol),
        x = ycol,
        y = "Prix"
      )
  })

    # Render the data table with optional filtering
  output$table <- renderDT({
    req(input$filter_col, input$filter_value)
    filtered_data <- data
    
    if (input$filter_value != "") {
      filter_col <- input$filter_col
      filter_value <- input$filter_value
      filtered_data <- filtered_data[grepl(filter_value, filtered_data[[filter_col]], ignore.case = TRUE), ]
    }
    
    datatable(filtered_data, options = list(pageLength = 10))
  })


}



shinyApp(ui = ui, server = server)