---
name: pub-figures
description: Use when producing a ggplot2 figure intended for sharing outside the immediate session, including manuscript figures, lab reports, posters, talk slides, and public engagement graphics. Do not invoke for diagnostic, exploratory, model-checking, or one-off plots.
---

# Publication figures

This skill governs production of figures that will be seen by an external audience. It assumes the repository-wide instructions are already in context: tidyverse style, native pipe, British spelling, `here::here()` paths, and the prohibitions on pie charts, dual y-axes, 3D effects, and dynamite plots when raw data exist.

## Autonomy rule

This skill runs in both interactive (VS Code agent mode) and autonomous (cloud agent CI) environments. Never block waiting for human input. If information is missing, choose the safest default, record the choice in a code comment, note it in the PR description when running in CI, and continue.

## Project toolkit

The packages this skill assumes are pinned in `renv.lock`:

- `ggplot2`, `patchwork`, `here`, `scales` for core plotting, composition, paths, and label formatting.
- `ggdist` for raincloud and half-eye distributions: `stat_halfeye()`, `stat_pointinterval()`.
- `ggbeeswarm` for moderate-n group displays: `geom_quasirandom()`.
- `colorspace` for palette construction: `scale_*_discrete_qualitative(palette = "Dark 2")`, `scale_*_continuous_sequential(palette = "Viridis")`, `scale_*_continuous_diverging(palette = "Blue-Red")`, and the HCL generators (`qualitative_hcl()`, `sequential_hcl()`, `diverging_hcl()`) used by the brand-seeded scales in `theme-project.R`.
- `emmeans` for estimated marginal means and pairwise contrasts: `emmeans(model, specs = "var")`, `pairs(emm, adjust = "tukey")`.
- `ggpubr::stat_pvalue_manual()` as the rendering layer for emmeans-derived contrasts. Never `ggpubr::stat_compare_means()`, which performs unadjusted pairwise t-tests by default.
- `ggh4x` for nested or hierarchical faceting: `facet_nested()`, `facet_nested_wrap()`, `guide_axis_nested()`.
- `ragg` for raster output via `ggsave(device = ragg::agg_png)`.
- `colorBlindness::cvdPlot()` for the colour-vision-deficiency check.

Do not introduce additional plotting packages without amending this list. Do not reach for `cowplot` themes when `theme_minimal()` or `theme_project()` will do. Do not hand-write manual hex colour vectors as data scales: either use the `colorspace` palettes or the brand-seeded HCL constructors in `theme-project.R`, both of which keep palettes CVD-checkable. A single fixed colour for a single-group or highlight geom is permitted and is not a "data scale".

## Audience must be determined first

Identify the audience as one of `journal-lab-report`, `poster`, `talk`, or `public-engagement` before writing any plotting code. Styling, annotation density, and title framing all depend on the answer.

If the audience is not specified, default to `journal-lab-report` and record the assumption at the top of the script:

```r
# Audience not specified; defaulting to journal-lab-report.
# Re-run with explicit audience if poster, talk, or public-engagement intended.
```

Then state in one sentence each: the variables and their types (continuous, discrete, date/time), the scientific question, the chart type the variable structure calls for, whether raw data will be shown, and whether statistical annotations are required.

## Statistical annotations require a model object

Do not annotate test statistics, p-values, or confidence intervals unless the fitted model object is available in the active R session. Fabricating values from descriptive data is a serious error. If the model is not in session, omit annotations and insert this placeholder for the legend:

> LEGEND PLACEHOLDER. Model object required to supply the test statistic, degrees of freedom, p-value, and adjustment method. Do not fabricate.

## Chart selection

| Variable 1 | Variable 2 | Variable 3 | Default chart |
|------------|------------|------------|---------------|
| Continuous | — | — | Raincloud (`ggdist::stat_halfeye` + boxplot + jitter) |
| Continuous | Continuous | — | Scatter plot |
| Continuous | Continuous | Discrete | Scatter, colour and shape mapped to discrete |
| Discrete | — | — | Bar chart of counts |
| Discrete | Continuous | — | Raincloud per group; boxplot if many groups; bar only if one summary value per group |
| Discrete | Discrete | — | Heatmap of counts |
| Discrete | Discrete | Continuous | Heatmap of the continuous variable |
| Date | Continuous | — | Line chart |
| Date | Continuous | Discrete | Line chart, one line per group |

If a chart not in this table is requested, select the closest matching entry, generate the code, and record both the request and the substitution in a comment at the top of the script and in the PR description.

## Colour

Colour is governed by a single decision rule, applied without blocking. The colour-vision-deficiency check (`cvdPlot()`, below) is the final arbiter in every branch: a palette that fails the check must be replaced, regardless of brand intent.

**No brand specified (default).** Use `colorspace::scale_*` functions, matched to data structure. This is the default whenever the request does not name brand colours.

**Brand specified.** When the request names a brand colour (for example, "use a brand colour of darkblue"), call `set_brand("darkblue")` once after sourcing `theme-project.R`. This sets the base colour used by single-colour and highlight geoms (`brand_base()`) and reseeds the sequential ramp and diverging low arm. `set_brand()` accepts any R colour name or hex string. Then seed the palette on the brand colour(s) using the constructors in `theme-project.R`, which wrap `colorspace` HCL generators so luminance is monotonic and the result remains CVD-checkable:

- Sequential: `scale_*_brand_seq(base = <brand>)`.
- Diverging: `scale_*_brand_div(low = <brand1>, high = <brand2>, midpoint = <value>)`.
- Qualitative: `scale_*_brand_qual(base = <brand>, n = <number of groups>)`. The `n` argument must equal the number of factor levels mapped, since the palette is built eagerly; an `n` smaller than the group count raises "Insufficient values in manual scale". Brand-seeded qualitative is capped at four hues and is at the limit of CVD-safety; if `cvdPlot()` shows groups merging, fall back to `colorspace::scale_*_discrete_qualitative(palette = "Dark 2")` and record the fallback in a comment.

**Single-colour and highlight geoms.** Default to `brand_base()`, which is teal until `set_brand()` is called and the brand colour thereafter, unless an alternative is specified. This applies to single-group plots and to the focal series when non-focal series are greyed out.

| Data structure | Palette type | colorspace default | Brand-seeded equivalent |
|----------------|--------------|--------------------|-------------------------|
| Discrete, unordered groups | Qualitative | `Dark 2` | `scale_*_brand_qual()` (≤4 hues) |
| Discrete, ordered groups | Sequential discrete | `Purples 3` | `scale_*_brand_seq()` |
| Continuous, one-directional | Sequential | `Viridis` | `scale_*_brand_seq()` |
| Continuous, midpoint-centred | Diverging | `Blue-Red` | `scale_*_brand_div()` |

Categorical groupings must use redundant encoding: shape for points, linetype for lines. Colour alone is not sufficient. This matters most for brand-seeded qualitative palettes, where the hue separation is smaller than in `Dark 2`.

## Audience-specific styling

| Element | Journal / lab report | Poster | Talk | Public engagement |
|---------|---------------------|--------|------|-------------------|
| Title above figure | No | Yes (explanatory) | Yes (explanatory) | Yes (explanatory) |
| Figure legend below | Yes (four elements) | Optional, abbreviated | No | No |
| Direct labelling | Sparingly | Yes | Yes | Yes |
| Highlighting (grey out non-focal) | No | Yes | Yes | Yes |
| Reference lines | Sparingly | Yes | Yes | Yes |
| Statistical annotations | Precise p-values | Abbreviated | One key result | None |
| Base font size | 12 pt floor | 16 to 20 pt | 14 to 18 pt | 14 to 18 pt |
| Raw data shown | Always where n permits | Always | Always | Where it clarifies |

`theme_project()` defaults to `base_size = 12`, the journal/lab-report floor. Raise it explicitly via `theme_project(base_size = ...)` for poster, talk, and public-engagement figures per this table.

Descriptive titles state what the figure shows. Explanatory titles state what it means. Journal figures put descriptive framing in the legend, not the title.

## Showing raw data

| n per group | Display |
|-------------|---------|
| Up to ~30 | Strip plot or raincloud, all points visible |
| ~30 to ~300 | Raincloud with jittered points, alpha 0.3 to 0.5 |
| ~300 to ~3000 | Beeswarm or 2D density |
| > ~3000 | Hexbin or 2D contour |

## Statistical annotations workflow

Pairwise contrasts come from `emmeans::emmeans()` and `emmeans::pairs()` with an explicit adjustment method (`tukey`, `holm`, or similar). Render brackets with `ggpubr::stat_pvalue_manual()`, supplying a data frame of contrasts.

Filter to significant contrasts before drawing. Format p-values with `scales::label_pvalue()` so very small values appear as `<0.001` rather than `0.000`.

A worked example is in `emmeans-bridge.R`.

## Error bars

Three options, not interchangeable:

- **Standard deviation:** spread of individual observations. Use when describing population variability.
- **Standard error of the mean:** precision of the sample mean. Shrinks with sample size.
- **95% confidence interval:** the recommended default. Prefer model-based intervals via `emmeans` where a model exists, otherwise from `stat_summary(fun.data = mean_cl_normal)`.

The choice must appear in the y axis label.

## Multiple panels and shared legends

When composing panels with `patchwork` and `plot_layout(guides = "collect")`,
collection merges only guides that are identical in aesthetic, scale, breaks, and
title (`name`). It deduplicates by guide specification, not by visual appearance,
and it never removes a guide it judges different. Two failures follow: panels that
encode the same variable through different aesthetics (`fill` in one, `colour` plus
`shape` in another) or different palettes produce one legend each; and a panel
encoding a genuinely different variable produces its own legend, which is correct.

Resolve the layout from the plot specifications, without blocking:

- **Same variable, same palette, across all panels:** produce one shared legend.
  Designate the panel with the richest encoding (e.g. colour plus shape) as the
  legend-bearer, because that legend is a complete key for the simpler panels but
  not the reverse. Apply the identical scale call (`colorspace::scale_*` or the
  same brand-seeded constructor with the same `base`) and an identical `name` in
  every panel, then suppress the guide on every non-bearing panel with
  `guides(<aesthetic> = "none")`. Record the choice of bearer in a comment.
- **Panels encode different variables:** do not force collection into one key. Keep
  the separate legends; merging them would mislabel a panel.

A mismatched `name`, a differing aesthetic or scale, or a missing suppression line
will silently leave more than one legend for the same variable. After composing,
confirm exactly one legend appears per distinct variable. A worked skeleton is in
`patchwork-template.R`.

## Saving

Always save to `outputs/figures/` via `here::here()` in both PDF and PNG formats. Specify `width`, `height`, `units`, and `dpi` explicitly; do not rely on `ggsave()` defaults. Use `ragg::agg_png` as the device for PNG output with `bg = "white"`. PDF uses the default device.

## Accessibility check

The agent cannot verify visual accessibility. Insert this line at the end of the script and flag it for the investigator to run and inspect:

```r
colorBlindness::cvdPlot(fig1)
```

If the four-panel simulation shows groups becoming indistinguishable under deuteranopia, protanopia, or tritanopia, the palette or redundant encoding must be revised. For brand-seeded palettes specifically, a failed check requires falling back to the `colorspace` default named in the colour table; brand intent does not override accessibility.

## Pre-flight checklist (agent-verifiable items only)

Before declaring the script complete, confirm:

- Both axes labelled with name and unit, or just name for dimensionless variables.
- Bar chart axes start at zero; other axes cropped to the data range.
- Faceted panels share scale unless a comment justifies freeing it.
- Composite figures collect to one legend per distinct variable; non-bearing panels suppress their guide with `guides(... = "none")` and all retained scales share an identical `name`.
- Palette applied via `colorspace::scale_*` functions or the brand-seeded constructors in `theme-project.R`, never hand-written hex vectors as data scales. Single fixed colours for single-group or highlight geoms are permitted.
- A brand-seeded palette that the colour-vision-deficiency check would fail is replaced by its `colorspace` default; the fallback is recorded in a comment.
- Categorical grouping carries redundant encoding (shape or linetype).
- Statistical annotations sourced from a model object in the active session.
- Default theme is `theme_project()`, `theme_minimal()`, or `theme_classic()`. Never `theme_grey()`.
- `theme_project()` base font size matches the audience floor (12 pt journal; 14 to 20 pt otherwise).
- File saved to `outputs/figures/` as both PDF and PNG with explicit dimensions.
- `cvdPlot()` call inserted at the end of the script with a comment flagging it for the investigator.

## Supplementary files in this skill directory

- `raincloud-template.R`: figure skeleton with palette, theme, and saving.
- `emmeans-bridge.R`: worked emmeans-to-ggpubr annotation pattern.
- `theme-project.R`: project theme plus brand-seeded HCL palette constructors.
- `patchwork-template.R`: composite-figure skeleton with collected legend and guide suppression.