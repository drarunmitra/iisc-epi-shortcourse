# Placeholders

**There are none left.** Every `[TBD: ...]{.tbd}` marker has been resolved and
the yellow-highlight style is now unused on every page. If you add a new
unknown, mark it `[TBD: what is missing]{.tbd}` so it ships visibly, and list it
here.

Check with:

```bash
grep -rn "TBD" --include="*.qmd" .
```

## Resolved

| What | Resolved to |
|---|---|
| GitHub org and repo | `drarunmitra/iisc-epi-shortcourse`, live and deploying. `site-url` and `repo-url` in `_quarto.yml` match. |
| The two `source()` URLs | `prelude/check-setup.qmd` and `resources/troubleshooting.qmd` point at the live `setup/` scripts. Both fetch and parse; verified 2026-09-16. |
| Poppy's full name | Poppy Mallinson. |
| WhatsApp group link | Removed. Email is the only participant channel. |
| Session titles and faculty assignments | No longer on the site. The programme is circulated separately. |

## Confirmed — do not change without a source

- Course title: Short Course in Epidemiology: Concepts & Methods
- Organiser: Isaac Centre for Public Health, Indian Institute of Science, Bengaluru
- Collaborator: London School of Hygiene & Tropical Medicine, University of London
- Dates: 21–25 September 2026
- Venue: IISc, Bengaluru
- Applications closed 25 July 2026; participants already shortlisted
- Contact: office.msicph@iisc.ac.in
- Faculty, all 6 names confirmed: Neil Pearce, Prabhdeep Kaur, Poppy Mallinson,
  Arun Mitra, Manikandanesan Sakthivel ("Nesan"), Uttara Partap.
  Affiliations known so far: Poppy Mallinson is LSHTM; Uttara Partap is
  Assistant Professor at IISc, **not** LSHTM as first assumed. The site lists
  names without affiliations, so nothing on the page depends on this.

## Deliberately absent

- **No downloadable datasets, and no project folder.** Every example builds its
  own data inline. Do not add a `data/` folder back.
- **No Moodle and no WhatsApp.** Email is the only participant channel.
- **No schedule page, and no admissions or fees section.** Participants are
  already shortlisted and the programme is circulated separately. Do not
  recreate `schedule.qmd` or put day-by-day themes back on the home page, and
  keep new prose free of "on Day 3" claims.
- **No slides, and no day-by-day session pages.**
