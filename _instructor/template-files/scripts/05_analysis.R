# scripts/05_analysis.R: the original, trusted version ----
library(tidyverse)
library(here)
source(here("scripts", "04_load_data.R"))

metabolic_summary <- voles |>
  group_by(treatment_arm, sex) |>
  summarise(
    mean_rate = mean(metabolic_rate_post),
    sd_rate   = sd(metabolic_rate_post),
    n         = n(),
    .groups   = "drop"
  )
