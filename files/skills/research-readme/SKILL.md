---
name: research-readme
description: >-
  Writes a README.md for a research repository whose code and data accompany
  a paper. Use when asked to write a README for an analysis project, document
  a repository for a paper, or prepare code for journal submission or
  archiving (Zenodo, Figshare, OSF). Not for general software READMEs and not
  for auditing code.
disable-model-invocation: true
---

# Research README generator

Produces one README.md for a repository of R code and data that accompanies a
manuscript, including the metadata that journals and archives expect:
persistent identifiers, ORCIDs, funding, per-variable descriptions with units,
an explicit script run order, and a dependency record.

## Operating constraints
These hold for the whole conversation unless the user explicitly withdraws
them.
1. The only file you create or overwrite is README.md. Do not edit, rename or
   delete any other file. If you notice an apparent error in code or data,
   record it under "Open questions" in the README or report it in chat, and
   leave the file untouched.
2. Do not fabricate metadata. DOIs, ORCIDs, grant numbers, collection dates,
   units and affiliations come from the user or from a file the user points to.
   If a value is unknown, insert a placeholder (see Placeholders).
3. Automatic summaries describe; they do not interpret. Report column type,
   missing count and range. Do not state what a variable means, its unit, or
   whether a value is plausible.
4. Work conversationally and write the file directly; do not build an app.

## Before executing
Present a short numbered plan: the folder to be scanned, that only README.md
will be written, and the six stages below. Wait for the user to confirm.

## Stage 1: Project information
Collect title, abstract, DOIs (paper; archived code and data), licences,
authors with ORCIDs and affiliations, and funders with grant numbers. Read
these from CITATION.cff, codemeta.json or DESCRIPTION if present, and ask only
for what is missing. Pair each author with their own ORCID and affiliation. If
no code licence is supplied, flag it prominently and use a placeholder; do not
choose a licence for the user.

## Stage 2: Files and variable summaries
List the data and code files. For CSV files, run
describe_project_csvs() from scripts/describe_csv.R and use its output as a
scaffold. Ask the user for each column's description and unit, and for
collection dates and locations per data file. List other tabular formats
(.xlsx, .tsv) and ask the user to describe their columns by hand. Never infer
units from column names.

## Stage 3: Script order
List executable files (.R, .Rmd, .qmd). Propose a run order using numeric
prefixes (01_, 02_) as the first signal, and ask the user to confirm or
reorder; the user's order is authoritative. Collect a one-line description of
each script. Do not run any script to determine the order.

## Stage 4: R packages and versions
Run print_lockfile() from scripts/scan_packages.R.
- If a lockfile exists, the Dependencies section states the R version, says
  that versions are pinned in renv.lock, gives the restore command
  renv::restore(), and includes the package table.
- If no lockfile exists, the Dependencies section states that package versions
  were not recorded, and contains the placeholder from print_lockfile(). Do not
  guess versions or scan the installed library.

## Stage 5: Assemble, preview and reader-test
Fill references/readme_template.md. Show the rendered Markdown in chat. Then
read it as a newcomer who has only the repository and the paper: could they
find the data, restore the environment, run the scripts in order and
understand every variable? List any section still holding a placeholder. On
confirmation, write README.md to the project root.

## Stage 6: Check the README against its sources
Compare the README with its sources: the R and package
versions against read_lockfile(), every numbered script against the scripts
folder, and every unit against the user's answers. Report the number of
placeholders left.

## AI declaration
State that an AI assisted in generating this README, naming the model if the
user wishes, with the date. Make no claims about AI use elsewhere in the
project unless the user states them, and then record exactly what they state.

## Placeholders
Write every unknown value as a visible placeholder, in exactly this form:
**TODO: supply [field]: not provided**
Flag a missing code licence and a missing code or data DOI as blocking for
submission, but still write the file so the user has a working draft.

## Scope
This skill does not audit code quality or reproducibility, and does not
produce figures. If asked to do either mid-run, say so and stop that part of
the request.

## References
- Ivimey-Cook, E.R. et al. (2023) Implementing code review in the scientific
  workflow. Journal of Evolutionary Biology 36(10), 1347–1356.
- Ivimey-Cook, E.R. et al. (2025) TADA! Simple guidelines to improve
  analytical code sharing for transparency and reproducibility. EcoEvoRxiv.
