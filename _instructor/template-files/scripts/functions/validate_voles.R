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

validate_voles <- function(data, label) {
  data |>
    pointblank::create_agent(label = label) |>
    pointblank::col_vals_not_null(columns = c(subject_id, sex, treatment_arm)) |>
    pointblank::col_vals_regex(columns = subject_id, regex = "^V[0-9]{3}$") |>
    pointblank::rows_distinct(columns = subject_id) |>
    pointblank::col_vals_in_set(columns = sex, set = c("M", "F")) |>
    pointblank::col_vals_in_set(
      columns = treatment_arm,
      set = c("Control", "Low_dose", "High_dose")
    ) |>
    pointblank::col_vals_between(
      columns = c(mass_pre_g, mass_post_g),
      left = 15, right = 60, na_pass = TRUE
    ) |>
    pointblank::col_vals_between(
      columns = metabolic_rate_post,
      left = 5, right = 30, na_pass = TRUE
    ) |>
    pointblank::interrogate()
}
