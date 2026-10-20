# tests/test_cleaning.R ----
# Block 7: the raw data are untouched, every row is accounted for, and the
# clean data pass every codebook rule.
library(testthat)
testthat::local_edition(3)
source(here::here("scripts", "functions", "validate_voles.R"))

read_chr <- function(...) {
  readr::read_csv(
    here::here(...),
    col_types = readr::cols(.default = readr::col_character())
  )
}

clean_path <- here::here("data", "derived", "voles_clean.csv")

test_that("raw data are unchanged", {
  checksum_path <- here::here("tests", "fixtures", "raw_checksum.txt")
  skip_if_not(file.exists(checksum_path), "Block 7 Step 0 not done yet")
  recorded <- readLines(checksum_path)
  current <- unname(tools::md5sum(here::here("data", "raw", "voles_raw.csv")))
  expect_identical(current, recorded)
})

test_that("every raw row is either in the clean data or in the exclusion log", {
  skip_if_not(file.exists(clean_path), "Block 7 not done yet: no clean data")
  raw_df <- read_chr("data", "raw", "voles_raw.csv")
  clean_df <- read_chr("data", "derived", "voles_clean.csv")
  excluded_df <- read_chr("data", "derived", "exclusion_log.csv")

  expect_equal(nrow(raw_df), nrow(clean_df) + nrow(excluded_df))
  expect_setequal(
    c(clean_df$raw_row, excluded_df$raw_row),
    as.character(seq_len(nrow(raw_df)))
  )
  expect_false(any(is.na(excluded_df$reason) | excluded_df$reason == ""))
})

test_that("clean data pass every codebook rule", {
  skip_if_not(file.exists(clean_path), "Block 7 not done yet: no clean data")
  clean_df <- readr::read_csv(clean_path, col_types = voles_col_types())
  expect_equal(nrow(readr::problems(clean_df)), 0)
  validation <- validate_voles(clean_df, "Clean data")
  expect_true(pointblank::all_passed(validation))
})
