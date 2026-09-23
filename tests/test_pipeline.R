# End-to-end regression and integrity checks.
# Run from repository root: Rscript tests/test_pipeline.R

source("RUN_ALL.R")

reference <- read.csv("tests/reference_irvine_lodi_summary.csv",
                      stringsAsFactors = FALSE)

actual <- focus_summary[
  order(focus_summary$district),
  c("district", "schools_with_positive_tk_k", "schools_usable",
    "census_tk_k", "eligible_cumulative_tk_k", "total_absence_days",
    "proxy_attended_census_180", "proxy_attended_cumulative_180",
    "cumulative_vs_census_pct", "median_school_difference_pct")
]
reference <- reference[order(reference$district), ]

stopifnot(identical(actual$district, reference$district))

exact_cols <- c(
  "schools_with_positive_tk_k", "schools_usable", "census_tk_k",
  "eligible_cumulative_tk_k", "total_absence_days",
  "proxy_attended_census_180", "proxy_attended_cumulative_180"
)
for (v in exact_cols) stopifnot(all(actual[[v]] == reference[[v]]))

float_cols <- c("cumulative_vs_census_pct", "median_school_difference_pct")
for (v in float_cols) stopifnot(all(abs(actual[[v]] - reference[[v]]) < 1e-9))

stopifnot(!anyDuplicated(school_panel$cds_code))
stopifnot(nrow(school_panel) == nrow(enrollment_clean))
stopifnot(all(school_panel$tk_k_expected_student_days_publicly_identified == FALSE))
stopifnot(all(school_panel$tk_k_attended_student_days_publicly_identified == FALSE))

# Non-charter sensitivity regression checks.
nc <- sample_sensitivity[sample_sensitivity$sample == "non-charter schools only", ]
irv_nc <- nc[nc$district == "Irvine Unified", ]
lodi_nc <- nc[nc$district == "Lodi Unified", ]
stopifnot(irv_nc$schools_usable == 29)
stopifnot(lodi_nc$schools_usable == 29)
stopifnot(abs(irv_nc$cumulative_vs_census_pct - 8.757419480393104) < 1e-9)
stopifnot(abs(lodi_nc$cumulative_vs_census_pct - 8.521180656919913) < 1e-9)

message("All pipeline regression and integrity tests passed.")
