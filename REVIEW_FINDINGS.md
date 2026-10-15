# Open issues after the final wording pass (2026-10-15)

The earlier review (about 330 items) has been fixed. These were found during the final wording pass. They need a content decision or a check, not a wording fix, so they have **not** been changed. Each one was flagged by a review agent and has not yet been checked by hand.

## Likely errors (quick to fix)

| Chapter | Issue | Suggested fix |
|---|---|---|
| 01 | "Setting up a new project" task: step 4 "Click Create Project" comes before step 5 "Give it a name". | Swap the steps. |
| 03 | "A function's behaviour depends only on its arguments" — the example just above has `fn()` reading the global `x`. | Qualify it ("should depend only on…"). |
| 03 | The "Argument order" task asks for the three calls that the code block above already shows. | Remove the code or change the task. |
| 07 | Barnes 2010 and Nakagawa et al. 2023 are cited in Part 5 but missing from the Reading list. | Add both. |
| 07 | "Wrecking every group mean": only three worms have TO = 9999, so not every strain × diet group is affected. | "wrecking the means of the groups they fall in". |
| 07 | Says the messy folder was "at the start of the reproducibility chapter"; it is in Part 4 of 06. | "in Part 4 of the reproducibility chapter". |
| 08c | The Ugly-Off rescue uses "the three questions from Block 5", which learners have not seen yet (they come at the end of Day 3). | Replace with a short criterion (e.g. "every point visible, readable labels, accessible colours"). |
| 08d | "`&` applies to every subplot, including those added later": `&` only affects subplots already in the composition. | Delete "including those added later". |
| 08d | The prose describes `geom_text_repel()`; the code uses `geom_label_repel()`. | Align them. |
| 08d | The guides callout explains how to fix duplicate legends, but its demo shows the un-fixed case without saying so. | Add one sentence, or show the fix. |
| 09 | "a chunk label carrying the correct prefix (… `sec-` for sections)": section ids go on headings, not chunks. | Reword. |
| 10a | The Pages callout says Part 2 keeps the published page current "on every push", but Part 2 only uploads an artefact. | Point to the commit-back section instead. |
| 10a | Says "Under **Artefacts**"; GitHub's UI label is "Artifacts". | Use the UI spelling. |
| 11d | Says run the exercises in Browser Chat, then later says Positron/VS Code users may use either. | Pick one. |
| 12-gt | The text says `group_name_col()` and `.fn`; the code uses `groupname_col` and `fn`. Also says "your cleaned penguins from Day One", but the chapter loads `files/chapter5.RData`. | Align the text with the code. |
| 12a | Inline code says `flipper_length` and `body_mass`; the columns are `flipper_length_mm` and `body_mass_g`. The last task asks for a theme that its solution does not add. | Fix the names; add the theme. |
| 12b | Says a fixed colour goes in the geom "as only `aes` is inherited". The real reason is that constants go outside `aes()`. | Reword. |
| r-basics | Saving the workspace is given as Tools > Project Options; it is usually Tools > Global Options. | Check and fix. |

## Needs a decision

| Chapter | Issue |
|---|---|
| 06 | Gould et al. (2025) is described as using "the same EcoEvo dataset". The study used two datasets (blue tit and *Eucalyptus*). "Some analyses were better documented than others" could not be confirmed against the paper. |
| 06 | "The execution rate has not budged": no cited study tracks this over time, so it is the authors' inference. Keep it, label it as such, or cut it. |
| 08 | The categorical ranking (hue second, shape third) is credited to Cleveland & McGill (1984); it comes from Mackinlay (1986). Cleveland & McGill only tested quantitative judgements. |
| 08 / 08e | The timetable lists Block 6 (figure legends) and Block 7 (three questions), but there is no Block 6 chapter, and "three questions" sits inside the Block 5 file. |
| 08e | `ggview` is cited as "(Domin, 2025)", with no reference-list entry. The claim that the RStudio viewer "renders at 72 dpi" is questionable. |
| 11 / 11h | Block 1 promises that Block 8 uses the cloud agent ("RStudio users should follow the cloud-agent material… the focus of Block 8"), but 11h's paths are by hand, an in-IDE agent and a conceptual skill. RStudio users therefore have no agent path in Block 8. |
| 11f | "From here on, everyone works the same way", but Part B then explains how skills differ by surface. |
| 11g | Item 3 of the prompt checklist ("This measurably changes output toward specificity") has no source. Item 4 says the uncertainty instruction "surfaces P8"; the debrief credits a separate "9999" rule. |
| 03 | Filazzola & Lortie (2022) is cited as plain text, with no bibliography key. |
| working_with_large_data | The SQLite database is read from `data/portal_mammals.sqlite`, but the chapter has no download link for it. |

## Heading style (optional)

Headings were deliberately not edited, because changing them breaks links. Suggested tidy-ups:

- Mixed Title Case and sentence case: 09 (e.g. "The Problem with Traditional Workflows"), 12b ("Choosing Effective Palettes", "Nested Facets"), 01 ("Build a Project Structure").
- Em dashes in "Part N — …" and "Step N — …" headings (06, 07, 10a, 11g, 11h); a colon would match the rest of the book.
- 09: "A critical wrinkle: …". 11b: the title "AI - Inline completions" does not follow the other block titles. 10: the emoji bullet list (🔢 Data, ✍️ Scripts).
