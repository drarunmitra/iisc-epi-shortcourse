# Project memory — Epidemiology Short Course site

## What this is
Quarto website for the **Short Course in Epidemiology: Concepts & Methods**,
21–25 September 2026, at the Isaac Centre for Public Health, Indian Institute of
Science, Bengaluru, in collaboration with the London School of Hygiene &
Tropical Medicine, University of London. Deployed to GitHub Pages.

Modelled on the MedEd Conclave 2026 site
(`C:\Users\Arun\Downloads\meded-conclave-2026-site\meded-conclave-2026`), which
is the source of the WebR primer machinery and the house writing style.

## Non-negotiables

- **R/tidyverse only.** Native pipe `|>`, never `%>%`.
- **Beginners.** Every concept gets a worked example before an exercise.
- **No downloadable datasets and no project folder.** Deliberate, at the course
  lead's instruction. Every code example builds its own data inline with
  `tibble()`. Do not reintroduce a `data/` folder, a `read_csv("data/...")`
  example, or an `epi-course-2026` project folder.
- **No Moodle, and no WhatsApp group.** Email
  (office.msicph@iisc.ac.in) is the only participant channel. A WhatsApp group
  was offered and removed on 2026-09-16 at the course lead's instruction; do not
  add a second channel back.
- **No schedule, no admissions or fees section.** Participants are already
  shortlisted, and the programme goes out separately. The site carries only:
  before you arrive, the primers, and resources.
- **All participant-facing instructions follow
  `.claude/skills/playbook-instructions`**: numbered steps, one action per step,
  an explicit **You should see:**, and, where it can fail, an **If it does not
  work:**. Reasons go in one "Why this matters" callout per page, never inside a
  step. Run
  `bash .claude/skills/playbook-instructions/check.sh <files>` before committing
  any prose change.
- **Two deliberate departures from `playbook-instructions`, both on the course
  lead's instruction (2026-09-16). CLAUDE.md wins over the skill here.**
  1. The skill's heading form is `## Step 3 of 6 - Install the packages`. On
     this site the prelude already numbers its own 5 steps, so a page titled
     "Step 1 of 5" whose last heading read "Step 5 of 5" told the reader the
     whole prelude was finished. Inner headings are therefore plain numbers:
     `## 1. Install R`. The word "Step" now means one of the 5 prelude steps
     and nothing else. Each task page says "There are N things to do on this
     page" near the top and ends with `## Step N is done`.
  2. No em-dash in any title, subtitle or heading. Use a colon. Prose em-dashes
     are fine in moderation; headings are not.
- The 7 primers are teaching pages, not task pages, so they keep prose plus
  exercises rather than the numbered-step shape. The ban list and the digit rule
  still apply to their prose. `check.sh` never scans inside a ```` ```{webr} ````
  fence, by design.
- **No graded exercises, no quizzes, no checkers.** Removed 2026-09-16 at the
  course lead's instruction. The primers keep their worked `{webr}` cells and
  the inline "change this and run it again" invitations, and nothing is marked.
  Do not add `#| exercise:`, `#| solution:` or `#| check:` blocks back.
- **No Quarto.** Removed from Step 1, from both setup scripts, and from
  Troubleshooting and the cheatsheet. `check_setup.R` has no render test.
- **No time estimates anywhere.** No `**Time:**` lines, no per-primer minutes,
  no total for the prelude. They kept going stale.

## The 7 primers

5 R primers (`primer-r-0*.qmd`, Step 3) then 2 epidemiology primers
(`primer-epi-0*.qmd`, Step 4). Primers 8 and 9, on study designs and on bias
and confounding, were written and then deleted on 2026-09-16 at the course
lead's instruction; those topics are taught in the room instead. Numbering
stays continuous, so the epidemiology pair are Primers 6 and 7. Each declares its own `format: live-html:` and its own
`webr: packages:` list, so each page downloads only what it needs.

Stated download sizes, rounded **up** from the measured figures in
`~/.claude/skills/webr-workshop/references/payload.md`:

| Page declares | Say |
|---|---|
| nothing (base R) | about 17 MB |
| tibble | about 21 MB |
| dplyr | about 22 MB |
| ggplot2 | about 37 MB |

Primer 5 is the only heavy page. Its callout says so and tells learners to open
it at home.

## The 5 steps

1. Install R and RStudio (`install.qmd`). **No Quarto**, removed 2026-09-16:
   nothing left on the site needs it, and it was the commonest install failure.
2. Install the packages (`check-setup.qmd`). 12 packages. Both scripts are
   `source()`d straight from the published site, so there is nothing to
   download and no project folder.
3. R primers (`primers-r.qmd`).
4. Epidemiology primers (`primers-epi.qmd`).
5. Additional resources (`resources/index.qmd`).

The old "send us your check result" and "do the reading" steps are gone. If you
change the count, the digit appears in `index.qmd`, `prelude/index.qmd` and in
every page subtitle ("Step N of 5").

## Build

```bash
quarto render
```

**CI needs R, and this is not obvious.** No R on this site is ever *evaluated*:
every block is either static ```` ```r ```` or a ```` ```{webr} ```` cell that
runs in the reader browser. But the 7 primers declare `engine: knitr`, and
quarto-live's `_knitr.qmd` include registers a passthrough knitr engine that
rewrites each `{webr}` block into the page, so knitr must run the document.
Drop the setup-r step and the render dies at the first primer with
`Unable to locate an installed version of R`. CI therefore installs R plus
**knitr and rmarkdown only** - never the teaching packages, which live in
`setup/install_packages.R` for participants and are never evaluated here.

The quarto-live extension is committed under `_extensions/`. If it goes missing:

    quarto add r-wasm/quarto-live@v0.2.0

The extension self-reports `0.1.3-dev` even when installed from tag `v0.2.0`.
Do not trust `quarto update` for it; re-pin with the command above.

## Traps that cost time in the MedEd build, inherited here

- **Never** put `live-html` in `_quarto.yml`'s site-wide `format:` block. In a
  website project that map applies to every format-less input, so every other
  page renders twice to the same output path, aborting the build and emptying
  `_site`.
- A primer's theme path is `../styles.scss`, not `styles.scss` — it resolves
  relative to the document, not the project root. Getting it wrong fails almost
  silently: one `WARN: Theme file not found`, and the page renders unbranded.
- Never name a work-in-progress primer with a leading underscore. Quarto
  excludes underscore-prefixed files from the project and then cannot resolve
  `_extensions/`, failing with a misleading
  `Unable to read the extension 'live'`.
- Never open a rendered primer via `file://`. The WebAssembly worker is blocked.
  Use `quarto preview`.
- **Never use `gradethis`.** 31.6 MB and 53 packages for feedback that a plain
  `#| check: true` block gives for 0 MB.

## Do not repeat library() or the data in every cell

quarto-live **installs and attaches** every package named in `webr: packages:`
before the first cell runs. See
`_extensions/r-wasm/live/templates/webr-setup.ojs`:

    webr::install(pkg, repos = repos)
    library(pkg, character.only = TRUE)

So `library(dplyr)` inside a cell is a no-op in the browser.

Cells also share one R session. quarto-live starts **one webR worker per page**,
so every cell on a page writes into the same global environment and cell N sees
what cell 1 made. This is **not** what `persist: true` does - that option saves
the learner's editor text to localStorage so a reload does not destroy their
typing. Do not cite it as the reason.

Each page therefore builds its data **once**, in its first cell, and the later
cells use it. A `callout-note` near the top tells the reader to run the cells
from the top. Primer 3 is the exception: that page teaches `library()`, and its
callout explains that the browser has already done it for you.

Before this was fixed, primer-r-04 repeated the same 12-row tibble 9 times.

**Verify with the cell harness**, which is the only test that runs what the
reader will run:

    python tools/run_cells.py

It extracts every `{webr}` cell from each primer in page order, attaches the
declared packages, and runs the lot in one R session. An `object not found`
there is a page the reader cannot work through.

## Writing exercise checks

Rules learned the hard way; full version in
`~/.claude/skills/webr-workshop/references/exercises.md`.

1. Compare values, never rendered output or code text. The single exception on
   this site is the pipe exercise in Primer 3, where the syntax *is* the lesson.
2. `fixed = TRUE` in any `grepl()` against R syntax is load-bearing. Without it
   `"|>"` is a regex meaning "empty string or >", which matches everything, and
   the exercise can never be failed.
3. Test the specific failure before the general success, or the specific branch
   is unreachable.
4. Every branch must be reachable **and** its message must be true of this data.
   Walk each branch against the numbers before shipping.
5. `identical()` is type-strict. Guard with `as.numeric()`, or use `all.equal()`
   for anything with decimals.
6. Accept every correct answer, not only the intended one.

## Known gaps flagged to the course lead

1. **There is no schedule page, deliberately.** The programme is circulated
   separately by the course office. `schedule.qmd` was written and then deleted
   at the course lead's instruction on 2026-09-16; do not recreate it, and do
   not put day-by-day themes back on the home page. The site promises no
   specific day for any topic, so keep new prose free of "on Day 3" claims.
2. **`site-url` and `repo-url` are correct and live**
   (`drarunmitra/iisc-epi-shortcourse`). The `source()` URL in
   `prelude/check-setup.qmd` depends on `site-url`; both were fetched and
   parsed successfully on 2026-09-16. If you ever move the repo, change the two
   URLs in `_quarto.yml` and the `source()` line together, and re-test the
   fetch.
3. **The primers are unverified in a browser.** A successful `quarto render`
   proves only that Quarto parsed the syntax. Serve over HTTP and load at least
   Primer 1, Primer 5 and Primer 7 before the course.
4. `setup/check_setup.R` and `setup/install_packages.R` must list the **same**
   16 packages; they drifted once (12 vs 16) and the page quoted the wrong one.
   `prelude/check-setup.qmd` says "installs 16 of them". Change all three
   together.
5. Applications closed on 25 July 2026 and the site addresses **selected
   participants**. There is no admissions or fees section. Reusing this for a
   later cohort means writing one.
6. **Faculty affiliations are only partly known.** Poppy Mallinson is LSHTM;
   Uttara Partap is Assistant Professor at IISc. The home page lists names
   without affiliations, so nothing on the site depends on this.
