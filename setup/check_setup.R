# check_setup.R ---------------------------------------------------------------
# Short Course in Epidemiology: Concepts & Methods
# Isaac Centre for Public Health, IISc Bengaluru, with LSHTM
# 21-25 September 2026
#
# Checks that your laptop is ready for the course.
#
# Usage:  source("https://drarunmitra.github.io/iisc-epi-shortcourse/setup/check_setup.R")
#
# Email the whole output to office.msicph@iisc.ac.in if any line starts with a
# cross.
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
# The course uses |> throughout. It arrived in R 4.1.0, so this is a second,
# behavioural check on the version above.
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

# 4. Packages -----------------------------------------------------------------
# Kept in step with install_packages.R. rstudioapi is here because check 3
# above calls it; leaving it out meant the script could warn about a package it
# never verified.
required <- c(
  "tidyverse", "dplyr", "ggplot2", "readr", "tidyr", "stringr", "forcats",
  "here", "janitor", "gtsummary", "gt", "broom", "broom.helpers",
  "epitools", "scales", "rstudioapi"
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

# 5. Do the core packages actually load? --------------------------------------
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

# 6. Does an epidemiological calculation run? ---------------------------------
# Installing epitools is not the same as epitools working. Compute a risk ratio
# from a known 2x2 and check the number, so a broken install fails here rather
# than in front of the class.
#
# epitools wants the unexposed row first and the non-case column first, so the
# matrix below is
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

# 7. Can R write files here? --------------------------------------------------
write_ok <- tryCatch({
  tmp <- file.path(getwd(), ".epi_write_test")
  writeLines("test", tmp); file.remove(tmp); TRUE
}, error = function(e) FALSE)
if (write_ok) {
  ok(sprintf("Working folder is writable (%s)", basename(getwd())))
} else {
  bad(sprintf("Cannot write to %s - move your work out of a restricted or cloud-synced folder",
              getwd()))
}

# Verdict ---------------------------------------------------------------------
rule()
all_good <- r_ok && isTRUE(pipe_ok) && length(missing) == 0 &&
  load_ok && isTRUE(epi_ok) && write_ok

if (all_good) {
  cat("You are ready for 21 September. See you at IISc.\n\n")
} else {
  cat("Some checks failed. Email this whole output to office.msicph@iisc.ac.in\n")
  cat("Include your operating system and its version.\n\n")
}

cat("Details for the course team:\n")
print(sessionInfo()$R.version$version.string)
cat("Platform:", R.version$platform, "\n")
