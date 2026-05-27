# Closing: synthesis {.unnumbered}




*Roughly 15 minutes.*

## The arc, retraced

One analytical task ran through the whole day, and you watched it transform:

- **Block 1**: three copy-pasted blocks, with three copy-paste bugs.
- **Block 3**: one function, validated and documented, called three times.
- **Block 4**: one pipeline iterating over groups, no per-group calls at all.
- **Block 5**: one generalised function that fits any response on any predictor.

Each version was shorter than the last, and each removed a class of error rather
than a single bug. That is the through-line: organisation is not tidiness for its
own sake, it is the removal of opportunities to be wrong.

## What a finished project looks like

The pieces assembled into a conventional layout that you can carry to your own
work:

```
project.Rproj
|- data/
|   |- raw/                       # read-only source data
|   |- processed/
|- R/
|   |- functions/
|       |- modelling_functions.R  # fit_model(), tidy_model(), fit_species_model()
|       |- plotting_functions.R   # make_scatter_plot()
|- analysis.R                     # sources functions, orchestrates the analysis
|- tests/
|   |- test_modelling_functions.R
|   |- fixtures/penguins_test_subset.rds
|- outputs/
|   |- figures/
|   |- tables/
|- renv.lock                      # pinned package versions
```

The discipline that holds it together is one sentence: **functions are defined in
`R/functions/` and invoked from analysis scripts; raw data is never edited; the
environment is pinned.** Everything else is detail.

## When is this worth the overhead?

Not always. The full toolkit suits medium-to-large analyses: projects
that run for weeks or months, have a slow step or two, get revised repeatedly as
co-authors and reviewers push back, and must regenerate identically. For a one-off
descriptive analysis that runs in a minute and will never be revised, much of this
is over-engineering, and the "do not functionalise a one-line pipeline" lesson from
Block 3 applies to the whole approach. Match the machinery to the project. A test
suite for a throwaway script is as much a smell as a copy-pasted block in a
five-year project.



## What we deliberately left out

Two further steps, signposted rather than taught:

- **`targets`** turns the analysis script into a dependency-aware pipeline that
  reruns only the parts affected by a change. It is the natural next step once a
  project has a slow step you do not want to recompute on every run. The
  manual-caching pain that motivates it is exactly the "implicit ordering" problem
  from Block 1, solved properly.
- **Packaging** turns `R/functions/` into an installable package with formal
  documentation and namespacing. Worth it when functions outgrow one project and
  you want to reuse them across several.

Neither is needed to get the benefits we covered today.

## Reflection

<div class="try">
<p>Return to the script you named at the start of the day, the one you
would not want read. For each problem you identified, name the technique
from today that addresses it: a relative path, a function, a validation
check, an iteration, a test, or a generalised argument. If a problem
maps to no technique, that is worth discussing: not every problem is a
code-organisation problem, and knowing the difference is part of the
skill.</p>
</div>

The single habit to keep, if you keep only one: **the agent generates, you
verify.** Whether the code came from a colleague, a tutorial, or an AI assistant,
plausible is not the same as correct. Functions, tests and small reproducible
examples are the tools that let you check, rather than hope. That habit, more than
any particular function, is what separates ad hoc scripting from an organised
workflow.
