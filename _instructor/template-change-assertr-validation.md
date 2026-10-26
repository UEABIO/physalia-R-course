# Template change: Block 7's validation in assertr, not pointblank

Made in the course repository on 26 October 2026; **not yet made in the
template repository**. Quarto ignores this folder, so nothing here is
published.

## Why

Block 7's *Going further* (`11g`, *Validation: another view of the same
rules*) now uses assertr, as Day 1 does (`02-tidyverse.qmd`, *Data validation
with `tidylog` and `assertr`*), instead of pointblank. The rules are the same.
`chain_end(error_fun = just_warn)` lists every broken rule with its row and
value, then warns rather than stops, so `02_validate.R` goes on to check the
clean data after the raw. pointblank is no longer used anywhere in the book,
and `index.qmd` no longer installs it.

## 1. What changes in the template

| File | Change |
|---|---|
| `scripts/functions/validate_voles.R` | Replace with `_instructor/template-files/scripts/functions/validate_voles.R` |
| `scripts/02_validate.R` | Replace with `_instructor/template-files/scripts/02_validate.R` |
| `renv.lock` | Add assertr, and any of its dependencies not already pinned. Remove nothing. |

Nothing else changes. No test, fixture, page solution or checkpoint file uses
either script. `.claude/settings.json` keeps its deny rules on both scripts.

## 2. Tested

**26 October 2026**, R 4.4.1 and assertr 3.0.1 on Windows, in a scratch copy
of the template layout:

- a synthetic `voles_metabolism.csv` built to the build brief's B6
  specification;
- `voles_raw.csv` made from it by `make_dirty_voles.R`, copied verbatim from
  `ai-blocks-instructor-notes.md`;
- the agreed codebook from `11g`, and the checkpoint `01_clean.R`.

Results:

- **Raw data:** seven broken rules, at these raw rows (`index` in the output):
  - 52: `V15` fails the ID pattern;
  - 7 and 31: `V007` twice;
  - 60: `male`;
  - 20 and 34: the two treatment labels;
  - 27 and 66: `mass_pre_g` out of range;
  - 5 and 42: `9999`;
  - 12: `-1`.

  Then one warning, `assertr encountered errors`. The planting script fixes
  these rows, so they are the same in the real template. Only the values
  differ.
- **Clean data:** `All rules pass.`
- **Both ways of running it:** works with `Rscript scripts/02_validate.R`
  (exit status 0) and with `source()` in an R session.
- **Other tests:** `tests/test_cleaning.R` passed.

It has **not** been run inside the real template, nor on macOS. Section 5
does both.

## 3. Which branches

**All four:** `main`, `checkpoint-skills`, `checkpoint-cleaning`,
`checkpoint-refactor`. Each checkpoint branch is built on `main` and carries
both scripts and `renv.lock`, so make the change once on `main` and merge it
forward in order. No checkpoint branch changes these three files, so the
merges should not conflict.

What each branch should show afterwards:

| Branch | Test suite | `Rscript scripts/02_validate.R` |
|---|---|---|
| `main` | `FAIL 0`, same `PASS` count as before | Raw section only (no clean data yet) |
| `checkpoint-skills` | `FAIL 0` | Raw section only |
| `checkpoint-cleaning` | `FAIL 0`; `test_cleaning.R` passes rather than skips | Raw section, then `All rules pass.` |
| `checkpoint-refactor` | `FAIL 0`; nothing skips | Raw section, then `All rules pass.` |

**If the live template has not been rebuilt yet,** do not use this note. A
live template that still has `block5-done`, `block7-done` and `block9-done`,
and no `checkpoint-*` branches, has not been rebuilt. The build brief
(`day4-template-build-brief.md`) now copies the new scripts from
`template-files/` and pins assertr, so a rebuild picks up the change
automatically.

## 4. How to run it with Claude Code

**1. Assemble a work folder.** In the R console of *this* course project, so
that `here::here()` points here:

```r
# assemble the update folder from the course repository ----
src <- here::here()
ws <- fs::path_home("day4-template-update")   # must not exist yet
stopifnot(!fs::dir_exists(ws))

fs::dir_create(fs::path(ws, "inputs"))
fs::file_copy(
  fs::path(src, "_instructor",
           c("template-files/scripts/02_validate.R",
             "template-files/scripts/functions/validate_voles.R",
             "template-change-assertr-validation.md")),
  fs::path(ws, "inputs")
)
print(fs::dir_ls(fs::path(ws, "inputs")))   # three files
```

**2. Clone the template beside `inputs/`, then start Claude Code in the work
folder.** In a terminal:

```bash
cd ~/day4-template-update
git clone https://github.com/<template-owner>/<template-repo>.git template
git -C template switch checkpoint-skills
git -C template switch checkpoint-cleaning
git -C template switch checkpoint-refactor
git -C template switch main
claude
```

These lines work in Git Bash, PowerShell, and the macOS or Linux terminal. The
`git switch` lines create local copies of the three checkpoint branches.
Start Claude Code in `day4-template-update/`, **not** inside `template/`.
Inside it, the template's `.claude/settings.json` denies edits to both scripts
and to `renv.lock`, and its `AGENTS.md` forbids commits. From the parent
folder, the deny rules do not load.

**3. Give it this prompt:**

```text
Read inputs/template-change-assertr-validation.md in full. Carry out
section 5 on the repository in template/, one step at a time, and stop for
my approval after each step.
```

**4. When it reports step 6,** check the report, then run the push yourself:

```bash
git -C template push origin main checkpoint-skills checkpoint-cleaning checkpoint-refactor
```

## 5. For Claude: the roll-out

Rules:

1. Copy the two scripts from `inputs/` byte for byte. Do not reformat them.
2. Change nothing else, apart from the lockfile records in step 1. Never edit
   a test, a fixture or a tolerance.
3. Commit locally with the git identity already configured, and with **no**
   `Co-Authored-By` or other trailers: learners fork these commits. Do not
   push. Do not change git settings.
4. `template/AGENTS.md` is written for learners. For this task only, its
   rules "Do not edit renv.lock" and "Never commit" are lifted, for the
   lockfile change and the commits named below. The rest of it applies.
5. Run R from `template/` with `Rscript`, without `--vanilla`, so that the
   project's `.Rprofile` activates renv and `here::here()` resolves there.
   Use a new process for each command.
6. If a check fails, or anything differs from what is expected below, stop
   and report. Do not fix it.

**Step 1: `main`.**

1. `git switch main`; `git status` must be clean.
2. Copy `inputs/02_validate.R` to `scripts/02_validate.R`, and
   `inputs/validate_voles.R` to `scripts/functions/validate_voles.R`.
3. If `renv.lock` holds a `pointblank` record, stop and report.
4. Install and record assertr:
   - `Rscript -e "renv::install('assertr')"`
   - `Rscript -e "renv::snapshot(packages = 'assertr', update = TRUE)"`

   `update = TRUE` keeps every existing record. A plain `renv::snapshot()`
   can drop usethis, which only learners' console code calls.
5. `git diff renv.lock` must show only added records: assertr, plus any
   dependency not already pinned. No record may be removed or changed. Report
   the packages added and their versions.
6. `Rscript -e "renv::status()"`: no problems.
7. `Rscript -e "testthat::test_dir('tests')"`: `FAIL 0`, and the same `PASS`
   count as before step 2. Paste the summary line.
8. `Rscript scripts/02_validate.R`: exit status 0. The output must have:
   - `Raw data (expected to FAIL)`;
   - seven broken rules at `index` 52; 7 and 31; 60; 20 and 34; 27 and 66;
     5 and 42; 12;
   - the warning `assertr encountered errors`;
   - no `Clean data` section.
9. `git status` must list only the three changed files. Commit them with the
   message `Validate with assertr instead of pointblank`.

**Step 2: `checkpoint-skills`.** Run `git switch checkpoint-skills`, then
`git merge --no-edit main`. Expect no conflict. Then:

- run the test suite: `FAIL 0`;
- run `02_validate.R`: the same output as on `main`.

**Step 3: `checkpoint-cleaning`.** Run `git switch checkpoint-cleaning`,
then `git merge --no-edit checkpoint-skills`. Then:

- run the test suite: `FAIL 0`, with `test_cleaning.R` passing, not skipped;
- run `02_validate.R`: the raw section as on `main`, then
  `Clean data (expected to PASS)` and `All rules pass.`;
- `git status` must still be clean, because `02_validate.R` writes nothing.

**Step 4: `checkpoint-refactor`.** Run `git switch checkpoint-refactor`,
then `git merge --no-edit checkpoint-cleaning`. Then:

- run the test suite: `FAIL 0`, and nothing skips;
- run `02_validate.R`: the same output as on `checkpoint-cleaning`.

**Step 5: check as a learner would.**

1. `git clone template clone-check` (a local clone, from the path).
2. In `clone-check`, on each of the four branches (`git switch`, with a new
   process for each command), run:
   - `Rscript -e "renv::restore(prompt = FALSE)"`;
   - `Rscript -e "renv::status()"`;
   - the test suite.
3. Expect the results in section 3.
4. Delete `clone-check`.

**Step 6: report.** For each branch, report:

- the test summary line;
- whether `02_validate.R` printed what is expected above.

Also report:

- the lockfile records added;
- the four new commits (one on `main`, one merge on each checkpoint);
- the push command in section 4, item 4, for the instructor to run.

## 6. After the push

- **Learners who forked earlier** keep the pointblank version. No live step
  uses it, so the day is unaffected. For *Going further*, they can copy both
  files from the `11g` page, which shows them in full, then run
  `renv::install("assertr")` and `renv::snapshot()`.
- **Status note:** update `status-2026-10-23.md`, item 1, if the template
  update there is still open.
