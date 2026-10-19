# describe_csv.R ----
# Purpose: one row per column of a CSV file: name, the type readr assigns,
# missing-value count, and a brief range (numeric) or distinct-value count
# (other). Describes; does not interpret.
# Used by: research-readme skill, Stage 2.

describe_range <- function(x) {
  if (all(is.na(x))) {
    return("all values missing")
  }
  if (is.numeric(x)) {
    return(paste(min(x, na.rm = TRUE), "to", max(x, na.rm = TRUE)))
  }
  paste(dplyr::n_distinct(x, na.rm = TRUE), "distinct values")
}

# one-row-per-column summary of a single CSV ----
describe_csv <- function(path) {
  stopifnot(is.character(path), length(path) == 1L, file.exists(path))
  data_df <- readr::read_csv(path, show_col_types = FALSE)
  tibble::tibble(
    file        = basename(path),
    column      = names(data_df),
    type        = purrr::map_chr(data_df, \(x) class(x)[1]),
    n_missing   = purrr::map_int(data_df, \(x) sum(is.na(x))),
    range       = purrr::map_chr(data_df, describe_range),
    # completed by the user during Stage 2:
    description = NA_character_,
    unit        = NA_character_
  )
}

# describe every CSV in a project, skipping renv and git folders ----
describe_project_csvs <- function(project_dir) {
  stopifnot(dir.exists(project_dir))
  csv_paths <- list.files(
    project_dir,
    pattern = "\\.csv$",
    recursive = TRUE,
    full.names = TRUE,
    ignore.case = TRUE
  )
  csv_paths <- csv_paths[!grepl("(^|/)(renv|\\.git)/", csv_paths)]
  if (length(csv_paths) == 0L) {
    message("No CSV files found under ", project_dir)
    return(tibble::tibble())
  }
  csv_paths |>
    purrr::map(describe_csv) |>
    purrr::list_rbind()
}
