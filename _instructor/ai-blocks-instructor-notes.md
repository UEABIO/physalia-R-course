# Day 4 AI blocks: instructor and maintenance notes

Moved out of the published chapters. Quarto ignores this folder because its name starts with an underscore.

## Documentation last verified

- **11a-setup-claude-code.qmd**: 9 October 2026, against the Claude Code documentation (code.claude.com: setup, authentication, permission modes). Installation details change; if a command here fails, check the setup page first.
- **11b-inline-completions.qmd**: 9 October 2026, against the Positron documentation (completions; release notes 2026.06 and 2026.07), Posit's announcement of Posit AI, and GitHub's Copilot plans page.
- **11d-context-disclosure-autonomy.qmd**: 9 October 2026, against GitHub's Copilot documentation (plans, IDE agent and plan modes), the Claude Code documentation (permission modes) and the Posit Assistant documentation (docs version 1.7).
- **11e-instructions-skills.qmd**: 9 October 2026, against GitHub's Copilot documentation (custom instructions, agent skills), the Claude Code documentation (features overview, skills) and the Posit Assistant documentation (docs version 1.7: memory, skills).
- **11f-enforced-controls.qmd**: 9 October 2026, against the Claude Code documentation (code.claude.com: permissions, hooks), the Posit Assistant documentation (assistant.posit.co, docs version 1.7: Permissions & Trust, Hooks) and GitHub's documentation on code owners.
- **11g-data-cleaning.qmd**: 9 October 2026, against the Claude Code documentation (code.claude.com) and the Posit Assistant documentation (assistant.posit.co, docs version 1.7). Tool behaviour changes quickly; check the linked pages before teaching.
- **11i-characterisation-tests.qmd**: 9 October 2026, against the Claude Code permissions documentation (code.claude.com) and GitHub's documentation on customising the Copilot cloud agent's environment (docs.github.com).

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

## 11i-characterisation-tests.qmd: Instructor notes

- Check your copy of `voles_metabolism.csv` before teaching: the `.by` failure
  in Path A appears only if
  `load_voles() |> dplyr::distinct(treatment_arm, sex)` is not already in sorted
  order. If it is sorted, reorder the rows of the file once and commit it before
  the session.
- Confirm that the file contains exactly one missing value in
  `metabolic_rate_post`, and note which group it falls in, for the Step 4
  discussion.
- The skill now takes the first snapshot itself (it runs the shipped
  `tests/make_reference.R` when no reference exists), then stops for the
  learner to commit it. If you registered Block 6's guard hook for the
  demonstration, it blocks that command (it matches `make_reference.R`):
  remove the hook before Block 9, or have learners capture by hand as the
  page's *If it goes wrong* describes.
- Path C depends on account features. Run it once on a participant-type account
  before the session.
