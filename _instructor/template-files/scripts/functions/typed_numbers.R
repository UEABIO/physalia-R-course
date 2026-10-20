# scripts/functions/typed_numbers.R ----
# List the prose lines of a .qmd file that still contain numbers outside
# inline code, for you to review by eye. Years, design sizes and YAML values
# are flagged too, so treat each hit as a question, not an error.
find_typed_numbers <- function(path) {
  lines <- readLines(path, warn = FALSE)
  is_fence <- grepl("^```", lines)
  in_chunk <- cumsum(is_fence) %% 2 == 1

  tibble::tibble(line = seq_along(lines), text = lines) |>
    dplyr::filter(!in_chunk, !is_fence) |>
    dplyr::mutate(prose = gsub("`\\{?r\\}? [^`]*`", "", text)) |>
    dplyr::filter(grepl("[0-9]+\\.[0-9]+|\\b[0-9]{2,}\\b", prose, perl = TRUE)) |>
    dplyr::select(line, text)
}
