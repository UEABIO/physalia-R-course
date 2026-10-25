# Catch up: Day 3 ----
# Recreates penguins_complete (Block 1) and theme_project() (Block 3).
# Run it inside your project.
library(tidyverse)
library(here)

# Block 1: palmerpenguins::penguins without its incomplete rows
penguins_complete <- palmerpenguins::penguins |>
  tidyr::drop_na(body_mass_g, flipper_length_mm, bill_length_mm, bill_depth_mm, sex)

# Block 3: the house theme
theme_project <- function(base_size = 12) {
  theme_minimal(base_size = base_size) +
    theme(
      panel.grid.minor = element_blank(),
      axis.title = element_text(face = "bold"),
      plot.title = element_text(face = "bold", size = rel(1.1)),
      plot.subtitle = element_text(colour = "grey40"),
      legend.position = "bottom",
      plot.background = element_rect(fill = "white", colour = NA),
      strip.text = element_text(face = "bold")
    )
}
