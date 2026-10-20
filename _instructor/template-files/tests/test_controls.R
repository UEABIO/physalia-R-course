# tests/test_controls.R ----
# Blocks 5 and 6: the instruction file is connected, and no shipped deny rule
# has been removed. An agent cannot edit .claude/ with its edit tools, but R
# code it runs could; this test catches that by any route.
library(testthat)
testthat::local_edition(3)

shipped_deny_rules <- c(
  "Edit(/data/raw/**)",
  "Edit(/docs/data_note.md)",
  "Edit(/docs/codebook.csv)",
  "Edit(/scripts/02_validate.R)",
  "Edit(/scripts/03_audit_cleaning.R)",
  "Edit(/scripts/functions/validate_voles.R)",
  "Edit(/tests/fixtures/**)",
  "Edit(/tests/make_reference.R)",
  "Edit(/tests/test_cleaning.R)",
  "Edit(/renv.lock)",
  "Edit(/.github/**)",
  "Edit(/.claude/**)",
  "Edit(/.posit/**)",
  "Edit(/hooks/**)",
  "Read(/.Renviron)",
  "Read(/.env)"
)

test_that("every shipped deny rule is still in .claude/settings.json", {
  settings <- jsonlite::read_json(here::here(".claude", "settings.json"))
  deny <- unlist(settings$permissions$deny)
  missing_rules <- setdiff(shipped_deny_rules, deny)
  expect_length(missing_rules, 0)
})

test_that("CLAUDE.md contains only the import of AGENTS.md", {
  skip_if_not(
    file.exists(here::here("CLAUDE.md")),
    "Block 5 not done yet: no CLAUDE.md"
  )
  lines <- trimws(readLines(here::here("CLAUDE.md"), warn = FALSE))
  expect_identical(lines[nzchar(lines)], "@AGENTS.md")
  expect_true(file.exists(here::here("AGENTS.md")))
})
