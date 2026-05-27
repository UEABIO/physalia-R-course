# Day 1 Block 2: Getting more out of tidyverse {.unnumbered}




*Roughly 55 minutes. We assume the core verbs are familiar and spend the time on
the patterns that remove repetition: working across many columns, reshaping, and
the nesting idea that the afternoon depends on.*

Throughout this block we use a cleaned copy of the data:


```r
library(tidyverse)
library(palmerpenguins)
library(janitor)

penguins_clean <- penguins_raw |>
  janitor::clean_names()
```

## A 5-minute refresher (diagnostic, not teaching)

Before the new material, a quick check that the foundation is solid. Predict the
output of each line *before* running it, then run it.


```r
penguins_clean |> dplyr::filter(body_mass_g > 5000)               # which rows?
penguins_clean |> dplyr::filter_out(body_mass_g > 5000)           # which rows? (Hint this is a new function)
penguins_clean |> dplyr::select(species, body_mass_g)             # which columns?
penguins_clean |> dplyr::mutate(mass_kg = body_mass_g / 1000)     # new column?
penguins_clean |> dplyr::summarise(m = mean(body_mass_g, na.rm = TRUE), .by = species)
```

If those four lines hold no surprises, you have everything you need for the day.
Note the modern `.by = species` argument to `summarise()`: it groups for that one
operation and returns an ungrouped result, which avoids the classic forgotten
`ungroup()` bug.

## Working across many columns with `across()`

A recurring issue in analysis scripts is the same operation written out once per
column:


```r
penguins_clean |>
  dplyr::summarise(
    mean_body_mass      = mean(body_mass_g, na.rm = TRUE),
    mean_flipper_length = mean(flipper_length_mm, na.rm = TRUE),
    .by = species
  )
```

`across()` says "apply this function to these columns" in one place. It works only
inside a dplyr verb, and takes three arguments worth knowing: `.cols` (which
columns, using tidy-selection), `.fns` (the function to apply), and `.names` (how
to name the results).


```r
penguins_clean |>
  dplyr::summarise(
    dplyr::across(
      .cols  = where(is.numeric),
      .fns   = \(x) mean(x, na.rm = TRUE),
      .names = "mean_{.col}"
    ),
    .by = species
  )
```

Two modern points. The function is written as `\(x) mean(x, na.rm = TRUE)`, the
R 4.1 anonymous-function shorthand, rather than the older `~ mean(.x, na.rm = T)`
formula-lambda you will still see in the wild. And `na.rm = TRUE` is spelled out;
`T` and `F` are ordinary variables that can be reassigned, so they are best
avoided in code you intend to keep.

The same pattern coerces a set of columns to factors:


```r
penguins_clean |>
  dplyr::mutate(
    dplyr::across(.cols = c(species, island), 
    .fns = as.factor)
  ) |>
  dplyr::select(where(is.factor)) |>
  dplyr::glimpse()
```

### `across()`'s row-wise cousins: `if_any()` and `if_all()`

To filter rows on a condition applied across several columns, use `if_any()` (the
condition holds for *at least one* of the columns) or `if_all()` (it holds for
*all* of them).


```r
# Keep rows where ALL numeric measurements are present (no NA)
penguins_clean |>
  dplyr::filter(
    dplyr::if_all(.cols = where(is.numeric), .fns = \(x) !is.na(x))
  )
```

<div class="try">
<p>The line above reads slightly backwards at first.
<code>if_all()</code> asks whether <em>all</em> the chosen columns
satisfy “is not <code>NA</code>”. Try swapping <code>if_all</code> for
<code>if_any</code>, and try removing the <code>!</code>, and predict
each result before running it.</p>
</div>

### Activity: one summary, every numeric column

<div class="panel panel-default"><div class="panel-heading"> Task </div><div class="panel-body"> 

Write a single `summarise()` that returns, for each species, both the mean and the
standard deviation of every numeric column, with names like `mean_body_mass_g` and
`sd_body_mass_g`. Hint: `.fns` can be a named list of functions.
 </div></div>

<button id="displayTextunnamed-chunk-10" onclick="javascript:toggle('unnamed-chunk-10');">Show Solution</button>

<div id="toggleTextunnamed-chunk-10" style="display: none"><div class="panel panel-default"><div class="panel-heading panel-heading1"> Solution </div><div class="panel-body">

```r
penguins_clean |>
  dplyr::summarise(
    dplyr::across(
      .cols  = where(is.numeric),
      .fns   = list(mean = \(x) mean(x, na.rm = TRUE),
                    sd   = \(x) sd(x, na.rm = TRUE)),
      .names = "{.fn}_{.col}"
    ),
    .by = species
  )
```

When `.fns` is a named list, `{.fn}` in `.names` expands to each function's name.
This is the whole quarter-page of repeated `mean_x =`, `sd_x =` lines replaced by
four lines that cannot drift out of step with each other.
</div></div></div>

## A note on factors

Categorical variables are often better as factors than as character strings, and
`forcats` (part of the tidyverse) provides verbs for managing their levels.


```r
penguins_clean |>
  dplyr::mutate(
    # collapse rare levels into "Other", keeping the 2 most frequent
    island_lumped = forcats::fct_lump_n(island, n = 2),
    # order species by their mean body mass, for sensible plot ordering
    species       = forcats::fct_reorder(species, body_mass_g, .fun = mean,
                                         na.rm = TRUE)
  )
```

`fct_reorder()` is the one to remember: it reorders a factor's levels by a summary
of another variable, which is what you almost always want for an ordered axis or
legend.

## Reshaping with `pivot_longer()` and `pivot_wider()`

Tidy data has one variable per column and one observation per row. Data collected
in the field often violates this, most commonly by spreading one variable across
several columns. Consider weekly observation counts:


```r
peng_obs <- tibble::tibble(
  penguin_id = c("N15A1", "N15A2", "N18A1", "N71A2"),
  wk1 = c(1, 2, 4, 5),
  wk2 = c(3, 4, 1, 0),
  wk3 = c(0, 0, 2, 0)
)
```

This is untidy: `wk1`, `wk2`, `wk3` are three columns holding one variable (the
count), recorded at three values of another variable (the week).
`pivot_longer()` repairs it:


```r
peng_obs |>
  tidyr::pivot_longer(
    cols            = wk1:wk3,
    names_to        = "week",
    names_prefix    = "wk",            # strip the "wk" so "wk2" becomes "2"
    names_transform = as.integer,      # and make week an integer, not a string
    values_to       = "observations"
  )
```

`pivot_wider()` is the inverse, and is most useful for turning a tidy summary into
a human-readable table:


```r
penguins_clean |>
  dplyr::summarise(mean = mean(body_mass_g, na.rm = TRUE),
                   .by = c(species, island)) |>
  tidyr::pivot_wider(
    names_from   = island,
    values_from  = mean,
    names_prefix = "mean_"
  )
```

<div class="info">
<p>Keep analysis in long (tidy) form and pivot wide only at the very
end, for display. Long data is what <code>ggplot2</code> and the
modelling functions expect; wide data is for human eyes in a printed
table.</p>
</div>

## Slicing rows

`slice()` and its helpers select rows by position or by an ordering, which is
often cleaner than a `filter()` with an arithmetic threshold.


```r
# The three heaviest penguins per species
penguins_clean |>
  dplyr::slice_max(order_by = body_mass_g, n = 3, by = species) |>
  dplyr::select(species, body_mass_g)
```

The relatives are `slice_head()`, `slice_tail()`, `slice_min()` and
`slice_sample()`. The modern `by =` argument applies the slice within each group
without a separate `group_by()`/`ungroup()` pair.

## The bridge to the afternoon: nesting

The afternoon's iteration work rests on one idea introduced here. A tibble cell
usually holds a single value. It can instead hold an entire tibble.
`group_by()` followed by `nest()` collapses each group's rows into one cell:


```r
penguins_clean |>
  tidyr::drop_na(body_mass_g, flipper_length_mm) |>
  dplyr::group_by(species) |>
  tidyr::nest()
# # A tibble: 3 x 2
#   species   data
#   <chr>     <list>
# 1 Adelie    <tibble [...]>
# 2 Gentoo    <tibble [...]>
# 3 Chinstrap <tibble [...]>
```

The `data` column is a **list-column**: each cell is a tibble holding one species'
observations. This is not exotic; it is an ordinary column whose values happen to
be tibbles. We do nothing further with it now. Hold the picture in mind: in Block 4
we will apply a function to each of those cells and fit one model per species in a
single pipeline.

### Reading many files (a preview of iteration)

The same nesting and iteration ideas read a folder of files at once. Suppose a
directory holds one CSV per sampling site:


```r
# List the files (full paths, so they can be opened from anywhere)
csv_files <- list.files(
  path       = here::here("data", "many_files"),
  pattern    = "\\.csv$",
  full.names = TRUE
)

# Read every file and stack the results into one tibble.
# The modern idiom is map() then list_rbind(); the older map_dfr() is superseded.
all_sites <- csv_files |>
  purrr::map(\(f) readr::read_csv(f, show_col_types = FALSE)) |>
  purrr::list_rbind()
```

`map()` reads each file into a list of tibbles; `list_rbind()` binds that list
into one tibble. We will unpack `map()` properly in Block 4. For now, notice that
"do the same thing to every element of a collection" is the shape of almost all
the work ahead.

<div class="info">
<p><strong>Where this leaves us.</strong> We can now operate on many
columns at once, reshape between long and wide, slice by order, and
collapse groups into list-columns. The data-handling toolkit is
complete. The rest of the day is about the <em>code that acts on the
data</em>: functions, iteration, and generalisation.</p>
</div>

### Other key packages 

## Data validation with `tidylog` and `assertr` {#sec-validate}

Robust data analysis depends on making every transformation visible and ensuring assumptions about the data are actually met. Two useful tools for this are `tidylog`, which reports what `dplyr` is doing, and `assertr`, which enforces explicit checks during a pipeline.

We’ll use a small simulated dataset of insect reproduction to illustrate both ideas.


```r
library(tidyverse)
library(dplyr)
library(tidylog)
library(assertr)

set.seed(123)
n <- 200

female_egg_data <- tibble(
  female_id = 1:n,
  treatment = rep(c("A","B"), times = 100),
  age_days = sample(1:30, n, replace = TRUE),
  eggs_laid = rpois(n, lambda = 50),
  eggs_hatched = pmin(eggs_laid, rpois(n, lambda = 45)),
  body_mass  = rnorm(n, mean = 0.2, sd = 5)
)

# introduce a few intentional problems
female_egg_data$age_days[1] <- 0
female_egg_data$eggs_laid[2] <- 120
female_egg_data$eggs_hatched[3] <- female_egg_data$eggs_laid[3] + 5
```

---

## Making transformations visible with `tidylog`

When `tidylog` is loaded, standard `dplyr` verbs report what they change. This is particularly helpful in pipelines where rows are filtered or variables are modified without otherwise obvious trace.


```r
female_egg_data_clean <- female_egg_data |>
  filter(age_days > 0) |>
  mutate(eggs_per_day = eggs_laid / age_days)
```

Instead of silently dropping rows or creating variables, the console output summarises exactly what was removed or added, making the workflow easier to audit and debug.

---

## Enforcing assumptions with `assertr`

While `tidylog` improves transparency, `assertr` ensures that data meet expectations before analysis continues.

The core idea is that validation lives *inside your pipeline*, right next to the data it is checking. If an assertion fails, the pipeline stops and tells you exactly what went wrong and in which rows. If everything passes, execution continues as normal.

## Data validation with `assertr`

Again, we will use the `female_egg_data_clean` dataset.


```r
glimpse(female_egg_data_clean)
```

```
## Rows: 19
## Columns: 6
## $ female_id    <int> 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 1…
## $ treatment    <chr> "B", "A", "B", "A", "B", "A", "B", "A", "B", "A", "B", "A…
## $ age_days     <dbl> 19, 14, 3, 10, 18, 22, 11, 5, 20, 14, 22, 25, 26, 27, 5, …
## $ eggs_laid    <dbl> 120, 50, 46, 59, 55, 49, 44, 42, 47, 44, 57, 48, 41, 41, …
## $ eggs_hatched <dbl> 52, 55, 46, 50, 43, 49, 38, 42, 39, 44, 46, 44, 41, 41, 4…
## $ eggs_per_day <dbl> 6.315789, 3.571429, 15.333333, 5.900000, 3.055556, 2.2272…
```

### `verify()` — check a logical condition

`verify()` is the simplest function. It evaluates a logical expression against the whole dataframe and stops if it is FALSE. Think of it as `stopifnot()` with better error messages and pipeline compatibility.


```r
# Check that all rows of eggs laid are positive — this should pass
female_egg_data_clean |>
  verify(eggs_laid > 0)
```

<div class="kable-table">

<table>
 <thead>
  <tr>
   <th style="text-align:right;"> female_id </th>
   <th style="text-align:left;"> treatment </th>
   <th style="text-align:right;"> age_days </th>
   <th style="text-align:right;"> eggs_laid </th>
   <th style="text-align:right;"> eggs_hatched </th>
   <th style="text-align:right;"> eggs_per_day </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> 19 </td>
   <td style="text-align:right;"> 120 </td>
   <td style="text-align:right;"> 52 </td>
   <td style="text-align:right;"> 6.315790 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 14 </td>
   <td style="text-align:right;"> 50 </td>
   <td style="text-align:right;"> 55 </td>
   <td style="text-align:right;"> 3.571429 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 46 </td>
   <td style="text-align:right;"> 46 </td>
   <td style="text-align:right;"> 15.333333 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:right;"> 59 </td>
   <td style="text-align:right;"> 50 </td>
   <td style="text-align:right;"> 5.900000 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> 18 </td>
   <td style="text-align:right;"> 55 </td>
   <td style="text-align:right;"> 43 </td>
   <td style="text-align:right;"> 3.055556 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 22 </td>
   <td style="text-align:right;"> 49 </td>
   <td style="text-align:right;"> 49 </td>
   <td style="text-align:right;"> 2.227273 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> 11 </td>
   <td style="text-align:right;"> 44 </td>
   <td style="text-align:right;"> 38 </td>
   <td style="text-align:right;"> 4.000000 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 9 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 42 </td>
   <td style="text-align:right;"> 42 </td>
   <td style="text-align:right;"> 8.400000 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> 20 </td>
   <td style="text-align:right;"> 47 </td>
   <td style="text-align:right;"> 39 </td>
   <td style="text-align:right;"> 2.350000 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 11 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 14 </td>
   <td style="text-align:right;"> 44 </td>
   <td style="text-align:right;"> 44 </td>
   <td style="text-align:right;"> 3.142857 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 12 </td>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> 22 </td>
   <td style="text-align:right;"> 57 </td>
   <td style="text-align:right;"> 46 </td>
   <td style="text-align:right;"> 2.590909 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 13 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 25 </td>
   <td style="text-align:right;"> 48 </td>
   <td style="text-align:right;"> 44 </td>
   <td style="text-align:right;"> 1.920000 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 14 </td>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> 26 </td>
   <td style="text-align:right;"> 41 </td>
   <td style="text-align:right;"> 41 </td>
   <td style="text-align:right;"> 1.576923 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 15 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 27 </td>
   <td style="text-align:right;"> 41 </td>
   <td style="text-align:right;"> 41 </td>
   <td style="text-align:right;"> 1.518519 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 16 </td>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 47 </td>
   <td style="text-align:right;"> 43 </td>
   <td style="text-align:right;"> 9.400000 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 19 </td>
   <td style="text-align:right;"> 47 </td>
   <td style="text-align:right;"> 47 </td>
   <td style="text-align:right;"> 2.473684 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 18 </td>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> 27 </td>
   <td style="text-align:right;"> 49 </td>
   <td style="text-align:right;"> 34 </td>
   <td style="text-align:right;"> 1.814815 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 19 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 25 </td>
   <td style="text-align:right;"> 56 </td>
   <td style="text-align:right;"> 37 </td>
   <td style="text-align:right;"> 2.240000 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 20 </td>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> 28 </td>
   <td style="text-align:right;"> 48 </td>
   <td style="text-align:right;"> 46 </td>
   <td style="text-align:right;"> 1.714286 </td>
  </tr>
</tbody>
</table>

</div>


```r
# Check something that will fail — no female should produce more than 1000 offspring
female_egg_data_clean |>
  verify(eggs_hatched > 1000)
```

```
## Error: assertr stopped execution
```

```
## verification [eggs_hatched > 1000] failed! (19 failures)
## 
##      verb redux_fn           predicate column index value
## 1  verify       NA eggs_hatched > 1000     NA     1    NA
## 2  verify       NA eggs_hatched > 1000     NA     2    NA
## 3  verify       NA eggs_hatched > 1000     NA     3    NA
## 4  verify       NA eggs_hatched > 1000     NA     4    NA
## 5  verify       NA eggs_hatched > 1000     NA     5    NA
## 6  verify       NA eggs_hatched > 1000     NA     6    NA
## 7  verify       NA eggs_hatched > 1000     NA     7    NA
## 8  verify       NA eggs_hatched > 1000     NA     8    NA
## 9  verify       NA eggs_hatched > 1000     NA     9    NA
## 10 verify       NA eggs_hatched > 1000     NA    10    NA
## 11 verify       NA eggs_hatched > 1000     NA    11    NA
## 12 verify       NA eggs_hatched > 1000     NA    12    NA
## 13 verify       NA eggs_hatched > 1000     NA    13    NA
## 14 verify       NA eggs_hatched > 1000     NA    14    NA
## 15 verify       NA eggs_hatched > 1000     NA    15    NA
## 16 verify       NA eggs_hatched > 1000     NA    16    NA
## 17 verify       NA eggs_hatched > 1000     NA    17    NA
## 18 verify       NA eggs_hatched > 1000     NA    18    NA
## 19 verify       NA eggs_hatched > 1000     NA    19    NA
```

<div class="info">
<p><code>verify()</code> operates on the whole dataframe. It is good for
checking structural properties: expected number of rows, expected
columns, range constraints you know in advance.</p>
</div>

### `assert()` — check a predicate column by column

`assert()` applies a predicate function to one or more columns and reports which rows fail. This is more useful for checking individual variables.


```r
# Check that eggs_hatched is within a plausible biological range
female_egg_data_clean |>
  assert(within_bounds(30, 60), eggs_hatched)

# Check that treatment only contains expected values
female_egg_data_clean |>
  assert(in_set("B", "A", "Gentoo"), treatment)

# Check that age_days has no NAs
female_egg_data_clean |>
  assert(not_na, age_days)
```

<div class="kable-table">

<table>
 <thead>
  <tr>
   <th style="text-align:right;"> female_id </th>
   <th style="text-align:left;"> treatment </th>
   <th style="text-align:right;"> age_days </th>
   <th style="text-align:right;"> eggs_laid </th>
   <th style="text-align:right;"> eggs_hatched </th>
   <th style="text-align:right;"> eggs_per_day </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> 19 </td>
   <td style="text-align:right;"> 120 </td>
   <td style="text-align:right;"> 52 </td>
   <td style="text-align:right;"> 6.315790 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 14 </td>
   <td style="text-align:right;"> 50 </td>
   <td style="text-align:right;"> 55 </td>
   <td style="text-align:right;"> 3.571429 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 46 </td>
   <td style="text-align:right;"> 46 </td>
   <td style="text-align:right;"> 15.333333 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:right;"> 59 </td>
   <td style="text-align:right;"> 50 </td>
   <td style="text-align:right;"> 5.900000 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> 18 </td>
   <td style="text-align:right;"> 55 </td>
   <td style="text-align:right;"> 43 </td>
   <td style="text-align:right;"> 3.055556 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 22 </td>
   <td style="text-align:right;"> 49 </td>
   <td style="text-align:right;"> 49 </td>
   <td style="text-align:right;"> 2.227273 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> 11 </td>
   <td style="text-align:right;"> 44 </td>
   <td style="text-align:right;"> 38 </td>
   <td style="text-align:right;"> 4.000000 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 9 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 42 </td>
   <td style="text-align:right;"> 42 </td>
   <td style="text-align:right;"> 8.400000 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> 20 </td>
   <td style="text-align:right;"> 47 </td>
   <td style="text-align:right;"> 39 </td>
   <td style="text-align:right;"> 2.350000 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 11 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 14 </td>
   <td style="text-align:right;"> 44 </td>
   <td style="text-align:right;"> 44 </td>
   <td style="text-align:right;"> 3.142857 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 12 </td>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> 22 </td>
   <td style="text-align:right;"> 57 </td>
   <td style="text-align:right;"> 46 </td>
   <td style="text-align:right;"> 2.590909 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 13 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 25 </td>
   <td style="text-align:right;"> 48 </td>
   <td style="text-align:right;"> 44 </td>
   <td style="text-align:right;"> 1.920000 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 14 </td>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> 26 </td>
   <td style="text-align:right;"> 41 </td>
   <td style="text-align:right;"> 41 </td>
   <td style="text-align:right;"> 1.576923 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 15 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 27 </td>
   <td style="text-align:right;"> 41 </td>
   <td style="text-align:right;"> 41 </td>
   <td style="text-align:right;"> 1.518519 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 16 </td>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 47 </td>
   <td style="text-align:right;"> 43 </td>
   <td style="text-align:right;"> 9.400000 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 19 </td>
   <td style="text-align:right;"> 47 </td>
   <td style="text-align:right;"> 47 </td>
   <td style="text-align:right;"> 2.473684 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 18 </td>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> 27 </td>
   <td style="text-align:right;"> 49 </td>
   <td style="text-align:right;"> 34 </td>
   <td style="text-align:right;"> 1.814815 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 19 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 25 </td>
   <td style="text-align:right;"> 56 </td>
   <td style="text-align:right;"> 37 </td>
   <td style="text-align:right;"> 2.240000 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 20 </td>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> 28 </td>
   <td style="text-align:right;"> 48 </td>
   <td style="text-align:right;"> 46 </td>
   <td style="text-align:right;"> 1.714286 </td>
  </tr>
</tbody>
</table>

</div><div class="kable-table">

<table>
 <thead>
  <tr>
   <th style="text-align:right;"> female_id </th>
   <th style="text-align:left;"> treatment </th>
   <th style="text-align:right;"> age_days </th>
   <th style="text-align:right;"> eggs_laid </th>
   <th style="text-align:right;"> eggs_hatched </th>
   <th style="text-align:right;"> eggs_per_day </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> 19 </td>
   <td style="text-align:right;"> 120 </td>
   <td style="text-align:right;"> 52 </td>
   <td style="text-align:right;"> 6.315790 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 14 </td>
   <td style="text-align:right;"> 50 </td>
   <td style="text-align:right;"> 55 </td>
   <td style="text-align:right;"> 3.571429 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 46 </td>
   <td style="text-align:right;"> 46 </td>
   <td style="text-align:right;"> 15.333333 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:right;"> 59 </td>
   <td style="text-align:right;"> 50 </td>
   <td style="text-align:right;"> 5.900000 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> 18 </td>
   <td style="text-align:right;"> 55 </td>
   <td style="text-align:right;"> 43 </td>
   <td style="text-align:right;"> 3.055556 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 22 </td>
   <td style="text-align:right;"> 49 </td>
   <td style="text-align:right;"> 49 </td>
   <td style="text-align:right;"> 2.227273 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> 11 </td>
   <td style="text-align:right;"> 44 </td>
   <td style="text-align:right;"> 38 </td>
   <td style="text-align:right;"> 4.000000 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 9 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 42 </td>
   <td style="text-align:right;"> 42 </td>
   <td style="text-align:right;"> 8.400000 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> 20 </td>
   <td style="text-align:right;"> 47 </td>
   <td style="text-align:right;"> 39 </td>
   <td style="text-align:right;"> 2.350000 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 11 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 14 </td>
   <td style="text-align:right;"> 44 </td>
   <td style="text-align:right;"> 44 </td>
   <td style="text-align:right;"> 3.142857 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 12 </td>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> 22 </td>
   <td style="text-align:right;"> 57 </td>
   <td style="text-align:right;"> 46 </td>
   <td style="text-align:right;"> 2.590909 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 13 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 25 </td>
   <td style="text-align:right;"> 48 </td>
   <td style="text-align:right;"> 44 </td>
   <td style="text-align:right;"> 1.920000 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 14 </td>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> 26 </td>
   <td style="text-align:right;"> 41 </td>
   <td style="text-align:right;"> 41 </td>
   <td style="text-align:right;"> 1.576923 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 15 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 27 </td>
   <td style="text-align:right;"> 41 </td>
   <td style="text-align:right;"> 41 </td>
   <td style="text-align:right;"> 1.518519 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 16 </td>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 47 </td>
   <td style="text-align:right;"> 43 </td>
   <td style="text-align:right;"> 9.400000 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 19 </td>
   <td style="text-align:right;"> 47 </td>
   <td style="text-align:right;"> 47 </td>
   <td style="text-align:right;"> 2.473684 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 18 </td>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> 27 </td>
   <td style="text-align:right;"> 49 </td>
   <td style="text-align:right;"> 34 </td>
   <td style="text-align:right;"> 1.814815 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 19 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 25 </td>
   <td style="text-align:right;"> 56 </td>
   <td style="text-align:right;"> 37 </td>
   <td style="text-align:right;"> 2.240000 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 20 </td>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> 28 </td>
   <td style="text-align:right;"> 48 </td>
   <td style="text-align:right;"> 46 </td>
   <td style="text-align:right;"> 1.714286 </td>
  </tr>
</tbody>
</table>

</div><div class="kable-table">

<table>
 <thead>
  <tr>
   <th style="text-align:right;"> female_id </th>
   <th style="text-align:left;"> treatment </th>
   <th style="text-align:right;"> age_days </th>
   <th style="text-align:right;"> eggs_laid </th>
   <th style="text-align:right;"> eggs_hatched </th>
   <th style="text-align:right;"> eggs_per_day </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> 19 </td>
   <td style="text-align:right;"> 120 </td>
   <td style="text-align:right;"> 52 </td>
   <td style="text-align:right;"> 6.315790 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 14 </td>
   <td style="text-align:right;"> 50 </td>
   <td style="text-align:right;"> 55 </td>
   <td style="text-align:right;"> 3.571429 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 46 </td>
   <td style="text-align:right;"> 46 </td>
   <td style="text-align:right;"> 15.333333 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:right;"> 59 </td>
   <td style="text-align:right;"> 50 </td>
   <td style="text-align:right;"> 5.900000 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> 18 </td>
   <td style="text-align:right;"> 55 </td>
   <td style="text-align:right;"> 43 </td>
   <td style="text-align:right;"> 3.055556 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 22 </td>
   <td style="text-align:right;"> 49 </td>
   <td style="text-align:right;"> 49 </td>
   <td style="text-align:right;"> 2.227273 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> 11 </td>
   <td style="text-align:right;"> 44 </td>
   <td style="text-align:right;"> 38 </td>
   <td style="text-align:right;"> 4.000000 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 9 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 42 </td>
   <td style="text-align:right;"> 42 </td>
   <td style="text-align:right;"> 8.400000 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> 20 </td>
   <td style="text-align:right;"> 47 </td>
   <td style="text-align:right;"> 39 </td>
   <td style="text-align:right;"> 2.350000 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 11 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 14 </td>
   <td style="text-align:right;"> 44 </td>
   <td style="text-align:right;"> 44 </td>
   <td style="text-align:right;"> 3.142857 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 12 </td>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> 22 </td>
   <td style="text-align:right;"> 57 </td>
   <td style="text-align:right;"> 46 </td>
   <td style="text-align:right;"> 2.590909 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 13 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 25 </td>
   <td style="text-align:right;"> 48 </td>
   <td style="text-align:right;"> 44 </td>
   <td style="text-align:right;"> 1.920000 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 14 </td>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> 26 </td>
   <td style="text-align:right;"> 41 </td>
   <td style="text-align:right;"> 41 </td>
   <td style="text-align:right;"> 1.576923 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 15 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 27 </td>
   <td style="text-align:right;"> 41 </td>
   <td style="text-align:right;"> 41 </td>
   <td style="text-align:right;"> 1.518519 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 16 </td>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 47 </td>
   <td style="text-align:right;"> 43 </td>
   <td style="text-align:right;"> 9.400000 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 19 </td>
   <td style="text-align:right;"> 47 </td>
   <td style="text-align:right;"> 47 </td>
   <td style="text-align:right;"> 2.473684 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 18 </td>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> 27 </td>
   <td style="text-align:right;"> 49 </td>
   <td style="text-align:right;"> 34 </td>
   <td style="text-align:right;"> 1.814815 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 19 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 25 </td>
   <td style="text-align:right;"> 56 </td>
   <td style="text-align:right;"> 37 </td>
   <td style="text-align:right;"> 2.240000 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 20 </td>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> 28 </td>
   <td style="text-align:right;"> 48 </td>
   <td style="text-align:right;"> 46 </td>
   <td style="text-align:right;"> 1.714286 </td>
  </tr>
</tbody>
</table>

</div>

You can check multiple columns at once by listing them:


```r
# Check both egg measurements are within plausible ranges
female_egg_data_clean |>
  assert(within_bounds(0, 150), eggs_laid, eggs_hatched)
```

<div class="kable-table">

<table>
 <thead>
  <tr>
   <th style="text-align:right;"> female_id </th>
   <th style="text-align:left;"> treatment </th>
   <th style="text-align:right;"> age_days </th>
   <th style="text-align:right;"> eggs_laid </th>
   <th style="text-align:right;"> eggs_hatched </th>
   <th style="text-align:right;"> eggs_per_day </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> 19 </td>
   <td style="text-align:right;"> 120 </td>
   <td style="text-align:right;"> 52 </td>
   <td style="text-align:right;"> 6.315790 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 14 </td>
   <td style="text-align:right;"> 50 </td>
   <td style="text-align:right;"> 55 </td>
   <td style="text-align:right;"> 3.571429 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 46 </td>
   <td style="text-align:right;"> 46 </td>
   <td style="text-align:right;"> 15.333333 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:right;"> 59 </td>
   <td style="text-align:right;"> 50 </td>
   <td style="text-align:right;"> 5.900000 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> 18 </td>
   <td style="text-align:right;"> 55 </td>
   <td style="text-align:right;"> 43 </td>
   <td style="text-align:right;"> 3.055556 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 22 </td>
   <td style="text-align:right;"> 49 </td>
   <td style="text-align:right;"> 49 </td>
   <td style="text-align:right;"> 2.227273 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> 11 </td>
   <td style="text-align:right;"> 44 </td>
   <td style="text-align:right;"> 38 </td>
   <td style="text-align:right;"> 4.000000 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 9 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 42 </td>
   <td style="text-align:right;"> 42 </td>
   <td style="text-align:right;"> 8.400000 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> 20 </td>
   <td style="text-align:right;"> 47 </td>
   <td style="text-align:right;"> 39 </td>
   <td style="text-align:right;"> 2.350000 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 11 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 14 </td>
   <td style="text-align:right;"> 44 </td>
   <td style="text-align:right;"> 44 </td>
   <td style="text-align:right;"> 3.142857 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 12 </td>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> 22 </td>
   <td style="text-align:right;"> 57 </td>
   <td style="text-align:right;"> 46 </td>
   <td style="text-align:right;"> 2.590909 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 13 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 25 </td>
   <td style="text-align:right;"> 48 </td>
   <td style="text-align:right;"> 44 </td>
   <td style="text-align:right;"> 1.920000 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 14 </td>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> 26 </td>
   <td style="text-align:right;"> 41 </td>
   <td style="text-align:right;"> 41 </td>
   <td style="text-align:right;"> 1.576923 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 15 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 27 </td>
   <td style="text-align:right;"> 41 </td>
   <td style="text-align:right;"> 41 </td>
   <td style="text-align:right;"> 1.518519 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 16 </td>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 47 </td>
   <td style="text-align:right;"> 43 </td>
   <td style="text-align:right;"> 9.400000 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 19 </td>
   <td style="text-align:right;"> 47 </td>
   <td style="text-align:right;"> 47 </td>
   <td style="text-align:right;"> 2.473684 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 18 </td>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> 27 </td>
   <td style="text-align:right;"> 49 </td>
   <td style="text-align:right;"> 34 </td>
   <td style="text-align:right;"> 1.814815 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 19 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 25 </td>
   <td style="text-align:right;"> 56 </td>
   <td style="text-align:right;"> 37 </td>
   <td style="text-align:right;"> 2.240000 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 20 </td>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> 28 </td>
   <td style="text-align:right;"> 48 </td>
   <td style="text-align:right;"> 46 </td>
   <td style="text-align:right;"> 1.714286 </td>
  </tr>
</tbody>
</table>

</div>

### Built-in predicates

`assertr` ships with several predicate functions designed to work with `assert()`:

<table class="table table-striped table-hover" style="margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> Predicate </th>
   <th style="text-align:left;"> What it checks </th>
   <th style="text-align:left;"> Example </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> within_bounds(a, b) </td>
   <td style="text-align:left;"> Value falls within [a, b] </td>
   <td style="text-align:left;"> `within_bounds(0, 100)` </td>
  </tr>
  <tr>
   <td style="text-align:left;"> not_na </td>
   <td style="text-align:left;"> Value is not NA </td>
   <td style="text-align:left;"> `not_na` </td>
  </tr>
  <tr>
   <td style="text-align:left;"> is_uniq </td>
   <td style="text-align:left;"> Value is unique across rows </td>
   <td style="text-align:left;"> `is_uniq` </td>
  </tr>
  <tr>
   <td style="text-align:left;"> in_set(...) </td>
   <td style="text-align:left;"> Value belongs to an expected set </td>
   <td style="text-align:left;"> `in_set("A", "B", "C")` </td>
  </tr>
  <tr>
   <td style="text-align:left;"> within_n_sds(n) </td>
   <td style="text-align:left;"> Value is within n standard deviations of the mean </td>
   <td style="text-align:left;"> `within_n_sds(3)` </td>
  </tr>
  <tr>
   <td style="text-align:left;"> within_n_mads(n) </td>
   <td style="text-align:left;"> Value is within n median absolute deviations (more robust to outliers) </td>
   <td style="text-align:left;"> `within_n_mads(3)` </td>
  </tr>
</tbody>
</table>

`within_n_sds()` and `within_n_mads()` are particularly useful for flagging potential outliers without hard-coding exact bounds:


```r
# Flag any eggs_laid values more than 3 SDs from the mean
 female_egg_data_clean |>
  assert(within_n_sds(3), body_mass)
```

```
## Error in `dplyr::select()`:
## ! Can't subset columns that don't exist.
## ✖ Column `body_mass` doesn't exist.
```

```r
# within_n_mads is more robust to skewed distributions
female_egg_data_clean |>
  assert(within_n_mads(3), body_mass)
```

```
## Error in `dplyr::select()`:
## ! Can't subset columns that don't exist.
## ✖ Column `body_mass` doesn't exist.
```

### `insist()` — generate bounds from the data itself

`insist()` is like `assert()`, but the predicate is applied to a *function* of the data rather than a fixed bound. This is useful when you want to flag statistical outliers without specifying exact cutoffs in advance:


```r
# Same as within_n_sds but written through insist()
female_egg_data_clean |>
  insist(within_n_sds(3), eggs_laid)
```

```
## Error: assertr stopped execution
```

```
## Column 'eggs_laid' violates assertion 'within_n_sds(3)' 1 time
##     verb redux_fn       predicate    column index value
## 1 insist       NA within_n_sds(3) eggs_laid     1   120
```

### `assert_rows()` — check row-level conditions

Sometimes the condition is not about a single column but about a combination of values across columns in the same row. `assert_rows()` handles this. It applies a row-reduction function first, then checks the result.


```r
# Check that no row has more than 2 missing values across the numeric columns
female_egg_data_clean |>
  assert_rows(num_row_NAs, within_bounds(0, 2),
              eggs_laid, eggs_hatched, age_days, body_mass)
```

```
## Error in `dplyr::select()`:
## ! Can't subset columns that don't exist.
## ✖ Column `body_mass` doesn't exist.
```

`num_row_NAs` counts the number of NAs per row across the specified columns. You can supply your own row-reduction function — it just needs to return a single value per row.

### Chaining assertions

The real power comes from chaining multiple checks together in a single pipeline. All assertions run before any error is thrown, so you get a complete picture of what is wrong rather than having to fix one thing at a time.


```r
female_egg_data_clean %>%
  # Structural checks
  verify(ncol(.) == 7) %>% #adding %>% maggritr pipe to use (.)
  verify(nrow(.) > 0) |>
  # Column-level checks
  assert(in_set("A", "B"), treatment) |>
  assert(within_bounds(0, 135), eggs_laid) |>
  assert(within_bounds(0, 32), age_days) |>
  assert(within_bounds(0, 10), body_mass) 
```

```
## Error: assertr stopped execution
```

```
## verification [ncol(.) == 7] failed! (1 failure)
## 
##     verb redux_fn    predicate column index value
## 1 verify       NA ncol(.) == 7     NA     1    NA
```

<div class="note">
<p>The body mass column in the data contains negative values, which is
why <code>within_bounds()</code> fails. This is a good example of why
assertions are useful: they force you to make explicit decisions about
what you consider valid data.</p>
</div>

### Using `assertr` in a cleaning pipeline

The natural place for `assertr` checks is immediately after loading raw data and again after cleaning (here with the penguins dataset). This gives you confidence that:

1. The raw data is what you expect before you do anything to it
2. The cleaned data is valid before any analysis runs


```r
# ── Load and validate raw data ─────────────────────────────────────────────────
dat_raw <- read_csv(here("data", "raw", "penguins_raw.csv")) |>

  # Validate structure before touching anything
  verify(ncol(.) >= 8) |>
  assert(in_set("Adelie", "Chinstrap", "Gentoo"), species) |>
  assert(within_bounds(2500, 6500), body_mass_g) |>

# ── Clean ──────────────────────────────────────────────────────────────────────
  filter(!is.na(sex)) |>
  mutate(species = factor(species)) |>

# ── Validate cleaned data ──────────────────────────────────────────────────────
  assert(not_na, bill_length_mm, bill_depth_mm, flipper_length_mm, body_mass_g) |>
  verify(nrow(.) > 100)

cat("Data validated and cleaned:", nrow(dat_raw), "rows retained\n")
```

If this pipeline runs without error, you have documented proof that your data meets your stated expectations at the point it enters the analysis.

---

## Summary

Together, `tidylog` and `assertr` support a workflow where:

- every data manipulation step is explicitly reported
- key assumptions are tested during the pipeline
- failures are caught early and clearly explained

This combination helps ensure that analysis code is both transparent and self-validating, reducing the risk of unnoticed data issues propagating into results.
