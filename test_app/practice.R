## 📦 Exploring Shiny Output Types (New App Example)

Now that you've built an app to explore spatial data using dropdowns and `renderPlot()`, let’s shift gears and explore the **full range of output types Shiny supports**. We'll use a **simpler dataset** for this: the `palmerpenguins` dataset.

This will help us clearly demonstrate outputs like:
  - Dynamic text
- Plots
- Tables
- Images
- Downloadable files

We'll later come back to how you can integrate these ideas into your more complex apps.

---

## 🐧 New App: Penguins Output Explorer

We'll use several inputs to customize what the app shows, and several outputs to display that data.

### Step 1: Setup

```r
library(shiny)
library(bslib)
library(tidyverse)
library(palmerpenguins)
library(DT)

penguins <- as_tibble(palmerpenguins::penguins)
```

### Step 2: UI with Multiple Inputs and Outputs

```r
ui <- page_fluid(
  sidebarLayout(
    sidebarPanel(
      selectInput("species", "1. Select species:",
                  choices = unique(na.omit(penguins$species))),
      selectInput("colour", "2. Select histogram colour:",
                  choices = c("blue","green","red","purple","grey")),
      sliderInput("bin", "3. Select number of histogram bins:",
                  min = 1, max = 25, value = 10),
      textAreaInput("text", "4. Enter some text to be displayed:",
                    rows = 3, placeholder = "Write something")
    ),
    mainPanel(
      textOutput("demo_text"),
      plotOutput("demo_plot", height = "300px"),
      DT::dataTableOutput("demo_table"),
      imageOutput("demo_image"),
      downloadButton("download_csv", label = "Download Filtered Data")
    )
  )
)
```

### Step 3: Server Logic

```r
server <- function(input, output) {
  
  penguins_filtered <- reactive({
    filter(penguins, species == input$species)
  })
  
  output$demo_text <- renderText({
    paste("Figure 1.", input$species, input$text)
  })
  
  output$demo_plot <- renderPlot({
    ggplot(penguins_filtered(), aes(x = flipper_length_mm)) +
      geom_histogram(fill = input$colour, bins = input$bin) +
      theme_minimal()
  })
  
  output$demo_table <- DT::renderDataTable({
    penguins_filtered() %>% 
      summarise(
        flipper_length_mm = quantile(flipper_length_mm, c(0.25, 0.5, 0.75), na.rm = TRUE),
        quantile = c(0.25, 0.5, 0.75)
      )
  })
  
  output$demo_image <- renderImage({
    list(src = "images/penguin.jpg",
         width = 200,
         height = 150,
         alt = "A penguin")
  }, deleteFile = FALSE)
  
  output$download_csv <- downloadHandler(
    filename = function() {
      paste("filtered_penguins_", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      write.csv(penguins_filtered(), file, row.names = FALSE)
    }
  )
}

shinyApp(ui, server)
```

---
  
  This version of the app demonstrates five core output types:
  - **Text** using `renderText()`
- **Plot** using `renderPlot()`
- **Table** using `DT::renderDataTable()`
- **Image** using `renderImage()`
- **Download** using `downloadHandler()`

> 🚀 Up next, we’ll challenge you to modify this app or add your own output component.

######

🌿 Options for Bringing Output Types into the Jornada App
Each idea is tied to a specific output type and builds on your existing “highlight vegetation type” app.

🔹 1. Add Dynamic Text (renderText)
📌 Goal: Show a description or summary of the selected vegetation type
UI:
  
  r
Copy
Edit
textOutput("veg_summary")
Server:
  
  r
Copy
Edit
output$veg_summary <- renderText({
  selected <- input$highlight
  paste("You have selected:", selected)
})
🧠 This reinforces how to return a string from the server and makes the dropdown feel more interactive.

🔹 2. Add a Table (renderTable or DT::renderDataTable)
📌 Goal: Show the number of polygons or total area for each vegetation type
UI:
  
  r
Copy
Edit
DT::dataTableOutput("veg_table")
Server:
  
  r
Copy
Edit
output$veg_table <- DT::renderDataTable({
  jornada_veg |>
    st_drop_geometry() |>
    group_by(name) |>
    summarise(count = n()) |>
    filter(name == input$highlight)
})
🧠 This links a table directly to a spatial selection, without introducing full reactivity complexity.

🔹 3. Add a Download Button (downloadHandler)
📌 Goal: Let users download the selected vegetation as a GeoJSON or CSV file
UI:
  
  r
Copy
Edit
downloadButton("download_veg", "Download selected polygons")
Server:
  
  r
Copy
Edit
output$download_veg <- downloadHandler(
  filename = function() {
    paste0("veg_", input$highlight, "_", Sys.Date(), ".geojson")
  },
  content = function(file) {
    selected <- filter(jornada_veg, name == input$highlight)
    st_write(selected, file, driver = "GeoJSON")
  }
)


# 🔄 Reactivity in Shiny: Making Your App Respond

Shiny’s **reactivity system** is what makes your app dynamic. It automatically updates outputs when users interact with inputs.

But that only works if you understand **when** and **where** to use reactive values like `input$species`.

---
  
  ## 🧠 What is Reactivity?
  
  At its core, **reactivity** is a system for **automatically tracking dependencies**. When a user changes something in the UI, Shiny knows which pieces of your app depend on it — and updates only those parts.

---
  
  ## 🧪 Reactivity in Action: The Classic Mistake
  
  Let’s walk through a common issue. Try moving your data filtering outside `renderPlot()`:
  
  ```{r, eval = FALSE}
server <- function(input, output) {
  penguins_filtered <- penguins |>
    filter(species == input$species)   # ❌ This will fail
  
  output$demo_plot <- renderPlot({
    ggplot(penguins_filtered, aes(x = flipper_length_mm)) +
      geom_histogram()
  })
}
🧨 Error:
  
  rust
Copy
Edit
Can't access reactive value 'species' outside of reactive consumer.
This happens because input$species is a reactive value — and can only be used inside certain “reactive contexts”.

✅ Fixing It with renderPlot()
Here’s the correct approach — put the filtering inside the render function:

{r,
Copy
Edit
server <- function(input, output) {
  output$demo_plot <- renderPlot({
    penguins_filtered <- penguins |>
      filter(species == input$species)

    ggplot(penguins_filtered, aes(x = flipper_length_mm)) +
      geom_histogram()
  })
}
This works because renderPlot() is a reactive context — it knows to re-run when input$species changes.

🔁 Reusing Logic with reactive()
What if you want to use the filtered dataset in more than one place — like a plot and a table?

That’s when you create a reactive expression:

{r,
Copy
Edit
server <- function(input, output) {
  penguins_filtered <- reactive({
    penguins |> filter(species == input$species)
  })

  output$demo_plot <- renderPlot({
    ggplot(penguins_filtered(), aes(x = flipper_length_mm)) +
      geom_histogram()
  })

  output$demo_table <- DT::renderDataTable({
    penguins_filtered() |>
      summarise(...)  # Use same data
  })
}
✅ Reactive expressions act like “smart variables” that automatically update when needed.
🚨 Don't forget the () when calling them!
  
  💡 Visual Summary
text
Copy
Edit
input$species
↓
reactive()   → reusable filtered data
↓             ↓
renderPlot()   renderDataTable()
🧠 Tip: Know When to Use Which
Purpose	Use	Returns a value?
  Generate output (plot, table)	renderPlot(), renderText() etc.	✅
Store reusable data logic	reactive()	✅
Trigger an action (no return)	observeEvent()	❌
✋ But What If I Only Want to Update on Button Click?
  Sometimes, you don’t want the app to update constantly. You want the user to make changes, then click a “Go” button.

For that, use observeEvent():
  
  {r,
    Copy
    Edit
    server <- function(input, output) {
      observeEvent(input$update, {
        filtered <- penguins |> filter(species == input$species)
        
        output$demo_plot <- renderPlot({
          ggplot(filtered, aes(x = flipper_length_mm)) +
            geom_histogram()
        })
      })
    }
    This runs the code only when the button is clicked, regardless of other input changes.
    
    🔄 Recap of Shiny Reactivity
    Use render*() when producing an output
    
    Use reactive() when reusing logic across outputs
    
    Use observeEvent() for custom control over when updates happen
    
    Always access reactive values inside a reactive context
    
    💪 Challenge: Reactive Practice
    Update your penguins app so that:
      
      The filtered dataset is defined using reactive()
    
    The same data is used in both a plot and a data table
    
    Bonus: Add an actionButton() to only update when clicked using observeEvent()
    
    🧠 Common Errors and How to Fix Them
    Error Message	What It Means	How to Fix
    Can't access reactive value...	You used a reactive outside of a reactive context	Move into render*() or wrap in reactive()
Forgot () on reactive	You're calling a reactive variable like an object	Use my_data() not my_data
    Outputs update too often	You're not controlling reactivity	Use observeEvent() or isolate logic
