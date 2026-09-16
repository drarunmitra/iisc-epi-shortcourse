# -*- coding: utf-8 -*-
"""
Run every {webr} cell in every primer, in page order, in one R session.

This is the only test that runs what the reader actually runs. quarto-live
attaches the packages named in `webr: packages:` before the first cell (see
_extensions/r-wasm/live/templates/webr-setup.ojs), and every primer sets
`persist: true`, so cell N sees everything cells 1..N-1 created.

Each page builds its data once, in its first cell. An `object not found` here
means a page the reader cannot work through.

Usage:  python tools/run_cells.py
Needs:  Rscript on PATH, with the packages the primers declare.
"""
import io, os, re, subprocess, sys, tempfile

os.chdir(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
OUT = tempfile.mkdtemp(prefix="epi_cells_")

CELL = re.compile(r"```\{webr\}\n(.*?)\n```", re.S)
PKG = re.compile(r"^\s+- (\w+)$", re.M)

# Noise every tidyverse attach prints; not a failure.
NOISE = ("Warning", "masked", "Attaching", "The following", "conflict")

fails = 0
for f in sorted(os.listdir("prelude")):
    if not (f.startswith("primer-") and f.endswith(".qmd")):
        continue
    p = os.path.join("prelude", f)
    s = io.open(p, encoding="utf-8").read()
    pkgs = PKG.findall(s.split("---")[1])
    cells = [m.group(1) for m in CELL.finditer(s)]

    script = ["# quarto-live attaches every declared package before cell 1 runs",
              "suppressPackageStartupMessages({"]
    script += ["  library(%s)" % pk for pk in pkgs]
    script.append("})")
    for i, c in enumerate(cells, 1):
        script.append('\ncat("---- cell %d ----\\n")' % i)
        script.append(c)

    rf = os.path.join(OUT, "cells_%s.R" % f[:-4])
    io.open(rf, "w", encoding="utf-8").write("\n".join(script) + "\n")

    r = subprocess.run(["Rscript", rf], capture_output=True, text=True)
    bad = [l for l in r.stderr.strip().split("\n")
           if l.strip() and not any(n in l for n in NOISE)]
    ok = r.returncode == 0 and not bad
    fails += 0 if ok else 1
    print("%s %-46s %2d cells, pkgs=%s"
          % ("OK  " if ok else "FAIL", p, len(cells), pkgs or "[]"))
    for l in bad[:6]:
        print("        ", l[:140])

print("\nfailing pages:", fails)
sys.exit(1 if fails else 0)
