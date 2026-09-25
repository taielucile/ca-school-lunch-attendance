# One-stop runner: California school lunch attendance denominator
# 2024-25
#
# Raw files must be placed in data/raw/. See data/README.md.

scripts <- c(
  "R/00_config.R",
  "R/01_clean_enrollment.R",
  "R/02_clean_absenteeism.R",
  "R/03_clean_cbeds.R",
  "R/04_build_school_panel.R",
  "R/05_validate_links.R",
  "R/06_build_denominators.R",
  "R/07_irvine_lodi_analysis.R",
  "R/08_district_validation.R",
  "R/09_lodi_enrollment_triangulation.R"
)

for (script in scripts) {
  message("Running ", script)
  source(script, local = FALSE)
}

message("Build complete.")

