# 2025–26 district denominator extracts — implementation handoff

## Status (October 29, 2026)
A standalone R extractor has been added on a working branch. **Not yet executed against real CDE 2025–26 source files**: the repository deliberately excludes raw CDE files, and this environment has no R runtime or source inputs. No 2025–26 district extracts or validation results are claimed.

## Run
Download the official **2025–26 Census Day enrollment** and **2025–26 Student Absenteeism by Reason** tab-delimited releases, confirm their file versions and column schema, and save locally in `data/raw/`. The absence filename below is a local placeholder, not a verified official release filename.

```sh
Rscript R/11_district_denominator_extracts_2526.R \
  data/raw/cdenroll2526.txt \
  data/raw/absenteeismreason26.txt \
  output/district_denominators
```

The script emits a statewide school-level extract, one file per county–district identifier, and a quality summary. **Lodi** should be inspected first, using its actual county/district CDS prefix, followed by Ventura and other districts with usable 2025–26 grade-specific meal data. Never select a district by a name-only match when a CDS identifier is available.

## Measurement
Each row represents one school and the **combined TK/K grade band** in 2025–26. The proxy is:

`estimated_tk_k_ada = tk_k_census_enrollment - tk_k_absence_days / 180`

This is an assumption-dependent proxy for average daily attendance, **not observed ADA** or directly observed student-days. The public GRTKKN absence band combines TK and K. The script retains separate TK and K *Census enrollment counts* but does **not** fabricate separate TK or K ADA. First-grade ADA is also not estimated by this module. The 180-day assumption is provisional and may differ from local calendars. Flagged negative estimates, missing or suppressed inputs, and unusual values must be reviewed before any analytical use.

## Validation and district handoff
1. Verify CDE release years, field definitions, file versions, source URLs, and SHA-256 checksums.
2. Inspect `quality_summary_2025_26.csv` and resolve invalid, missing, suppressed, or duplicate records. Do not silently impute suppressed absence days.
3. Confirm Lodi school membership and compare its CDS codes against the district meal workbook; maintain an explicit match audit.
4. Recover Ventura's original 17-school observed ADA benchmark and crosswalk. The existing October note **already labels the proxy comparison 2025–26**, but its source files and scripts are missing. Determine the *actual source year of each original proxy input* before describing any new run as a correction. Recalculate P0/P1/P2 using verified same-year inputs and compare school-level and aggregate results, including 13/2/2 reported comparison and Homestead exclusion.
5. Harmonize district meal exports to a shared school–grade–meal type–period schema. Meal counts, average daily meal participation, student attendance, and enrollment are distinct measures. Do not produce a kindergarten participation rate from a combined TK/K attendance proxy without explicit numerator/denominator alignment.
6. Add synthetic fixture tests and run the R script and full applicable tests in an R-enabled environment. Only then mark extracts validated or merge into the default pipeline.

## Separation of workstreams
2024–25 FNS10 statewide meal claims align in year with 2024–25 CDE denominators. District-provided 2025–26 meal data require 2025–26 denominators. The separate attendance-records correspondence should not be included in Nutrition Services report requests.
