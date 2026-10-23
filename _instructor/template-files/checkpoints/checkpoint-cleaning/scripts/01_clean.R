# scripts/01_clean.R ----
# Checkpoint version (branch checkpoint-cleaning): applies docs/codebook.csv to
# data/raw/voles_raw.csv. Every changed cell goes in the cleaning log and every
# excluded row in the exclusion log, with a reason. The codebook is the only
# source of rules: nothing is inferred beyond it.
library(tidyverse)
library(here)

codebook_df <- read_csv(
  here("docs", "codebook.csv"),
  col_types = cols(.default = col_character())
)

# raw_row is the 1-based row number in the raw file, after the header
raw_df <- read_csv(
  here("data", "raw", "voles_raw.csv"),
  col_types = cols(.default = col_character())
) |>
  mutate(raw_row = row_number())

# one cleaning rule applied to one column: returns the new values and a log ----
apply_codebook_row <- function(values, entry) {
  rule <- coalesce(entry$rule, "")
  new <- values
  log_rule <- rep(NA_character_, length(values))

  # missing-value codes: recode to NA
  codes <- str_split_1(coalesce(entry$missing_codes, ""), ";") |> str_trim()
  codes <- codes[nzchar(codes)]
  is_code <- !is.na(new) & new %in% codes
  new[is_code] <- NA
  log_rule[is_code] <- "missing_code"

  # valid range: values outside it are set to NA and queried, never corrected
  if (!is.na(entry$min) || !is.na(entry$max)) {
    value <- suppressWarnings(as.numeric(new))
    out <- !is.na(value) &
      ((!is.na(entry$min) & value < as.numeric(entry$min)) |
         (!is.na(entry$max) & value > as.numeric(entry$max)))
    new[out] <- NA
    log_rule[out] <- "out_of_range_query"
  }

  # allowed labels, with the recodings the codebook states
  allowed <- str_match(rule, "allowed ([^;]+)")[, 2]
  if (!is.na(allowed)) {
    allowed <- str_split_1(allowed, ",") |> str_trim()
    # "recode male to M, female to F": every "x to y" pair in the recode clause
    clause <- coalesce(str_match(rule, "recode ([^;]+)")[, 2], "")
    pairs <- str_match_all(clause, "(\\S+) to ([^,;\\s]+)")[[1]]
    recode_to <- set_names(pairs[, 3], str_to_lower(pairs[, 2]))
    case_free <- str_detect(rule, "case-insensitive")

    to_fix <- !is.na(new) & !new %in% allowed
    lower <- str_to_lower(new)
    mapped <- unname(recode_to[lower])
    if (case_free) {
      mapped <- coalesce(mapped, allowed[match(lower, str_to_lower(allowed))])
    }
    fix <- to_fix & !is.na(mapped)
    new[fix] <- mapped[fix]
    log_rule[fix] <- "label_recode"
  }

  # identifier format: pad the digits to three when the codebook says so
  if (str_detect(rule, "pad digits to three")) {
    pattern <- str_match(rule, "pattern (\\S+);")[, 2]
    digits <- str_match(new, "^V([0-9]+)$")[, 2]
    fix <- !is.na(new) & !str_detect(new, pattern) & !is.na(digits)
    new[fix] <- sprintf("V%03d", as.integer(digits[fix]))
    log_rule[fix] <- "id_format"
  }

  list(values = new, rule = log_rule)
}

clean_df <- raw_df
log_parts <- list()
for (i in seq_len(nrow(codebook_df))) {
  entry <- codebook_df[i, ]
  col_name <- entry$column
  result <- apply_codebook_row(raw_df[[col_name]], entry)
  changed <- !is.na(result$rule)
  clean_df[[col_name]] <- result$values
  log_parts[[col_name]] <- tibble(
    raw_row = raw_df$raw_row[changed],
    subject_id = raw_df$subject_id[changed],
    column = col_name,
    old_value = raw_df[[col_name]][changed],
    new_value = result$values[changed],
    rule = result$rule[changed]
  )
}
cleaning_log_df <- bind_rows(log_parts) |> arrange(raw_row, column)

# duplicates: the first occurrence of each subject_id is kept ----
data_cols <- codebook_df$column
first_row <- clean_df |>
  mutate(first = min(raw_row), .by = subject_id) |>
  pull(first)
is_duplicate <- duplicated(clean_df$subject_id)
is_exact <- map_lgl(seq_len(nrow(raw_df)), \(r) {
  identical(unlist(raw_df[r, data_cols]), unlist(raw_df[first_row[r], data_cols]))
})

exclusion_log_df <- tibble(
  raw_row = raw_df$raw_row[is_duplicate],
  subject_id = raw_df$subject_id[is_duplicate],
  reason = if_else(
    is_exact[is_duplicate],
    paste0("exact duplicate of raw row ", first_row[is_duplicate]),
    paste0("duplicate subject_id after ID formatting; same animal as raw row ",
           first_row[is_duplicate])
  )
)

clean_df <- clean_df |>
  filter(!is_duplicate) |>
  select(raw_row, all_of(data_cols))

# outputs: values are written as text, exactly as they were or as logged ----
dir.create(here("data", "derived"), showWarnings = FALSE)
write_csv(clean_df, here("data", "derived", "voles_clean.csv"), na = "")
write_csv(cleaning_log_df, here("data", "derived", "cleaning_log.csv"), na = "")
write_csv(exclusion_log_df, here("data", "derived", "exclusion_log.csv"), na = "")

# final report ----
cat(
  "Rows in:", nrow(raw_df), "| rows out:", nrow(clean_df),
  "| excluded:", nrow(exclusion_log_df), "\n"
)
cleaning_log_df |>
  filter(rule == "out_of_range_query") |>
  print(width = Inf)
