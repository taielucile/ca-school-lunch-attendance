# October 2026 TK/K stability audit. Base R only.
# Run from repository root AFTER Rscript RUN_ALL.R, with CDE stability TSV at
# data/raw/sr2425-v3.txt. Alternatively, reuse the pipeline's saved comparison
# CSV at output/tables/irvine_lodi_denominator_comparison_2024_25.csv.
raw_path <- "data/raw/sr2425-v3.txt"
comparison_path <- "output/tables/irvine_lodi_denominator_comparison_2024_25.csv"

if (!file.exists(raw_path) || !file.exists(comparison_path)) {
  stop(
    "Need the CDE stability TSV and generated 2024-25 comparison CSV; ",
    "see docs/october_2026_stability_reproduction.md"
  )
}

raw <- read.delim(
  raw_path,
  encoding = "latin1",
  colClasses = "character",
  check.names = FALSE,
  quote = "",
  na.strings = c("", "*")
)

required_stability_cols <- c(
  "Academic Year", "Aggregate Level", "Reporting Category", "District Name",
  "County Code", "District Code", "School Code",
  "Adjusted Cumulative Enrollment", "Stability Count",
  "Stability Rate (percent)"
)
stopifnot(all(required_stability_cols %in% names(raw)))

keep <- raw[
  raw[["Academic Year"]] == "2024-25" &
    raw[["Aggregate Level"]] == "S" &
    raw[["Reporting Category"]] == "GRTKKN" &
    raw[["District Name"]] %in% c("Irvine Unified", "Lodi Unified") &
    !(raw[["School Code"]] %in% c("0000000", "0000001")),
  ,
  drop = FALSE
]

keep$cds_code <- paste0(
  keep[["County Code"]],
  keep[["District Code"]],
  keep[["School Code"]]
)
stopifnot(
  nrow(keep) == 64L,
  !anyDuplicated(keep$cds_code),
  all(nchar(keep$cds_code) == 14L)
)

stability <- data.frame(
  cds_code = keep$cds_code,
  adjusted_cumulative_enrollment =
    as.numeric(keep[["Adjusted Cumulative Enrollment"]]),
  stable_enrollment = as.numeric(keep[["Stability Count"]]),
  stability_rate_pct = as.numeric(keep[["Stability Rate (percent)"]])
)

stopifnot(
  !anyNA(stability),
  all(stability$adjusted_cumulative_enrollment > 0),
  all(
    stability$stable_enrollment >= 0 &
      stability$stable_enrollment <= stability$adjusted_cumulative_enrollment
  ),
  all(
    abs(
      100 * stability$stable_enrollment /
        stability$adjusted_cumulative_enrollment -
        stability$stability_rate_pct
    ) < 0.11
  )
)

comparison <- read.csv(
  comparison_path,
  colClasses = c(cds_code = "character"),
  check.names = FALSE
)
# R/07_irvine_lodi_analysis.R writes this exact field name.
denominator_gap_col <- "cumulative_vs_census_180_pct"
required_comparison_cols <- c(
  "cds_code", "district_focus", "tk_k_total_absence_days",
  "tk_k_eligible_cumulative_enrollment", denominator_gap_col
)
stopifnot(
  all(required_comparison_cols %in% names(comparison)),
  nrow(comparison) == 64L,
  !anyDuplicated(comparison$cds_code),
  setequal(comparison$cds_code, stability$cds_code)
)

matched <- merge(comparison, stability, by = "cds_code", sort = FALSE)
summary <- do.call(
  rbind,
  lapply(split(matched, matched$district_focus), function(group) {
    usable <- group[
      is.finite(group[[denominator_gap_col]]) &
        !is.na(group$tk_k_total_absence_days) &
        !is.na(group$tk_k_eligible_cumulative_enrollment),
      ,
      drop = FALSE
    ]

    data.frame(
      district = group$district_focus[1],
      schools = nrow(group),
      usable = nrow(usable),
      stable_count = sum(group$stable_enrollment),
      adjusted_cumulative_enrollment =
        sum(group$adjusted_cumulative_enrollment),
      weighted_stability_pct =
        100 * sum(group$stable_enrollment) /
          sum(group$adjusted_cumulative_enrollment),
      pearson = cor(
        usable$stability_rate_pct,
        usable[[denominator_gap_col]],
        method = "pearson"
      ),
      spearman = cor(
        usable$stability_rate_pct,
        usable[[denominator_gap_col]],
        method = "spearman"
      )
    )
  })
)

for (district in c("Irvine Unified", "Lodi Unified")) {
  result <- summary[summary$district == district, , drop = FALSE]

  if (district == "Irvine Unified") {
    stopifnot(
      result$schools == 30,
      result$usable == 30,
      result$stable_count == 3012,
      result$adjusted_cumulative_enrollment == 3519,
      abs(result$pearson + 0.798) < 0.0015,
      abs(result$spearman + 0.735) < 0.0015
    )
  } else {
    stopifnot(
      result$schools == 34,
      result$usable == 33,
      result$stable_count == 2450,
      result$adjusted_cumulative_enrollment == 2957,
      abs(result$pearson + 0.647) < 0.0015,
      abs(result$spearman + 0.664) < 0.0015
    )
  }
}

dir.create("output/tables", recursive = TRUE, showWarnings = FALSE)
write.csv(
  summary,
  "output/tables/october_2026_stability_summary.csv",
  row.names = FALSE
)
write.csv(
  matched,
  "output/tables/october_2026_stability_school_audit.csv",
  row.names = FALSE
)
print(summary, row.names = FALSE)
cat("PASS: October 2026 stability source, join, and correlation checks\n")
