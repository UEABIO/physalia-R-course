# tests/test_cleaning.R ----
# Block 7: the raw data are untouched, every row is accounted for, every
# change is logged truthfully, nothing was over-cleaned, and the clean data
# pass every codebook rule. Written from the agreed codebook, before any
# cleaning code existed. Raw values are read as text, exactly as entered, so a
# logged old value can be compared character for character.
library(testthat)
testthat::local_edition(3)

read_chr <- function(...) {
  readr::read_csv(
    here::here(...),
    col_types = readr::cols(.default = readr::col_character())
  )
}

to_long <- function(data, value_name) {
  data |>
    tidyr::pivot_longer(-raw_row, names_to = "column", values_to = value_name)
}

same <- function(x, y) (is.na(x) & is.na(y)) | (!is.na(x) & !is.na(y) & x == y)

clean_path <- here::here("data", "derived", "voles_clean.csv")

cleaning_inputs <- function() {
  raw_df <- read_chr("data", "raw", "voles_raw.csv") |>
    dplyr::mutate(raw_row = as.character(dplyr::row_number()))
  clean_df <- read_chr("data", "derived", "voles_clean.csv")
  list(
    raw = raw_df,
    clean = clean_df,
    excluded = read_chr("data", "derived", "exclusion_log.csv"),
    log = read_chr("data", "derived", "cleaning_log.csv"),
    raw_long = to_long(raw_df, "raw_value"),
    clean_long = to_long(clean_df, "clean_value")
  )
}

test_that("raw data are unchanged", {
  checksum_path <- here::here("tests", "fixtures", "raw_checksum.txt")
  skip_if_not(file.exists(checksum_path), "no checksum file: tests/fixtures/raw_checksum.txt is missing")
  recorded <- readLines(checksum_path)
  current <- unname(tools::md5sum(here::here("data", "raw", "voles_raw.csv")))
  expect_identical(current, recorded)
})

test_that("every raw row is either in the clean data or in the exclusion log", {
  skip_if_not(file.exists(clean_path), "Block 7 not done yet: no clean data")
  x <- cleaning_inputs()

  expect_equal(nrow(x$raw), nrow(x$clean) + nrow(x$excluded))
  expect_setequal(c(x$clean$raw_row, x$excluded$raw_row), x$raw$raw_row)
  expect_false(any(is.na(x$excluded$reason) | x$excluded$reason == ""))
})

test_that("every log entry is truthful: old value from raw, new value in clean", {
  skip_if_not(file.exists(clean_path), "Block 7 not done yet: no clean data")
  x <- cleaning_inputs()
  wrong_old <- x$log |>
    dplyr::left_join(x$raw_long, by = c("raw_row", "column")) |>
    dplyr::filter(!same(old_value, raw_value))
  wrong_new <- x$log |>
    dplyr::inner_join(x$clean_long, by = c("raw_row", "column")) |>
    dplyr::filter(!same(new_value, clean_value))
  expect_equal(nrow(wrong_old), 0)
  expect_equal(nrow(wrong_new), 0)
})

test_that("every changed cell appears in the log", {
  skip_if_not(file.exists(clean_path), "Block 7 not done yet: no clean data")
  x <- cleaning_inputs()
  numeric_cols <- c("mass_pre_g", "mass_post_g", "metabolic_rate_post")
  changed <- x$clean_long |>
    dplyr::left_join(x$raw_long, by = c("raw_row", "column")) |>
    dplyr::mutate(
      # numbers are compared as numbers, so 28.30 and 28.3 count as unchanged
      differs = dplyr::if_else(
        column %in% numeric_cols,
        !same(suppressWarnings(as.numeric(clean_value)),
              suppressWarnings(as.numeric(raw_value))),
        !same(clean_value, raw_value)
      )
    ) |>
    dplyr::filter(differs)
  unlogged <- dplyr::anti_join(changed, x$log, by = c("raw_row", "column"))
  expect_equal(nrow(unlogged), 0)
})

test_that("no more values were set to NA than the codebook explains", {
  skip_if_not(file.exists(clean_path), "Block 7 not done yet: no clean data")
  x <- cleaning_inputs()
  codebook <- read_chr("docs", "codebook.csv")
  numeric_rules <- dplyr::filter(codebook, !is.na(min) | !is.na(max) | !is.na(missing_codes))

  for (i in seq_len(nrow(numeric_rules))) {
    col <- numeric_rules$column[[i]]
    codes <- trimws(strsplit(dplyr::coalesce(numeric_rules$missing_codes[[i]], ""), ";")[[1]])
    lo <- as.numeric(numeric_rules$min[[i]])
    hi <- as.numeric(numeric_rules$max[[i]])

    kept_raw <- x$raw[[col]][match(x$clean$raw_row, x$raw$raw_row)]
    value <- suppressWarnings(as.numeric(kept_raw))
    explained <- !is.na(kept_raw) & (
      kept_raw %in% codes |
        (!is.na(lo) & !is.na(value) & value < lo) |
        (!is.na(hi) & !is.na(value) & value > hi)
    )
    newly_na <- !is.na(kept_raw) & is.na(x$clean[[col]])

    expect_equal(sum(newly_na), sum(explained),
                 label = paste("values newly set to NA in", col))
  }
})

test_that("cleaning is reproducible: a fresh run writes identical files", {
  skip_if_not(file.exists(clean_path), "Block 7 not done yet: no clean data")
  derived <- here::here("data", "derived",
                        c("voles_clean.csv", "cleaning_log.csv", "exclusion_log.csv"))
  before <- unname(tools::md5sum(derived))
  callr::rscript(here::here("scripts", "01_clean.R"), wd = here::here(),
                 show = FALSE)
  expect_identical(unname(tools::md5sum(derived)), before)
})

test_that("clean data pass every rule in the agreed codebook", {
  skip_if_not(file.exists(clean_path), "Block 7 not done yet: no clean data")
  clean_df <- readr::read_csv(
    clean_path,
    col_types = readr::cols(
      subject_id = readr::col_character(),
      sex = readr::col_character(),
      treatment_arm = readr::col_character(),
      mass_pre_g = readr::col_double(),
      mass_post_g = readr::col_double(),
      metabolic_rate_post = readr::col_double(),
      .default = readr::col_character()
    )
  )
  expect_equal(nrow(readr::problems(clean_df)), 0)

  # identifiers and labels
  expect_true(all(grepl("^V[0-9]{3}$", clean_df$subject_id)))
  expect_false(anyDuplicated(clean_df$subject_id) > 0)
  expect_true(all(clean_df$sex %in% c("M", "F")))
  expect_true(all(clean_df$treatment_arm %in% c("Control", "Low_dose", "High_dose")))

  # ranges; a missing value is allowed, an out-of-range one is not
  in_range <- function(x, lo, hi) all(is.na(x) | (x >= lo & x <= hi))
  expect_true(in_range(clean_df$mass_pre_g, 15, 60))
  expect_true(in_range(clean_df$mass_post_g, 15, 60))
  expect_true(in_range(clean_df$metabolic_rate_post, 5, 30))
})
