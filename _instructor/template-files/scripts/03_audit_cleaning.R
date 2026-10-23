# scripts/03_audit_cleaning.R ----
# Purpose: read the cleaning log yourself. tests/test_cleaning.R already checks
# that the log is truthful and complete; it cannot tell you whether each change
# was the right decision. That is your job.
library(tidyverse)
library(here)

cleaning_log_df <- read_csv(
  here("data", "derived", "cleaning_log.csv"),
  col_types = cols(.default = col_character())
)

# 1. What kinds of change were made ----
cleaning_log_df |> count(column, rule, sort = TRUE) |> print()

# 2. Up to ten logged changes to check by hand against the raw file ----
set.seed(2026)
cleaning_log_df |> slice_sample(n = 10) |> print(width = Inf)
