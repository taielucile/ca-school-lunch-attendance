# Project configuration
# Package-free by design: the core pipeline uses base R only.

RAW_DIR <- "data/raw"
DERIVED_DIR <- "data/derived"
DIAGNOSTIC_DIR <- "output/diagnostics"
TABLE_DIR <- "output/tables"
FIGURE_DIR <- "output/figures"

for (d in c(DERIVED_DIR, DIAGNOSTIC_DIR, TABLE_DIR, FIGURE_DIR)) {
  dir.create(d, recursive = TRUE, showWarnings = FALSE)
}

FILES <- list(
  enrollment = file.path(RAW_DIR, "cdenroll2425.txt"),
  enrollment_2526 = file.path(RAW_DIR, "cdenroll2526.txt"),
  absenteeism = file.path(RAW_DIR, "absenteeismreason25-v2.txt"),
  cbeds = file.path(RAW_DIR, "cbedsora24b.txt")
)

missing_files <- names(FILES)[!file.exists(unlist(FILES))]
if (length(missing_files) > 0) {
  stop("Missing raw input(s): ", paste(missing_files, collapse = ", "),
       ". See data/README.md.")
}

# 2024-25 focus districts
IRVINE_COUNTY <- "30"
IRVINE_DISTRICT <- "73650"
LODI_COUNTY <- "39"
LODI_DISTRICT <- "68585"

ACADEMIC_YEAR <- "2024-25"

# Sensitivity benchmarks, not claims about each student's actual exposure.
DAYS_PRIMARY <- 180
DAYS_ALT <- 175
