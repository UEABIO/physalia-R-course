# Packages ----
library(shiny)       # Essential for running any Shiny app
library(tidyverse)
library(palmerpenguins)    # The source of your data

# Load the data
penguins <- as_tibble(penguins)

# ui.R ----
ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      demo_sp <- selectInput(inputId = "species",  # Give the input a name "genotype"
                             label = "1. Select species",  # Give the input a label to be displayed in the app
                             choices = c("Adelie" = "Adelie", "Chinstrap" = "Chinstrap", "Gentoo" = "Gentoo"), selected = "Adelie"),  # Create the choices that can be selected. e.g. Display "Adelie" and link to value "Adelie"
      demo_select <- selectInput(inputId = "colour", 
                                 label = "2. Select histogram colour", 
                                 choices = c("blue","green","red","purple","grey"), selected = "grey"),
      demo_slide <- sliderInput(inputId = "bin", 
                                label = "3. Select number of histogram bins", 
                                min=1, max=25, value= c(10)),
      demo_text <- textAreaInput(inputId = "text", 
                                 label = "4. Enter some text to be displayed",
                                 rows = 5,
                                 placeholder = "Enter some information here")
    ),
    mainPanel(
      # Output elements go here
      
      tags$ul(
        tags$strong(textOutput("demo_sp")), # emphasise text
        textOutput("demo_text")),
      
      plotOutput("demo_plot", width = "500px", height="300px"),
      
      DT::dataTableOutput("demo_table",
                          width = "50%",
                          height = "auto")
    )
  )
)
# server.R ----



server <- function(input, output) {
  
  
  output$demo_sp <- renderText({
    paste("Figure 1.", input$species)
  })
  
  output$demo_text <- renderText({
    (input$text)
  })
  
  
  output$demo_plot <- renderPlot({
    penguins_filtered <- penguins |>
      filter(species == input$species)
    
    ggplot(penguins_filtered, aes(x = flipper_length_mm)) +
      geom_histogram(fill = input$colour, show.legend = FALSE, bins = input$bin) +
      labs(fill = "Color") +
      theme_minimal()
  })
  
  output$demo_table <- DT::renderDataTable({
    penguins |>
      filter(species == input$species) |> 
      summarise(flipper_length_mm = quantile(flipper_length_mm, c(0.25, 0.5, 0.75), na.rm = T), quantile = c(0.25, 0.5, 0.75))
  })
  
}



# Run the app ----
shinyApp(ui = ui, server = server)