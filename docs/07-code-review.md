# Day 2 Block 2: Code Review {.unnumbered}






> **Materials:** The project folder from the course OSF page (https://osf.io/jgeq9/). It contains the data files, `ANALYSIS.R`, an `old_code.R`, `celegans_analysis.Rmd` (+ rendered `.html`), and four `.jpg` figures — all in a single folder.

> **Prerequisite:** The reproducibility chapter, taught this morning. You have already cleaned this dataset and met the `9999` "not recorded" sentinel; this afternoon we review the analysis code.

<div class="info">
<p><strong>Before we start:</strong> Open <code>ANALYSIS.R</code> from
https://osf.io/jgeq9/ in RStudio and read it once through before the
session begins. This is an analysis script for the <em>C. elegans</em>
experiment from this morning — and it is the script we will review.</p>
</div>

---

## Part 1 — Why code review matters {#cr-why}

*⏱ ~15 minutes*

This morning, in the reproducibility chapter, you ran the many-analysts activity: the same *C. elegans* reproduction dataset, the same broad question, meaningfully different results across the room. That illustrated the problem of **underspecified methods** — analytical decisions that are not documented produce variable, non-transparent science. You then cleaned the raw data and built a documented project.

Code review addresses a related but distinct failure: **the code does not actually do what the analyst thinks it does**. It is possible to write a fully specified, well-documented analysis plan, implement it in R, and still have the code contain errors that silently produce wrong results. No amount of pre-registration prevents this — only someone actually reading the code can catch it.

The paper for this chapter:

> **Ivimey-Cook, E.R., Pick, J.L., Bairos-Novak, K.R., Culina, A., Gould, E., Grainger, M.J., Marshall, B.M., Moreau, D., Paquet, M., Royauté, R., Sánchez-Tójar, A., Silva, I., & Windecker, S.M. (2023).** Implementing code review in the scientific workflow: Insights from ecology and evolutionary biology. *Journal of Evolutionary Biology*, 36(10), 1347–1356. https://doi.org/10.1111/jeb.14230

Spend five minutes reading the abstract and Figure 1 now.

### Types of coding error

Errors take three forms, all of which are common:

**Conceptual** — the wrong model for the data type: Gaussian errors on offspring counts (which are non-negative integers and often overdispersed); a fixed effect where a random effect is needed; comparing models that are not comparable.

**Programmatic** — the right model implemented incorrectly: selecting columns by position rather than name; an operator-precedence slip that quietly changes which rows are analysed; a column name that breaks on a round-trip through disk.

**Syntactic** — misspelled function names, wrong argument orders. These at least cause a visible error rather than a silent wrong result.

<div class="try">
<p><strong>Opening poll</strong> <em>(type in chat)</em></p>
<p>“Have you ever found an error in your own analysis code that had
already influenced something — a figure in a draft, a number in a
report, a decision?”</p>
<p>A: Yes, in my own code B: Yes, in someone else’s code I tried to
reproduce C: Both D: Not yet, but I think it is possible</p>
<p>Keep the results visible. We will return to them.</p>
</div>

---

## Part 2 — The 4Rs framework {#cr-4rs}

*⏱ ~20 minutes*

Ivimey-Cook et al. (2023) organise what a code reviewer should evaluate around four questions — the **4Rs** (Figure 1 of the paper):

<table class="table table-striped table-hover" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:4rs-table)The 4Rs of code review (Ivimey-Cook et al. 2023, Figure 1)</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> # </th>
   <th style="text-align:left;"> R </th>
   <th style="text-align:left;"> Question </th>
   <th style="text-align:left;"> Tagline </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;font-weight: bold;"> Reported </td>
   <td style="text-align:left;"> Is the code as reported? </td>
   <td style="text-align:left;"> Methods and code must match (note in this case we are simply using the code to help us link to the methods) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;font-weight: bold;"> Run </td>
   <td style="text-align:left;"> Does the code run? </td>
   <td style="text-align:left;"> Code must be executable </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;font-weight: bold;"> Reliable </td>
   <td style="text-align:left;"> Is the code reliable? </td>
   <td style="text-align:left;"> Code runs and completes as intended </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;font-weight: bold;"> Reproducible </td>
   <td style="text-align:left;"> Are the results reproducible? </td>
   <td style="text-align:left;"> Results must be able to be reproduced </td>
  </tr>
</tbody>
</table>

### Each R in the context of `ANALYSIS.R`

**Reported.** A reviewer should be able to hold the methods section in one hand and the code in the other and verify they describe the same analysis. `ANALYSIS.R` has no header and almost no comments: a reviewer cannot tell what the intended analysis is, why one worm is dropped, or which of the three models that get fitted is meant to be *the* result. Its variable names (`block`, `total_offspring`) also drift from the data dictionary you wrote this morning (`B`, `TO`).

**Run.** Can the code be executed on a different machine, in a clean R session? `ANALYSIS.R` reads its data from an absolute OneDrive path, and lines 23–24 call `libray()` — a typo for `library()` — so the script does not even parse to the end.

**Reliable.** The hardest R. Code can run without error and still produce a wrong result every time. In `ANALYSIS.R`: an operator-precedence slip changes which worms are analysed; the `9999` "not recorded" sentinel you met this morning is never handled; and a count outcome is fitted with a Gaussian model. None of these throw an error.

**Reproducible.** Given the same data and code, does re-running produce the reported outputs? `ANALYSIS.R` fits three models, designates none of them as the answer, saves no model output to disk, and writes a figure called `final2.jpg` — the "2" hinting at undocumented earlier versions.

<div class="try">
<p><strong>Activity: map <code>ANALYSIS.R</code> to the 4Rs (5
minutes)</strong></p>
<p>Open <code>ANALYSIS.R</code>. Without running it, type into the chat
one specific example for each R:</p>
<ul>
<li><strong>Reported:</strong> Something a reader could not understand
without asking the author</li>
<li><strong>Run:</strong> Something that would stop it running on your
machine right now</li>
<li><strong>Reliable:</strong> Something that could produce a silently
wrong result</li>
<li><strong>Reproducible:</strong> Something that would prevent
recovering the reported numbers</li>
</ul>
</div>

---

## Part 3 — Performing a structured code review {#cr-manual}

*⏱ ~50 minutes*

### The script to review

`ANALYSIS.R` from https://osf.io/jgeq9/ is a **real** analysis script for the *C. elegans* strain × diet experiment — the same experiment you cleaned this morning. It is reproduced here for reference:


``` r
library(lme4)
library(lmerTest)
library(tidyverse)
library(ggplot2)
library(dplyr)
library(tidyr)
library(lubridate)
library(stringr)
library(rvest)
library(readr)
library(knitr)
library("data.table")
library(gplots)
library(ggridges)
library(shiny)
library(lme4)
library(rpart)
library(caret)
library(randomForest)
library(glmnet)
library("xgboost")
library("plotly")
libray(tidyverse)
libray(hablar)

dat1 = read.csv("~/Library/CloudStorage/OneDrive-UniversityofGlasgow/AllFiles/Other Projects/Workshops/REPROCODE_ANALYSIS/celegans_raw.csv")

dat1$block <-  as.numeric(dat1$block)
dat1$worm_id <- as.numeric(dat1$worm_id)
dat1$total_offspring <- as.numeric(dat1$total_offspring)

dat2 <- pivot_longer(dat1, cols = 3:5, names_to = "strain", values_to = "total offspring") %>% filter(worm_id != 5)

full.dat <- dat2[complete.cases(dat2$`total offspring`), ]

write.csv(full.dat, file = "~/Library/CloudStorage/OneDrive-UniversityofGlasgow/AllFiles/Other Projects/Workshops/REPROCODE_ANALYSIS/celegans_datafinal.csv", row.names = F)

full_dat = read.csv("~/Library/CloudStorage/OneDrive-UniversityofGlasgow/AllFiles/Other Projects/Workshops/REPROCODE_ANALYSIS/celegans_datafinal.csv")

summary(full_dat)

plot(as.factor(full_dat$strain), full_dat$total_offspring)

full_dat <- full_dat %>%
  convert(fct(worm_id, block, strain, diet)) %>%
  filter(strain == "daf" | strain == "empty_vector" & !is.na(diet)) %>%
  mutate(total_offspring = as.numeric(total_offspring))

m1a <- lmer(total_offspring ~
              + strain
            + diet
            + (1|block),
            data = full_dat)
summary(m1a)

m1b <- lmer(total_offspring ~
              strain * diet
            + (1|block),
            data = full_dat)
summary(m1b)

m1c <- lm(total_offspring ~
            + strain * diet,
          data = full_dat)
summary(m1c)

anova(m1a, m1b, m1c)

Na <- full_dat[complete.cases(full_dat$strain), ]

ggplot(data = Na, aes(x = as.factor(strain), y = total_offspring, colour = as.factor(diet))) +
  theme_bw() +
  geom_jitter(alpha = 0.3) +
  geom_smooth(linetype = "dotted", method = "lm", colour = "black", fill = "light grey") +
  stat_summary(fun.data = "mean_cl_boot", geom = "errorbar", shape = 0, width = 0.8) +
  stat_summary(fun.data = "mean_cl_boot", geom = "point", shape = 0, width = 0.8) +
  labs(x = "Strain", y = "Total Offspring", colour = "Diet")

ggsave(filename = "final2.jpg", path = "~/Library/CloudStorage/OneDrive-UniversityofGlasgow/AllFiles/Other Projects/Workshops/REPROCODE_ANALYSIS/", dpi = 300, device = "jpg")
```

<div class="note">
<p><strong>A bridge from this morning.</strong> <code>ANALYSIS.R</code>
analyses the same experiment as the reproducibility chapter, but its
author used different names: <code>block</code> for <code>B</code>, and
<code>total_offspring</code> for <code>TO</code>. That drift between
code and data dictionary is itself a small <em>Reported</em> problem —
but to keep the review readable we use the script’s own names below.</p>
</div>

<div class="try">
<p><strong>Step 1: First read (3 minutes)</strong></p>
<p>Read the script end to end without annotating. Ask yourself:</p>
<ul>
<li>What does this script try to do?</li>
<li>What is the intended analysis?</li>
<li>What immediately strikes you as wrong?</li>
<li>Could the style be improved? (e.g. would using Air or styler help,
see Extra Material, Addins intro to R)</li>
</ul>
<p>Then move to the checklist.</p>
</div>

### The 4Rs review checklist

Work through the script systematically. Record ✅ Pass / ❌ Fail / ⚠️ Unclear for each item, and write one sentence describing the issue.

<table class="table table-striped table-hover" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:review-checklist)4Rs review checklist for ANALYSIS.R</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> R </th>
   <th style="text-align:left;"> Review item </th>
   <th style="text-align:left;"> Verdict </th>
   <th style="text-align:left;"> Note (one sentence) </th>
  </tr>
 </thead>
<tbody>
  <tr grouplength="5"><td colspan="4" style="border-bottom: 1px solid;"><strong>Reported</strong></td></tr>
<tr>
   <td style="text-align:left;padding-left: 2em;" indentlevel="1"> Reported </td>
   <td style="text-align:left;"> Could a reader tell what the intended analysis is, without asking the author? </td>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;padding-left: 2em;" indentlevel="1"> Reported </td>
   <td style="text-align:left;"> Is the worm_id != 5 exclusion described and justified? </td>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;padding-left: 2em;" indentlevel="1"> Reported </td>
   <td style="text-align:left;"> Is it stated which of m1a / m1b / m1c is the reported model? </td>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;padding-left: 2em;" indentlevel="1"> Reported </td>
   <td style="text-align:left;"> Do the variable names match the project's data dictionary? </td>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;padding-left: 2em;" indentlevel="1"> Reported </td>
   <td style="text-align:left;"> Are packages documented with version numbers anywhere? </td>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr grouplength="4"><td colspan="4" style="border-bottom: 1px solid;"><strong>Run</strong></td></tr>
<tr>
   <td style="text-align:left;padding-left: 2em;" indentlevel="1"> Run </td>
   <td style="text-align:left;"> Does the script use absolute file paths? </td>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;padding-left: 2em;" indentlevel="1"> Run </td>
   <td style="text-align:left;"> Would the script parse and run on a clean machine in a fresh session? </td>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;padding-left: 2em;" indentlevel="1"> Run </td>
   <td style="text-align:left;"> Are all loaded packages actually used, and all function calls spelled correctly? </td>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;padding-left: 2em;" indentlevel="1"> Run </td>
   <td style="text-align:left;"> Is there a README explaining how to set up and run the project? </td>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr grouplength="6"><td colspan="4" style="border-bottom: 1px solid;"><strong>Reliable</strong></td></tr>
<tr>
   <td style="text-align:left;padding-left: 2em;" indentlevel="1"> Reliable </td>
   <td style="text-align:left;"> Is the analysis sample selected with correct use of filter arguments? </td>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;padding-left: 2em;" indentlevel="1"> Reliable </td>
   <td style="text-align:left;"> Are data columns selected by name rather than by position? </td>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;padding-left: 2em;" indentlevel="1"> Reliable </td>
   <td style="text-align:left;"> Is the 9999 'not recorded' sentinel handled before modelling? </td>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;padding-left: 2em;" indentlevel="1"> Reliable </td>
   <td style="text-align:left;"> Is total_offspring (a count) modelled with an appropriate distribution? </td>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;padding-left: 2em;" indentlevel="1"> Reliable </td>
   <td style="text-align:left;"> Does anova() compare models that are actually comparable? </td>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;padding-left: 2em;" indentlevel="1"> Reliable </td>
   <td style="text-align:left;"> Are model diagnostics (residuals, singularity) checked anywhere? </td>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr grouplength="4"><td colspan="4" style="border-bottom: 1px solid;"><strong>Reproducible</strong></td></tr>
<tr>
   <td style="text-align:left;padding-left: 2em;" indentlevel="1"> Reproducible </td>
   <td style="text-align:left;"> Is it unambiguous which model's results are the reported result? </td>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;padding-left: 2em;" indentlevel="1"> Reproducible </td>
   <td style="text-align:left;"> Are model outputs saved to disk, or only printed to the console? </td>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;padding-left: 2em;" indentlevel="1"> Reproducible </td>
   <td style="text-align:left;"> Is the saved figure named meaningfully and reproducibly? </td>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;padding-left: 2em;" indentlevel="1"> Reproducible </td>
   <td style="text-align:left;"> Is sessionInfo() called, or renv used? </td>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;">  </td>
  </tr>
</tbody>
</table>

<div class="try">
<p><strong>Step 2: Complete the checklist (15 minutes)</strong></p>
<p>Work through <code>ANALYSIS.R</code> against every item. Record your
verdict and a one-sentence note.</p>
<p>Then type into the chat:</p>
<ul>
<li>Your verdict for the three items you think are most
consequential</li>
<li>One issue you found that is not on the checklist</li>
</ul>
</div>

### The problems — revealed

<table class="table table-striped table-hover" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:problems-table)Issues in ANALYSIS.R</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> # </th>
   <th style="text-align:left;"> R </th>
   <th style="text-align:left;"> Lines </th>
   <th style="text-align:left;"> Issue </th>
   <th style="text-align:left;"> Severity </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> P1 </td>
   <td style="text-align:left;"> Run </td>
   <td style="text-align:left;"> 23–24 </td>
   <td style="text-align:left;"> libray(tidyverse) and libray(hablar) are typos for library(). R throws 'could not find function libray' and execution stops here. (library(lme4) is also loaded twice — lines 1 and 16.) </td>
   <td style="text-align:left;"> Critical </td>
  </tr>
  <tr>
   <td style="text-align:left;"> P2 </td>
   <td style="text-align:left;"> Run </td>
   <td style="text-align:left;"> 26, 36, 38, 79 </td>
   <td style="text-align:left;"> Absolute OneDrive paths in read.csv(), write.csv(), the re-read, and ggsave(). The script only runs on the original author's machine. </td>
   <td style="text-align:left;"> Critical </td>
  </tr>
  <tr>
   <td style="text-align:left;"> P3 </td>
   <td style="text-align:left;"> Run / Reported </td>
   <td style="text-align:left;"> 1–24 </td>
   <td style="text-align:left;"> About 22 library() calls, the great majority unused (xgboost, glmnet, caret, randomForest, rpart, rvest, shiny, plotly, gplots, ggridges, ...). Slows loading, hides the real dependencies, and any one missing package aborts the script. No versions recorded. </td>
   <td style="text-align:left;"> High </td>
  </tr>
  <tr>
   <td style="text-align:left;"> P4 </td>
   <td style="text-align:left;"> Reliable </td>
   <td style="text-align:left;"> 46 </td>
   <td style="text-align:left;"> Operator-precedence bug. filter(strain == 'daf' | strain == 'empty_vector' &amp; !is.na(diet)): &amp; binds tighter than |, so this keeps daf OR (empty_vector AND diet recorded). daf worms with missing diet slip through; the intended grouping needs parentheses. </td>
   <td style="text-align:left;"> Critical </td>
  </tr>
  <tr>
   <td style="text-align:left;"> P5 </td>
   <td style="text-align:left;"> Reliable </td>
   <td style="text-align:left;"> 32, 36–38, 42 </td>
   <td style="text-align:left;"> values_to = 'total offspring' creates a column name with a space. After write.csv() then read.csv() (lines 36–38) it becomes total.offspring, so full_dat$total_offspring on lines 42 and 47 silently returns NULL. </td>
   <td style="text-align:left;"> Critical </td>
  </tr>
  <tr>
   <td style="text-align:left;"> P6 </td>
   <td style="text-align:left;"> Reliable </td>
   <td style="text-align:left;"> 32 </td>
   <td style="text-align:left;"> pivot_longer(cols = 3:5) selects columns by position. If the column order ever changes, the wrong columns are reshaped — with no error. </td>
   <td style="text-align:left;"> High </td>
  </tr>
  <tr>
   <td style="text-align:left;"> P7 </td>
   <td style="text-align:left;"> Reliable / Reported </td>
   <td style="text-align:left;"> 32 </td>
   <td style="text-align:left;"> filter(worm_id != 5) silently drops one worm with no comment, reason, or logged count. </td>
   <td style="text-align:left;"> High </td>
  </tr>
  <tr>
   <td style="text-align:left;"> P8 </td>
   <td style="text-align:left;"> Reliable </td>
   <td style="text-align:left;"> 34 </td>
   <td style="text-align:left;"> complete.cases() on 'total offspring' removes only NA. It does NOT handle the 9999 'not recorded' sentinel from the raw data (reproducibility chapter): 9999s enter the models as real offspring counts of 9999. </td>
   <td style="text-align:left;"> Critical </td>
  </tr>
  <tr>
   <td style="text-align:left;"> P9 </td>
   <td style="text-align:left;"> Reliable </td>
   <td style="text-align:left;"> 67 </td>
   <td style="text-align:left;"> anova(m1a, m1b, m1c) compares two lmer models and an lm in one call. The mixed models are REML-fitted, so a likelihood-ratio test of different fixed effects is invalid, and mixing model classes is meaningless. </td>
   <td style="text-align:left;"> Critical </td>
  </tr>
  <tr>
   <td style="text-align:left;"> P10 </td>
   <td style="text-align:left;"> Reliable </td>
   <td style="text-align:left;"> 49–65 </td>
   <td style="text-align:left;"> total_offspring is a count, but all three models are Gaussian (lmer / lm). A count GLMM (Poisson or negative binomial) is not considered; no residual or distributional checks. </td>
   <td style="text-align:left;"> High </td>
  </tr>
  <tr>
   <td style="text-align:left;"> P11 </td>
   <td style="text-align:left;"> Reliable </td>
   <td style="text-align:left;"> 71–77 </td>
   <td style="text-align:left;"> geom_smooth(method = 'lm') is drawn over a categorical x (as.factor(strain)) — a regression line through factor levels is meaningless. stat_summary(..., shape = 0) passes shape to an errorbar geom that ignores it. </td>
   <td style="text-align:left;"> Medium </td>
  </tr>
  <tr>
   <td style="text-align:left;"> P12 </td>
   <td style="text-align:left;"> Reproducible </td>
   <td style="text-align:left;"> 49–67, 79 </td>
   <td style="text-align:left;"> Three models are fitted but none is designated as the result and no model output is saved to disk. The figure is saved as final2.jpg (the '2' implies undocumented earlier versions). No sessionInfo(), no renv, no versions; full.dat / full_dat / Na are confusingly similar names. </td>
   <td style="text-align:left;"> Medium </td>
  </tr>
</tbody>
</table>

**P1, P4, and P8 are the most consequential.** P1 means the script does not even run to the end — the `libray` typo halts it before any analysis happens. But fixing the typo does not make the script correct. P4 is the dangerous one: the precedence slip silently changes *which worms are in the analysis*, and the code looks perfectly reasonable. P8 is the direct callback to this morning — `complete.cases()` removes `NA`, but `9999` is a number, not `NA`, so every "not recorded" worm enters the models as if it produced 9,999 offspring, wrecking every group mean. None of P4, P8, P10 or P12 throws an error: the script (once it runs) produces numbers, and the numbers are wrong.

<div class="try">
<p><strong>Step 3: Write the review (12 minutes)</strong></p>
<p>Write a structured code review of <code>ANALYSIS.R</code> as if
emailing it to the author. Be kind but direct. Organise by R, reference
line numbers, and suggest a concrete fix for each issue.</p>
<p>CODE REVIEW: ANALYSIS.R Reviewer: [your name] | Date: [today] |
Approx. time: [X] minutes</p>
<p>SUMMARY [2 sentences: overall impression, most important finding]</p>
<p>REPORTED - Line [X]: …</p>
<p>RUN - Line [X]: …</p>
<p>RELIABLE - Line [X]: …</p>
<p>REPRODUCIBLE - Line [X]: …</p>
<p>RECOMMENDATION [ ] Ready to submit [ ] Minor revision [ ] Major
revision required</p>
<p>When done, paste your SUMMARY and your RECOMMENDATION into the
chat.</p>
</div>

<div class="info">
<p><strong>Debrief (5 minutes):</strong></p>
<ol style="list-style-type: decimal">
<li><p>Did everyone identify P8 (the 9999 sentinel)? This is the same
lesson as this morning — and the error with the largest effect on the
result — yet the code runs without complaint. What does that say about
automatic testing vs human review?</p></li>
<li><p>Did anyone give “ready to submit”? P4 and P8 together mean the
analysis is not just poorly documented — its central estimate is
numerically wrong. Would this have passed peer review as
written?</p></li>
<li><p>P12 (which of the three models is the answer?) — is there any way
a journal reviewer reading only the paper would catch this without
seeing the code?</p></li>
</ol>
</div>

---

## Part 4 — Fixing the script {#cr-fixing}

*⏱ ~25 minutes*

Finding the problems is only half of code review; the point is to fix them. The good news is that the fix is not exotic. Most of the twelve problems disappear once the script is rewritten as a **plain, linear, well-commented analysis** — relative paths, a documented sample, the sentinel handled, one model fitted and saved deliberately. You do not need clever abstractions or a pile of custom functions to make code reviewable. A flat script that a reviewer can read top to bottom is usually the easiest thing to check.

### A corrected version

Here is `ANALYSIS.R` rewritten. It also slots into the project structure you built this morning: the cleaning happens in `01_data_cleaning.R`, so this script reads the cleaned file and only *analyses*. Each numbered section names the problems (P1–P12) it resolves, and it uses the documented data-dictionary names (`TO`, `B`).


``` r
# analysis/02_analysis.R  -- corrected analysis script
# Author:  [your name]
# Date:    [today]
# Purpose: C. elegans total-offspring analysis -- daf-2 RNAi x diet
#
# Input:   data/processed/celegans_clean.csv   (produced by 01_data_cleaning.R)
# Output:  results/model_summary.csv
#          figures/offspring_by_strain.png
#          results/sessionInfo.txt
#
# Pre-specified model (see osf.io/jgeq9/):
#   TO ~ strain * diet + (1 | B)        TO = total offspring (a count)

# -- Packages: load only what is used --------------------------------- fixes P1, P3
library(tidyverse)    # readr, dplyr, ggplot2
library(lme4)         # glmer.nb
library(broom.mixed)  # tidy() for mixed models
library(here)         # project-relative paths -- fixes P2

# -- 1. Load the cleaned data ----------------------------------------- fixes P2, P8
# Cleaning -- including dropping the 9999 "not recorded" sentinel -- is done
# in 01_data_cleaning.R. This script only analyses; it never re-cleans.
dat <- read_csv(here("data", "processed", "celegans_clean.csv"),
                show_col_types = FALSE) |>
  mutate(
    strain = factor(strain, levels = c("empty_vector", "daf")),
    diet      = factor(diet),
    B         = factor(B)
  )

# -- 2. Select the analysis sample ------------------------------------ fixes P4, P7
# Keep the two strains of interest AND require diet to be recorded.
# The parentheses are the fix for P4: the original wrote
#   strain == "daf" | strain == "empty_vector" & !is.na(diet)
# which R reads as  daf | (empty_vector & diet recorded)  -- not the intent.
dat <- dat |>
  filter(strain %in% c("empty_vector", "daf") & !is.na(diet))

# -- 3. Fit ONE pre-specified model ----------------------------------- fixes P9, P10
# TO is a count, so a Gaussian lmer is the wrong family. Fit one
# negative-binomial GLMM (handles the overdispersion typical of brood
# counts) and report it -- no comparing across model classes.
m <- glmer.nb(TO ~ strain * diet + (1 | B), data = dat)

# -- 4. Diagnostics --------------------------------------------------- fixes P10
plot(m)                                   # residuals vs fitted
if (isSingular(m)) warning("Model is singular -- check the block random effect.")

# -- 5. Save the reported model --------------------------------------- fixes P12
write_csv(tidy(m, conf.int = TRUE),
          here("results", "model_summary.csv"))

# -- 6. Figure: categorical x, so show data + group means ------------- fixes P11
p <- ggplot(dat, aes(x = strain, y = TO, colour = diet)) +
  geom_jitter(width = 0.15, alpha = 0.3) +
  stat_summary(fun.data = mean_se, geom = "errorbar", width = 0.3) +
  stat_summary(fun = mean, geom = "point", size = 3) +
  labs(x = "strain (RNAi)", y = "Total offspring", colour = "Diet") +
  theme_classic()

ggsave(here("figures", "offspring_by_strain.png"), p,
       width = 7, height = 5, dpi = 300)

# -- 7. Record the computational environment -------------------------- fixes P12
writeLines(capture.output(sessionInfo()),
           here("results", "sessionInfo.txt"))
```

<div class="note">
<p>Notice what this rewrite does <em>not</em> do: it does not wrap every
step in a bespoke function. For a script this size, a flat sequence of
clearly commented blocks is easier to review than a set of custom
functions, because the reviewer sees exactly what happens, in order,
with nothing hidden behind a call. Reach for a function only when you
genuinely repeat a block three or more times.</p>
</div>

<div class="try">
<p><strong>Activity: map the fix to the problems (10
minutes)</strong></p>
<p>Working from the corrected script above and the P1–P12 table:</p>
<ol style="list-style-type: decimal">
<li>For each numbered section (1–7), name which problems it fixes. Two
of the twelve are <em>not</em> fixed by this script — which two, and
why? (Hint: both belong to the raw-data reshaping).</li>
<li>Section 1 of the corrected script reads
<code>celegans_clean.csv</code> instead of re-cleaning the raw file. How
does separating cleaning (<code>01_data_cleaning.R</code>) from analysis
(<code>02_analysis.R</code>) make <em>both</em> scripts easier to
review?</li>
<li>The corrected script fits one model and saves it. What did we lose
by dropping <code>m1a</code>/<code>m1b</code>/<code>m1c</code>, and is
that a loss worth accepting?</li>
</ol>
<p>Type your answers into the chat.</p>
</div>

### Tidy the project, not just the script

`ANALYSIS.R` reads its data from one folder and writes its outputs back to the same folder. Look at what is actually *in* that folder on the OSF page: the data files, `ANALYSIS.R`, an `old_code.R`, `celegans_analysis.Rmd` and its rendered `.html`, and four loose `.jpg` figures — everything in one flat directory.

That is exactly the messy structure you saw at the start of the reproducibility chapter, and exactly what the TADA folder structure fixes. Three things a reviewer should flag:

- **`old_code.R` should not be there.** It is a superseded earlier version. Dead code left in the project root invites a collaborator to run the wrong script. Move it to an `archive/` folder, or delete it — version control already remembers it.
- **The four `.jpg` figures are loose.** Generated outputs belong in `figures/`, produced by the code, not committed by hand next to the scripts.
- **There is no README.** You built one this morning, in the reproducibility chapter; that same `README.md` belongs in the project root here — it is what lets a reviewer answer the *Reported* questions at all.

Re-using the structure you created in the reproducibility chapter — `data/raw`, `data/processed`, `analysis/`, `figures/`, `results/` — makes the project navigable and makes the *Run* check ("can I tell which script to run, and in what order?") answerable at a glance.

### Reviewing the whole archive: the SORTEE stages

The 4Rs are a lens for reviewing a *script*. The SORTEE Guidelines (Pick et al. 2026) provide the complementary lens for reviewing a whole *archive* — the data, the code and the metadata together — as six ordered **Stages of Review**:

<table class="table table-striped table-hover" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:sortee-stages)The six SORTEE Stages of Review (Pick, et al. 2026)</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Stage </th>
   <th style="text-align:left;"> Stage of review </th>
   <th style="text-align:left;"> Goal it serves </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;font-weight: bold;"> 1 </td>
   <td style="text-align:left;"> Data are archived and adhere to the FAIR principles </td>
   <td style="text-align:left;"> Data re-use </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;"> 2 </td>
   <td style="text-align:left;"> Archived data correspond to the data reported in the manuscript </td>
   <td style="text-align:left;"> Data re-use </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;"> 3 </td>
   <td style="text-align:left;"> Code is archived and adheres to the FAIR principles </td>
   <td style="text-align:left;"> Transparency </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;"> 4 </td>
   <td style="text-align:left;"> Archived code corresponds to the workflow reported in the manuscript </td>
   <td style="text-align:left;"> Transparency </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;"> 5 </td>
   <td style="text-align:left;"> Archived code runs with the archived data </td>
   <td style="text-align:left;"> Reproducibility </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;"> 6 </td>
   <td style="text-align:left;"> Results can be computationally reproduced by running the code </td>
   <td style="text-align:left;"> Reproducibility </td>
  </tr>
</tbody>
</table>

The stages build on each other: Stages 1–2 deliver **data re-use**, Stages 1–4 deliver **transparency**, and all six together deliver **full computational reproducibility**.

**DCQC** — the SORTEE Data and Code Quality Control Shiny app (https://github.com/SORTEE/DCQC) — does **not** check anything automatically. It is a structured walk-through: it takes a reviewer (a journal data editor, or you, reviewing your own archive before submission) through these six stages in order, recording the outcome of each. Think of it as the counterpart, for the whole data-and-code package, of the 4Rs checklist you used on the script.

<div class="info">
<p><strong>What no tool can do for you.</strong> DCQC
<em>structures</em> the review; it does not pass judgement. Stage 5
(“does the code run?”) and Stage 6 (“do the results reproduce?”) still
require <em>you</em> to run the code. And the 4Rs <em>Reliable</em>
question — does the code do what the analyst intended? — is the one
neither DCQC nor Copilot can answer. That is the human reading you did
in Part 3.</p>
</div>

---

## Part 5 — Building the review habit {#cr-habit}

*⏱ ~10 minutes*

### Setting up a code review group

Most code review never happens because no one organises it. Ivimey-Cook et al. (2023) — drawing on their experience building SORTEE's peer code review club — distilled five practical considerations for getting a group off the ground. They aren't novel, but they're the ones that decide whether a group survives past meeting three or quietly dies.

1. **Start collaborating early.** Review works best when it's continuous, not a one-off pre-submission check. Build in regular sessions from project kickoff and use GitHub issues or pull requests to anchor discussion to specific lines rather than vague impressions.
2. **Set a clear goal for each session.** "Learn together" and "find the bug in my analysis before I submit" need different time, different reviewers and different rules. Decide which one you're doing before people show up.
3. **Normalise errors and make it judgement-free.** There is no such thing as bad code (Barnes 2010) and there are usually multiple defensible ways to solve the same problem (Silberzahn et al. 2018; Gould et al. 2023). The fastest way to kill a group is to let it become a place where the most confident voice rewrites everyone else's style.
4. **Mind the group size.** Small (even 1-on-1) is better for focused review of specific code; larger groups work for general principles and discussion. Pick on purpose.
5. **Think about credit up front.** A reviewer who catches a meaningful bug deserves more than a thank-you — MeRIT acknowledgement (Nakagawa et al. 2023) or co-authorship where the fix changes the conclusions. Agree the default *before* the first review, not after.

<div class="try">
<p><strong>Plan your group</strong> <em>(~5 min — type in chat)</em></p>
<p>Without overthinking it, commit to specifics on the following five
questions. Two-line answers are fine — the point is to write them down,
because <em>“we should review each other’s code”</em> without specifics
is a sentence that ages badly.</p>
<ol style="list-style-type: decimal">
<li><strong>Who</strong> — name 2–4 people you’d actually invite in the
next month.</li>
<li><strong>What</strong> — readability/learning, or pre-submission
error-checking? (Pick one for the first meeting.)</li>
<li><strong>When and where</strong> — cadence and platform (in-person,
Zoom, async via GitHub).</li>
<li><strong>First case</strong> — whose code goes first, and what’s the
explicit scope of that review (which of the four Rs)?</li>
<li><strong>Credit</strong> — what’s your default acknowledgement, and
what triggers escalating to MeRIT or co-authorship?</li>
</ol>
<p>When you’ve written your five, post the one you’re least sure about
and we’ll workshop it briefly as a group.</p>
</div>

### Online lab culture

For groups working entirely online, the **pull request** model on GitHub provides the most practical structure for code review. The author opens a PR, writes a description explaining what the code does and why, and requests review. The reviewer comments on specific lines. Nothing merges until approved. We cover this in the GitHub session tomorrow.

<div class="try">
<p><strong>Closing reflection</strong> <em>(type in chat)</em></p>
<p>Return to the opening poll. Has anyone’s answer changed?</p>
<p>Then: “Based on <code>ANALYSIS.R</code> — which of the 12 problems is
most likely to appear in code from your own field? Why?”</p>
<p>And: “The one change I will make to my workflow before my next
submission is…”</p>
</div>

## Glossary

<table class="table table-striped table-hover" style="margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> Term </th>
   <th style="text-align:left;"> Definition </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 4Rs </td>
   <td style="text-align:left;"> Reported, Run, Reliable, Reproducible — evaluation criteria for code review (Ivimey-Cook et al. 2023) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Reported </td>
   <td style="text-align:left;"> Code matches the methods; packages and versions documented </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Run </td>
   <td style="text-align:left;"> Code executes from a clean session on any machine </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Reliable </td>
   <td style="text-align:left;"> Code does what the author intended; no silent errors </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Reproducible </td>
   <td style="text-align:left;"> Running the code produces the outputs stated in the paper </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Operator precedence </td>
   <td style="text-align:left;"> The order R applies operators; &amp; binds tighter than |, so a | b &amp; c means a | (b &amp; c) — a frequent source of silent filter() bugs </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Sentinel value </td>
   <td style="text-align:left;"> A number used to encode a special meaning (e.g. 9999 = 'not recorded'); must be handled before any model is fitted </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Count GLMM </td>
   <td style="text-align:left;"> A generalised linear mixed model for count outcomes (Poisson or negative binomial); appropriate for offspring counts, unlike a Gaussian lmer </td>
  </tr>
  <tr>
   <td style="text-align:left;"> isSingular() </td>
   <td style="text-align:left;"> lme4 function checking whether a model has converged to a singular fit (random-effect variance ~ 0) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> SORTEE Stages of Review </td>
   <td style="text-align:left;"> The SORTEE Guidelines' six-stage framework for reviewing an archive, from data archiving (Stage 1) to computational reproducibility (Stage 6) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> DCQC </td>
   <td style="text-align:left;"> SORTEE Data and Code Quality Control Shiny app; a structured walk-through of the six SORTEE Stages of Review — it organises a review, it does not automate one </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Pull request </td>
   <td style="text-align:left;"> GitHub mechanism for proposing changes; a natural structure for code review in online collaborative groups </td>
  </tr>
</tbody>
</table>

---

## Reading

- **Ivimey-Cook, E.R., et al. (2023).** Implementing code review in the scientific workflow. *Journal of Evolutionary Biology*, 36, 1347–1356. https://doi.org/10.1111/jeb.14230
- **Ivimey-Cook, E.R., et al. (2025).** TADA! https://doi.org/10.32942/X2D93K
- **Pick, J.L., et al. (2026).** SORTEE Guidelines. https://doi.org/10.24072/pcjournal.687
- **Gould, E., et al. (2023).** Same data, different analysts. *EcoEvoRxiv*. https://doi.org/10.32942/X2BP4S
- **Trisovic, A., et al. (2022).** A large-scale study on research code quality and execution. *Scientific Data*. https://doi.org/10.1038/s41597-022-01143-6
- **SORTEE DCQC app:** https://github.com/SORTEE/DCQC
- **Course OSF page:** https://osf.io/jgeq9/ — `ANALYSIS.R` is the script reviewed in this chapter
