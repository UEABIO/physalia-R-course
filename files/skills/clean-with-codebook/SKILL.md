---
name: clean-with-codebook
description: >-
  Writes or revises a reproducible R cleaning script that applies a
  human-authored codebook (docs/codebook.csv) to raw tabular data. Use when
  asked to clean, recode or prepare raw data in a project that has a codebook.
  Not for exploratory analysis or modelling.
disable-model-invocation: true
---

# Clean data against a codebook

## Hard constraints
1. Never modify anything under data/raw/. Read raw files with explicit
   column types.
2. The codebook is the only source of rules. Do not infer units, ranges,
   missing-value codes or label mappings that the codebook does not state.
3. Do not edit docs/, scripts/functions/, scripts/02_validate.R,
   scripts/03_audit_cleaning.R or anything under tests/. If a check fails,
   report it; never change a check to make it pass.
4. Never drop a row silently. Every excluded row goes in the exclusion log
   with a reason.
5. Every changed cell goes in the cleaning log.
6. A value outside a codebook range that no codebook rule explains is set to
   NA, logged with rule "out_of_range_query", and listed in the final report.
   Never correct it by guessing a unit or decimal error.
7. No imputation.
8. Tidyverse style, native pipe, here::here() for all paths.

## Procedure
1. Present a plan before writing anything: every rule you will apply, the
   codebook row it comes from, and the order. Wait for the user to confirm.
2. If the data contain a value the codebook does not cover, stop and ask.
3. Write scripts/01_clean.R. It reads docs/codebook.csv when it runs; do not
   copy rules into the script by hand. Run it in a fresh R session
   (Rscript scripts/01_clean.R), then run it a second time and confirm the
   outputs are identical.
4. Run every test: Rscript -e "testthat::test_dir('tests')". Report the
   output verbatim, including skips.

## Outputs (exact columns)
- data/derived/voles_clean.csv: raw_row, then the codebook columns. raw_row
  is the 1-based row number in the raw file, not counting the header.
- data/derived/exclusion_log.csv: raw_row, subject_id (as it appears in the
  raw file), reason.
- data/derived/cleaning_log.csv: raw_row, subject_id, column, old_value,
  new_value, rule.
- rule is one of: missing_code, label_recode, id_format, out_of_range_query.

## Final report
Row counts in, out and excluded; every value set to NA for query; any gaps
in the codebook you found.
