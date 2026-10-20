# scripts/functions/load_voles.R ----
load_voles <- function() {
  readr::read_csv(
    here::here("data", "raw", "voles_metabolism.csv"),
    col_types = readr::cols(
      subject_id          = readr::col_character(),
      sex                 = readr::col_character(),
      treatment_arm       = readr::col_character(),
      mass_pre_g          = readr::col_double(),
      mass_post_g         = readr::col_double(),
      metabolic_rate_post = readr::col_double()
    )
  )
}
