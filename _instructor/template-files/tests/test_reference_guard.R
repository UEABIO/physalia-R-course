# tests/test_reference_guard.R ----
# Block 8: the characterisation test the agent wrote checks the function
# against the reference YOU captured, rather than against numbers it typed or
# a copy of the computation.
library(testthat)
testthat::local_edition(3)

test_that("the characterisation test reads your reference and calls the function", {
  path <- here::here("tests", "test_summary_functions.R")
  skip_if_not(file.exists(path), "Block 8 not done yet")
  code <- paste(readLines(path, warn = FALSE), collapse = "\n")
  # a comment may mention the capture script; only the code counts
  code <- gsub("#[^\n]*", "", code)

  expect_match(code, "readRDS", fixed = TRUE)
  expect_match(code, "metabolic_summary.rds", fixed = TRUE)
  expect_match(code, "summarise_metabolic_rate(", fixed = TRUE)
  expect_false(grepl("saveRDS|make_reference", code),
               label = "the test never writes or regenerates the reference")
})

test_that("the reference is still the file you committed", {
  path <- here::here("tests", "fixtures", "metabolic_summary.rds")
  skip_if_not(file.exists(path), "Block 8 not done yet: no reference captured")
  # git knows whether the reference changed since your last commit
  changed <- tryCatch(
    gert::git_status(pathspec = "tests/fixtures", repo = here::here()),
    error = function(e) NULL
  )
  skip_if(is.null(changed), "not a git repository")
  expect_equal(nrow(changed), 0,
               label = "uncommitted changes under tests/fixtures/")
})
