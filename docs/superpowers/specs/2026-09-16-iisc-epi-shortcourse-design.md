# IISc Epidemiology Short Course — website design

> [!WARNING]
> **SUPERSEDED — historical record only. Do not build from this document.**
>
> This was the design approved on 2026-09-16, before the course lead cut the
> site down. Everything below describing a schedule page, downloadable
> datasets, an `R/` folder, Moodle, nine primers or Quarto is **no longer
> true**. The site now has 5 steps, 7 primers, no datasets, no schedule, no
> Quarto and no graded exercises.
>
> It is kept because it records *why* the site was built this way — the WebR
> payload budgeting and the primer design still explain decisions in the code.
> For what is actually true, read `CLAUDE.md` and `docs/PLACEHOLDERS.md`.

Date: 2026-09-16
Status: approved by Arun Mitra, 2026-09-16

## Purpose

A public course website for an Epidemiology short course at IISc Bangalore,
organised by the ISAC School of Public Health and LSHTM, UK. It carries the
pre-course work ("prelude"), nine browser-runnable primers, the schedule, and
a resources section that stays online after the course ends.

Modelled on the MedEd Conclave 2026 site
(`C:\Users\Arun\Downloads\meded-conclave-2026-site\meded-conclave-2026`),
which is a Quarto website with WebR live primers published to GitHub Pages.

## Constraints

- Learners are new to R and new to a command line. Anything that can fail on
  a venue wifi must degrade to a readable static page.
- The primers must run with nothing installed, so they use WebR via the
  `r-wasm/live` Quarto extension.
- Real course details (dates, venue, faculty, Moodle links) are not yet known.
  Every one of them is a marked placeholder, collected in one list.
- The site must not look like a recoloured copy of the MedEd site.

## Technology

| Piece | Choice | Why |
|---|---|---|
| Site generator | Quarto website, `_site` output | Same as MedEd; already proven |
| Live R | `r-wasm/live` extension, `format: live-html` | R in the browser, no install |
| Theme | `cosmo` + `styles.scss` | Bootstrap base, small custom layer |
| Hosting | GitHub Pages via `.github/workflows/publish.yml` | Free, already scripted |
| Quarto version | pinned 1.9.36 in CI | The version the extension was verified on |

Copied verbatim from the MedEd site: `_extensions/r-wasm/live/**`,
`.github/workflows/publish.yml`, `.gitignore`, `setup/check_setup.R`,
`setup/install_packages.R`. These are infrastructure, not content, and are
edited only where course-specific strings appear.

## Visual identity

Distinct from MedEd's teal/ochre. Palette:

- `$primary` deep indigo `#2c3e70`
- `$secondary` slate blue `#5b6ea8`
- `$success` `#2d6a4f`
- `$warning` warm coral `#c1543a`
- `$danger` `#9b2226`
- `$light` `#f6f7fb`

Typography and the reusable components (`.card-grid`, `.card-tile`,
`.session-meta`) follow the MedEd `styles.scss` structure so the layout code
in the pages transfers unchanged.

## Site map

```
index.qmd                     Home
schedule.qmd                  Schedule (placeholder timings)
prelude/
  index.qmd                   The checklist of 6 steps
  install.qmd                 Step 1 — R, RStudio, Quarto
  check-setup.qmd             Step 2 — packages + check script
  send-result.qmd             Step 3 — send us the result
  primers.qmd                 Step 4 — hub page for the 9 primers
  primer-r-01-objects.qmd     R1 objects, functions, vectors
  primer-r-02-tibbles.qmd     R2 tibbles and data frames
  primer-r-03-packages-pipe.qmd  R3 packages and the pipe
  primer-r-04-dplyr-verbs.qmd R4 dplyr verbs
  primer-r-05-first-plot.qmd  R5 your first plot
  primer-epi-01-frequency.qmd E1 measures of disease frequency
  primer-epi-02-association.qmd E2 measures of association
  primer-epi-03-designs.qmd   E3 study designs
  primer-epi-04-bias.qmd      E4 bias, confounding, interaction
  data.qmd                    Step 5 — download the datasets
  pre-reading.qmd             Step 6 — the reading
  r-primer.qmd                Static fallback reference for the R primers
resources/
  index.qmd                   Resources landing
  cheatsheet.qmd              R + epi formula cheatsheet
  troubleshooting.qmd         Install and WebR problems
  glossary.qmd                Epidemiology and R terms
  further-reading.qmd         Books, papers, courses
R/
  00_generate_datasets.R      Builds the teaching datasets
data/                         Generated CSVs + codebook + README
setup/                        check_setup.R, install_packages.R
```

## Teaching datasets

`R/00_generate_datasets.R` generates, with a fixed seed, three CSVs used by
both the R and the epi primers. Simulated, not real, and labelled as such:

1. `cohort_study.csv` — a prospective cohort: id, age, sex, district, exposure,
   person_years, outcome. Supports incidence, person-time, risk ratio.
2. `case_control.csv` — id, case status, exposure, age group, smoking, sex.
   Supports odds ratios and confounding by age.
3. `prevalence_survey.csv` — a cross-sectional survey: id, age, sex, district,
   urban/rural, condition, bmi, sbp. Supports prevalence and `dplyr` work.

The same three datasets carry every primer, so learners meet one set of
variables rather than nine.

## Primer design

Each primer is a standalone `live-html` page with:

- a `callout-important` at the top explaining the WebR download and the static
  fallback, copied in shape from the MedEd primers;
- short prose, then a `{{webr}}` cell, then an instruction to change something
  and rerun;
- `webr.cell-options.persist: true` and `timelimit: 30`;
- an explicit "what you should now be able to do" list at the end.

The four epi primers teach the concept and the R that computes it together: E2
introduces `table()` and a hand-built 2x2 alongside risk ratio and odds ratio,
so the statistics and the code reinforce each other.

Primers 6 to 9 assume primers 1 to 5. The hub page says so.

## Error handling and degradation

- Every primer links to `r-primer.qmd`, a static page covering the same R, for
  learners whose network blocks the WebR download.
- The epi primers additionally show every worked answer as static output, so a
  learner with no working cells still gets the teaching.
- `check_setup.R` prints a single pass/fail line the learner copies to us.
- CI pins Quarto and installs R packages explicitly; a missing package fails
  the build loudly rather than rendering a broken page.

## Placeholders

Every unknown is written as `TBD` in the page text and listed in
`docs/PLACEHOLDERS.md` with file and purpose. The list covers: course dates,
venue, daily timings, faculty names and sessions, Moodle or LMS URLs, the
pre-test link, the GitHub org/repo and therefore `site-url` and `repo-url`,
and the registration contact address.

## Out of scope

- Slides. The MedEd site has a `slides/` tree; this site does not, until the
  faculty and sessions are known.
- Day-by-day session pages. Added once the schedule is real.
- Any private or admin material.
