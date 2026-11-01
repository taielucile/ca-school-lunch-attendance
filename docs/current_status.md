# Research status

Last source-checked: October 31, 2026. This page is a starting point for the files in this repository, not a new analysis. The [October 31 source audit](independent_research_integrity_audit_2026_10_31.md) is the main record for the figures below; the [October 30 full-source run](verified_end_to_end_execution_2026_10_30.md) records the source versions and execution checks.

## What the files support

**2025–26 attendance estimates.** The statewide CDE extract has 6,165 records with positive TK/K Census enrollment after excluding administrative placeholder school codes. Of these, 5,912 have calculable combined TK/K estimates. They use Census enrollment minus combined TK/K absence days divided by an assumed 180 days. They are not observed annual attended days. The [statewide CSV and district files](../results/README.md) are available for inspection.

**Ventura.** For 17 matched schools, district-reported TK/K average daily attendance totals 1,179.14 students per day. The absence-adjusted Census estimate totals 1,186.06; the cumulative-enrollment alternative totals 1,236.06. The Census-based estimate is closer at 13 schools, the cumulative estimate at two, with two ties. The original district workbook was subsequently rechecked. This is one district's descriptive comparison, not evidence that the estimate works equally well statewide. [Ventura comparison](../results/2025_26/ventura_17_school_ada_validation.csv)

**2024–25 statewide FNS10.** The source claims reconcile, and a conservative name-matching approach yields 6,282 candidate school links among 9,985 normalized sponsor/site pairs. These are proposed matches, not verified site identities. A prior method found 6,515 of 9,988 pairs under different matching rules; the counts should not be treated as comparable results. The FNS10 data do not identify kindergarten meals separately. [FNS10 review files](../results/README.md#202425-statewide-meal-claims)

**District meal records.** Elk Grove and Ontario-Montclair workbook extracts have been checked against their supplied workbooks, but some definitions are unresolved. Elk Grove's grade code `19` has not been confirmed as TK; its available attendance figures are rates, not recorded grade-specific attended days. Ontario-Montclair's monthly attendance is schoolwide, and its November meal totals do not reconcile straightforwardly with reported meal average daily participation (ADP). None of these checks establishes a valid matched-period kindergarten participation rate. [District workbook review](elk_grove_ontario_montclair_new_sources_2026_10_31.md)

## Corrections and limits to know

- The first Lodi attendance extract included 27 schools because the initial source retrieval was incomplete. The corrected 2025–26 extract includes 35 TK/K-serving school records, 34 with calculable estimates. Use the [corrected file](../results/2025_26/lodi_unified_school_denominator_proxies.csv).
- A preliminary Elk Grove check incorrectly reported 16 missing school attendance-rate records after stopping partway through a worksheet. The full worksheet recheck found K and TK rates for all 43 kindergarten meal sites. The earlier finding was retracted.
- School-name matches remain candidates until supported by identifiers or source review. Some school codes refer to nontraditional programs; removing placeholder codes alone does not define a final eligible school sample.
- TK/K and grade 1 estimates in the long district files divide combined-grade absences using enrollment shares. They are not observed grade-specific ADA.

## What is still needed

The available statewide files cannot yet support a kindergarten meal participation rate. That requires a kindergarten-aligned meal numerator, matching school or meal-site identities, and an attendance denominator for the same grade and reporting period.

For the statewide FNS10 work, the separate Nutrition Services request concerns comparable 2025–26 claims and stable sponsor/site identifiers or a site-to-CDS crosswalk. Kindergarten schedule classifications are to be obtained from public CBEDS files. The attendance-records correspondence is separate and is not part of the Nutrition Services request.

The [research decision log](decisions.md) preserves choices made earlier in the study, including approaches that were later revisited. For the latest checked results, use this page together with the dated audit rather than assuming that every earlier planning note describes the current analysis.
