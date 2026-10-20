# raincloud-template.R
# Figure skeleton: raincloud for Discrete x Continuous, with palette, theme
# and saving.
# Audience not specified; defaulting to journal-lab-report.
# Re-run with explicit audience if poster, talk, or public-engagement intended.
#
# Colour policy (see pub-figures SKILL.md):
#   * Groups are categorical, so colour comes from colorspace qualitative
#     "Dark 2" whether or not a brand is set. Categorical colour is never
#     brand-seeded; scale_*_brand_qual() in theme-project.R is the same palette.
#   * If a brand is set with set_brand(), use brand_base() only for
#     single-colour or highlight geoms.


library(ggplot2)
library(ggdist)
library(colorspace)
library(here)
library(scales)


# The skill's single copy lives in .agents/skills/. If you copied the folder
# into .claude/skills/ instead of linking it, change this path to match.
source(here::here(".agents", "skills", "pub-figures", "theme-project.R"))

# data |> expects: group (factor), value (numeric)
fig1 <-
  data |>
  ggplot(aes(x = group, y = value, colour = group, shape = group)) +
  ggdist::stat_halfeye(
    aes(fill = group),
    adjust = 0.5, width = 0.6, justification = -0.2,
    .width = 0, point_colour = NA, alpha = 0.5
  ) +
  geom_boxplot(width = 0.12, outlier.shape = NA, alpha = 0.5) +
  geom_point(
    position = position_jitter(width = 0.05, seed = 1),
    alpha = 0.4, size = 1.5
  ) +
  colorspace::scale_colour_discrete_qualitative(palette = "Dark 2") +
  colorspace::scale_fill_discrete_qualitative(palette = "Dark 2") +
  scale_shape_discrete() + # redundant encoding alongside colour
  labs(x = NULL, y = "Value (unit)") +
  theme_project()

# Save as PDF and PNG with explicit dimensions ----
fig_dir <- here::here("outputs", "figures")
dir.create(fig_dir, recursive = TRUE, showWarnings = FALSE)

ggsave(
  file.path(fig_dir, "fig1.pdf"), fig1,
  width = 160, height = 110, units = "mm"
)
ggsave(
  file.path(fig_dir, "fig1.png"), fig1,
  width = 160, height = 110, units = "mm", dpi = 300,
  device = ragg::agg_png, bg = "white"
)

# Accessibility check; investigator to run and inspect. Wrapped in
# interactive() so a run with Rscript does not write a stray Rplots.pdf.
if (interactive()) colorBlindness::cvdPlot(fig1)
