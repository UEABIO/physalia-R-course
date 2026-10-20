# scan_packages.R ----
# Purpose: read renv.lock and report the R version and pinned package
# versions. A missing lockfile is reported as a finding, not an error.
# Used by: research-readme skill, Stage 4.

read_lockfile <- function(lock_path = "renv.lock") {
  if (!file.exists(lock_path)) {
    return(list(found = FALSE, r_version = NA_character_, packages = tibble::tibble()))
  }
  lock <- jsonlite::read_json(lock_path)
  packages <- purrr::pluck(lock, "Packages", .default = list())

  packages_df <- tibble::tibble(
    package = unname(purrr::map_chr(packages, \(p) purrr::pluck(p, "Package", .default = NA_character_))),
    version = unname(purrr::map_chr(packages, \(p) purrr::pluck(p, "Version", .default = NA_character_)))
  ) |>
    dplyr::arrange(package)

  list(
    found = TRUE,
    r_version = purrr::pluck(lock, "R", "Version", .default = NA_character_),
    packages = packages_df
  )
}

print_lockfile <- function(lock_path = "renv.lock") {
  info <- read_lockfile(lock_path)
  if (!info$found) {
    cat(
      "No lockfile found at ", lock_path, ".\n",
      "FINDING: package versions were not recorded.\n",
      "README text: **TODO: supply R version and key package versions: ",
      "not recorded; resolve before submission**\n",
      sep = ""
    )
    return(invisible(info))
  }
  cat("R version: ", info$r_version, "\n\n", sep = "")
  print(info$packages, n = Inf)
  invisible(info)
}
