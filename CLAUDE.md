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
- Exercises use quarto-live's native hint and solution buttons, never a
  collapsed `callout-tip` holding a duplicate answer.

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
runs in the reader browser. But the 9 primers declare `engine: knitr`, and
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
3. **`site-url` and `repo-url` in `_quarto.yml` are guesses**
   (`drarunmitra/iisc-epi-shortcourse`). The `source()` URLs in
   `prelude/check-setup.qmd` and `resources/troubleshooting.qmd` depend on
   `site-url` being right. Fix all of them together.
4. **The primers are unverified in a browser.** A successful `quarto render`
   proves only that Quarto parsed the syntax. Serve over HTTP and load at least
   Primer 1, Primer 5 and Primer 9 before the course.
5. `setup/check_setup.R` is the single definition of the package list.
   `prelude/check-setup.qmd` mirrors its count (12). If you add a package,
   change `check_setup.R` first, then `install_packages.R`, then the digit in
   the page prose.
6. Applications closed on 25 July 2026 and the site is written for **selected
   participants**, not applicants. If it is ever reused for a later cohort, the
   admissions section of `index.qmd` needs rewriting first.
