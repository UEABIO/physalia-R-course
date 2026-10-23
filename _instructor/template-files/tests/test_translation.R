# tests/test_translation.R ----
# Block 6: the tidyverse translation your mini agent wrote gives the same
# output as the original base R code, once only presentation (types, row
# order) is normalised. The translation must behave like the original,
# including how it handles the missing value.
library(testthat)
testthat::local_edition(3)

legacy_rate_summary <- function() {
  voles <- read.csv(
    here::here("data", "raw", "voles_metabolism.csv"),
    stringsAsFactors = TRUE
  )
  rate_mean <- aggregate(metabolic_rate_post ~ treatment_arm + sex,
                         data = voles, FUN = mean)
  rate_n <- aggregate(metabolic_rate_post ~ treatment_arm + sex,
                      data = voles, FUN = length)
  names(rate_n)[3] <- "n"
  merge(rate_mean, rate_n, by = c("treatment_arm", "sex"))
}

normalise <- function(data) {
  data |>
    tibble::as_tibble() |>
    dplyr::mutate(dplyr::across(dplyr::where(is.factor), as.character)) |>
    dplyr::arrange(treatment_arm, sex)
}

test_that("the tidyverse summary matches the original base R summary", {
  path <- here::here("scripts", "functions", "summaries.R")
  skip_if_not(file.exists(path), "Block 6 not done yet: no summaries.R")

  # run the translation in a fresh R session, so library() calls in it cannot
  # change this one
  tidy_summary <- callr::r(
    function(path, loader) {
      source(loader)
      source(path)
      summarise_rate_tidy(load_voles())
    },
    args = list(path, here::here("scripts", "functions", "load_voles.R")),
    wd = here::here()
  )

  expect_equal(normalise(tidy_summary), normalise(legacy_rate_summary()))
})
