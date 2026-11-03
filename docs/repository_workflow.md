# Calculation map: from source files to results

This page explains how the analysis is organized so a reader can **trace a result to its source and calculation**. It is not a contribution workflow.

## From original source to estimate

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

A meal-claim count is not an attendance measure. The separate meal-site and meal-file checks do not automatically produce participation rates.

## Find the code behind the output

| Output | Code / method | Open the results |
| --- | --- | --- |
| 2025–26 statewide combined TK/K estimate | [`scripts/build_denominators_2526.py`](../scripts/build_denominators_2526.py); [input and command](../data/README.md#202526-cde-attendance-estimates) | [Statewide CSV](../results/2025_26/statewide_school_denominator_proxies.csv) |
| 2025–26 selected districts and grade allocations | [`R/11_district_denominator_extracts_2526.R`](../R/11_district_denominator_extracts_2526.R) and [`scripts/reshape_district_denominators_2526.py`](../scripts/reshape_district_denominators_2526.py) | [District file list](../results/README.md#district-files) |
| Ventura observed-versus-estimated ADA | [`scripts/reproduce_ventura_2526.py`](../scripts/reproduce_ventura_2526.py) and [validation note](ventura_tkk_ada_validation_2026-10.md) | [17-school comparison](../results/2025_26/ventura_17_school_ada_validation.csv) |
| Original 2024–25 analysis | [`RUN_ALL.R`](../RUN_ALL.R) and [`R/`](../R/) | [Source guide](../data/README.md#earlier-r-workflow) and [method note](denominator_method_note.md) |
| FNS10 site matching candidates | [`scripts/audit_fns10_links.py`](../scripts/audit_fns10_links.py) and [linkage audit](fns10_cde_linkage_review_2026_10.md) | [2024–25 candidate file index](../results/README.md#202425-statewide-meal-claims) |

**Important:** The standalone Python script produces its own output filenames in the folder you choose. The committed named-district results also involve separate extraction, reshaping, and source-review steps. Running just that Python script does **not** regenerate every committed result.

## Keep these units distinct

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

## Verification and limits

1. **Source and population:** Check the school-year and 14-digit CDS identifier against the original files. An initial Lodi extract missed eight schools and was later corrected.
2. **Missingness:** Preserve suppressed and missing absence records as missing. A calculation that runs successfully is not necessarily a valid population estimate.
3. **Reproducibility:** [Source filenames and SHA-256 values](../data/README.md) identify the versions used for the 2025–26 extract; the [October 30 execution record](verified_end_to_end_execution_2026_10_30.md) documents tests.
4. **External checks:** The [Ventura 17-school comparison](ventura_tkk_ada_validation_2026-10.md) checks a limited district subset; it does not establish statewide accuracy.
5. **Corrections:** The [October 31 integrity audit](independent_research_integrity_audit_2026_10_31.md) identifies corrected Lodi and Elk Grove claims.
6. **Interpretation:** Never divide meal counts by an unmatched attendance proxy or equate schoolwide ADA with TK/K ADA.

For a read-only tour, go back to the [reader's guide](START_HERE.md). For commands, go to the [data source guide](../data/README.md).
