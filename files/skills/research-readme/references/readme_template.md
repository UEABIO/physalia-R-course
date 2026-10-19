# {{TITLE}}

{{DOI_BADGE}} {{LICENCE_BADGE}}

## Description

{{DESCRIPTION}}

## Abstract

{{ABSTRACT}}

## Instructions

This repository contains the code and data accompanying the manuscript above.
To reproduce the analysis:

1. Obtain the data as described under *Data files*.
2. Set up the R environment as described under *Dependencies*.
3. Run the scripts in the order given under *Scripts*.

## Authors

| Name | ORCID | Affiliation |
|------|-------|-------------|
{{AUTHOR_ROWS}}

### Funding

{{FUNDING}}

## Data files

{{PER_FILE_SECTIONS}}

<!--
Each data file is rendered as:

### `<filename>`

Collected: <dates> at <locations>.

| Column | Type | Missing | Range / values | Description | Unit |
|--------|------|---------|----------------|-------------|------|
| ...    | ...  | ...     | ...            | ...         | ...  |

Type is the class readr assigns. Range is min to max for numeric columns,
or a count of distinct values otherwise.
-->

## Scripts

Run in this order:

| Order | Script | Description |
|-------|--------|-------------|
{{SCRIPT_ROWS}}

## Dependencies

{{DEPENDENCIES}}

## Open questions

{{OPEN_QUESTIONS}}

## AI declaration

{{AI_DECLARATION}}
