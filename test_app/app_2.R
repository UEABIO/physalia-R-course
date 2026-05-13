library(shiny)
library(tidyverse)
library(janitor)
library(sf)
library(here)
library(paletteer)


# Load spatial vegetation data
# This assumes you have the Jornada Basin vegetation KML file locally
jornada_veg <- read_sf(here("data", "doc.kml")) %>%
  dplyr::select(Name) %>%
  clean_names()

# UI ----
ui <- page_sidebar(
  sidebar = sidebar(
  titlePanel("Jornada Basin Vegetation Explorer"),
  p("All vegetation types are displayed. Use the menu to highlight one."),
radioButtons("highlight", "Vegetation type:", 
             choices = unique(jornada_veg$name),
            selected = unique(jornada_veg$name)[1]),
checkboxInput("show_labels", "Show labels?", value = TRUE)


  ),
  plotOutput("veg_map", height = "1000px", width ="100%"),
   DT::dataTableOutput("veg_table")
)

# Server ----
server <- function(input, output) {
  output$veg_map <- renderPlot({
    plot <- ggplot() +
      # Draw all types faded
      geom_sf(data = jornada_veg,
              aes(fill = name),
              alpha = 0.2, color = "white") +
      # Highlight selected type with full alpha + outline
      geom_sf(data = filter(jornada_veg, name == input$highlight),
              aes(fill = name),
              alpha = 0.8, color = "black", size = 0.5) +
      scale_fill_paletteer_d("ggthemes::manyeys") +
      labs(
        fill = "Vegetation Type",
        caption = "Source: Jornada Basin LTER"
      ) +
      theme_minimal(base_size = 12) +
      theme(
        plot.title.position = "plot",
        plot.caption = element_text(face = "italic", 
                                    color = "gray40",
                                    size = rel(1.5)),
        axis.text = element_blank(),
        axis.ticks = element_blank(),
        legend.position = "top",
        legend.title = element_text(face = "bold",
                                    size = rel(1.5)),
        legend.text = element_text(size = rel(1.5))
        )
    if (input$show_labels) {
       plot  + geom_sf_text(data = filter(jornada_veg, name == input$highlight), aes(label = name), size = 5)
    }
    else {
      plot
    }
      
  })
  output$veg_table <- DT::renderDataTable({
    jornada_veg |>
      st_drop_geometry() |>
      group_by(name) |>
      summarise(count = n()) |>
      filter(name == input$highlight)
})
  
}

# Run app ----
shinyApp(ui, server)
