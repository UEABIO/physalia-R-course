# scripts/03_audit_cleaning.R ----
library(tidyverse)
library(here)
source(here("scripts", "functions", "validate_voles.R"))

to_long <- function(data, value_name) {
  data |>
    pivot_longer(
      -raw_row,
      names_to = "column",
      values_to = value_name,
      values_transform = as.character
    )
}

# raw values are read as text, exactly as entered, so a logged old value can be
# compared character for character
raw_long_df <- read_csv(
  here("data", "raw", "voles_raw.csv"),
  col_types = cols(.default = col_character())
) |>
  mutate(raw_row = as.character(row_number())) |>
  to_long("raw_value")

clean_long_df <- read_csv(here("data", "derived", "voles_clean.csv"), col_types = voles_col_types()) |>
  to_long("clean_value")

cleaning_log_df <- read_csv(
  here("data", "derived", "cleaning_log.csv"),
  col_types = cols(.default = col_character())
)

# 1. Truthful: every logged old value matches the raw file ----
untruthful_df <- cleaning_log_df |>
  left_join(raw_long_df, by = c("raw_row", "column")) |>
  filter(!map2_lgl(old_value, raw_value, identical))

# 2. Complete: every changed cell appears in the log ----
unlogged_df <- clean_long_df |>
  left_join(raw_long_df, by = c("raw_row", "column")) |>
  filter(!map2_lgl(clean_value, raw_value, identical)) |>
  anti_join(cleaning_log_df, by = c("raw_row", "column"))

# both tables should have no rows; tests/test_audit.R checks the same things
# and fails if they do not
print(untruthful_df, width = Inf)
print(unlogged_df, width = Inf)

# 3. What kinds of change were made ----
cleaning_log_df |> count(column, rule, sort = TRUE)

# 4. Ten logged changes to check by hand against the raw file ----
set.seed(2026)
cleaning_log_df |> slice_sample(n = 10) |> print(width = Inf)
