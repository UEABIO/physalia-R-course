library(shiny)       # Essential for running any Shiny app
library(lterdatasampler)  # The source of your data
library(DT)  # For creating DataTables

# ui.R ----
# ui.R ----
ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "Dataset",
        label = "Select dataset",
        choices = c("and_vertebrates", "arc_weather", "hbr_maples", "luq_streamchem", 
                    "ntl_icecover", "ntl_airtemp", "nwt_pikas", "pie_crab")
      ),
      downloadButton("downloadData", "Download")
    ),
    mainPanel(
      DTOutput("demo_table", width = "50%")
    )
  )
)

# server.R ----
server <- function(input, output) {
  # Your server logic will be defined here
  output$demo_table <- DT::renderDataTable({
    data <- get(input$Dataset)  # Retrieve the selected data frame
    data
  })
  
  output$downloadData <- downloadHandler(
    filename = function() {
      # Use the selected dataset as the suggested file name
      paste0(input$Dataset, ".csv")
    },
    content = function(file) {
      # Write the dataset to the `file` that will be downloaded
      write_csv(get(input$Dataset), file)
    }
  )
  
}

# Run the app ----
shinyApp(ui = ui, server = server)
