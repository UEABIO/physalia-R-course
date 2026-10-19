# emmeans-bridge.R
# Worked emmeans-to-ggpubr annotation pattern.
# Requires the fitted model object in the active session. Do not fabricate.

library(emmeans)
library(ggpubr)
library(dplyr)
library(tibble)
library(tidyr)
library(ggplot2)
library(scales)

# model <- lm(value ~ group, data = data)  # supplied upstream

# fig1 <- ggplot(data, aes(group, value)) + geom_boxplot()   # supplied upstream
#
# ADAPT: `fig1` is your existing ggplot. `panel_ymax()` reads layer 1 by default,
# which must be the geom whose data the brackets sit above (e.g. the boxplot).
# If layer 1 is a reference line or similar, pass the correct index, e.g.
# panel_ymax(fig1, layer = 2L).

emm <- emmeans::emmeans(model, specs = "group")

panel_ymax <- function(p, layer = 1L) {
  d <- ggplot2::ggplot_build(p)$data[[layer]]
  # positional y columns ggplot may compute, in rough order of preference
  cols <- intersect(
    c("ymax_final", "ymax", "upper", "y"),
    names(d)
  )
  if (length(cols) == 0L) {
    stop("No y-position column found in layer ", layer, ".")
  }
  max(unlist(d[cols]), na.rm = TRUE)
}

ymax <- panel_ymax(fig1)

contrasts_df <-
  pairs(emm, adjust = "tukey") |>
  as_tibble() |>
  separate_wider_delim(
    contrast, delim = " - ", names = c("group1", "group2")
  ) |>
  dplyr::filter(p.value < 0.05) |>
  dplyr::mutate(
    p.label = scales::label_pvalue()(p.value),
    y.position = ymax * (1 + 0.05 * dplyr::row_number())
  )

# headroom so the top bracket isn't clipped: highest position + one more step
y_top <- ymax * (1 + 0.05 * (nrow(contrasts_df) + 1))

fig1 +
  stat_pvalue_manual(
    contrasts_df, label = "p.label", tip.length = 0.01
  ) +
  coord_cartesian(ylim = c(NA, y_top))

