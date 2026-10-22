# tests/test_controls.R ----
# Blocks 5, 6 and 9: the instruction file is in place, the project is under
# git, it still starts in Manual mode, and no deny rule has been removed. An agent cannot
# edit .claude/ with its edit tools, but R code it runs could; this test
# catches that by any route.
library(testthat)
testthat::local_edition(3)

shipped_deny_rules <- c(
  "Edit(/data/raw/**)",
  "Read(/docs/data_note.md)",
  "Edit(/docs/data_note.md)",
  "Edit(/docs/codebook.csv)",
  "Edit(/scripts/02_validate.R)",
  "Edit(/scripts/03_audit_cleaning.R)",
  "Edit(/scripts/functions/validate_voles.R)",
  "Edit(/tests/fixtures/**)",
  "Edit(/tests/make_reference.R)",
  "Edit(/tests/test_cleaning.R)",
  "Edit(/tests/test_audit.R)",
  "Edit(/renv.lock)",
  "Edit(/.github/**)",
  "Edit(/.claude/**)",
  "Edit(/.posit/**)",
  "Edit(/hooks/**)",
  "Read(/.Renviron)",
  "Read(/.env)"
)

# rules added with /permissions may be saved to either project settings file
read_project_settings <- function() {
  paths <- here::here(".claude", c("settings.json", "settings.local.json"))
  lapply(paths[file.exists(paths)], jsonlite::read_json)
}

deny_rules <- function() {
  unlist(lapply(read_project_settings(), \(s) s$permissions$deny))
}

test_that("every shipped deny rule is still in place", {
  missing_rules <- setdiff(shipped_deny_rules, deny_rules())
  expect_length(missing_rules, 0)
})

test_that("the project starts in Manual mode", {
  modes <- unlist(lapply(read_project_settings(), \(s) s$permissions$defaultMode))
  expect_true(length(modes) > 0 && all(modes == "default"),
              label = "permissions.defaultMode is \"default\" (Manual)")
})

test_that("AGENTS.md is in place, with its canary and version-control rule", {
  agents <- here::here("AGENTS.md")
  expect_true(file.exists(agents))
  lines <- readLines(agents, warn = FALSE)
  expect_true(any(grepl("agents-md: active", lines, fixed = TRUE)))
  expect_true(any(grepl("git status", lines, fixed = TRUE)),
              label = "AGENTS.md asks the agent to run git status before editing")
  # a rule about git is only a request; git itself must be there
  repo <- tryCatch(gert::git_find(here::here()), error = function(e) NULL)
  expect_false(is.null(repo), label = "the project is a git repository")
})

test_that("a CLAUDE.md, if there is one, imports AGENTS.md", {
  # Claude Code reads AGENTS.md itself unless a CLAUDE.md exists; a CLAUDE.md
  # without the import would hide your conventions from it.
  claude <- here::here("CLAUDE.md")
  skip_if_not(file.exists(claude), "no CLAUDE.md: Claude Code reads AGENTS.md")
  expect_true(any(grepl("@AGENTS.md", readLines(claude, warn = FALSE),
                        fixed = TRUE)))
})

test_that("the Block 9 test is protected once it exists", {
  skip_if_not(
    file.exists(here::here("tests", "test_summary_functions.R")),
    "Block 9 not done yet"
  )
  expect_true("Edit(/tests/test_summary_functions.R)" %in% deny_rules())
})
