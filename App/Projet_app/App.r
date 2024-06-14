# Importations
library(shiny)
library(bslib)
library(DBI)
library(RMySQL)
library(ggplot2)
library(DT)
library(shinyWidgets)
# library(keras)
 
# Charger le modèle
# model <- load_model_hdf5("house_price_prediction_model.h5")

# Application du thème graphique
custom_theme <- bs_theme(
  bg = "#00a59a", fg = "#000000", primary ="#007AC6",
  base_font = font_google("Space Mono"),
  code_font = font_google("Space Mono")
)


# Interface graphique - Front
ui <- shinyUI(
  navbarPage("Projet R - Immobilier",
    # use a gradient in background
  setBackgroundColor(
    color = c("#F7FBFF", "#2171B5"),
    gradient = "linear",
    direction = "bottom"
  ),
  theme = bs_theme(preset = "minty"),
      tabPanel("Accueil",
      mainPanel(
          titlePanel("Accueil"),
            strong("Bienvenue sur la Web App du Groupe 8 de la MIA24.2 !"),
            p("Celle-ci a été réalisé dans le cadre d'un projet IPSSI du 10 au 14 Juin 2024."),
            em("Ayse YILDRIM - Fatima OUDAHMANE - Ahmed Amine BOUTHALEB - Florian ALVAREZ RODRIGUEZ"),
        )),
             
      tabPanel("Jeu de données",
      
                fluidPage(theme = custom_theme,
                titlePanel("Jeu de données"),  
                sidebarLayout(sidebarPanel(
                    selectInput("filter_col", "Colonne", choices = names(df)),
                    textInput("filter_value", "Filtrer par valeur")
                  ),
                mainPanel(
                  tableOutput("db_table")
                )))),

      tabPanel("Analyse",
                fluidPage(
                titlePanel("Analyse"),
                    sidebarLayout(sidebarPanel(
                        # selectInput("price", "X-axis variable", ""),
                        selectInput("comparaison", "Variable Y", "")
                      ),
                      mainPanel(
                          plotOutput("scatterPlot"),
                      )
                    )
                  )
),
      tabPanel("Prédiction",
      mainPanel(
          titlePanel("Prédiction"),
            strong("Faites une prédiction de la valeur de votre bien !"),
              sidebarLayout(
    sidebarPanel(
      # Valeurs d'entrées à transmettre
      numericInput("bedrooms", "Bedrooms", value = 3, min = 1),
      numericInput("bathrooms", "Bathrooms", value = 2, min = 1),
      numericInput("sqft_living", "Square Feet Living", value = 2000, min = 1),
      numericInput("sqft_lot", "Square Feet Lot", value = 5000, min = 1),
      numericInput("floors", "Floors", value = 2, min = 1),
      numericInput("waterfront", "Waterfront", value = 0, min = 0, max = 1),
      numericInput("view", "View", value = 0, min = 0, max = 4),
      numericInput("condition", "Condition", value = 3, min = 1, max = 5),
      numericInput("grade", "Grade", value = 7, min = 1, max = 13),
      numericInput("sqft_above", "Square Feet Above", value = 1500, min = 1),
      numericInput("sqft_basement", "Square Feet Basement", value = 500, min = 0),
      numericInput("yr_built", "Year Built", value = 1990, min = 1900),
      numericInput("yr_renovated", "Year Renovated", value = 0, min = 0),
      numericInput("zipcode", "Zipcode", value = 98001, min = 1),
      numericInput("lat", "Latitude", value = 47.5112, min = -90, max = 90),
      numericInput("long", "Longitude", value = -122.257, min = -180, max = 180),
      numericInput("sqft_living15", "Square Feet Living 15", value = 1800, min = 1),
      numericInput("sqft_lot15", "Square Feet Lot 15", value = 4000, min = 1),
      actionButton("predict", "Prédire le prix")
    ),
    mainPanel(
      textOutput("price")
    ))
        )),
  )
)




# Gestion des datas - Back
server <- function(input, output, session) {
  
    # Connexion BDD
  con <- dbConnect(drv      = RMySQL::MySQL(), 
                  username = "ipssi", 
                  password = "Ipssi123?", 
                  host     = "mysql-ipssi.alwaysdata.net", 
                  port     = 3306,
                  dbname   = 'ipssi_r'
                  )

  # Update the UI with column names for selection
  observe({
    updateSelectInput(session, "filter_col", choices = names(df))
    updateSelectInput(session, "filter_value", choices = names(df))
    updateSelectInput(session, "comparaison", choices = names(df))
  })

  # observeEvent(input$predict, {
  #   # Conversion des features en matrice
  #   features <- matrix(as.numeric(input$sqft_living), nrow = 1)
  #   # Prédiction
  #   predicted_price <- predict(model, features)
  #   # Affichage du prix prédit
  #   output$price <- renderText({
  #     sprintf("Prix prédit : $%0.2f", predicted_price)
  #   })
  # })


  # Lecture de la table
  df <- dbReadTable(con, 'data_cleaned')
  # df_filtered <- dbGetQuery(con, paste("SELECT * FROM data_cleaned WHERE ",input$filter_col,"=",input$filter_value))


  # Render the data as a table in the UI
  output$db_table <- renderTable({
    if (input$filter_value == "") 
    {
    head(df, 100)
    }
    else{
      # df_filtered
     df_filtered <- dbGetQuery(con, paste("SELECT * FROM data_cleaned WHERE ",input$filter_col," = \'",input$filter_value,"\'"))

      head(df_filtered, 100)
    }
  },options = list(pageLength = 5))
  

  # Fermeture de la connexion BDD
  onStop(function() {
    dbDisconnect(con)
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
  output$dbd_table <- renderDT({
    req(input$filter_col, input$filter_value)
    filtered_data <- data
    
    if (input$filter_value != "") {
      # Page des données
      filter_col <- input$filter_col
      filter_value <- input$filter_value
    }
      #Page de l'analyse
      filtered_data <- filtered_data[grepl(filter_value, filtered_data[[filter_col]], ignore.case = TRUE), ]

    
    datatable(filtered_data, options = list(pageLength = 10))
  })


}


# Lancement de l'app
shinyApp(ui = ui, server = server)