# scripts/00_profile.R ----
# Purpose: describe the raw file as entered, before any decision is made.
# Every column is read as character so codes such as 9999 or -1 appear
# exactly as entered.
library(tidyverse)
library(here)

raw_df <- read_csv(
  here("data", "raw", "voles_raw.csv"),
  col_types = cols(.default = col_character())
)

# one row per column: missingness, distinct values, numeric range ----
profile_df <- raw_df |>
  pivot_longer(everything(), names_to = "column", values_to = "value") |>
  # suppressWarnings: text values become NA here by design
  mutate(value_num = suppressWarnings(as.numeric(value))) |>
  summarise(
    n_rows = n(),
    n_missing = sum(is.na(value)),
    n_distinct = n_distinct(value, na.rm = TRUE),
    n_numeric = sum(!is.na(value_num)),
    min_numeric = if (all(is.na(value_num))) NA_real_ else min(value_num, na.rm = TRUE),
    max_numeric = if (all(is.na(value_num))) NA_real_ else max(value_num, na.rm = TRUE),
    .by = column
  )

# every distinct label in the categorical columns ----
labels_df <- raw_df |>
  select(sex, treatment_arm) |>
  pivot_longer(everything(), names_to = "column", values_to = "value") |>
  count(column, value, sort = TRUE)

# identifiers that appear more than once, or whose length differs from the
# usual one (a possible formatting slip) ----
usual_length <- as.integer(names(which.max(table(nchar(raw_df$subject_id)))))
ids_df <- raw_df |>
  count(subject_id) |>
  mutate(unusual_length = nchar(subject_id) != usual_length) |>
  filter(n > 1 | unusual_length)

# print in full, and save each table so it can be opened, pasted or diffed ----
print(profile_df, n = Inf, width = Inf)
print(labels_df, n = Inf, width = Inf)
print(ids_df, width = Inf)
write_csv(profile_df, here("docs", "profile.csv"))
write_csv(labels_df, here("docs", "profile_labels.csv"))
write_csv(ids_df, here("docs", "profile_ids.csv"))
