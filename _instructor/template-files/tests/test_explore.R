# tests/test_explore.R ----
# Block 3: the derived column and the plot script the agent wrote.
library(testthat)
testthat::local_edition(3)

test_that("mass_change_g is post-treatment mass minus pre-treatment mass", {
  script <- here::here("scripts", "explore_voles.R")
  # the plot script is Block 3's other output: once it exists, the column must too
  skip_if_not(
    file.exists(here::here("scripts", "explore_mass_change_plot.R")),
    "Block 3 not done yet: no plot script"
  )

  # run the script in a fresh R session, so its library() calls cannot change
  # this one, and bring back only the voles data it made
  voles <- callr::r(
    function(script) {
      env <- new.env()
      utils::capture.output(sys.source(script, envir = env))
      if (exists("voles", envir = env)) env$voles else NULL
    },
    args = list(script),
    wd = here::here()
  )
  expect_true(
    !is.null(voles) && "mass_change_g" %in% names(voles),
    label = "explore_voles.R adds mass_change_g to voles"
  )
  expect_equal(voles$mass_change_g, voles$mass_post_g - voles$mass_pre_g)
})

test_that("the plot script runs in a fresh R session and saves to outputs/", {
  script <- here::here("scripts", "explore_mass_change_plot.R")
  skip_if_not(file.exists(script), "Block 3 not done yet: no plot script")

  # an Rplots.pdf made earlier by something else is not this script's fault
  rplots <- here::here("Rplots.pdf")
  rplots_before <- file.exists(rplots)
  expect_no_error(
    callr::rscript(script, wd = here::here(), show = FALSE)
  )
  after <- list.files(here::here("outputs"), recursive = TRUE)

  expect_true(
    length(after) > 0 && any(grepl("\\.(png|pdf)$", after)),
    label = "a .png or .pdf in outputs/"
  )
  expect_false(
    !rplots_before && file.exists(rplots),
    label = "no stray Rplots.pdf (save the figure with ggsave())"
  )
})
