# Day 4 AI blocks: instructor and maintenance notes

Moved out of the published chapters. Quarto ignores this folder because its name starts with an underscore.

## Documentation last verified

- **11a-setup-claude-code.qmd**: 9 October 2026, against the Claude Code documentation (code.claude.com: setup, authentication, permission modes). Installation details change; if a command here fails, check the setup page first.
- **11-AI-programming-integrated.qmd, quick reference** (`/model`, `/effort`, `/remote-control`, `/init`): 23 October 2026, checked by an AI agent against code.claude.com (model-config, remote-control, commands, memory, cli-reference). The commands and model-config wording came through an extraction step: check it on the live pages before teaching. Findings worth knowing:
  - `/model` (picker, **Enter**) and `/model <name>` both save the choice as the default for new sessions; **s** in the picker switches for this session only. The session header shows the model next to the effort level.
  - `/effort` opens a slider; levels `low` to `max`, plus `auto`, which clears the saved level.
  - Remote Control needs a Pro, Max, Team or Enterprise login (no API keys; Team and Enterprise need an Owner to enable it). The session keeps running locally.
  - `/init` writes `CLAUDE.md`; once one exists, Claude Code stops reading `AGENTS.md`. The CLI flag `claude --init` is unrelated (Setup hooks, print mode only) and is not in the book.
- **11b-inline-completions.qmd**: 9 October 2026, against the Positron documentation (completions; release notes 2026.06 and 2026.07), Posit's announcement of Posit AI, and GitHub's Copilot plans page.
- **11d-context-disclosure-autonomy.qmd**: 9 October 2026, against GitHub's Copilot documentation (plans, IDE agent and plan modes), the Claude Code documentation (permission modes) and the Posit Assistant documentation (docs version 1.7).
- **11e-instructions-skills.qmd**: 9 October 2026, against GitHub's Copilot documentation (custom instructions, agent skills), the Claude Code documentation (features overview, skills) and the Posit Assistant documentation (docs version 1.7: memory, skills).
- **11f-enforced-controls.qmd**: 9 October 2026, against the Claude Code documentation (code.claude.com: permissions, hooks), the Posit Assistant documentation (assistant.posit.co, docs version 1.7: Permissions & Trust, Hooks) and GitHub's documentation on code owners.
- **11g-data-cleaning.qmd**: 9 October 2026, against the Claude Code documentation (code.claude.com) and the Posit Assistant documentation (assistant.posit.co, docs version 1.7). Tool behaviour changes quickly; check the linked pages before teaching.
- **11l-copilot-cloud-agent.qmd**: 23 October 2026, against GitHub's Copilot documentation (plans, cloud agent, customising the agent's environment with `copilot-setup-steps.yml`).
- **11i-characterisation-tests.qmd**: 9 October 2026, against the Claude Code permissions documentation (code.claude.com) and GitHub's documentation on customising the Copilot cloud agent's environment (docs.github.com).
- **Claude Code claims across 11, 11a, 11d–11g and 11i**: 22 October 2026, fact-checked by an AI agent against code.claude.com (memory, permission modes, permissions, settings, skills, commands, sandboxing, data usage, interactive mode, changelog). Re-check the live pages before teaching. Findings worth knowing:
  - `AGENTS.md` is read directly from v2.1.277 and listed by `/memory` from v2.1.280; the book's minimum of v2.1.281 covers both.
  - `auto` is the start mode of recent interactive sessions; the docs disagree on the version (permission-modes page v2.1.283, changelog v2.1.284), so the book gives no version.
  - Read and Edit deny rules also cover simple Bash file commands (`cat`, `head`, `tail`, `sed`, `tee`) and `> file`; they do not cover scripts that open files themselves, such as `Rscript`.
  - `/permissions` offers a choice of settings file, but the docs do not give the option labels, so the book names the file (`.claude/settings.json`) rather than a label.
  - Claude Code adds `.claude/settings.local.json` to your global git excludes on first write, so a branch cannot carry it.
  - A `.claude/skills/` directory created after a session starts needs `/reload-skills`; the template ships the directory, so new skills inside it are picked up.
- **Whole-day check, 23 October 2026**: the 12 AI pages were reviewed against each other and the template; Claude Code and GitHub claims were fact-checked by AI agents against code.claude.com and docs.github.com. Findings worth knowing:
  - The `default` mode is named **Manual** in the CLI; the status bar shows `⏸ manual mode on`. `/plan` takes a description on the same line, and plan mode can run read-only commands.
  - The plan-approval option that switches approvals off reads *Yes, and use auto mode*, or *Yes, auto-accept edits* when auto mode is unavailable. The docs list both version thresholds for the `auto` start mode (v2.1.283, and v2.1.228/v2.1.233 by platform), so the book still gives no version.
  - `/status`, not `/config`, shows which credential is billed. An `ANTHROPIC_API_KEY` in the environment outranks a subscription login once approved.
  - A PreToolUse matcher `Edit|Write|Bash` does not cover `NotebookEdit`; irrelevant for this R template.
  - **Copilot cloud agent:** the person who asked Copilot for a pull request cannot give it a counting approval. So `11l` no longer requires approvals in a learner's own fork: the rule requires a pull request and the `r-checks` check (the job is named `r-checks` so the check appears under that name). Workflows on the agent's pull requests need **Approve and run workflows** by default. A fork's workflows start disabled (GitHub's banner; the docs state it only for scheduled workflows). A status check can be required only after it has run.
  - Plans including the cloud agent: Student, Pro, Pro+, Max, Business, Enterprise; not Free. Copilot code review reads `AGENTS.md`. `r-lib/actions/setup-r` accepts `r-version: renv`.
  - References checked against arXiv, Crossref, the Bilkent repository, the R Consortium site and Substack: Spreafico et al. (2025), Cihan et al. (2025), Cihan (2025), Wickham (2026) and Barbier (2026, a talk scheduled for 10 November 2026 at R+AI 2026).
- **11k-build-an-agent.qmd (Block 6)**: 22 October 2026, against the installed ellmer 0.5.0 (help pages and NEWS): `chat_anthropic(credentials =)`, `Chat$on_tool_request()`, `tool_reject()`, `tool_annotations()`, and `Chat$get_rounds()`, which groups each user prompt with all the turns that follow it, so the book counts requests (assistant turns) instead.

## Block 6 (11k-build-an-agent.qmd): instructor notes

- **Before the course:** run Task 2 once with a key from a brand-new Console account, on a fresh fork. Note the number of requests, the tokens (`chat$get_tokens()`) and the cost (`chat$get_cost()`, after `ellmer::models_update_prices()` if it shows NA), and check the account's rate limits; if every learner's key comes from one Console organisation, the room shares that organisation's limits.
- **The agent can write only under `scripts/`.** That is deliberate: it cannot edit its checks (`tests/`) or its own rules (`agent/`). If it tries, the refusal and its next move are worth showing.
- **The flex block.** Nothing later in the day uses `summaries.R`. If the day is late, or several keys fail, run Task 2 on screen and have learners decide each approval in the chat (about 20 minutes instead of 35). Learners whose key fails can pair with a neighbour in a breakout room.
- **Three narrow tools.** The agent can read files, write under `scripts/`, and run one test (`run_test()`); it has no general run-R tool and no file listing. That keeps the walkthrough short, the cost low and the risk small. *Going further* shows how adding a general `run_r()` reopens Block 5's gap.

## Block 9 (11h-code-review.qmd): instructor notes

- **Before the block:** check every learner made `~/ai-review` with `ANALYSIS.R` in the pre-workshop check (11a, step 7); the files callout repeats the two lines for anyone who did not.
- **Split the room** before Task 1: odd-numbered participants delete the 9999 line from the prompt (*without*), even-numbered keep it (*with*). Post the split in the chat.
- **Grading:** have the P1–P12 answer key from 07-code-review.qmd open; ask everyone to post group, hit count, P8 caught or not, and the most confident false positive.
- **Debrief (5 minutes):** compare P8 between the groups first: it is the clearest demonstration that a reviewer cannot know what the data alone reveal.

## 11g-data-cleaning.qmd: Instructor only: generating the planted data

Keep this script and `planted_errors.csv` **outside** the participant
repository. An agent that can read the answer key will use it. Run it in an
instructor copy of the repository that holds the clean
`data/raw/voles_metabolism.csv`, and copy only the generated
`data/raw/voles_raw.csv` into the participant repository.

```{r}
#| eval: false
# instructor/make_dirty_voles.R ----
library(tidyverse)
library(here)

# suppressWarnings: case_when() evaluates every branch, including numeric
# conversion of text labels
as_num <- function(x) suppressWarnings(as.numeric(x))

clean_df <- read_csv(
  here("data", "raw", "voles_metabolism.csv"),
  col_types = cols(.default = col_character())
)

plants_df <- tribble(
  ~row, ~column,               ~error_class,
  5,    "mass_post_g",         "sentinel 9999",
  41,   "mass_post_g",         "sentinel 9999",
  12,   "metabolic_rate_post", "non-standard missing code -1",
  20,   "treatment_arm",       "label in lower case",
  33,   "treatment_arm",       "label in upper case",
  58,   "sex",                 "label spelled out",
  27,   "mass_pre_g",          "recorded in kg",
  64,   "mass_pre_g",          "decimal slip (x10)"
) |>
  mutate(
    subject_id = clean_df$subject_id[row],
    old_value = map2_chr(row, column, \(r, col) clean_df[[col]][[r]]),
    new_value = case_when(
      error_class == "sentinel 9999" ~ "9999",
      error_class == "non-standard missing code -1" ~ "-1",
      error_class == "label in lower case" ~ str_to_lower(old_value),
      error_class == "label in upper case" ~ str_to_upper(old_value),
      error_class == "label spelled out" ~ if_else(old_value == "M", "male", "female"),
      error_class == "recorded in kg" ~ as.character(as_num(old_value) / 1000),
      error_class == "decimal slip (x10)" ~ as.character(as_num(old_value) * 10)
    )
  )

# apply each plant to its cell ----
planted_df <- reduce(
  seq_len(nrow(plants_df)),
  \(data, i) {
    data[[plants_df$column[[i]]]][[plants_df$row[[i]]]] <- plants_df$new_value[[i]]
    data
  },
  .init = clean_df
)

# insert an exact duplicate and a near duplicate with a malformed ID ----
near_duplicate_df <- planted_df |>
  slice(15) |>
  mutate(subject_id = str_replace(subject_id, "^V0", "V"))

raw_df <- bind_rows(
  slice(planted_df, 1:30),
  slice(planted_df, 7),
  slice(planted_df, 31:50),
  near_duplicate_df,
  slice(planted_df, 51:n())
)

write_csv(raw_df, here("data", "raw", "voles_raw.csv"), na = "")

# answer key, indexed by row in the raw file ----
key_df <- plants_df |>
  mutate(
    raw_row = row + (row > 30) + (row > 50),
    expected_handling = case_when(
      str_starts(error_class, "sentinel") |
        str_starts(error_class, "non-standard") ~ "recode to NA (codebook missing code); log",
      str_starts(error_class, "label") ~ "recode to canonical label; log",
      .default = "fails range rule; set to NA and query, do not infer a correction; log"
    )
  ) |>
  select(raw_row, subject_id, column, old_value, new_value, error_class, expected_handling) |>
  bind_rows(
    tibble(
      raw_row = c(31, 52),
      subject_id = clean_df$subject_id[c(7, 15)],
      column = "(whole row)",
      error_class = c("exact duplicate row", "near duplicate: malformed ID"),
      expected_handling = c(
        "exclude one copy; log reason",
        "fails ID pattern; identify as duplicate of the original animal; exclude; log reason"
      )
    )
  )

write_csv(key_df, here("instructor", "planted_errors.csv"))
```

The raw file has 74 rows: 72 animals, one exact duplicate (raw row 31) and one
near duplicate (raw row 52). A correct pipeline excludes two rows and sets five
values to `NA`: two sentinels, the `-1` code, and the two masses queried as out
of range. These are in addition to the genuine missing value already in the
source data.

`docs/data_note.md` ships from `template-files/docs/data_note.md`, the source
of truth. It states: IDs are V followed by three digits; sex is M or F; the
three treatment arms; masses in grams, with adults in this colony between 15
and 60 g and 9999 entered when an animal could not be weighed; metabolic rate
`-1` when the respirometry run failed, with valid readings between 5 and 30
and no unit given.

## Block 8 (11i-characterisation-tests.qmd): instructor notes

- Check your copy of `voles_metabolism.csv` before teaching: the row-order
  failure (a function using `.by` without sorting) appears only if
  `load_voles() |> dplyr::distinct(treatment_arm, sex)` is not already in sorted
  order. If it is sorted, reorder the rows of the file once and commit it before
  the session.
- Confirm that the file contains exactly one missing value in
  `metabolic_rate_post`, and note which group it falls in, for the Step 2
  discussion ("unchanged is not correct").
- The skill now takes the first snapshot itself (it runs the shipped
  `tests/make_reference.R` when no reference exists), then stops for the
  learner to commit it. If you registered Block 5's guard hook for the
  demonstration, it blocks that command (it matches `make_reference.R`):
  remove the hook before Block 8, or have learners capture by hand as the
  page's *If it goes wrong* describes.
- The skill runs only its new test file, then stops: learners protect that
  test and run the whole suite themselves. If the suite is run before the test
  is protected, `test_controls.R` fails on purpose; refuse any offer from the
  agent to "fix" it by writing a settings file.
- The Copilot cloud-agent self-study page (`11l`) depends on the learner's
  Copilot plan: on 23 October 2026 the cloud agent was in Student, Pro, Pro+
  and Max, not Free. Check the plans page before recommending it, and run the
  page once on a participant-type account.
