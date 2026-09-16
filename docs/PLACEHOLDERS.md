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
| Session titles, all 5 days | `schedule.qmd` | The day themes are inferred from the course title. Replace with the real programme. |
| Faculty against each session | `schedule.qmd` | The faculty list is confirmed; who teaches what is not. |
| Faculty affiliations | `index.qmd` | Neil Pearce and Uttara Partap are listed as LSHTM; Prabhdeep Kaur, Arun Mitra and Manikandanesan Sakthivel as ICPH/IISc. Confirm. |
| Day themes table | `index.qmd` | Same caveat as the schedule. |
| Daily start and end times | `schedule.qmd` | 09:00 to 17:00 is assumed. |

## Confirmed from the course announcement — do not change without a source

- Course title: Short Course in Epidemiology: Concepts & Methods
- Organiser: Isaac Centre for Public Health, Indian Institute of Science, Bengaluru
- Collaborator: London School of Hygiene & Tropical Medicine, University of London
- Dates: 21–25 September 2026
- Venue: IISc, Bengaluru
- Applications closed: 25 July 2026
- Fees: Rs 5,000 students, Rs 10,000 professionals
- Contact: office.msicph@iisc.ac.in
- Faculty named: Neil Pearce, Prabhdeep Kaur, Arun Mitra, Manikandanesan Sakthivel, Uttara Partap

## Deliberately absent

- **No downloadable datasets, and no project folder.** Every example builds its
  own data inline. Do not add a `data/` folder back.
- **No Moodle.** Email and WhatsApp only.
- **No slides.** Add a `slides/` tree once sessions and owners are fixed.
- **No day-by-day session pages.** Add once the schedule is real.
