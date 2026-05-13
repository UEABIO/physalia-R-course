## 🧪 Full Shiny App Example

library(shiny)
library(tidyverse)
library(palmerpenguins)
library(bslib)

penguins <- drop_na(palmerpenguins::penguins)

ui <- page_fluid(
  theme = bs_theme(bootswatch = "minty"),
  layout_columns(
    col_widths = c(6, 6),
    
    card(
      card_header("🔄 Instant Update Plot"),
      selectInput("species_reactive", "Choose a species:", choices = unique(penguins$species)),
      sliderInput("bins_reactive", "Number of bins:", min = 5, max = 50, value = 20),
      plotOutput("plot_reactive")
    ),
    
    card(
      card_header("🖱 Manual Update Plot"),
      selectInput("species_manual", "Choose a species:", choices = unique(penguins$species)),
      sliderInput("bins_isolate", "Number of bins:", min = 5, max = 50, value = 20),
      plotOutput("plot_manual")
    )
  )
)

server <- function(input, output) {
  
  ## ✅ Example 1: Fully Reactive Plot
  filtered_reactive <- reactive({
    penguins |> filter(species == input$species_reactive)
  })
  
  output$plot_reactive <- renderPlot({
    ggplot(filtered_reactive(), aes(x = flipper_length_mm)) +
      geom_histogram(bins = input$bins_reactive, fill = "#4C9F70") +
      labs(title = "Auto-Updating Plot") +
      theme_minimal()
  })
  
  ## ✅ Example 2: Manual Update using reactiveValues() and isolate()

  filtered_reactive2 <- reactive({
    penguins |> filter(species == input$species_manual)
  })
  
  output$plot_manual <- renderPlot({
     ggplot(filtered_reactive2(), aes(x = flipper_length_mm)) +
      geom_histogram(bins = isolate(input$bins_isolate), fill = "#9B59B6") +
      labs(title = "Manually Updated Plot") +
      theme_minimal()
  })
}

# Run app ----
shinyApp(ui, server)
