# book-specific code to include on every page

if (requireNamespace("knitr", quietly = TRUE)) {

  library(glossary)
  glossary::glossary_path("include/glossary.yml")
  glossary_popup("click") # "click", "hover" or "none"

  # default knitr options ----
  knitr::opts_chunk$set(
    echo       = TRUE,
    warning = FALSE,
    message = FALSE,
    results    = "hold",
    out.width  = '100%',
    fig.width  = 8,
    fig.height = 5,
    fig.align  = 'center',
    dpi = 96
  )
}

library(ggplot2)

my_theme <- theme_minimal(base_size = 16) +
  theme(
    panel.grid = element_blank(),  # Removes gridlines
    axis.line = element_line(color = "black")  # Adds x and y axis lines
  )

theme_set(my_theme)
