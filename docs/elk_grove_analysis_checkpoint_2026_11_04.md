# Elk Grove: district analysis checkpoint (November 4, 2026)

**Status: source extraction and reconciliation complete; kindergarten participation-rate denominator not verified.** This checkpoint draws on the [October 31 source workbook audit](elk_grove_ontario_montclair_new_sources_2026_10_31.md), [source-audit metrics](../results/2025_26/elk_ontario_uploaded_workbook_source_audit_2026_10_31.json), and [school/CDS candidate table](../results/2025_26/elk_grove_unified_source_cds_candidates_review_only.csv). It is **not** a fresh audit of the original Excel workbook.

## What can be reported now

| Item | Checked result | Meaning |
| --- | ---: | --- |
| Meal reporting period | July 1, 2025–March 31, 2026 | Partial school year, not a full-year attendance exposure |
| Named school worksheets | 44 | Jessie Baker includes separately labeled segments |
| Source school-grade rows | 442 | Excludes printed TOTAL row |
| Breakfast meals, source total | 711,424 | Reported meal quantities, not children |
| Lunch meals, source total | 2,429,657 | Reported meal quantities, not children |
| Worksheet total discrepancies | 0 of 44 | Source totals reconcile to grade details |
| School rows labeled K | 43 | Kindergarten meal records |
| School rows labeled 19 | 43 | **Do not relabel as TK without source definition** |
| K meal sites with K and TK attendance rates | 43 of 43 | Rate *availability*, not verified attended student-days |
| School-name/CDS candidates | 40 normalized exact + 3 name variants | None is an official site-to-CDS identity confirmation |
| CDE TK/K-serving records without K meal-source rows | 2 | Not evidence of zero meals |

The original attendance-detail sheet runs through row **1,156**. The previous claim of 16 missing attendance sites was caused by an incomplete read and is withdrawn. The internal handoff's **260** checked grade × meal-type records agree with the original workbook's enrollment and attendance-rate values.

## What can be compared, and what cannot

The workbook supports **descriptive K meal totals by school and meal type**, and separately reports grade-specific enrollment and attendance *rates*. A rate alone does not tell us how many attended student-days occurred over July–March without its underlying expected-day exposure and definition. The 2025–26 CDE Census-minus-absences estimate assumes **180 days** and is a full-year *proxy*, so dividing July–March meals by that figure would mix periods and measures.

The raw code `19` occurs alongside K rows and schools with positive TK enrollment, making TK a plausible interpretation, **not a confirmed grade code**. Chloe indicated that code `19` was copied from the district's original report, rather than assigned while preparing the spreadsheet. This provenance detail does not establish its meaning.

**Do not publish a TK-specific total or a K/TK participation rate yet.** Do not equate meal counts with unique students or imply that a school-level attendance rate is a meal-program participation rate.

## Concrete next verification, in order

1. **Original grade-code definition:** obtain the grade key or original report documentation establishing what `19` means. Preserve the raw code regardless of the outcome.
2. **Attendance-rate denominator:** establish whether the rate is days attended / expected days, the dates used, and whether expected grade-specific days (or actual attended student-days) can be recovered for the **same July–March period**.
3. **School identity:** verify Charles Mack / Charles E. Mack, James McKee / James A. McKee, and Maeola Beitzel / Maeola R. Beitzel against source identifiers; keep the other 40 as name candidates until reviewed.
4. **Coverage:** investigate California Montessori Project – Elk Grove Campus and Las Flores High (Alternative) without interpreting missing meal rows as zero.
5. **Then** produce school-grade descriptive comparisons and any rate with its numerator, denominator, dates, and exclusions explicitly documented.

## Decision

**Elk Grove should be the first district to advance**, because its grade-labeled meal records and grade-specific attendance rates are available for all 43 K meal sites. The immediate output is a verified source-definition and period-alignment check, **not** a calculated kindergarten participation rate. If the district cannot supply same-period expected/attended days, keep the meal analysis descriptive and clearly labeled.

See also [the results guide](../results/README.md) and [current research status](current_status.md).
