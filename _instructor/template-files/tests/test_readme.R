# tests/test_readme.R ----
# Self-study page "Reporting from your repository", Part B: every checkable
# statement in README.md agrees with the files it was drafted from. The AI may
# phrase the facts; it may not invent them.
library(testthat)
testthat::local_edition(3)

readme_path <- here::here("README.md")

read_readme <- function() readLines(readme_path, warn = FALSE)

read_lock <- function() jsonlite::read_json(here::here("renv.lock"))

test_that("the README states the R version pinned in renv.lock", {
  skip_if_not(file.exists(readme_path), "Self-study README not written yet: no README.md")
  r_version <- read_lock()$R$Version
  expect_true(any(grepl(r_version, read_readme(), fixed = TRUE)),
              label = paste("README mentions R", r_version))
  expect_true(any(grepl("renv::restore()", read_readme(), fixed = TRUE)),
              label = "README gives renv::restore()")
})

test_that("the README lists every numbered script in the scripts folder", {
  skip_if_not(file.exists(readme_path), "Self-study README not written yet: no README.md")
  scripts <- list.files(here::here("scripts"), pattern = "^\\d{2}_.*\\.R$")
  text <- paste(read_readme(), collapse = "\n")
  listed <- vapply(scripts, \(s) grepl(s, text, fixed = TRUE), logical(1))
  expect_true(all(listed),
              label = paste("missing:", paste(scripts[!listed], collapse = ", ")))
})

test_that("no template tokens are left, and placeholders are reported", {
  skip_if_not(file.exists(readme_path), "Self-study README not written yet: no README.md")
  lines <- read_readme()
  expect_false(any(grepl("{{", lines, fixed = TRUE)))
  n_todo <- sum(grepl("TODO: supply", lines, fixed = TRUE))
  message("README placeholders still to fill: ", n_todo)
  succeed()
})

test_that("a unit the codebook leaves blank is a placeholder, not invented", {
  skip_if_not(file.exists(readme_path), "Self-study README not written yet: no README.md")
  codebook_path <- here::here("docs", "codebook.csv")
  skip_if_not(file.exists(codebook_path), "no docs/codebook.csv")
  codebook <- readr::read_csv(codebook_path,
                              col_types = readr::cols(.default = "c"))
  blank <- codebook$column[is.na(codebook$unit) |
                             codebook$unit %in% c("", "<unit>")]
  # only the data dictionary states units: check the table row whose first cell
  # is the column's name; a sentence or another table that mentions the column
  # is not checked
  table_rows <- grep("^\\s*\\|", read_readme(), value = TRUE)
  for (column in blank) {
    first_cell <- paste0("^\\s*\\|\\s*`?", column, "`?\\s*\\|")
    rows <- table_rows[grepl(first_cell, table_rows)]
    for (row in rows) {
      expect_true(grepl("TODO", row, fixed = TRUE),
                  label = paste0("README's dictionary row for ", column,
                                 " has a TODO, not an invented unit"))
    }
  }
  succeed()
})
