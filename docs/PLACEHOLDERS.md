# Placeholders to fill in before the site goes out

Every item below is marked in the source with `[TBD: ...]{.tbd}`, which renders
with a yellow highlight so nothing ships unnoticed. Search the repo for `TBD`
to find them all.

## Blocking — the site is wrong without these

| What | File | Note |
|---|---|---|
| GitHub org and repo | `_quarto.yml` (`site-url`, `repo-url`, the navbar GitHub link) | Currently guessed as `drarunmitra/iisc-epi-shortcourse`. |
| The two `source()` URLs | `prelude/check-setup.qmd`, `resources/troubleshooting.qmd` | These must match `site-url` exactly, or Step 2 fails for every participant. |
| WhatsApp group link | `prelude/index.qmd`, `prelude/send-result.qmd`, `resources/index.qmd`, `resources/troubleshooting.qmd` | 4 places. |

## Provisional — confirmed in outline, not in detail

| What | File | Note |
|---|---|---|
| Poppy's full name | `index.qmd` | The other 5 faculty are spelled out from the course announcement. Poppy was given as a first name only. |

## Confirmed from the course announcement — do not change without a source

- Course title: Short Course in Epidemiology: Concepts & Methods
- Organiser: Isaac Centre for Public Health, Indian Institute of Science, Bengaluru
- Collaborator: London School of Hygiene & Tropical Medicine, University of London
- Dates: 21–25 September 2026
- Venue: IISc, Bengaluru
- Applications closed: 25 July 2026; participants already shortlisted
- Contact: office.msicph@iisc.ac.in
- Faculty: Neil, Prabhdeep, Poppy, Arun, Nesan (Manikandanesan Sakthivel), Uttara

## Deliberately absent

- **No downloadable datasets, and no project folder.** Every example builds its
  own data inline. Do not add a `data/` folder back.
- **No Moodle.** Email and WhatsApp only.
- **No schedule page, and no admissions or fees section.** Participants are
  already shortlisted and the programme is circulated separately. Do not
  recreate `schedule.qmd` or put day-by-day themes back on the home page.
- **No slides, and no day-by-day session pages.**
