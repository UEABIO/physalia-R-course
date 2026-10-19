# emmeans-bridge.R
# Worked emmeans-to-ggpubr annotation pattern.
# Requires a fitted model object: fitted by code in this project that you have
# run or can read, or present in the user's live R session where your tool can
# see it. Never fabricate test statistics from descriptive data.

library(emmeans)
library(ggpubr)
library(dplyr)
library(tibble)
library(tidyr)
library(stringr)
library(ggplot2)
library(scales)

# model <- lm(value ~ group, data = data)  # supplied upstream

# fig1 <- ggplot(data, aes(group, value)) + geom_boxplot()   # supplied upstream
#
# ADAPT: `fig1` is your existing ggplot. `panel_yrange()` reads layer 1 by
# default, which must be the geom whose data the brackets sit above (e.g. the
# boxplot). If layer 1 is a reference line or similar, pass the correct index,
# e.g. panel_yrange(fig1, layer = 2L).

emm <- emmeans::emmeans(model, specs = "group")

# lowest and highest y values drawn by one layer ----
panel_yrange <- function(p, layer = 1L) {
  d <- ggplot2::ggplot_build(p)$data[[layer]]
  # positional y columns ggplot may compute
  cols <- intersect(
    c("ymin_final", "ymin", "lower", "ymax_final", "ymax", "upper", "y"),
    names(d)
  )
  if (length(cols) == 0L) {
    stop("No y-position column found in layer ", layer, ".")
  }
  range(unlist(d[cols]), na.rm = TRUE)
}

y_range <- panel_yrange(fig1)
# step between brackets as a fraction of the data range, so positions work for
# negative values and for data far from zero
y_step <- 0.07 * diff(y_range)

contrasts_df <-
  pairs(emm, adjust = "tukey") |>
  as_tibble() |>
  separate_wider_delim(
    contrast, delim = " - ", names = c("group1", "group2")
  ) |>
  # emmeans wraps level names containing spaces or operators in parentheses
  dplyr::mutate(dplyr::across(
    c(group1, group2), \(x) stringr::str_remove_all(x, "^\\(|\\)$")
  )) |>
  dplyr::filter(p.value < 0.05) |>
  dplyr::mutate(
    p.label = scales::label_pvalue()(p.value),
    y.position = y_range[2] + y_step * dplyr::row_number()
  )

# headroom so the top bracket isn't clipped: highest position + one more step
y_top <- y_range[2] + y_step * (nrow(contrasts_df) + 1)

fig1 +
  stat_pvalue_manual(
    contrasts_df, label = "p.label", tip.length = 0.01
  ) +
  coord_cartesian(ylim = c(NA, y_top))
