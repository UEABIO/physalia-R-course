# Template change (deferred): reject a leftover `TODO` in the AI-use log

Not yet made. Quarto ignores this folder, so nothing here is published.

## Why

Since the 24 October 2026 revision, Block 3 (`11d`, Exercise 2, step 4) has
the agent draft the first AI-log line with the last field, *what you kept or
changed*, left as `TODO`. The learner then replaces it. `test_ai_log.R` checks
only the line's form, `^\d{4}-\d{2}-\d{2}; [^;]+; [^;]+; .+$`, so a line still
ending in `TODO` passes. This check makes the test fail until the learner has
written their own judgement.

## 1. The code

In `_instructor/template-files/tests/test_ai_log.R`, add after the second
test:

```r
test_that("no AI-use log entry still has TODO in place of what you kept or changed", {
  skip_if_not(
    file.exists(here::here("docs", "ai-log.md")),
    "Block 3 not done yet: no docs/ai-log.md"
  )
  unfinished <- grepl("\\bTODO\\b", read_log_lines())
  expect_false(
    any(unfinished),
    label = paste("replace TODO with what you kept or changed, on line(s):",
                  paste(which(unfinished), collapse = ", "))
  )
})
```

It reuses `read_log_lines()` from the same file.

**Tested on 2026-10-24** with R 4.5.2 on Windows, in a scratch copy of
`tests/test_ai_log.R` with this test appended:

- no `docs/ai-log.md`: all three tests skip;
- a line ending in `TODO`: the new test fails and the other two pass;
- a finished line: all pass.

Copy the regex exactly as `"\\bTODO\\b"`. With single backslashes, R reads
`\b` as a backspace character, and the test passes on a `TODO` line. That
happened once during the scratch test, when a shell collapsed the backslashes.

## 2. Effect on the pass counts

- On `main` there is no `docs/ai-log.md`, so the new test skips. `PASS 8` in
  11a Step 8, the checklist and the build brief is **unchanged**.
- On the checkpoint branches the log lines are written in full (build brief,
  B9), with no `TODO`, so the new test passes. Check that `FAIL 0` still holds.

## 3. Page text

- `11d-context-disclosure-autonomy.qmd`, Exercise 2:
  - In the step 5 table, add to the `test_ai_log.R` row: "and none still says
    TODO".
  - In *If it goes wrong*, add: "If `test_ai_log.R` names a line with
    TODO, replace it with what you kept or changed."
- `11a-setup-claude-code.qmd`, file tree (`test_ai_log.R  from Block 3: the
  AI-use log`): no change.

## 4. Roll-out

As in `template-change-claude-md-guard.md`, section 4:

1. Edit the file in `template-files/`.
2. Copy it into the template's `main` and run the suite.
3. Merge into `checkpoint-skills`, `checkpoint-cleaning` and
   `checkpoint-refactor` in order, running the suite on each.
4. Clone-check, then push all four branches.

On `checkpoint-skills`, also add a temporary `TODO` line to the log, check
that the test fails and names it, then remove the line.

The two deferred changes touch different test files, so they can go out
together in one rebuild.
