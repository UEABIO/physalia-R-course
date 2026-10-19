# skill_download.R ----
# Purpose: zip a skill folder from files/skills/ at render time and offer it as
# a download button, so the download always matches the files shown on the
# page. Unzipping gives a single folder named after the skill.
# Used by: the AI chapters (Blocks 5, 7 and 8).

skill_download_button <- function(skill) {
  skill_dir <- here::here("files", "skills", skill)
  stopifnot(dir.exists(skill_dir))
  zip_path <- file.path(tempdir(), paste0(skill, ".zip"))
  if (file.exists(zip_path)) {
    file.remove(zip_path)
  }
  zip::zipr(zip_path, skill_dir)
  downloadthis::download_file(
    path = zip_path,
    output_name = skill,
    output_extension = ".zip",
    button_label = paste0("Download ", skill, ".zip"),
    button_type = "success",
    has_icon = TRUE,
    icon = "fa fa-save",
    self_contained = FALSE
  )
}

# print a file from a skill folder verbatim, for display in a chapter ----
show_skill_file <- function(skill, file) {
  cat(readLines(here::here("files", "skills", skill, file), warn = FALSE), sep = "\n")
}
