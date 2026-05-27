# (PART\*) Day 1:  {.unnumbered}

# Opening: why organise? {.unnumbered}




<div class="info">
<p><strong>Instructor run sheet (approximately 5 hours 25 minutes of
contact, two short breaks).</strong></p>
<table>
<thead>
<tr>
<th>Block</th>
<th>Topic</th>
<th>Time</th>
</tr>
</thead>
<tbody>
<tr>
<td>Opening</td>
<td>Framing and the running example</td>
<td>15 min</td>
</tr>
<tr>
<td>1</td>
<td>Project-based workflows</td>
<td>35 min</td>
</tr>
<tr>
<td>2</td>
<td>Getting more out of tidyverse</td>
<td>55 min</td>
</tr>
<tr>
<td></td>
<td><em>Break</em></td>
<td>10 min</td>
</tr>
<tr>
<td>3</td>
<td>Writing functions, and the first refactor</td>
<td>75 min</td>
</tr>
<tr>
<td>4</td>
<td>Iteration with <code>map</code></td>
<td>55 min</td>
</tr>
<tr>
<td></td>
<td><em>Break</em></td>
<td>10 min</td>
</tr>
<tr>
<td>5</td>
<td>Tidy evaluation and data masking</td>
<td>55 min</td>
</tr>
<tr>
<td>Closing</td>
<td>Synthesis</td>
<td>15 min</td>
</tr>
</tbody>
</table>
<p>The testing segment inside Block 3 (Block 2b in the source) is the
first thing to shorten or drop if running long. The day deliberately
stops before <code>targets</code> and pipelines; signpost these at the
close as the next step.</p>
<p>Assets the chapters reference but that are not bundled:
<code>_setup.Rmd</code> (stubbed here), the <code>images/</code>
directory, and any pre-baked <code>.RData</code>. Restore these from the
parent project before building the book.</p>
</div>

## What this day is, and is not

Most people learn R by accumulation. You needed a plot, you found code that made
one, you kept it. You needed a model, you adapted a script from a colleague. This
works, up to a point. The point at which it stops working is usually a revision:
a reviewer asks for one more species, a co-author finds an error, you return to a
project after six months and cannot rerun your own analysis.

This day is about the habits that make that revision survivable. We will move
from a single, deliberately messy analysis script to an organised, function-based
project: code in a project with relative paths, modern tidyverse for the data
work, custom functions for the analytical steps, iteration in place of
copy-paste, and functions general enough to reuse without rewriting.

Set expectations honestly. This is a great deal of structure to meet in one
sitting, and the realistic outcome is *exposure plus a reference scaffold*, not
fluency. The materials are built to be returned to. Nobody leaves able to write
tidy-evaluation functions from memory; everybody should leave knowing such things
exist, why they matter, and where to look.

## The values underneath the technique

We are not learning functions and pipelines for their own sake. We are learning
them because they make analytical code **transferable, available, documented and
annotated**: the TADA principles set out by Ivimey-Cook et al. The evidence that
this matters is not anecdotal. Across ecology and evolutionary biology, rates of
code sharing remain low, and even when code is shared it frequently fails to run:
a recent study of R code in species-distribution and abundance papers found that
the overwhelming majority of scripts did not run or ran with errors, and a review
of over 9,000 R files in one repository found that roughly three-quarters failed
to complete without error (figures collated in Ivimey-Cook et al.). Functions,
projects and tests are mechanisms for not being part of that statistic.

Three of the four TADA pillars map directly onto the day:

- **Transferable** is the project-workflow block: relative paths and `here()` so
  the code runs on a machine that is not yours.
- **Documented** is the function block: a function with a clear contract and a
  documentation comment tells the next reader what it promises.
- **Annotated** is a habit we carry throughout: chunked, commented code that says
  what it does and why.

## The running example

One dataset runs through the whole day: the Palmer penguins (Gorman, Williams &
Fraser 2014, distributed in the `palmerpenguins` package). The analytical goal is
small and concrete, so that all the attention goes on *how the code is organised*
rather than on the statistics:

> Fit a linear regression of body mass on flipper length, separately for each of
> the three penguin species. Produce a coefficient table with confidence
> intervals and a multi-panel figure.

You will see this same task four times: as three copy-pasted blocks (Block 1), as
three function calls (Block 3), as one iteration over groups (Block 4), and
finally as a single generalised function that works for any response and predictor
(Block 5). Watching one task transform is the point. Each version is more compact,
more correct, and harder to break than the last.

<div class="try">
<p><strong>Discussion to open the room (5 minutes).</strong> Think of
one analysis script you have written that you would not want a stranger,
or yourself in a year, to read. What specifically is wrong with it? Hold
that example in mind; by the close of the day you should be able to name
the techniques that would fix each problem.</p>
</div>
