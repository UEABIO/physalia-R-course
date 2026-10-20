# scripts/04_load_data.R ----
library(tidyverse)
library(here)
source(here("scripts", "functions", "load_voles.R"))

voles <- load_voles()
