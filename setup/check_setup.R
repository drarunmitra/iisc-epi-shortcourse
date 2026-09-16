# check_setup.R ---------------------------------------------------------------
# Short Course in Epidemiology: Concepts & Methods
# Isaac Centre for Public Health, IISc Bengaluru, with LSHTM, University of London
# 21-25 September 2026
#
# Verifies that a participant's laptop is ready for the course.
#
# Usage:  source("setup/check_setup.R")
# Send the full console output to office.msicph@iisc.ac.in if any line starts
# with a cross.
# -----------------------------------------------------------------------------

ok   <- function(msg) cat("✔", msg, "\n")
bad  <- function(msg) cat("✖", msg, "\n")
warn <- function(msg) cat("!", msg, "\n")
rule <- function(title = "") {
  cat("\n── ", title, " ",
      strrep("─", max(0, 62 - nchar(title))), "\n", sep = "")
}

rule("Epidemiology Short Course 2026 · setup check")

# 1. R version ----------------------------------------------------------------
r_ok <- getRversion() >= "4.1.0"
if (r_ok) {
  ok(sprintf("%s (need >= 4.1.0)", R.version.string))
} else {
  bad(sprintf("%s is too old. Install the current R from https://cran.r-project.org",
              R.version.string))
}

# 2. Native pipe --------------------------------------------------------------
# The course uses |> throughout. It arrived in R 4.1.0, so this doubles as a
# second, behavioural check on the version above.
pipe_ok <- tryCatch({
  eval(parse(text = "c(1, 2, 3) |> sum()")) == 6
}, error = function(e) FALSE)

if (isTRUE(pipe_ok)) ok("Native pipe |> works") else
  bad("Native pipe |> not available - your R is older than 4.1.0")

# 3. RStudio ------------------------------------------------------------------
# A missing rstudioapi looks exactly like "not in RStudio" unless we say so.
if (!requireNamespace("rstudioapi", quietly = TRUE)) {
  warn("Cannot read the RStudio version - run install.packages('rstudioapi')")
} else if (rstudioapi::isAvailable()) {
  ok(paste("RStudio", rstudioapi::versionInfo()$version))
} else {
  warn("Not running inside RStudio (fine if you use another editor)")
}

# 4. Quarto -------------------------------------------------------------------
# quarto::quarto_version() fails when the quarto R package is missing, even
# though Quarto itself is installed. Ask the command line before saying so.
quarto_pkg <- requireNamespace("quarto", quietly = TRUE)

quarto_ver <- if (quarto_pkg) {
  tryCatch(as.character(quarto::quarto_version()), error = function(e) NA_character_)
} else {
  NA_character_
}

if (is.na(quarto_ver)) {
  quarto_ver <- tryCatch({
    v <- suppressWarnings(
      system("quarto --version", intern = TRUE, ignore.stderr = TRUE)
    )
    if (length(v) > 0 && nzchar(v[[1]])) trimws(v[[1]]) else NA_character_
  }, error = function(e) NA_character_)
}

if (!is.na(quarto_ver) && quarto_pkg) {
  ok(paste("Quarto", quarto_ver))
} else if (!is.na(quarto_ver)) {
  bad(sprintf("Quarto %s is installed, but the quarto R package is not. Run install.packages('quarto')",
              quarto_ver))
} else {
  bad("Quarto not found. Install from https://quarto.org/docs/get-started/ , then restart your computer, then run install.packages('quarto')")
}

# 5. Packages -----------------------------------------------------------------
required <- c(
  "tidyverse", "dplyr", "ggplot2", "readr", "tidyr",
  "here", "janitor", "gtsummary", "gt", "broom",
  "epitools", "quarto", "knitr", "rmarkdown", "scales"
)
installed <- required[required %in% rownames(installed.packages())]
missing   <- setdiff(required, installed)

if (length(missing) == 0) {
  ok(sprintf("All %d required packages installed", length(required)))
} else {
  bad(sprintf("%d package(s) missing: %s",
              length(missing), paste(missing, collapse = ", ")))
  cat("   Fix with:  install.packages(c(",
      paste0('"', missing, '"', collapse = ", "), "))\n", sep = "")
}

# 6. Can we actually load the core stack? -------------------------------------
load_ok <- suppressWarnings(suppressMessages(
  tryCatch({
    library(dplyr);   library(ggplot2)
    library(readr);   library(gtsummary)
    library(epitools)
    TRUE
  }, error = function(e) FALSE)
))
if (load_ok) ok("Core packages load cleanly") else
  bad("A core package failed to load - see the error above")

# 7. An epidemiological calculation actually runs -----------------------------
# Installing epitools is not the same as epitools working. Compute a risk ratio
# from a known 2x2 and check the number, so a broken install fails here rather
# than in front of the class.
#
# epitools expects the table with the unexposed row first and the non-case
# column first, so the matrix below is
#         no outcome   outcome
#   unexposed   85        15
#   exposed     70        30
# giving a risk ratio of (30/100) / (15/100) = 2.
epi_ok <- tryCatch({
  tab <- matrix(c(85, 15, 70, 30), nrow = 2, byrow = TRUE)
  rr  <- epitools::riskratio(tab, method = "wald")$measure[2, 1]
  isTRUE(all.equal(as.numeric(round(rr, 3)), 2))
}, error = function(e) FALSE)
if (isTRUE(epi_ok)) ok("epitools computes a risk ratio correctly") else
  bad("epitools is installed but did not return the expected risk ratio")

# 8. Writable working directory -----------------------------------------------
write_ok <- tryCatch({
  tmp <- file.path(getwd(), ".epi_write_test")
  writeLines("test", tmp); file.remove(tmp); TRUE
}, error = function(e) FALSE)
if (write_ok) {
  ok(sprintf("Project directory writable (%s)", basename(getwd())))
} else {
  bad(sprintf("Cannot write to %s - move your project out of a restricted or cloud-synced folder",
              getwd()))
}

# 9. End-to-end render --------------------------------------------------------
render_ok <- FALSE
if (!is.na(quarto_ver) && quarto_pkg) {
  render_ok <- tryCatch({
    tmpdir <- tempfile("qtest"); dir.create(tmpdir)
    qmd <- file.path(tmpdir, "test.qmd")
    writeLines(c(
      "---", "title: Render test", "format: html", "---", "",
      "```{r}", "library(ggplot2)",
      "ggplot(mtcars, aes(wt, mpg)) + geom_point()", "```"
    ), qmd)
    quarto::quarto_render(qmd, quiet = TRUE)
    file.exists(file.path(tmpdir, "test.html"))
  }, error = function(e) FALSE)
}
if (render_ok) ok("Test render (HTML) succeeded") else
  bad("Test render failed - Quarto and R are installed but not co-operating")

# Verdict ---------------------------------------------------------------------
rule()
all_good <- r_ok && isTRUE(pipe_ok) && length(missing) == 0 &&
  load_ok && isTRUE(epi_ok) && write_ok && render_ok

if (all_good) {
  cat("You are ready for 21 September. See you at IISc.\n\n")
} else {
  cat("Some checks failed. Send this entire output to office.msicph@iisc.ac.in\n")
  cat("Include your operating system and version.\n\n")
}

cat("Session details for the course team:\n")
print(sessionInfo()$R.version$version.string)
cat("Platform:", R.version$platform, "\n")
