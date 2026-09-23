# Project configuration

required_packages <- c("readr", "dplyr", "tidyr", "stringr", "lubridate", "purrr")
missing_packages <- required_packages[!vapply(required_packages, requireNamespace, logical(1), quietly = TRUE)]
if (length(missing_packages) > 0) {
  stop("Install required packages before running: ", paste(missing_packages, collapse = ", "))
}

RAW_DIR <- "data/raw"
DERIVED_DIR <- "data/derived"
DIAGNOSTIC_DIR <- "output/diagnostics"
TABLE_DIR <- "output/tables"
FIGURE_DIR <- "output/figures"

dir.create(DERIVED_DIR, recursive = TRUE, showWarnings = FALSE)
dir.create(DIAGNOSTIC_DIR, recursive = TRUE, showWarnings = FALSE)
dir.create(TABLE_DIR, recursive = TRUE, showWarnings = FALSE)
dir.create(FIGURE_DIR, recursive = TRUE, showWarnings = FALSE)

FILES <- list(
  enrollment = file.path(RAW_DIR, "cdenroll2425.txt"),
  absenteeism = file.path(RAW_DIR, "absenteeismreason25-v2.txt"),
  cbeds = file.path(RAW_DIR, "cbedsora24b.txt")
)

missing_files <- names(FILES)[!file.exists(unlist(FILES))]
if (length(missing_files) > 0) {
  stop("Missing raw input(s): ", paste(missing_files, collapse = ", "),
       ". See data/README.md.")
}

# District identifiers
IRVINE_COUNTY <- "30"
IRVINE_DISTRICT <- "73650"
LODI_COUNTY <- "39"
LODI_DISTRICT <- "68585"

ACADEMIC_YEAR <- "2024-25"
