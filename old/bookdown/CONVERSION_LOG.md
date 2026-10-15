# Conversion Log: .Rmd → .qmd

This log documents the automated conversion of `.Rmd` files from `rmd/` into Quarto `.qmd` files,
following the conventions established in the existing book project.

## Build Validation

- **Quarto version:** 1.7.29
- **Render result:** ✅ Successful (`quarto render` completed with no errors)
- **Warnings:** 1 unresolved crossref `@fig-scatter` in `09-quarto-workshop-revised.qmd` (this is demonstrative text showing how cross-references work, not an actual broken reference)

## Conversion Rules Applied

| Rule | Description |
|------|-------------|
| YAML headers | Removed (existing .qmd files have no per-file YAML) |
| `(PART\*)` headings | Removed; part structure handled via `_quarto.yml` |
| `child='_setup.Rmd'` | Replaced with standard setup: `source("R/booktem_setup.R")`, `source("R/my_setup.R")`, `library(tidyverse)`, `library(here)` |
| Chunk options `fig.cap` | Renamed to `fig-cap` (hash-pipe `#\|` style) |
| Chunk options `fig.width`/`fig.height` | Renamed to `fig-width`/`fig-height` |
| Chunk options `out.width` | Renamed to `out-width` |
| Chunk options `fig.align` | Renamed to `fig-align` |
| Chunk options `fig.asp` | Renamed to `fig-asp` |
| Chunk options `fig.alt` | Renamed to `fig-alt` |
| Chunk options `fig.show` | Renamed to `fig-show` |
| R logical `TRUE`/`FALSE` | Converted to YAML `true`/`false` in `#\|` options |
| `block type="info"` | → `:::{.callout-note}` |
| `block type="note"` | → `:::{.callout-note}` |
| `block type="warning"` | → `:::{.callout-warning}` |
| `block type="try"` | → `:::{.callout-tip}` |
| `block type="task"` | → `:::{.callout-important}` |
| `block type="success"` | → `:::{.callout-tip}` |
| `block type="dashed"`/`"dotted"`/`"lag"` | → `:::{.callout-note}` (flagged, non-standard) |
| Custom engine `task` | → `:::{.callout-important}` with title |
| Custom engine `solution` | → `:::{.callout-tip}` with title |
| Custom engine `multCode` | → `:::{.callout-note}` with title |
| Citations `@key` | Unchanged (already Quarto-compatible) |
| `\@ref()` cross-references | None found in source .Rmd files |

## Per-File Details

### `01-projects.Rmd` → `01-projects.qmd`

- - Removed (PART\*) heading: 'Day 1' (handled in _quarto.yml)
- - Replaced child='_setup.Rmd' with standard setup sourcing
- - Renamed chunk option: out.width → out-width
- - Renamed chunk option: fig.cap → fig-cap
- - Converted block type='info' → callout-note
- - Converted custom engine 'task' → callout-important
- - Converted custom engine 'solution' → callout-tip
- - Converted block type='try' → callout-tip
- - Converted block type='info' → callout-note
- - Converted custom engine 'task' → callout-important
- - Converted block type='info' → callout-note
- Part headings removed: Day 1

### `02-tidyverse.Rmd` → `02-tidyverse.qmd`

- - Replaced child='_setup.Rmd' with standard setup sourcing
- - Converted block type='try' → callout-tip
- - Converted custom engine 'task' → callout-important
- - Converted custom engine 'solution' → callout-tip
- - Converted block type='info' → callout-note
- - Converted block type='info' → callout-note
- - Converted block type='info' → callout-note
- - Converted block type='note' → callout-note

### `03-functions.Rmd` → `03-functions.qmd`

- - Replaced child='_setup.Rmd' with standard setup sourcing
- - Converted block type='info' → callout-note
- - Converted custom engine 'task' → callout-important
- - Converted custom engine 'solution' → callout-tip
- - Converted block type='info' → callout-note
- - Converted custom engine 'task' → callout-important
- - Converted custom engine 'solution' → callout-tip
- - Converted block type='info' → callout-note
- - Converted custom engine 'task' → callout-important
- - Converted custom engine 'solution' → callout-tip
- - Converted block type='info' → callout-note
- - Converted custom engine 'solution' → callout-tip
- - Converted block type='info' → callout-note

### `04-iteration.Rmd` → `04-iteration.qmd`

- - Replaced child='_setup.Rmd' with standard setup sourcing
- - Converted block type='info' → callout-note
- - Converted block type='warning' → callout-warning
- - Converted block type='info' → callout-note
- - Converted custom engine 'task' → callout-important
- - Converted custom engine 'solution' → callout-tip
- - Converted custom engine 'task' → callout-important
- - Converted custom engine 'solution' → callout-tip
- - Converted block type='info' → callout-note

### `05-tidy-evaluation.Rmd` → `05-tidy-evaluation.qmd`

- - Replaced child='_setup.Rmd' with standard setup sourcing
- - Converted block type='info' → callout-note
- - Converted block type='info' → callout-note
- - Converted custom engine 'solution' → callout-tip
- - Converted custom engine 'task' → callout-important
- - Converted custom engine 'solution' → callout-tip
- - Converted custom engine 'task' → callout-important
- - Converted custom engine 'solution' → callout-tip
- - Converted custom engine 'task' → callout-important
- - Converted custom engine 'solution' → callout-tip
- - Converted custom engine 'task' → callout-important
- - Converted custom engine 'solution' → callout-tip
- - Converted block type='info' → callout-note

### `06-reproducibility.Rmd` → `06-reproducibility.qmd`

- - Removed (PART\*) heading: 'Day 2' (handled in _quarto.yml)
- - Replaced child='_setup.Rmd' with standard setup sourcing
- - Converted block type='info' → callout-note
- - Converted block type='info' → callout-note
- - Converted block type='try' → callout-tip
- - Renamed chunk option: out.width → out-width
- - Renamed chunk option: fig.cap → fig-cap
- - Converted block type='try' → callout-tip
- - Renamed chunk option: fig.cap → fig-cap
- - Renamed chunk option: fig.height → fig-height
- - Renamed chunk option: fig.width → fig-width
- - Converted block type='info' → callout-note
- - Converted block type='try' → callout-tip
- - Converted block type='note' → callout-note
- - Converted block type='try' → callout-tip
- - Converted block type='try' → callout-tip
- - Converted block type='try' → callout-tip
- - Converted block type='info' → callout-note
- - Converted block type='try' → callout-tip
- - Converted block type='try' → callout-tip
- Part headings removed: Day 2

### `07-code-review.Rmd` → `07-code-review.qmd`

- - Replaced child='_setup.Rmd' with standard setup sourcing
- - Converted block type='info' → callout-note
- - Converted block type='try' → callout-tip
- - Converted block type='try' → callout-tip
- - Converted block type='note' → callout-note
- - Converted block type='try' → callout-tip
- - Converted block type='try' → callout-tip
- - Converted block type='try' → callout-tip
- - Converted block type='info' → callout-note
- - Converted block type='note' → callout-note
- - Converted block type='try' → callout-tip
- - Converted block type='info' → callout-note
- - Converted block type='try' → callout-tip
- - Converted block type='try' → callout-tip

### `08-ggplot.Rmd` → `08-ggplot.qmd`

- - Removed (PART\*) heading: 'Day 3: Data Visualisation' (handled in _quarto.yml)
- - Replaced child='_setup.Rmd' with standard setup sourcing
- - Renamed chunk option: fig.height → fig-height
- - Renamed chunk option: fig.width → fig-width
- - Converted block type='try' → callout-tip
- - Converted block type='warning' → callout-warning
- - Converted block type='task' → callout-important
- - Converted block type='task' → callout-important
- - Renamed chunk option: fig.height → fig-height
- - Renamed chunk option: fig.height → fig-height
- - Renamed chunk option: fig.width → fig-width
- - Converted block type='info' → callout-note
- - Converted block type='warning' → callout-warning
- - Renamed chunk option: fig.height → fig-height
- - Renamed chunk option: fig.height → fig-height
- - Renamed chunk option: fig.height → fig-height
- - Renamed chunk option: fig.width → fig-width
- - Converted block type='info' → callout-note
- - Converted block type='note' → callout-note
- - Renamed chunk option: fig.height → fig-height
- - Converted block type='try' → callout-tip
- - Converted block type='task' → callout-important
- - Converted custom engine 'solution' → callout-tip
- - Renamed chunk option: fig.height → fig-height
- - Converted block type='try' → callout-tip
- - Converted block type='task' → callout-important
- - Converted custom engine 'solution' → callout-tip
- - Renamed chunk option: fig.height → fig-height
- - Renamed chunk option: fig.height → fig-height
- - Converted block type='try' → callout-tip
- - Converted block type='task' → callout-important
- - Converted custom engine 'solution' → callout-tip
- - Renamed chunk option: fig.height → fig-height
- - Converted block type='try' → callout-tip
- - Converted block type='task' → callout-important
- - Converted custom engine 'solution' → callout-tip
- - Converted block type='warning' → callout-warning
- - Converted block type='info' → callout-note
- - Converted block type='task' → callout-important
- - Converted block type='try' → callout-tip
- Part headings removed: Day 3: Data Visualisation

### `09-quarto-workshop-revised.Rmd` → `09-quarto-workshop-revised.qmd`

- - Replaced child='_setup.Rmd' with standard setup sourcing
- - Renamed chunk option: out.width → out-width
- - Renamed chunk option: out.width → out-width
- - Renamed chunk option: fig.asp → fig-asp
- - Renamed chunk option: fig.width → fig-width
- - Renamed chunk option: fig.asp → fig-asp
- - Renamed chunk option: fig.width → fig-width
- - Renamed chunk option: fig.asp → fig-asp
- - Renamed chunk option: fig.width → fig-width
- - Renamed chunk option: fig.asp → fig-asp
- - Renamed chunk option: fig.width → fig-width
- - Renamed chunk option: fig.asp → fig-asp
- - Renamed chunk option: fig.width → fig-width
- - Renamed chunk option: out.width → out-width

### `09-reproducible-reports.Rmd` → `09-reproducible-reports.qmd`

- - Replaced child='_setup.Rmd' with standard setup sourcing
- - Renamed chunk option: out.width → out-width
- - Renamed chunk option: out.width → out-width
- - Converted block type='try' → callout-tip
- - Converted block type='info' → callout-note
- - Converted custom engine 'task' → callout-important
- - Converted block type='info' → callout-note
- - Renamed chunk option: fig.asp → fig-asp
- - Renamed chunk option: fig.width → fig-width
- - Renamed chunk option: fig.asp → fig-asp
- - Renamed chunk option: fig.width → fig-width
- - Renamed chunk option: fig.asp → fig-asp
- - Renamed chunk option: fig.width → fig-width
- - Renamed chunk option: fig.asp → fig-asp
- - Renamed chunk option: fig.width → fig-width
- - Renamed chunk option: fig.asp → fig-asp
- - Renamed chunk option: fig.width → fig-width
- - Renamed chunk option: out.width → out-width
- - Converted block type='try' → callout-tip
- - Converted custom engine 'task' → callout-important
- - Converted block type='try' → callout-tip
- - Converted block type='info' → callout-note
- - Converted block type='warning' → callout-warning

### `10-github.Rmd` → `10-github.qmd`

- - Removed (PART\*) heading: 'Day 3: Github' (handled in _quarto.yml)
- - Replaced child='_setup.Rmd' with standard setup sourcing
- - Converted block type='info' → callout-note
- - Converted block type='info' → callout-note
- - Converted block type='info' → callout-note
- - Converted block type='note' → callout-note
- - Renamed chunk option: out.width → out-width
- - Renamed chunk option: fig.align → fig-align
- - Renamed chunk option: out.width → out-width
- - Renamed chunk option: fig.align → fig-align
- - Renamed chunk option: out.width → out-width
- - Renamed chunk option: fig.align → fig-align
- - Renamed chunk option: out.width → out-width
- - Renamed chunk option: fig.align → fig-align
- - Converted custom engine 'task' → callout-important
- - Converted block type='note' → callout-note
- Part headings removed: Day 3: Github

### `10a-github-automation-tutorial.Rmd` → `10a-github-automation-tutorial.qmd`

- - Replaced child='_setup.Rmd' with standard setup sourcing
- - Converted block type='info' → callout-note

### `11-AI-programming-integrated.Rmd` → `11-AI-programming-integrated.qmd`

- - Removed (PART\*) heading: 'Day 4' (handled in _quarto.yml)
- - Replaced child='_setup.Rmd' with standard setup sourcing
- - Converted custom engine 'solution' → callout-tip
- - Converted custom engine 'solution' → callout-tip
- - Converted custom engine 'solution' → callout-tip
- - Converted custom engine 'solution' → callout-tip
- - Converted block type='info' → callout-note
- - Converted custom engine 'solution' → callout-tip
- - Converted block type='info' → callout-note
- Part headings removed: Day 4

### `12-appendix.Rmd` → `12-appendix.qmd`

- - Removed (PART\*) heading: 'Extra Material' (handled in _quarto.yml)
- - Replaced child='_setup.Rmd' with standard setup sourcing
- - Converted custom engine 'solution' → callout-tip
- Part headings removed: Extra Material

### `12-basic-ggplot.Rmd` → `12-basic-ggplot.qmd`

- - Replaced child='_setup.Rmd' with standard setup sourcing
- - Renamed chunk option: out.width → out-width
- - Renamed chunk option: fig.cap → fig-cap
- - Converted block type='info' → callout-note
- - Converted block type='info' → callout-note
- - Renamed chunk option: fig.cap → fig-cap
- - Converted block type='warning' → callout-warning
- - Converted block type='info' → callout-note
- - Converted block type='info' → callout-note
- - Converted block type='try' → callout-tip
- - Renamed chunk option: out.width → out-width
- - Converted block type='try' → callout-tip
- - Converted block type='warning' → callout-warning

### `12a-basic-ggplot.Rmd` → `12a-basic-ggplot.qmd`

- - Replaced child='_setup.Rmd' with standard setup sourcing
- - Renamed chunk option: out.width → out-width
- - Renamed chunk option: fig.cap → fig-cap
- - Converted block type='info' → callout-note
- - Converted block type='info' → callout-note
- - Renamed chunk option: fig.cap → fig-cap
- - Converted block type='warning' → callout-warning
- - Converted block type='info' → callout-note
- - Converted block type='info' → callout-note
- - Converted block type='try' → callout-tip
- - Renamed chunk option: out.width → out-width
- - Converted block type='try' → callout-tip
- - Converted block type='warning' → callout-warning

### `12b-ggplot-principles.Rmd` → `12b-ggplot-principles.qmd`

- - Replaced child='_setup.Rmd' with standard setup sourcing
- - Converted block type='info' → callout-note
- - Renamed chunk option: out.width → out-width
- - Converted block type='info' → callout-note
- - Renamed chunk option: out.width → out-width
- - Renamed chunk option: out.width → out-width
- - Renamed chunk option: out.width → out-width
- - Converted block type='info' → callout-note
- - Converted block type='try' → callout-tip
- - Converted block type='try' → callout-tip
- - Renamed chunk option: out.width → out-width
- - Converted block type='info' → callout-note
- - Renamed chunk option: fig.width → fig-width
- - Converted custom engine 'solution' → callout-tip

### `12c-big_data_workshop.Rmd` → `12c-big_data_workshop.qmd`

- - Replaced child='_setup.Rmd' with standard setup sourcing
- - Converted block type='info' → callout-note
- - Converted block type='warning' → callout-warning
- - Converted block type='info' → callout-note
- - Converted block type='info' → callout-note
- - Converted block type='warning' → callout-warning
- - Converted block type='info' → callout-note
- - Converted block type='task' → callout-important
- - Converted block type='warning' → callout-warning
- - Converted block type='task' → callout-important
- - Converted block type='try' → callout-tip
- - Converted block type='info' → callout-note
- - Converted block type='warning' → callout-warning
- - Converted block type='warning' → callout-warning

### `13-intro-to-r.Rmd` → `13-intro-to-r.qmd`

- - Replaced child='_setup.Rmd' with standard setup sourcing
- - Renamed chunk option: fig.cap → fig-cap
- - Renamed chunk option: fig.cap → fig-cap
- - Renamed chunk option: fig.show → fig-show
- - Renamed chunk option: out.width → out-width
- - Converted block type='info' → callout-note
- - Converted block type='warning' → callout-warning
- - Converted block type='info' → callout-note
- - Converted block type='warning' → callout-warning
- - Converted block type='info' → callout-note
- - Renamed chunk option: fig.cap → fig-cap
- - Converted block type='warning' → callout-warning
- - Converted block type='info' → callout-note
- - Renamed chunk option: out.width → out-width
- - Renamed chunk option: fig.alt → fig-alt
- - Renamed chunk option: fig.cap → fig-cap
- - Converted custom engine 'task' → callout-important
- - Converted custom engine 'solution' → callout-tip
- - Converted block type='info' → callout-note
- - Converted block type='warning' → callout-warning
- - Converted block type='try' → callout-tip
- - Converted block type='try' → callout-tip
- - Converted block type='try' → callout-tip
- - Converted block type='warning' → callout-warning
- - Converted block type='try' → callout-tip
- - Renamed chunk option: out.width → out-width
- - Renamed chunk option: fig.alt → fig-alt
- - Renamed chunk option: fig.cap → fig-cap

## Files Archived

The following superseded `.qmd` files were moved to `archive/`:

- `02-renv.qmd` → `archive/02-renv.qmd`
- `03-github.qmd` → `archive/03-github.qmd`
- `04-eda.qmd` → `archive/04-eda.qmd`
- `04-managing-data.qmd` → `archive/04-managing-data.qmd`
- `04-penguin-project.qmd` → `archive/04-penguin-project.qmd`
- `05-coding-AI.qmd` → `archive/05-coding-AI.qmd`
- `05-dplyr.qmd` → `archive/05-dplyr.qmd`
- `06-complex-models.qmd` → `archive/06-complex-models.qmd`
- `06-data-bias.qmd` → `archive/06-data-bias.qmd`
- `07-data-insights.qmd` → `archive/07-data-insights.qmd`
- `07-generalised-linear.qmd` → `archive/07-generalised-linear.qmd`
- `08-inferential-statistics.qmd` → `archive/08-inferential-statistics.qmd`
- `08-poisson.qmd` → `archive/08-poisson.qmd`
- `09-binomial.qmd` → `archive/09-binomial.qmd`
- `09-linear-models.qmd` → `archive/09-linear-models.qmd`
- `10-data-visualisation.qmd` → `archive/10-data-visualisation.qmd`
- `10-paired-design.qmd` → `archive/10-paired-design.qmd`
- `11-regression.qmd` → `archive/11-regression.qmd`
- `11-writing-functions.qmd` → `archive/11-writing-functions.qmd`
- `12-ANOVA.qmd` → `archive/12-ANOVA.qmd`
- `13-interaction.qmd` → `archive/13-interaction.qmd`
- `CopyOfsupervised-learning-regression.qmd` → `archive/CopyOfsupervised-learning-regression.qmd`
- `Naming conventions.qmd` → `archive/Naming conventions.qmd`
- `advanced_ggplot.qmd` → `archive/advanced_ggplot.qmd`
- `data_reshaping.qmd` → `archive/data_reshaping.qmd`
- `dimensionality_reduction.qmd` → `archive/dimensionality_reduction.qmd`
- `ggplot.qmd` → `archive/ggplot.qmd`
- `import.qmd` → `archive/import.qmd`
- `instructions.qmd` → `archive/instructions.qmd`
- `orig-01-projects.qmd` → `archive/orig-01-projects.qmd`
- `projects.qmd` → `archive/projects.qmd`
- `quarto.qmd` → `archive/quarto.qmd`
- `r-basics.qmd` → `archive/r-basics.qmd`
- `script.qmd` → `archive/script.qmd`
- `summary-table.qmd` → `archive/summary-table.qmd`
- `supervised-classifier.qmd` → `archive/supervised-classifier.qmd`
- `supervised-learning-regression.qmd` → `archive/supervised-learning-regression.qmd`
- `task1.qmd` → `archive/task1.qmd`
- `task2.qmd` → `archive/task2.qmd`
- `task3.qmd` → `archive/task3.qmd`
- `task4.qmd` → `archive/task4.qmd`
- `task5.qmd` → `archive/task5.qmd`
- `task6.qmd` → `archive/task6.qmd`
- `task7.qmd` → `archive/task7.qmd`
- `task8.qmd` → `archive/task8.qmd`
- `tidy-data.qmd` → `archive/tidy-data.qmd`
- `webexercises.qmd` → `archive/webexercises.qmd`

## Files NOT Archived

Per instructions, the following were not archived:

- `index.qmd` — book index
- `_quarto.yml` — project configuration
- `references.qmd` — bibliography page (still used)

## Residual Manual Tasks

1. **Install R packages:** The build environment lacked several R packages (webexercises, glossary, palmerpenguins, etc.). A full render with code execution requires these packages to be installed. The current render was validated with `execute: false` plus function stubs.

2. **Verify inline R expressions:** Files with inline R code (`` `r mcq(...)` ``, `` `r hide(...)` ``, etc.) use webexercises functions. These render correctly when the `webexercises` package is available.

3. **Review `_setup.Rmd` replacement:** Each file's `child='_setup.Rmd'` chunk was replaced with a standard setup block sourcing `R/booktem_setup.R` and `R/my_setup.R`. The original `_setup.Rmd` contained custom knitr engines for `task`, `solution`, and `multCode` which are now converted to callout blocks. Verify the callout rendering matches expectations.

4. **Check `@fig-scatter` reference:** In `09-quarto-workshop-revised.qmd`, the text `@fig-scatter` on line 625 is demonstrative (teaching how cross-refs work). It shows as an unresolved ref warning during render. If this is undesirable, wrap it in backticks.

5. **Review duplicate content:** `12-basic-ggplot.qmd` and `12a-basic-ggplot.qmd` appear to have identical content (both sourced from similarly named .Rmd files). Consider removing one.

6. **Non-standard block types:** The block types `dashed`, `dotted`, and `lag` were mapped to `callout-note` as a default. Review if a different callout type is more appropriate.

7. **Freeze cache:** The `_freeze/` directory contains cached results for the old chapter files. After a full render with R packages installed, the freeze cache will be updated for the new files.

