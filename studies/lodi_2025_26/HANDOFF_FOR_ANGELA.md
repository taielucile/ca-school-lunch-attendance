# Lodi data and methods handoff for Angela

**Scope:** Input data and reproducibility checks for Angela's district reporting and visualizations. No report text or figure design is being submitted as the analyst's deliverable.

## Ready to use

1. `outputs/lodi_31_school_k_meal_attendance_review.csv` — 31 schools; a matched record with CDE CDS code, two kindergarten meal counts, modeled kindergarten attendance, and ratios for each meal type.
2. `outputs/lodi_k_summary_2025_26.csv` — pooled district totals and ratios. The district ratio is total meals divided by total modeled attended student-days, not an average of the 31 school ratios.
3. `outputs/lodi_coverage_audit.csv` — shows which of the 35 school records in the corrected state extract are included. There are 31 included and four excluded. Exclusions are symmetric for meals and attendance.
4. `inputs/` — source snapshots with source locations and versions in `README.md`. The eligibility extract is used to verify school coverage, **not** as an attendance denominator.
5. `code/reproduce_lodi_2025_26.R` and `code/test_lodi_reproduction.R` — base-R production and checks. These were rerun after removing the out-of-scope report and figure generation.

## Columns for plotting and tables

| Field | Meaning |
| --- | --- |
| `source_school`, `cde_school`, `cds_code` | Workbook name, state name, school identifier |
| `k_breakfast_meals`, `k_lunch_meals` | **Meals**, not unique students |
| `k_census`, `tk_census` | Census Day headcounts; model inputs, not attended student-days |
| `tk_k_absence_days` | Combined TK/K recorded absence days |
| `assumed_days` | 180-day benchmark, not a verified student-specific calendar |
| `estimated_k_ada` | Modeled kindergarten average daily attendance, not observed kindergarten attendance |
| `estimated_k_attended_days` | Modeled kindergarten student-days attended; **the denominator** |
| `breakfast_per_100_attended_days`, `lunch_per_100_attended_days` | 100 × relevant meals / modeled K attended student-days; descriptive ratios, not participation percentages |
| `preschool_breakfast_meals`, `preschool_lunch_meals` | Separate workbook category; not treated as TK |

## Numerical reconciliation

- 31 unique Breakfast schools = 31 unique Lunch schools = 31 independent kindergarten eligibility schools.
- All 31 matched to corrected 35-school CDE extract; four additional CDE records have no meal workbook match.
- Kindergarten breakfast total = 70,667; kindergarten lunch total = 203,639; both reconcile to the printed workbook totals.
- K Census enrollment = 1,763; TK Census enrollment = 853; modeled K ADA = 1,595.412985; modeled K attended student-days = 287,174.337285.
- Overall breakfast-to-day ratio = 24.6077 and lunch-to-day ratio = 70.9113 per 100 modeled K student-days.

## Before any district-facing interpretation

The public attendance extract gives **combined TK/K absences**, not K-only attended days. Our proportional allocation assumes the K share of absences follows its Census enrollment share and assumes 180 days. It does not model enrollment entry/exit or align student-specific expected attendance exposure. The reporting span and grade coding in the district meal workbook remain to be confirmed, including the meaning of `Preschool`. The eligibility file's `Highest Eligible` and `Last Day` counts are **not** usable attendance denominators. These questions are logged in `internal/QA_AND_OPEN_QUESTIONS.md`.

Use 'recorded kindergarten meals per 100 **modeled** kindergarten attendance days,' not 'percent of kindergartners eating meals' or a validated participation rate. Breakfast and lunch must remain separate. Do not infer why schools differ from the descriptive ratios.

## Reproduction

```sh
Rscript code/reproduce_lodi_2025_26.R
Rscript code/test_lodi_reproduction.R
```

Both completed successfully on Debian 13 with R 4.5.0 using pinned source CSV snapshots. The original XLSX import option was not tested. Report writing and data visualization are Angela's responsibility.
