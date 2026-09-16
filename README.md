# Epidemiology: Concepts & Methods — course website

Quarto website for the **Short Course in Epidemiology: Concepts & Methods**,
21–25 September 2026, at the Isaac Centre for Public Health, Indian Institute of
Science, Bengaluru, in collaboration with the London School of Hygiene &
Tropical Medicine, University of London.

## What is here

| Path | What |
|---|---|
| `index.qmd` | Home page |
| `schedule.qmd` | 5-day schedule (session titles still provisional) |
| `prelude/` | The 5 pre-course steps, and the 9 browser primers |
| `resources/` | Cheatsheet, troubleshooting, glossary, further reading |
| `setup/` | `install_packages.R` and `check_setup.R`, run by participants |
| `_extensions/r-wasm/live/` | quarto-live, pinned to v0.2.0 |
| `docs/PLACEHOLDERS.md` | Everything still to fill in |
| `CLAUDE.md` | Project rules, traps, and known gaps |

## The primers

9 pages that run R **inside the reader's browser** through WebR. Nothing to
install. 5 teach R; 4 teach epidemiological measures and reasoning.

Each page declares its own packages, so each downloads only what it needs: about
17 MB for a base-R page, 21 MB with tibble, 22 MB with dplyr, 37 MB with
ggplot2. Browsers cache that for 7 days, which is why the site tells
participants to open the primers at home before they travel.

## Build

```bash
quarto render
```

That is all. There is no R step: every code block is either static ```` ```r ````
or a ```` ```{webr} ```` cell that runs in the reader's browser. CI installs
Quarto only.

Preview locally with `quarto preview`. Do not open a rendered primer via
`file://` — the WebAssembly worker is blocked.

## House style

Participant-facing instructions follow `.claude/skills/playbook-instructions`.
Before committing any prose change:

```bash
bash .claude/skills/playbook-instructions/check.sh index.qmd schedule.qmd prelude/*.qmd resources/*.qmd
```

## Licence

Materials [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).
Code [MIT](https://opensource.org/licenses/MIT).

## Contact

office.msicph@iisc.ac.in
