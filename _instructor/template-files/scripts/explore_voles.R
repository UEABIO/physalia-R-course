# scripts/explore_voles.R ----
# A quick exploratory look at the voles data (Block 3). Exploratory, so it is
# unnumbered and not part of the run order.
library(tidyverse)
library(here)
source(here("scripts", "functions", "load_voles.R"))

voles <- load_voles()

# how many animals per treatment arm and sex
voles |>
  count(treatment_arm, sex) |>
  print()
