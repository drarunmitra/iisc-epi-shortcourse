---
name: playbook-instructions
description: Use when writing or rewriting any instruction a workshop participant will follow - website pages, Moodle activity text, emails, handouts. Converts prose instructions into numbered procedures with explicit success criteria, in plain Indian English, for readers who are not programmers.
---

## When to use / when not to use

Use this skill for any text a workshop participant reads and then does
something as a result: website pages under `prelude/`, `day1/`, `day2/`,
`resources/`, `index.qmd`; Moodle activity text, announcements and the
feedback form; invitation and reminder emails.

Do not use it for:

- Reveal.js slides (`slides/*.qmd`). Slides are spoken over, not read alone.
- R source (`R/**`, `setup/**`).
- `{webr}` cells or `#| exercise` / `#| check` / `#| solution` blocks in the
  interactive primers.
- Moodle XML question banks (`moodle/questions/**`).
- YAML front matter, except a `title:` or `subtitle:` change a task
  explicitly names.

## The page shape

Every task page opens with exactly three lines before the first step:

- **Time:** how long it takes.
- **Before you start:** what must already be done.
- **When you finish:** what you will have.

Then numbered steps. Nothing else above the first step.

## The step shape

- Heading form: `## Step 3 of 6 — Install the packages`.
- One action per step. A step containing two verbs is split into two steps.
- Every step ends with **You should see:** and the literal expected result.
- Every step that can fail ends with **If it does not work:** and one fix or
  one link.

## Where reasoning goes

Reasoning goes in a single "Why this matters" callout at the top or bottom of
the page. Never inside a step. A step contains an instruction and its
result.

## Words

- Short sentences. One idea per sentence. Active voice.
- No jokes, metaphors, idioms or rhetorical questions.
- Ban list (literal strings to remove): "make tea", "you have won", "on
  Tuesdays", "the room that actually turns up", "lies to you", "when the
  words have referents", "break them on purpose", "and that is the point".
- Banned intensifiers: "simply", "just", "obviously", "of course", "merely",
  "clearly".
- Indian English usage: "tick the box", "press Enter", "type this", "switch
  on". Not "hit", "grab", "fire up", "spin up".
- Interface text in bold, exactly as it appears on screen:
  **File → New Project → New Directory**.
- Digits, not words, for any countable quantity: "16 packages", not
  "sixteen".
- Second person singular. "You", never "one" or "participants".

**The digit rule governs instructions, not example academic prose.** "16
packages, not sixteen" applies to text telling the reader what to do or
what to expect. It does not apply inside example academic prose being
modelled for the reader — an abstract, a Methods section, a demo
manuscript the reader is meant to copy or study as a model of correct
academic writing. Academic convention there spells out numbers under ten
and avoids starting a sentence with a numeral; a workshop that teaches
people to write papers has to model that convention in its own examples,
not the instruction-prose digit rule. When a page has both (instructions
in playbook style, and an example document quoted or reproduced inside
it), only the instructions are subject to the digit rule.

Mark an intentional exception with a `style-exempt` marker rather than
leaving `check.sh` red or silently rewriting example prose into the wrong
register:

```
<!-- style-exempt: <reason> -->
```

The marker exempts its own line, or the line immediately after it, from
all four `check.sh` categories — and if that following line opens a
fenced code block, the exemption covers the whole block (an HTML comment
placed *inside* a fence renders as visible literal text, so a marker that
needs to reach content mid-fence has to sit on the line before the fence
opens instead). The reason after the colon is mandatory; an empty reason
suppresses nothing. Place the marker so it stays invisible on the
rendered page — outside any fence, never inside one — and check
`grep -rn "style-exempt" _site/` after rendering to confirm.

**The exemption is a line range, not a one-off tag on a phrase.** When the
marker sits before a fence, it silently covers every line from the fence's
opening delimiter through its matching closing delimiter — the whole
block, not just the line that originally needed it. If you later edit
content inside a fence that already carries a marker, re-check whether the
marker's reason still applies to what you changed: an edit can introduce
ordinary instruction prose into a block that was only ever exempted for
its original example text, and `check.sh` will not catch that, because the
whole range is already suppressed.

Run `check.sh` on every file you touch. It greps for the ban list above and
for spelled-out counts. It only reports file and line; it never edits a
file. A hit on "just" or "clearly" is not automatically wrong — judge it —
but every hit must be looked at. `check.sh` catches a banned phrase split
across one line break by a hard wrap, but not across two or more - an exit
0 means no known-shaped hit was found, not a guarantee the prose is clean,
so still skim what you wrote.

## The rewrite procedure

1. List every action the current page asks the reader to take.
2. Split any action containing two verbs.
3. Number them. Write `## Step N of M — <verb phrase>`.
4. For each step, write the literal expected result under
   **You should see:**.
5. For each step that can fail, write one fix under
   **If it does not work:**.
6. Move every "why" sentence into one callout.
7. Delete every joke, aside and metaphor.
8. Check every number against its source file.
9. Run `check.sh` on the file.

## What never to touch

- `{webr}` cells.
- `#| exercise`, `#| check`, `#| solution` blocks.
- `R/**`.
- `setup/**`.
- `moodle/questions/**`.
- YAML front matter (except a `title:`/`subtitle:` change a task explicitly
  names).

`check.sh` does not scan inside a ```` ```{webr} ```` fence at all -
including the `#| check: true` grader messages, which are ordinary R string
literals that happen to sit inside that fence. That content is on this
list, so a style hit there is never a defect to fix and never something to
argue into a `style-exempt`: it is out of scope for the checker by design,
the same way `R/**` and `moodle/questions/**` are. Do not add a
`style-exempt` marker to silence a hit inside a `{webr}` fence - there is
nothing to silence there.
