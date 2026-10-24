# Template change (deferred): a test that no `CLAUDE.md` hides `AGENTS.md`

Not yet made. This note says what to change, where, and how to roll it out to
the template repository and its checkpoint branches. Quarto ignores this
folder, so nothing here is published.

## Why

Claude Code reads `AGENTS.md` only when there is no `CLAUDE.md`,
`.claude/CLAUDE.md` or `CLAUDE.local.md` in the project **or any folder above
it**. Your personal `~/.claude/CLAUDE.md` does not count. (Source: Claude Code
docs, *How Claude remembers your project*, section *AGENTS.md*,
<https://code.claude.com/docs/en/memory>, checked 2026-10-24.)

If a learner runs `/init`, or has a stray `CLAUDE.md` in OneDrive or
Documents, their conventions disappear without any warning. Today only the
missing canary shows it. This test turns that silent failure into a named test
failure, in the suite learners run in 11a Step 8 and in every block from 4
on.

## 1. The code

Add to `_instructor/template-files/tests/test_controls.R`. Put the helper
below `deny_rules()`, and the test after the
`"AGENTS.md is in place, with its canary and version-control rule"` test.

```r
# Claude Code reads AGENTS.md only when no CLAUDE.md, .claude/CLAUDE.md or
# CLAUDE.local.md exists in the project or any folder above it; the personal
# ~/.claude/CLAUDE.md does not count
hiding_instruction_files <- function(root = here::here()) {
  dir <- normalizePath(root, winslash = "/")
  dirs <- dir
  while (dirname(dir) != dir) {
    dir <- dirname(dir)
    dirs <- c(dirs, dir)
  }
  candidates <- c(
    file.path(dirs, "CLAUDE.md"),
    file.path(dirs, ".claude", "CLAUDE.md"),
    file.path(dirs, "CLAUDE.local.md")
  )
  found <- normalizePath(candidates[file.exists(candidates)], winslash = "/")
  personal <- normalizePath(fs::path_home(".claude", "CLAUDE.md"),
                            winslash = "/", mustWork = FALSE)
  found[tolower(found) != tolower(personal)]
}
```

```r
test_that("no CLAUDE.md hides AGENTS.md", {
  found <- hiding_instruction_files()
  expect_true(length(found) == 0,
              label = paste("no CLAUDE.md that hides AGENTS.md; rename or delete:",
                            paste(found, collapse = ", ")))
})
```

Notes on the code:

- `fs::path_home()` is used, not `path.expand("~")`. On Windows, R's `~` is
  usually `Documents`, but Claude Code's home is `%USERPROFILE%`.
  `fs::path_home()` follows `USERPROFILE`. fs is already pinned in
  `renv.lock`.
- The check reads files outside the project (parent folders). It only tests
  whether they exist; it never opens them.
- **Tested on 2026-10-24** with R 4.5.2 on Windows, using a scratch copy of the
  helper in a temporary folder. All five cases passed:
  1. A clean project: nothing found.
  2. A root `CLAUDE.md`: found.
  3. `.claude/CLAUDE.md` and `CLAUDE.local.md`: both found.
  4. A `CLAUDE.md` in a parent folder: found.
  5. A personal `~/.claude/CLAUDE.md`: ignored.

  Run against this course repository, it found nothing. It has **not** been
  run inside the template repository or on macOS. Do both before the next
  course run (step 4).

## 2. The pass count changes from 8 to 9

On `main`, the suite currently passes 8 expectations, and the new test adds
one. Update every place that states the count:

| File | Where | Change |
|---|---|---|
| `11a-setup-claude-code.qmd` | Step 8, around line 366 | `PASS 8` → `PASS 9`; "The eight passing checks" → "The nine passing checks", and add "no `CLAUDE.md` hiding it" after `AGENTS.md` |
| `_instructor/workshop-template-checklist.md` | *Before each run*, around line 107 | `PASS 8` → `PASS 9`; add "no hiding `CLAUDE.md`" to the list in brackets |
| `_instructor/day4-template-build-brief.md` | Around lines 341 and 431 | `PASS 8` → `PASS 9` (twice) |

Search for others first: `grep -rn "PASS 8" --include=*.qmd --include=*.md .`

## 3. Page text that describes the test

None of this is wrong without the change, but it should mention the new
check once it exists:

- **`11e-instructions-skills.qmd`:**
  - In the *This block's files* table (row `AGENTS.md`, `tests/test_controls.R`), add "and that no `CLAUDE.md` hides it" after "deny rules".
  - In the step 4 *Why a test* paragraph, add "or a `CLAUDE.md` appears that hides `AGENTS.md`" to the list of things the test catches.
  - In Activity 1's *If it goes wrong*, add: "`test_controls.R` names the file it found."
  - In the *Check your understanding* question on the test, the correct answer can stay as it is.
- **`11a-setup-claude-code.qmd`, file tree around line 175:** "instructions and deny rules" is still accurate. No change.
- **`11f-enforced-controls.qmd`, around line 331** (*copy `test_controls.R` for your own project*): learners who copy it now get the `CLAUDE.md` check too. Add a clause: delete that test if your project uses `CLAUDE.md` on purpose.

Render each page you change (see *Rendering locally*, below).

## 4. Roll it out to the template repository

`_instructor/template-files/` is the source of truth. The template repository
and its branches are built from it (`day4-template-build-brief.md`, B9–B10).
Apply the change in this order:

1. **Course repo:** edit `_instructor/template-files/tests/test_controls.R`.
   Make the page edits in steps 2 and 3. Commit.
2. **Template `main`:** copy the new `tests/test_controls.R` over the old one.
   Restart R, then run `testthat::test_dir(here::here("tests"))`.
   - Expect `FAIL 0 | PASS 9`.
   - Then create an empty `CLAUDE.md` at the root and run it again. Expect one
     failure that names the file.
   - Delete the `CLAUDE.md`, then commit.
3. **Checkpoint branches, in order:** `checkpoint-skills` →
   `checkpoint-cleaning` → `checkpoint-refactor`. Each is built on the one
   before, so on each branch run `git switch <branch>` then `git merge main`
   (or the previous branch). The only conflict should be in
   `tests/test_controls.R`; take the new version. On each branch, restart R
   and run the suite:
   - every branch: `FAIL 0`;
   - `checkpoint-refactor`: nothing skips.
4. **Learner check:** clone the template into a new folder and run
   `renv::restore()`. Run the suite on all four branches, on Windows and, if
   you can, on macOS.
5. **Push** all four branches:
   `git push origin main checkpoint-skills checkpoint-cleaning checkpoint-refactor`.
   Learners who forked earlier keep the old test. That is harmless, because
   the suite still passes for them.
6. Tick *No `CLAUDE.md` on any branch* in the checklist's *Verify on the live
   template*. The test now checks this for you.

## Risks

- **Learners who keep a `CLAUDE.md` in a parent folder on purpose:**
  - This now fails a test from 11a onwards. That is the intended outcome: on
    the day, that file would hide the course's `AGENTS.md`.
  - The failure message names the file.
  - Tell learners in 11a that the fix is to rename it for the day.
- **Network drives:**
  - Walking up the folders reaches the drive root, which on a OneDrive or UNC
    path may be slow.
  - Not observed in the scratch test, but check on a university-managed
    machine.

## Rendering locally

On 2026-10-24, neither R installation on the Windows teaching machine could
render the AI pages as they were:

- R 4.6.1 under `C:\Program Files\R\Rwinget`, which Quarto picks by default,
  has no packages.
- The 4.5 library lacked `glossary`, `webexercises`, `janitor` and
  `downloadthis`.

The renders that day used a temporary library holding those four packages, with:

```powershell
$env:R_LIBS = "<scratch library>;C:\Users\hpd08ucu\AppData\Local\R\win-library\4.5"
$env:QUARTO_R = "C:\Program Files\R\R-4.5.2\bin"
quarto render 11e-instructions-skills.qmd
```

To make this permanent, install those four packages into the 4.5 library, and
either set `QUARTO_R`, or remove the Rwinget R from `PATH`.
