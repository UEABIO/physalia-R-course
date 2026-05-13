## 🧪 Full Shiny App Example

```{r, eval = FALSE}
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
      sliderInput("bins_manual", "Number of bins:", min = 5, max = 50, value = 20),
      actionButton("update", "Update Plot"),
      plotOutput("plot_manual")
    )
  )
)