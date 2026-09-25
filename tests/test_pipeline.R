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



# School-level handoff integrity checks
stopifnot(
  exists("school_handoff"),
  nrow(school_handoff) == 64,
  ncol(school_handoff) == 18,
  all(nchar(school_handoff$cds_code_14char) == 14),
  !anyDuplicated(school_handoff$cds_code),
  sum(school_handoff$district == "Irvine Unified") == 30,
  sum(school_handoff$district == "Lodi Unified") == 34,
  sum(school_handoff$usable_public_denominator) == 63,
  sum(school_handoff$absenteeism_suppressed, na.rm = TRUE) == 1
)

# Irvine 2025-26 district-attendance validation checks.
#
# The district reports contain 30 K rows and 28 PK/TK rows for Nov. 3-7,
# 2025. Vista Verde and IUSD Virtual Academy have no PK/TK attendance row;
# same-year CDE Census data report zero TK enrollment at both schools, so
# their missing TK attendance is reconciled to zero rather than treated as
# an unverified missing value.

stopifnot(
  exists("irvine_attendance"),
  exists("validation_out"),
  exists("irvine_validation_summary")
)

# Raw attendance transcription integrity.
stopifnot(
  nrow(irvine_attendance) == 58,
  sum(irvine_attendance$grade == "K") == 30,
  sum(irvine_attendance$grade == "PK_TK") == 28,
  !anyDuplicated(irvine_attendance[c("school", "grade")]),
  sum(
    irvine_attendance$five_day_student_days[
      irvine_attendance$grade == "K"
    ]
  ) == 8703,
  sum(
    irvine_attendance$five_day_student_days[
      irvine_attendance$grade == "PK_TK"
    ]
  ) == 5401
)

# Same-year CDE Census integrity for the full Irvine district.
stopifnot(
  nrow(irvine_census_2526) == 47,
  sum(irvine_census_2526$GR_TK) == 1296,
  sum(irvine_census_2526$GR_KN) == 2022,
  sum(irvine_census_2526$tk_k_census_2526) == 3318
)

# The district attendance reports cover 30 schools.
stopifnot(
  nrow(validation_out) == 30,
  !anyDuplicated(validation_out$cds_code_14char),
  all(nchar(validation_out$cds_code_14char) == 14),
  sum(validation_out$census_tk_2025_26) == 1170,
  sum(validation_out$census_k_2025_26) == 1873,
  sum(validation_out$census_tk_k_2025_26) == 3043
)

# Missing PK/TK rows are resolved only when same-year Census TK is zero.
stopifnot(
  sum(!validation_out$tk_attendance_reported) == 2,
  sum(validation_out$tk_zero_census_and_not_reported) == 2,
  all(
    validation_out$census_tk_2025_26[
      !validation_out$tk_attendance_reported
    ] == 0
  )
)

missing_tk_schools <- sort(
  validation_out$district_report_school[
    !validation_out$tk_attendance_reported
  ]
)

stopifnot(
  identical(
    missing_tk_schools,
    sort(c(
      "Vista Verde K-8",
      "IUSD Virtual Academy Elementary"
    ))
  )
)

# Observed five-day attendance benchmark.
stopifnot(
  sum(validation_out$observed_k_five_day_student_days) == 8703,
  sum(validation_out$observed_tk_five_day_student_days) == 5401,
  sum(validation_out$observed_tk_k_five_day_student_days) == 14104,
  abs(
    sum(validation_out$mean_daily_tk_k_attendance) - 2820.8
  ) < 1e-10
)

# Aggregate and school-level descriptive regression checks.
stopifnot(
  irvine_validation_summary$schools == 30,
  irvine_validation_summary$census_tk_k == 3043,
  irvine_validation_summary$observed_tk_k_five_day_student_days == 14104,
  abs(
    irvine_validation_summary$mean_daily_tk_k_attendance -
      2820.8
  ) < 1e-10,
  abs(
    irvine_validation_summary$aggregate_attendance_to_census_ratio -
      0.926979954
  ) < 1e-9,
  abs(
    irvine_validation_summary$median_school_attendance_to_census_ratio -
      0.9272639
  ) < 1e-7
)

message("All pipeline regression and integrity tests passed.")

