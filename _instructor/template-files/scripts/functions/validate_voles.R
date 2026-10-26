# scripts/functions/validate_voles.R ----
# Rules transcribed from docs/codebook.csv by a human, not by the agent
# that writes the cleaning script.

voles_col_types <- function() {
  readr::cols(
    subject_id = readr::col_character(),
    sex = readr::col_character(),
    treatment_arm = readr::col_character(),
    mass_pre_g = readr::col_double(),
    mass_post_g = readr::col_double(),
    metabolic_rate_post = readr::col_double(),
    .default = readr::col_character()
  )
}

# subject_id is V followed by three digits
is_vole_id <- function(x) grepl("^V[0-9]{3}$", x)

# One assert() per rule. chain_end() lists every rule the data break, with
# the row and the value, then warns rather than stops (just_warn), so a script
# can go on to check other data.
validate_voles <- function(data, label) {
  cat("\n", label, "\n", sep = "")
  data |>
    assertr::chain_start() |>
    assertr::assert(assertr::not_na, subject_id, sex, treatment_arm) |>
    assertr::assert(is_vole_id, subject_id) |>
    assertr::assert(assertr::is_uniq, subject_id) |>
    assertr::assert(assertr::in_set("M", "F"), sex) |>
    assertr::assert(
      assertr::in_set("Control", "Low_dose", "High_dose"),
      treatment_arm
    ) |>
    # a missing value passes: allow.na = TRUE is the default
    assertr::assert(assertr::within_bounds(15, 60), mass_pre_g, mass_post_g) |>
    assertr::assert(assertr::within_bounds(5, 30), metabolic_rate_post) |>
    assertr::chain_end(
      success_fun = \(data) {
        cat("All rules pass.\n")
        data
      },
      error_fun = assertr::just_warn
    ) |>
    invisible()
}
