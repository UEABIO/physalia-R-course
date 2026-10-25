# Catch up: Day 1 ----
# Recreates what Blocks 1 and 2 leave behind: data/raw/penguins_raw.csv
# (only if it is missing) and penguins_clean. Run it inside your project.
library(tidyverse)
library(here)

# Block 1: the raw file, saved once from the package
raw_path <- here("data", "raw", "penguins_raw.csv")
if (!file.exists(raw_path)) {
  dir.create(here("data", "raw"), recursive = TRUE, showWarnings = FALSE)
  readr::write_csv(palmerpenguins::penguins_raw, raw_path)
}

# Block 2: read the raw file and clean it
penguins_raw <- readr::read_csv(raw_path, show_col_types = FALSE)

penguins_clean <- penguins_raw |>
  janitor::clean_names() |>
  # match the names used in palmerpenguins::penguins
  dplyr::rename(bill_length_mm = culmen_length_mm,
                bill_depth_mm  = culmen_depth_mm) |>
  # "Adelie Penguin (Pygoscelis adeliae)" -> "Adelie"
  dplyr::mutate(species = stringr::word(species, 1)) |>
  tidyr::drop_na(body_mass_g, flipper_length_mm, species)
