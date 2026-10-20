# tests/test_audit.R ----
# Block 7: the cleaning log is truthful and complete, and the cleaning did no
# more than the codebook allows. Raw values are read as text, exactly as
# entered, so a logged old value can be compared character for character.
library(testthat)
testthat::local_edition(3)

log_path <- here::here("data", "derived", "cleaning_log.csv")

allowed_rules <- c("missing_code", "label_recode", "id_format", "out_of_range_query")

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

audit_inputs <- function() {
  raw_df <- read_chr("data", "raw", "voles_raw.csv") |>
    dplyr::mutate(raw_row = as.character(dplyr::row_number()))
  clean_df <- read_chr("data", "derived", "voles_clean.csv")
  log_df <- read_chr("data", "derived", "cleaning_log.csv")
  list(
    raw = raw_df,
    clean = clean_df,
    log = log_df,
    raw_long = to_long(raw_df, "raw_value"),
    clean_long = to_long(clean_df, "clean_value")
  )
}

test_that("every logged old value matches the raw file", {
  skip_if_not(file.exists(log_path), "Block 7 not done yet: no cleaning log")
  x <- audit_inputs()
  untruthful <- x$log |>
    dplyr::left_join(x$raw_long, by = c("raw_row", "column")) |>
    dplyr::filter(!same(old_value, raw_value))
  expect_equal(nrow(untruthful), 0)
})

test_that("every logged new value is the value in the clean file", {
  skip_if_not(file.exists(log_path), "Block 7 not done yet: no cleaning log")
  x <- audit_inputs()
  mismatched <- x$log |>
    dplyr::inner_join(x$clean_long, by = c("raw_row", "column")) |>
    dplyr::filter(!same(new_value, clean_value))
  expect_equal(nrow(mismatched), 0)
})

test_that("every changed cell appears in the log", {
  skip_if_not(file.exists(log_path), "Block 7 not done yet: no cleaning log")
  x <- audit_inputs()
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

test_that("every cleaning-log rule comes from the agreed list", {
  skip_if_not(file.exists(log_path), "Block 7 not done yet: no cleaning log")
  rules <- unique(audit_inputs()$log$rule)
  expect_true(all(rules %in% allowed_rules),
              label = paste("unexpected rule(s):",
                            paste(setdiff(rules, allowed_rules), collapse = ", ")))
})

test_that("each excluded row's subject_id is the one in the raw file", {
  skip_if_not(file.exists(log_path), "Block 7 not done yet: no cleaning log")
  x <- audit_inputs()
  excluded <- read_chr("data", "derived", "exclusion_log.csv") |>
    dplyr::left_join(dplyr::select(x$raw, raw_row, raw_id = subject_id),
                     by = "raw_row")
  expect_true(all(same(excluded$subject_id, excluded$raw_id)))
})

test_that("no more values were set to NA than the codebook explains", {
  skip_if_not(file.exists(log_path), "Block 7 not done yet: no cleaning log")
  x <- audit_inputs()
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
