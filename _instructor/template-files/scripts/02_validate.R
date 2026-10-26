# scripts/02_validate.R ----
# Runs the codebook rules on the raw data (expected to FAIL) and, once
# 01_clean.R has run, on the clean data (expected to PASS). Each broken rule
# is listed with its rows and values; assertr then warns rather than stops,
# so both checks run.
library(tidyverse)
library(here)
source(here("scripts", "functions", "validate_voles.R"))

raw_df <- read_csv(here("data", "raw", "voles_raw.csv"), col_types = voles_col_types())
# values that could not be read as numbers become NA and would pass the
# range rules, so list them
print(problems(raw_df), width = Inf)
validate_voles(raw_df, "Raw data (expected to FAIL)")

clean_path <- here("data", "derived", "voles_clean.csv")
if (file.exists(clean_path)) {
  clean_df <- read_csv(clean_path, col_types = voles_col_types())
  validate_voles(clean_df, "Clean data (expected to PASS)")
}
