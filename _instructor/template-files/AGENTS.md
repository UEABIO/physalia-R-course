# Project conventions: voles analysis

## Canary
When you write or edit R code, make the first line of the first code block:
# agents-md: active v1

## Structure
- Raw data live in data/raw/ and are never modified.
- Derived data go to data/derived/; figures and tables go to outputs/.
- Reusable functions live in scripts/functions/.

## R style
- Tidyverse style, native pipe |>, snake_case names, <- for assignment.
- Write TRUE and FALSE, never T and F.
- Build every path with here::here() (or here() after library(here)). Never
  use setwd() or rm(list = ls()).
- Read CSV files with readr and explicit col_types.

## Reproducibility
- Packages are managed with renv. Do not call install.packages(); ask before
  adding a package.
- Do not edit renv.lock.
- Set a seed immediately before any random step.
- Every script must run in a fresh R session.
- Before you report a task done, run each new script once with Rscript from
  the project root and report the exit status.
- Save figures with ggsave() to outputs/.

## Tests
- Before you report a task done, run Rscript -e "testthat::test_dir('tests')"
  once and paste the final summary line verbatim.
- Never edit anything in tests/fixtures/, an existing expectation or a
  tolerance to make a test pass.
- Every new function in scripts/functions/ gets a test with at least one
  known-answer case on a small tibble, including an NA; expected values are
  worked out by hand, never by running the code under test.

## Data integrity
- Never drop rows silently; state the reason for every filter in a comment.
- Report the number of observations behind every summary statistic.

## Statistics
- Label each analysis as exploratory or confirmatory.
- Never type numerical results into text; compute them in code.

## Version control
- Before you edit any file, run git status.
- If this folder is not a git repository, stop and ask me to set one up.
- If there are uncommitted changes, list them and ask whether I want to
  commit first.
- Never commit, push or change git settings unless I ask.

## Working with me
- Before changing more than one file, present a plan and wait for approval.
- Do not edit anything under data/raw/, tests/fixtures/ or .github/. The one
  exception: a skill may run tests/make_reference.R once, to capture a
  reference that does not exist yet.
