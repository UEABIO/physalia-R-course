# scripts/02_validate.R ----
# Runs the codebook rules on the raw data (expected to FAIL) and, once
# 01_clean.R has run, on the clean data (expected to PASS). In an interactive
# session the full pointblank report also opens in the Viewer.
library(tidyverse)
library(here)
source(here("scripts", "functions", "validate_voles.R"))

report_validation <- function(validation) {
  steps <- validation$validation_set
  n_failed <- sum(!steps$all_passed)
  cat(
    validation$label, ": ",
    if (n_failed == 0) "all rules pass" else paste(n_failed, "of", nrow(steps), "rules fail"),
    "\n",
    sep = ""
  )
  if (interactive()) print(validation)
  invisible(validation)
}

raw_df <- read_csv(here("data", "raw", "voles_raw.csv"), col_types = voles_col_types())
# values that could not be read as numbers become NA and would pass the
# range rules, so list them
print(problems(raw_df), width = Inf)
report_validation(validate_voles(raw_df, "Raw data (expected to FAIL)"))

clean_path <- here("data", "derived", "voles_clean.csv")
if (file.exists(clean_path)) {
  clean_df <- read_csv(clean_path, col_types = voles_col_types())
  report_validation(validate_voles(clean_df, "Clean data (expected to PASS)"))
}
