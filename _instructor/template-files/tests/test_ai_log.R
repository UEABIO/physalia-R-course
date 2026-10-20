# tests/test_ai_log.R ----
# Every block from Block 4: one line per piece of AI-assisted work, in the form
# date; tool and model; task; what you kept or changed
library(testthat)
testthat::local_edition(3)

read_log_lines <- function() {
  lines <- trimws(readLines(here::here("docs", "ai-log.md"), warn = FALSE))
  lines[nzchar(lines) & !startsWith(lines, "#")]
}

test_that("each AI-use log entry has four parts, separated by semicolons", {
  skip_if_not(
    file.exists(here::here("docs", "ai-log.md")),
    "Block 4 not done yet: no docs/ai-log.md"
  )
  lines <- read_log_lines()
  expect_gt(length(lines), 0)

  well_formed <- grepl("^\\d{4}-\\d{2}-\\d{2}; [^;]+; [^;]+; .+$", lines)
  expect_true(
    all(well_formed),
    label = paste("malformed line(s):", paste(which(!well_formed), collapse = ", "))
  )
})

test_that("AI-use log dates are real dates, in order", {
  skip_if_not(
    file.exists(here::here("docs", "ai-log.md")),
    "Block 4 not done yet: no docs/ai-log.md"
  )
  dates <- as.Date(substr(read_log_lines(), 1, 10))
  expect_false(anyNA(dates))
  expect_false(is.unsorted(dates))
})
