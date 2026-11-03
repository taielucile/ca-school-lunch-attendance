# Calculation map: sources, methods, and outputs

## Attendance extraction

```text
California enrollment file + CDE Absenteeism by Reason file
                         |
             match school/year by CDS
                         |
           check school coverage and
            missing/suppressed values
                         |
          construct attendance estimates
        (Census TK/K − absence days / 180)
                         |
      write statewide and district CSV outputs
                         |
   reconcile source records and compare with district
      reported ADA when comparable data exist
```

Meal-site linkage and meal-file comparability are assessed in separate analyses.

## Scripts and outputs

| Output | Code / method | Open the results |
| --- | --- | --- |
| 2025–26 statewide combined TK/K estimate | [`scripts/build_denominators_2526.py`](../scripts/build_denominators_2526.py); [input and command](../data/README.md#202526-cde-attendance-estimates) | [Statewide CSV](../results/2025_26/statewide_school_denominator_proxies.csv) |
| 2025–26 selected districts and grade allocations | [`R/11_district_denominator_extracts_2526.R`](../R/11_district_denominator_extracts_2526.R) and [`scripts/reshape_district_denominators_2526.py`](../scripts/reshape_district_denominators_2526.py) | [District file list](../results/README.md#district-files) |
| Ventura observed-versus-estimated ADA | [`scripts/reproduce_ventura_2526.py`](../scripts/reproduce_ventura_2526.py) and [validation note](ventura_tkk_ada_validation_2026-10.md) | [17-school comparison](../results/2025_26/ventura_17_school_ada_validation.csv) |
| Original 2024–25 analysis | [`RUN_ALL.R`](../RUN_ALL.R) and [`R/`](../R/) | [Source guide](../data/README.md#earlier-r-workflow) and [method note](denominator_method_note.md) |
| FNS10 site matching candidates | [`scripts/audit_fns10_links.py`](../scripts/audit_fns10_links.py) and [linkage audit](fns10_cde_linkage_review_2026_10.md) | [2024–25 candidate file index](../results/README.md#202425-statewide-meal-claims) |

The standalone Python script generates the statewide output and district files with its own naming scheme. The committed selected-district results include additional extraction, reshaping, and source-review steps.

## Measurement definitions

| Quantity | What it represents |
| --- | --- |
| Census enrollment | Students enrolled on one reporting day |
| Eligible cumulative enrollment | Students counted over a period, not their actual exposure days |
| Absence days | Days absent within the reporting population |
| Estimated TK/K ADA | Constructed average students attending per day |
| Estimated attended student-days | Modeled ADA × 180, not observed annual days |
| Allocated TK / K / grade 1 ADA | Modeled grade-level attendance from grouped absences |
| District-reported ADA | Attendance reported by the district for a specified population and period |
| Meal count | Meals recorded or claimed, not distinct students who ate meals |
| Meal ADP | Average daily meal-program participation, not student ADA |

See the [2025–26 dictionary](reading_2025_26_files.md) for exact field names.

## Validation and provenance

- **Coverage:** School-year and county-district-school (CDS) identifiers are reconciled with the source files. The [October 31 integrity audit](independent_research_integrity_audit_2026_10_31.md) documents corrections to the Lodi extract and Elk Grove source review.
- **Missingness:** Suppressed and unavailable absence values remain missing in derived estimates.
- **Reproducibility:** The [source inventory](../data/README.md) records filenames and SHA-256 hashes, and the [October 30 execution record](verified_end_to_end_execution_2026_10_30.md) documents verified runs.
- **External comparison:** The [Ventura validation](ventura_tkk_ada_validation_2026-10.md) covers 17 matched schools and does not establish statewide accuracy.
- **Comparability:** Meal and attendance measures are evaluated by school, grade, reporting period, and unit before constructing a participation measure.

