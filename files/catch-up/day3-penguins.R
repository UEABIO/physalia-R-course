# Catch up: Day 3, Blocks 2 and 3 ----
# Recreates penguins_complete (Block 1). Run it inside your project.
library(tidyverse)
library(here)

# Block 1: palmerpenguins::penguins without its incomplete rows
penguins_complete <- palmerpenguins::penguins |>
  tidyr::drop_na(body_mass_g, flipper_length_mm, bill_length_mm, bill_depth_mm, sex)
