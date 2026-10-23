# Build brief: the Day 4 workshop template repository

This brief has two parts. **Part A is for you, the instructor**: what to
provide, what Claude will write, and how to start. **Part B is for Claude**,
working in a new, separate folder: how to build the participant template
repository that learners fork before Day 4, together with its three
checkpoint branches.

Use it with **Claude Code** on your own machine. The build has to run R, git
and the test suite. A claude.ai Project cannot run any of these, so it cannot
do this job.

---

# Part A: for you

## A1. Fill these in before you start

Replace each value below in this file before you copy it into the new folder.
Claude stops and asks if any is still a placeholder.

| Placeholder | Meaning | Your value |
|---|---|---|
| `{{TEMPLATE_OWNER}}` | GitHub user or organisation that will own the template | |
| `{{TEMPLATE_REPO}}` | Repository name; also the `.Rproj` name | |
| `{{COURSE_DATE}}` | Date used in the checkpoint AI-log lines, as `YYYY-MM-DD` | |
| `{{START_FROM}}` | `scratch` (build everything new) or `live` (update a clone of the current live template) | |

## A2. What you provide

You copy everything below into `inputs/` in the new folder. The R snippet in
A5 does the copying for you, except for the two optional items.

| # | You provide | Copy from (this course repository) | Put it at (new folder) | Why Claude needs it |
|---|---|---|---|---|
| 1 | This brief, with A1 filled in | `_instructor/day4-template-build-brief.md` | `BUILD-BRIEF.md` | The instructions |
| 2 | The template source files | `_instructor/template-files/` (the whole folder, including the dot-folders) | `inputs/template-files/` | The source of truth for every shipped file that is not data. Claude copies these verbatim. |
| 3 | The two course skills | `files/skills/clean-with-codebook/`, `files/skills/characterisation-refactor/` | `inputs/skills/` | Shipped in `.agents/skills/` and `.claude/skills/` |
| 4 | The Day 4 pages | `11-AI-programming-integrated.qmd` and every `11*.qmd` | `inputs/pages/` | Solutions for the checkpoint branches, and cross-checks |
| 5 | The instructor notes | `_instructor/workshop-template-checklist.md`, `ai-blocks-instructor-notes.md`, `status-2026-10-23.md` | `inputs/notes/` | The checklist is the specification; the notes hold the planted-error script and the data specification |
| 6 | **Optional:** the clean data | Your copy of `voles_metabolism.csv` (it is not in this repository) | `inputs/data/voles_metabolism.csv` | If you leave it out, Claude generates a synthetic file to the specification and keeps the generating script outside the template |
| 7 | **Optional; needed if `{{START_FROM}}` is `live`:** a clone of the current live template | `git clone` of the live repository | `inputs/live-template/` | Claude reuses its `renv.lock`, `.Rproj` and data, and removes what the status note retires |

Do **not** provide `planted_errors.csv` or any answer key. Claude writes the
answer key into `instructor-only/`, outside the template.

## A3. What Claude writes

| Output | Where | Notes |
|---|---|---|
| The template repository, on `main` | `{{TEMPLATE_REPO}}/` (its own git repository) | Every file in the checklist's *Files the template must ship* table |
| Files copied verbatim | `{{TEMPLATE_REPO}}/` | Everything in `inputs/template-files/` **except** `checkpoints/`; both skills into both skill folders |
| Files Claude generates | `{{TEMPLATE_REPO}}/` | `data/raw/voles_metabolism.csv` (only if you did not supply it), `data/raw/voles_raw.csv`, `tests/fixtures/raw_checksum.txt`, `data/derived/.gitkeep`, `{{TEMPLATE_REPO}}.Rproj`, `renv.lock`, `.Rprofile`, `renv/activate.R`, `renv/settings.json` |
| Three checkpoint branches | `checkpoint-skills`, `checkpoint-cleaning`, `checkpoint-refactor` | Each built on the one before, using the solutions in the pages |
| Instructor-only files | `instructor-only/` (never in the template) | `make_clean_voles.R` (if it generated the data), `make_dirty_voles.R`, `planted_errors.csv`, `build-report.md` |
| The build report | `instructor-only/build-report.md` | Every file and where it came from, every test result, what still needs you |

## A4. What stays your job

Claude stops before anything outward-facing. You:

1. create the GitHub repository and push `main` and the three branches
   (Claude gives you the exact commands);
2. tick **Template repository** in the GitHub settings, if learners use it as
   a template rather than a fork;
3. put the real template name into `11a-setup-claude-code.qmd`;
4. run the interactive checks that need Claude Code in the template itself:
   `/permissions` lists 17 rules, `/memory` lists `AGENTS.md`, a new session
   starts in Manual mode, the agent is refused when it edits
   `data/raw/voles_raw.csv` and allowed to write `scripts/01_clean.R`;
5. the dry run on Windows and macOS with fresh accounts, including Block 6
   with a brand-new Console key.

## A5. How to start

**1. Assemble the folder.** Fill in A1 first. Then, in the R console of
*this* course project (so that `here::here()` points here), choose where the
new folder goes and run:

```r
# assemble the build folder from the course repository ----
src <- here::here()
ws <- fs::path_home("day4-template-build")   # change if you like; must not exist yet
stopifnot(!fs::dir_exists(ws))

fs::dir_create(fs::path(ws, "inputs", c("skills", "pages", "notes", "data")))
fs::dir_create(fs::path(ws, "instructor-only"))

fs::file_copy(
  fs::path(src, "_instructor", "day4-template-build-brief.md"),
  fs::path(ws, "BUILD-BRIEF.md")
)
fs::dir_copy(
  fs::path(src, "_instructor", "template-files"),
  fs::path(ws, "inputs", "template-files")
)
for (skill in c("clean-with-codebook", "characterisation-refactor")) {
  fs::dir_copy(
    fs::path(src, "files", "skills", skill),
    fs::path(ws, "inputs", "skills", skill)
  )
}
pages <- fs::dir_ls(src, regexp = "/11[a-z]?-[^/]*\\.qmd$")
fs::file_copy(pages, fs::path(ws, "inputs", "pages"))
fs::file_copy(
  fs::path(src, "_instructor",
           c("workshop-template-checklist.md", "ai-blocks-instructor-notes.md",
             "status-2026-10-23.md")),
  fs::path(ws, "inputs", "notes")
)

# check: 12 pages, 2 skills, and the dot-files came across
print(fs::path_file(fs::dir_ls(fs::path(ws, "inputs", "pages"))))
print(fs::dir_ls(fs::path(ws, "inputs", "template-files"), all = TRUE))
```

Then add the optional items from A2 by hand, if you have them.

**2. Open Claude Code in the new folder** (not in the course repository, and
not inside the template once it exists):

```bash
cd ~/day4-template-build
claude
```

**3. Give it this first prompt:**

```text
Read BUILD-BRIEF.md in full, then every file it tells you to read. Carry out
Phase 0 only and stop for my approval.
```

Approve each phase as Claude reports it. Expect about an hour of Claude's
time, most of it in running tests.

---

# Part B: for Claude

## B1. Goal

Build the participant template repository for Day 4 of *Advancing in R*, and
its three checkpoint branches, so that every item in
`inputs/notes/workshop-template-checklist.md` holds. Learners fork this
repository, run `renv::restore()`, and work in it all day. They cannot see
this brief, `inputs/` or `instructor-only/`.

## B2. Hard rules

1. **The answer key never enters the template.** `make_dirty_voles.R`,
   `planted_errors.csv`, any data-generating script and this brief stay in
   `instructor-only/` or the folder root. An agent that can read the answer
   key will use it. Before every commit, check that the staged files contain
   none of them and no text from them.
2. **No `CLAUDE.md`** anywhere: not in the template, not on any branch, not
   in this folder. Claude Code would then read it instead of `AGENTS.md`.
3. **Shipped files are copied byte for byte** from `inputs/template-files/`
   and `inputs/skills/`. Do not "improve", reformat or re-wrap them. If one
   looks wrong, report it in the build report and carry on with the original.
4. **Never edit a test, a fixture or a tolerance to make a test pass.** If a
   page's solution fails a shipped test, stop and report both.
5. **Nothing outward-facing.** Do not create a GitHub repository, push, or
   change global git settings. Commit locally only, with the instructor's git
   identity, and with no `Co-Authored-By` or other trailers: learners fork
   these commits.
6. **Add nothing beyond the checklist** without asking. Propose any file you
   think is missing (a short `README.md` is the likely one) in Phase 0.
7. **Stop at the end of each phase**, report in a few lines, and wait for
   approval. Stop sooner if anything below is ambiguous, contradicts another
   source, or a placeholder in Part A is unfilled.
8. British spelling in everything you write.

## B3. The folder

```
day4-template-build/                 you start Claude Code here; not a git repository
  BUILD-BRIEF.md                     this file
  inputs/                            read-only for you
    template-files/                  source of truth for shipped files
    skills/                          clean-with-codebook/, characterisation-refactor/
    pages/                           the Day 4 .qmd pages
    notes/                           checklist, instructor notes, status note
    data/voles_metabolism.csv        optional
    live-template/                   optional
  instructor-only/                   you write here; never copied into the template
  {{TEMPLATE_REPO}}/                 you create this; its own git repository
```

The pages include code with chunk options such as
`file = here::here("_instructor", "template-files", ...)`: that path means
`inputs/template-files/` here. They also use webexercises (`hide()`,
`unhide()`) and glossary calls; the code inside the hidden sections is what
you need.

Work from the folder root, with paths into `{{TEMPLATE_REPO}}/`. Run R inside
the template with `Rscript` and the template as the working directory, so that
`here::here()` and renv resolve there.

## B4. Sources, in order of precedence

1. The shipped tests in `inputs/template-files/tests/`: they are the
   acceptance criteria.
2. `inputs/template-files/`: the shipped files themselves.
3. `inputs/notes/workshop-template-checklist.md`: what ships, what each
   branch adds, and the checks.
4. `inputs/notes/ai-blocks-instructor-notes.md`: the planted-error script,
   the data note's facts and the Block 8 data requirements.
5. `inputs/pages/*.qmd`: the solutions the checkpoint branches use.
6. `inputs/notes/status-2026-10-23.md`: what has changed and what to remove.

If two sources disagree, stop and report. Do not choose for the instructor.

## B5. Phase 0: read and plan (then stop)

Read all of `inputs/notes/`, every file in `inputs/template-files/` and
`inputs/skills/`, and these parts of the pages:

- `11a-setup-claude-code.qmd`: *Your workshop repository* and the layout
  reference (the target layout);
- `11c-debugging.qmd`: what Block 2 expects of the data;
- `11d-context-disclosure-autonomy.qmd`: Exercise 2 (the `mass_change_g`
  column, the plot script, the AI-log format);
- `11e-instructions-skills.qmd`: Activity 1 (the two `AGENTS.md` edits) and
  Activity 2 (the `house-figures` skill and `scripts/fig_house.R`);
- `11k-build-an-agent.qmd`: Task 2 (`summarise_rate_tidy()` in
  `scripts/functions/summaries.R`);
- `11g-data-cleaning.qmd`: the agreed codebook (*A codebook you could agree
  on*) and the cleaning outputs;
- `11i-characterisation-tests.qmd`: Step 1 (the refactored
  `summarise_metabolic_rate()`, the new `05_analysis.R`, the characterisation
  test and the deny rule).

Then check that R, git and the packages are available
(`Rscript --version`, `git --version`, and whether tidyverse, here, testthat,
jsonlite, renv, callr, fs, usethis, gert, waldo and ellmer are installed).

Report, and stop:

- the placeholders from A1 and their values;
- which optional inputs are present;
- the full file list for `main`, marked *copied*, *generated* or *written*;
- what each checkpoint branch will add, and the page each file comes from;
- any conflict between sources, and any file you propose to add;
- anything missing (packages, inputs) that the instructor must supply.

## B6. Phase 1: the data (then stop)

Work in `instructor-only/` for every script in this phase.

**1. The clean file, `voles_metabolism.csv`.** Use, in order: the file in
`inputs/data/`; the one in `inputs/live-template/data/raw/`; or, if neither
exists, generate one with `instructor-only/make_clean_voles.R` (set a seed;
write with `readr::write_csv()`). It must meet every requirement below.
Check a supplied file against the same list. If a supplied file fails one,
report which and **ask before changing it** (the instructor notes allow
reordering the rows once if they are already sorted; nothing else).

| Requirement | Used by |
|---|---|
| Columns, in this order: `subject_id`, `sex`, `treatment_arm`, `mass_pre_g`, `mass_post_g`, `metabolic_rate_post` | `load_voles.R` |
| 72 rows, one per animal; IDs `V001` to `V072`, unique | Data note; test_cleaning |
| `sex` is `M` or `F`; `treatment_arm` is exactly `Control`, `Low_dose` or `High_dose`; 24 animals per arm (generated data: 12 of each sex per arm) | Block 2, Exercise 1 expects `nrow(high_dose)` of 24 |
| Mean `mass_post_g - mass_pre_g` rises from Control to Low_dose to High_dose, clearly | Block 2, Exercise 2 |
| Masses in grams, inside 15–60 with margin (generated data: about 20–50), one decimal place | Data note ranges; the kg and ×10 plants must fall out of range |
| `metabolic_rate_post` inside 5–30 (generated data: about 8–25), one decimal place | Data note range |
| Exactly one missing value in the whole file, in `metabolic_rate_post`, written as an empty field; not in rows 5, 7, 12, 15, 20, 27, 33, 41, 58 or 64 (the planted rows) | test_translation (`aggregate()` drops it); Block 8, Step 2 |
| `distinct(treatment_arm, sex)` in file order is **not** already sorted | Block 8's `arrange()` lesson |
| Row 15's ID starts `V0`; rows 58 and 64 have non-missing values in the planted columns | The planted-error script |

Record in the build report which treatment arm and sex the missing value
falls in: Block 8's Step 2 discussion needs it.

**2. The planted file, `voles_raw.csv`.** Copy the script from the
`make_dirty_voles.R` section of `ai-blocks-instructor-notes.md` into
`instructor-only/make_dirty_voles.R`. Change only its paths: read the clean
file from the template's `data/raw/`, write `voles_raw.csv` into the
template's `data/raw/`, and write `planted_errors.csv` into
`instructor-only/`. Run it. Check: 74 rows; raw row 31 duplicates the
original row 7; raw row 52 is the near duplicate with a malformed ID; the
answer key has ten rows.

**3. The checksum.** Create the template folder and its `.gitattributes`
first (Phase 2, step 1), then write
`tests/fixtures/raw_checksum.txt` from the template root:

```r
writeLines(unname(tools::md5sum("data/raw/voles_raw.csv")),
           "tests/fixtures/raw_checksum.txt")
```

Report the data checks and stop.

## B7. Phase 2: build `main` (then stop)

1. **Start the repository.** If `{{START_FROM}}` is `scratch`: `git init -b
   main` in `{{TEMPLATE_REPO}}/`. If it is `live`: `git clone
   inputs/live-template {{TEMPLATE_REPO}}`, so that learners' forks keep the
   live history, and work on `main` (step 7 says what to remove). Either way,
   `.gitattributes` must be committed *before or with* the first commit that
   adds or changes a data file, so no data file is stored with converted
   line endings. On `live`, check with `git ls-files --eol data/` that every
   data file is stored with LF.
2. **Copy the shipped files** from `inputs/template-files/`, keeping paths
   and dot-files, **except the `checkpoints/` folder** (it is source material
   for `checkpoint-cleaning`, not part of `main`).
3. **Copy the two skills** into both `.agents/skills/<name>/` and
   `.claude/skills/<name>/`, as copies, not links (links fail on Windows).
4. **Add the empty folders' placeholders:** `data/derived/.gitkeep` (empty);
   `outputs/.gitkeep` comes from the template files.
5. **Add `{{TEMPLATE_REPO}}.Rproj`** with RStudio's default project settings.
   If a live template is supplied, reuse its `.Rproj` contents.
6. **Set up renv.** The lockfile must pin tidyverse, here, testthat,
   jsonlite, renv, callr, fs, usethis (with gert), waldo and ellmer; not the
   *Going further* packages. Check the lockfile itself, not this list: the
   tests call callr, jsonlite and gert directly, and learners call usethis
   in the console, which renv's implicit snapshot will not see. If a live
   template is supplied, start from its `renv.lock` and add ellmer. Choose
   the method that makes a fresh clone report no problems from
   `renv::status()` after `renv::restore()`, and say in the build report how
   you did it. Ship `.Rprofile`, `renv/activate.R` and `renv/settings.json`;
   let renv write its own `renv/.gitignore`.
7. **If `{{START_FROM}}` is `live`:** remove `CLAUDE.md`,
   `scripts/functions/typed_numbers.R`, `reports/` and `tests/test_readme.R`,
   as the status note lists, and list anything else in the live `main` that
   the checklist does not name; ask before removing those. Every shipped
   file is replaced from `inputs/template-files/`. Build the checkpoint
   branches new (Phase 4); do not reuse the live `block5-done`,
   `block7-done` or `block9-done` branches.
8. **Do not ship** `CLAUDE.md`, `.github/`, `hooks/`, `docs/ai-log.md`,
   anything in `scratch/`, or anything learners create during the day (the
   checklist lists them).
9. **Commit** in a few logical commits with plain messages, for example
   "Add template files", "Add data and checksum", "Add renv".

## B8. Phase 3: verify `main` (then stop)

From the template root, in a fresh R session each time:

1. `Rscript -e "renv::status()"`: no problems.
2. `Rscript -e "testthat::test_dir('tests')"`: `FAIL 0`, `PASS 8`, the rest
   skipped. Paste the summary line in the report.
3. Each shipped script that should run on `main` runs without error:
   `scripts/explore_voles.R`, `scripts/00_profile.R` (then delete the
   `docs/profile*.csv` files it writes: learners make those in Block 7),
   `scripts/05_analysis.R`.
4. `git status` is clean, and `git ls-files` shows no answer-key file, no
   `CLAUDE.md` and nothing under `scratch/` or `outputs/` except
   `.gitkeep`.
5. `.claude/settings.json` is identical to the source and holds 17 deny
   rules, `defaultMode` `"default"` and no `allow` list.

Report and stop.

## B9. Phase 4: the checkpoint branches (then stop after each)

Build each branch from the one before (`main` → `checkpoint-skills` →
`checkpoint-cleaning` → `checkpoint-refactor`). Take every file's content
from the page named. Where a page gives no exact text, write the smallest
version that does what the page describes and passes the tests, follow
`AGENTS.md`, and flag it in the report as *written, not from a page*.

AI-log lines use the format the tests check,
`date; tool and model; task; what was kept or changed`, dated
`{{COURSE_DATE}}`.

**`checkpoint-skills`** (Blocks 3 and 4)

- `docs/ai-log.md` with two lines: Block 3's (the example in `11d`) and
  Block 4's.
- `mass_change_g` (`mass_post_g - mass_pre_g`) added to `voles` in
  `scripts/explore_voles.R`.
- `scripts/explore_mass_change_plot.R`: plots `mass_change_g` by treatment
  arm and saves to `outputs/` with `ggsave()`; leaves no `Rplots.pdf`.
- Two edits to `AGENTS.md`, as in `11e` Activity 1: one rule deleted from
  *Structure*, *R style*, *Reproducibility* or *Data integrity*, and one
  specific convention added. Keep the canary and the *Tests*, *Statistics*,
  *Version control* and *Working with me* sections exactly as they are.
- `.agents/skills/house-figures/SKILL.md` with the text in `11e`, and its
  copy in `.claude/skills/house-figures/`.
- `scripts/fig_house.R`: `mass_post_g` by `treatment_arm`, following every
  rule in `house-figures`, saved to `outputs/`.
- Check: the test suite has `FAIL 0` and `test_explore.R` and `test_ai_log.R`
  now pass rather than skip; both scripts run in a fresh session; `outputs/`
  stays untracked.

**`checkpoint-cleaning`** (Blocks 6 and 7)

- `scripts/functions/summaries.R` with `summarise_rate_tidy(data)`, a
  tidyverse translation that behaves like `legacy_rate_summary()` in
  `tests/test_translation.R`, including dropping the animal with the missing
  value. Add its AI-log line.
- `docs/codebook.csv`: the agreed codebook in `11g`, byte for byte, with
  `<unit>` kept for metabolic rate.
- `scripts/01_clean.R`, copied from
  `inputs/template-files/checkpoints/checkpoint-cleaning/scripts/01_clean.R`.
- Run it once. Commit the three files it writes:
  `data/derived/voles_clean.csv`, `cleaning_log.csv` and
  `exclusion_log.csv`. Do not commit the `docs/profile*.csv` files.
- Check against `instructor-only/planted_errors.csv`: raw rows 31 and 52
  excluded, five values set to `NA` (two sentinels, the `-1` code, the two
  out-of-range masses), labels recoded, the genuine missing value left as it
  was. The test suite has `FAIL 0`, and `test_translation.R` and
  `test_cleaning.R` pass rather than skip.

**`checkpoint-refactor`** (Block 8, Step 1 only)

In this order:

1. Capture the reference from the **original** `scripts/05_analysis.R` by
   running `Rscript tests/make_reference.R`, and commit
   `tests/fixtures/metabolic_summary.rds` on its own.
2. `scripts/functions/summary_functions.R`: the refactored
   `summarise_metabolic_rate()` from `11i`.
3. `scripts/05_analysis.R`: the *after refactoring* version from `11i`.
4. `tests/test_summary_functions.R`: the characterisation test from `11i`.
   It must read the `.rds` and call `summarise_metabolic_rate()`, and never
   write or regenerate the reference.
5. Add `"Edit(/tests/test_summary_functions.R)"` to the `deny` list in
   `.claude/settings.json` (the committed file, not `settings.local.json`).
   This is the one edit to that file anywhere in the build.
- Check: the test suite has `FAIL 0` and **nothing skips**; the reference is
  unchanged since its commit.

## B10. Phase 5: verify as a learner would (then stop)

1. `git clone` the template into a new folder under `instructor-only/`
   (a local clone, from the path).
2. In the clone, run `renv::restore()`, then `renv::status()` and the test
   suite, on `main` and then on each checkpoint branch (`git switch`, with a
   fresh R session each time). Expected: `main` `FAIL 0 | PASS 8`;
   every branch `FAIL 0`; `checkpoint-refactor` no skips.
3. On this Windows machine, confirm that the raw-data checksum and the
   cleaning reproducibility test pass in the clone (they fail if line endings
   were converted).
4. Run the checks in *Verify on the live template* in the checklist that do
   not need GitHub, and mark the rest *for the instructor*.
5. Delete the clone when the checks pass.

## B11. Phase 6: the build report and hand-off

Write `instructor-only/build-report.md` with:

1. **Inputs used**, and the values of the A1 placeholders.
2. **Every file on each branch**, marked *copied* (with its source),
   *generated* (with the script) or *written* (with the page section, or
   *not from a page*).
3. **Data facts:** row counts, animals per arm and sex, mean mass change per
   arm, the arm and sex of the missing value, the first rows of
   `distinct(treatment_arm, sex)` in file order, and the md5 of
   `voles_raw.csv`.
4. **Test summaries**, pasted verbatim, for every branch, from the build and
   from the clone.
5. **How renv was set up**, the R version, and the package versions pinned.
6. **The checklist**, item by item: *done and verified*, *done, not
   verifiable here*, or *for the instructor*.
7. **What the instructor does next:** the commands to publish all four
   branches. On `scratch`, for example:

   ```bash
   cd {{TEMPLATE_REPO}}
   gh repo create {{TEMPLATE_OWNER}}/{{TEMPLATE_REPO}} --public --source . --remote origin
   git push -u origin main checkpoint-skills checkpoint-cleaning checkpoint-refactor
   ```

   On `live`: set `origin` to the live GitHub repository, push the four
   branches, and delete the old remote branches (`block5-done`,
   `block7-done`, `block9-done`) only after the new ones are up. Give these
   as commands for the instructor to run; do not run them. Then the A4 list, and the line to change in `11a-setup-claude-code.qmd`
   (`<template-owner>/<template-repo>` → `{{TEMPLATE_OWNER}}/{{TEMPLATE_REPO}}`).
8. **Anything you could not do**, or flagged, with the reason.

End with a three-line summary in the chat and the path to the report.
