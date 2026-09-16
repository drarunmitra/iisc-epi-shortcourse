# install_packages.R ----------------------------------------------------------
# Short Course in Epidemiology: Concepts & Methods
# Isaac Centre for Public Health, IISc Bengaluru, with LSHTM
# 21-25 September 2026
#
# Installs everything the course needs. Run it once, then run check_setup.R.
#
# Usage:  source("https://drarunmitra.github.io/iisc-epi-shortcourse/setup/install_packages.R")
#
# It installs only what is missing, so it is safe to run again after a failure.
# Expect 10 to 25 minutes on a first run, longer on a slow connection.
# -----------------------------------------------------------------------------

required <- c(
  # the tidyverse core, plus the parts we use by name
  "tidyverse", "dplyr", "ggplot2", "readr", "tidyr", "stringr", "forcats",
  # cleaning and file paths
  "here", "janitor",
  # tables and model output
  "gtsummary", "gt", "broom", "broom.helpers",
  # epidemiological measures from a 2x2 table
  "epitools",
  # used in the plotting sessions
  "scales",
  # lets check_setup.R report your RStudio version
  "rstudioapi"
)

missing <- setdiff(required, rownames(installed.packages()))

if (length(missing) == 0) {
  message("Nothing to do: all ", length(required), " packages are installed.")
} else {
  message("Installing ", length(missing), " package(s): ",
          paste(missing, collapse = ", "))
  install.packages(missing, dependencies = TRUE)
}

# Report rather than assume. A package can fail to install and leave the
# console scrolled far past the error.
still_missing <- setdiff(required, rownames(installed.packages()))

if (length(still_missing) == 0) {
  message("\nAll packages installed. Now run the check_setup.R line from Step 2.")
} else {
  message("\nStill missing: ", paste(still_missing, collapse = ", "))
  message("Scroll up for the error, then see Troubleshooting on the course site.")
}
