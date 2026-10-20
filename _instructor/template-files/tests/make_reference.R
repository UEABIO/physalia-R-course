# tests/make_reference.R ----
# Run ONCE, by you, BEFORE any refactoring.
source(here::here("scripts", "05_analysis.R"))
dir.create(here::here("tests", "fixtures"), showWarnings = FALSE, recursive = TRUE)
saveRDS(
  metabolic_summary,
  here::here("tests", "fixtures", "metabolic_summary.rds")
)
