# tests/test_readme.R ----
# Block 10, Part C: every checkable statement in README.md agrees with the
# files it was drafted from. The AI may phrase the facts; it may not invent
# them.
library(testthat)
testthat::local_edition(3)

readme_path <- here::here("README.md")

read_readme <- function() readLines(readme_path, warn = FALSE)

read_lock <- function() jsonlite::read_json(here::here("renv.lock"))

test_that("the README states the R version pinned in renv.lock", {
  skip_if_not(file.exists(readme_path), "Block 10 not done yet: no README.md")
  r_version <- read_lock()$R$Version
  expect_true(any(grepl(r_version, read_readme(), fixed = TRUE)),
              label = paste("README mentions R", r_version))
  expect_true(any(grepl("renv::restore()", read_readme(), fixed = TRUE)),
              label = "README gives renv::restore()")
})

test_that("any package version the README states matches renv.lock", {
  skip_if_not(file.exists(readme_path), "Block 10 not done yet: no README.md")
  packages <- read_lock()$Packages
  lines <- read_readme()
  for (pkg in names(packages)) {
    # a version written right after the package name, as in "| dplyr | 1.1.4 |"
    # or "dplyr 1.1.4"; a version elsewhere on the line is not this package's
    pattern <- paste0(
      "(?<![A-Za-z0-9.])", gsub(".", "\\.", pkg, fixed = TRUE),
      "(?![A-Za-z0-9.])[\\s|:`*]{1,6}v?(\\d+\\.\\d+(?:\\.\\d+)*)"
    )
    stated <- unlist(regmatches(lines, gregexpr(pattern, lines, perl = TRUE)))
    versions <- sub(".*?v?(\\d+\\.\\d+(?:\\.\\d+)*)$", "\\1", stated, perl = TRUE)
    for (v in versions) {
      expect_identical(v, packages[[pkg]]$Version,
                       label = paste("README version for", pkg))
    }
  }
  succeed()
})

test_that("the README lists every numbered script in the scripts folder", {
  skip_if_not(file.exists(readme_path), "Block 10 not done yet: no README.md")
  scripts <- list.files(here::here("scripts"), pattern = "^\\d{2}_.*\\.R$")
  text <- paste(read_readme(), collapse = "\n")
  listed <- vapply(scripts, \(s) grepl(s, text, fixed = TRUE), logical(1))
  expect_true(all(listed),
              label = paste("missing:", paste(scripts[!listed], collapse = ", ")))
})

test_that("no template tokens are left, and placeholders are reported", {
  skip_if_not(file.exists(readme_path), "Block 10 not done yet: no README.md")
  lines <- read_readme()
  expect_false(any(grepl("{{", lines, fixed = TRUE)))
  n_todo <- sum(grepl("TODO: supply", lines, fixed = TRUE))
  message("README placeholders still to fill: ", n_todo)
  succeed()
})

test_that("a unit the codebook leaves blank is a placeholder, not invented", {
  skip_if_not(file.exists(readme_path), "Block 10 not done yet: no README.md")
  codebook_path <- here::here("docs", "codebook.csv")
  skip_if_not(file.exists(codebook_path), "no docs/codebook.csv")
  codebook <- readr::read_csv(codebook_path,
                              col_types = readr::cols(.default = "c"))
  blank <- codebook$column[is.na(codebook$unit) |
                             codebook$unit %in% c("", "<unit>")]
  lines <- read_readme()
  for (column in blank) {
    mentions <- lines[grepl(column, lines, fixed = TRUE)]
    if (length(mentions) > 0) {
      expect_true(any(grepl("TODO", mentions, fixed = TRUE)),
                  label = paste0("README gives no unit for ", column,
                                 " (codebook leaves it blank)"))
    }
  }
  succeed()
})
