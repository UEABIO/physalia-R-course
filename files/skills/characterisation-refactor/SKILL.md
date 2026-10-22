---
name: characterisation-refactor
description: >-
  Refactors working R analysis code into documented functions under a
  characterisation test, so the output is proved unchanged. Use when asked to
  functionalise, refactor or tidy a script whose output must not change.
  Not for fixing bugs or changing results.
disable-model-invocation: true
---

# Refactor under a characterisation test

## The reference stays with the human
The frozen reference in tests/fixtures/ is captured by the user, once, before
any refactoring. A reference produced by the code under test proves nothing.
- Never create, regenerate or modify anything under tests/fixtures/.
- Never run tests/make_reference.R or any script that writes a fixture.
- If no reference exists, stop and ask the user to capture one.

## Procedure
1. Present a plan: the code to move, the function name and file, and the
   test file. Wait for the user to confirm.
2. Refactor only. Write the function in scripts/functions/ with a roxygen2
   block and an argument check, and make the original script call it. Do not
   write or edit tests in this step. Stop and let the user review the diff.
3. Test only. Write tests/test_<functions file>.R (for
   scripts/functions/summary_functions.R, that is
   tests/test_summary_functions.R). Start it with library(testthat) and
   testthat::local_edition(3), source the function files with
   here::here(), read the reference from tests/fixtures/ with readRDS(), and
   compare it with the function's output using expect_equal(). Never
   hard-code expected values, and never reimplement the computation inside
   the test. Include an expect_error() test showing that the argument check
   rejects data with a required column missing.
4. Run every test in a fresh R session,
   Rscript -e "testthat::test_dir('tests')", and report the output verbatim,
   including skips.

## Rules
- If the test fails, report the difference. Never change the test, the
  tolerance or the reference to make it pass.
- Sort the output rows explicitly with dplyr::arrange() on the grouping
  columns, so the order never depends on how the data happen to be stored.
- Do not change behaviour, including how missing values are handled. A
  passing test shows the output is unchanged, not that it is correct; list
  anything that looks wrong for the user to decide.
