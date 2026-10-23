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

## The reference comes from the original code, and the user commits it
The frozen reference in tests/fixtures/ is written by the user's own capture
script (tests/make_reference.R) from the original, unchanged code, and the
user commits it before anything else changes. A reference made after the code
has changed proves nothing.
- Run tests/make_reference.R at most once, in step 2 below, and only if no
  reference exists yet and git status shows no uncommitted changes under
  scripts/. Never run it at any other time, and never edit the capture script.
- Never edit, regenerate or delete anything under tests/fixtures/.
- If a reference already exists, use it as it is.

## Procedure
1. Present a plan: whether a reference must be captured, the code to move,
   the function name and file, and the test file. Wait for the user to
   confirm.
2. Capture only, if no reference exists. Run git status; if anything under
   scripts/ has uncommitted changes, stop and ask. Otherwise run
   Rscript tests/make_reference.R, report the file it wrote, and stop: ask
   the user to commit it before you change any code. Do not commit it
   yourself.
3. Refactor only. Write the function in scripts/functions/ with a roxygen2
   block and an argument check, and make the original script call it. Do not
   write or edit tests in this step. Stop and let the user review the diff.
4. Test only. Write tests/test_<functions file>.R (for
   scripts/functions/summary_functions.R, that is
   tests/test_summary_functions.R). Start it with library(testthat) and
   testthat::local_edition(3), source the function files with
   here::here(), read the reference from tests/fixtures/ with readRDS(), and
   compare it with the function's output using expect_equal(). Never
   hard-code expected values, and never reimplement the computation inside
   the test. Include an expect_error() test showing that the argument check
   rejects data with a required column missing. This step's rules take
   precedence over any project instruction to add known-answer tests: those
   come later, if the user decides the behaviour should change.
5. Run only the new test file in a fresh R session, for example
   Rscript -e "testthat::test_file('tests/test_summary_functions.R')", and
   report the output verbatim. Then stop: the user protects the new test and
   runs the whole suite. Do not change any settings file.

## Rules
- If the test fails, report the difference. Never change the test, the
  tolerance or the reference to make it pass.
- Sort the output rows explicitly with dplyr::arrange() on the grouping
  columns, so the order never depends on how the data happen to be stored.
- Do not change behaviour, including how missing values are handled. A
  passing test shows the output is unchanged, not that it is correct; list
  anything that looks wrong for the user to decide.
