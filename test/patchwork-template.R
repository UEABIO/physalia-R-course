# ---------------------------------------------------------------------------
# Composite figure: panels sharing ONE collected legend.
#
# Precondition: every panel maps the SAME grouping variable to the SAME palette.
# If a panel encodes a different variable, do not use this pattern for it; give it
# its own scale and accept a separate legend (forcing one key would mislabel it).
#
# Colour policy (see pub-figures SKILL.md):
#   * Default (no brand): colorspace qualitative "Dark 2", as below.
#   * Brand specified: call set_brand("darkblue") once after sourcing, then
#     replace each colorspace::scale_colour_discrete_qualitative() call with
#     scale_colour_brand_qual(n = <=4) from theme-project.R, keeping an identical
#     `name` across panels so the legend collects to one. Re-run cvdPlot(); revert
#     to "Dark 2" on failure.
#
# Autonomy: the legend-bearer is chosen here by richness of encoding. If unclear,
# default to the panel with the most aesthetics mapped to the group and record it.
# ---------------------------------------------------------------------------

library(ggplot2)
library(patchwork)

# Legend-bearing panel: richest encoding (colour + shape), legend retained.
# Redundant encoding (shape) is required by the skill, and conveniently makes this
# panel a complete key for the simpler ones.
p_keep <- data |>
  ggplot(aes(x = x1, y = y1, colour = group_var, shape = group_var)) +
  geom_point(alpha = 0.7) +
  colorspace::scale_colour_discrete_qualitative(palette = "Dark 2", name = "Group") +
  scale_shape_manual(values = c(16, 17, 15), name = "Group") +
  labs(x = "X1", y = "Y1") 

# Other panels: identical palette and identical name, guide suppressed.
# Suppression is what collection cannot do for you. Repeat per additional panel.
p_other <- data |>
  ggplot(aes(x = x2, y = y2, colour = group_var)) +
  geom_point(alpha = 0.7) +
  colorspace::scale_colour_discrete_qualitative(palette = "Dark 2", name = "Group") +
  labs(x = "X2", y = "Y2") +
  guides(colour = "none")

# Letters refer to plots in the order added (A = p_keep, B = p_other).
layout <- "
AB
"

fig1 <- p_keep + p_other +
  patchwork::plot_layout(design = layout, guides = "collect") +
  patchwork::plot_annotation(tag_levels = "A") &
  theme(legend.position = "bottom",
        plot.tag = element_text(face = "bold", size = 12))

fig1