# (PART\*) Day 1 

# Day 1 Block 1: Project-based workflows {.unnumbered}




The single most common reason a shared script fails on someone else's computer is
a file path. A line like `read.csv("C:/Users/me/thesis/data/penguins.csv")` is a
statement about *your* machine, not about the analysis. The fix is to make the
project, not your home directory, the centre of the universe.

## Why a project

An RStudio (or Positron) project is a folder with an `.Rproj` marker file. Opening
it does two useful things automatically: it sets the working directory to the
project folder, and it points the file browser there. Every path you write can
then be relative to the project root, which means the project can be zipped,
shared, or moved to another operating system and still run without editing a
single path.

To create one: **File &rarr; New Project &rarr; New Directory &rarr; New Project**,
name it, and click **Create Project**. RStudio leaves an `.Rproj` file in the
folder. Double-clicking that file opens a fresh session pointed at the project.

<div class="figure" style="text-align: center">
<img src="images/project.png" alt="A typical R project layout" width="80%" />
<p class="caption">(\#fig:unnamed-chunk-2)A typical R project layout</p>
</div>

## Absolute versus relative paths

An **absolute path** spells out the full location from the root of the disk:

```
/home/your-username/project/data/raw/penguins.csv
```

It breaks the moment anyone else opens your code, because nobody else has your
directory structure. A **relative path** is relative to the project root, so it
travels with the project:

```
data/raw/penguins.csv
```

## A sensible layout

Organise each project into its own folder with a predictable structure. The
convention we follow all day:

```
my-project.Rproj
|- data/
|   |- raw/          # read-only; never edited by code
|   |- processed/    # outputs of cleaning
|- R/
|   |- functions/    # function definitions only
|- scripts/          # or numbered analysis scripts in R/
|- outputs/
|   |- figures/
|   |- tables/
```

The principle that does the most work here is *raw data is read-only*. Cleaning
scripts read from `data/raw/` and write to `data/processed/`; they never overwrite
the original. If a clean goes wrong, the source of truth is untouched.

## The `here` package

Even inside a project, paths written with `/` or `\\` can behave differently
across operating systems, and they break if you run code from a subdirectory.
`here::here()` builds a path from the project root regardless of where the code is
called from or which operating system runs it.


```r
# Fragile: relative to wherever the session happens to sit
raw_data <- readr::read_csv("data/raw/penguins.csv")

# Robust: built from the project root every time
library(here)
raw_data <- readr::read_csv(here("data", "raw", "penguins.csv"))
```

`here()` finds the root by looking for the `.Rproj` file (or a `.here` file), so
it does not depend on the working directory. We recommend using an RStudio project
*and* `here()` together. Either alone helps; both together is robust.

<div class="info">
<p>Further reading on <code>here</code>: the package’s own rationale at
<a href="https://github.com/jennybc/here_here"
class="uri">https://github.com/jennybc/here_here</a> sets out the
argument better than we can here. The short version: a path is part of
your code, and code should not assume it knows where it lives.</p>
</div>

### Activity: de-path a script

<div class="panel panel-default"><div class="panel-heading"> Task </div><div class="panel-body"> 

Below is the opening of a script written without a project. Rewrite it so it would
run unchanged on a colleague's machine. You should change two things: the working
directory line, and the path.
 </div></div>


```r
setwd("/Users/sam/Documents/penguin_thesis/")

penguins_raw <- read.csv("/Users/sam/Documents/penguin_thesis/data/raw/penguins.csv")
```

<button id="displayTextunnamed-chunk-7" onclick="javascript:toggle('unnamed-chunk-7');">Show Solution</button>

<div id="toggleTextunnamed-chunk-7" style="display: none"><div class="panel panel-default"><div class="panel-heading panel-heading1"> Solution </div><div class="panel-body">

```r
# No setwd() at all: open the project instead, which sets the directory for you.
library(here)
library(tidyverse)

penguins_raw <- readr::read_csv(here("data", "raw", "penguins.csv"))
```

The `setwd()` line is deleted entirely, not replaced. Working directory is the
project's job, not the script's. The path is rebuilt from the project root with
`here()`, so it no longer mentions any user or machine.
tidyverse contains the `readr` package which has `read_csv()`, so we load it here. We could load `readr` directly if we wanted, but `tidyverse` is a common choice for data analysis and it includes `readr`, so we go with that.
</div></div></div>

## Blank slates

A clean analysis should not depend on hidden state left over from a previous
session: a package you attached by hand, an object you created interactively, an
option you set and forgot. Many scripts open with `rm(list = ls())` in an attempt
to start clean, but this is a weak guarantee. It removes user-created objects but
does **not** detach packages, reset options, or change the working directory. The
session is still contaminated.

The reliable habit is to **restart R** (Session &rarr; Restart R, or
`Ctrl/Cmd+Shift+F10`) and rerun the script from the top. If the analysis only runs
correctly from a fresh session, it is reproducible; if it needs objects that exist
only because of something you did by hand earlier, you find out immediately rather
than six months later. Treat the script, not the workspace, as the record of what
you did.

<div class="try">
<p>Turn off workspace saving so a stale <code>.RData</code> never loads
silently. In Tools → Global Options → General, set “Save workspace to
.RData on exit” to <strong>Never</strong>, and untick “Restore .RData
into workspace at startup”. Now every session starts blank, and the only
way to recreate your objects is to run your code.</p>
</div>

## `renv`: pinning package versions

A project that runs today can break next year if a package changes its behaviour.
`renv` records the exact package versions a project uses, in a project-local
library, so the environment can be reconstructed later or on another machine.


```r
# Once per project: create a project-local library and record current versions
renv::init()

# Install into the project library (not the global one)
renv::install("dplyr")

# After installing or updating anything, record the new state
renv::snapshot()

# On another machine, or after things break, rebuild the recorded environment
renv::restore()
```

`renv::status()` reports whether the lockfile and the library agree.

`renv.lock` records only packages actually loaded in the project, so it captures
what you use rather than everything installed.

<div class="info">
<p><code>renv</code> is a large step towards reproducibility, not a
complete guarantee. It records, but does not by itself reinstall, the R
version you used (though the version is noted in
<code>renv.lock</code>). For stronger guarantees, tools such as
<code>rig</code> (switching R versions) or Docker (capturing the whole
environment) exist, but they are beyond today’s scope. For most analysis
projects, a project plus <code>here()</code> plus <code>renv</code> is
enough.</p>
</div>

### Activity: initialise a project environment

<div class="panel panel-default"><div class="panel-heading"> Task </div><div class="panel-body"> 

In a fresh project, run `renv::init()`, then `renv::install("janitor")`, then
`renv::snapshot()`. Open `renv.lock` in a text editor and find the entry for
`janitor`. What information is recorded about it, and why would a collaborator need
that exact information to reproduce your analysis?
 </div></div>

<div class="info">
<p><strong>Where this leaves us.</strong> We now have a project that
runs anywhere, reads its data by relative path, starts from a blank
slate, and pins its package versions. That is the foundation. Everything
from here assumes you are working inside such a project. The rest of the
day fills it with well-organised analytical code.</p>
</div>
