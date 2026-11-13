# Research status

The October 31 source audit covers statewide attendance and Ventura. The November 4 reviews cover statewide meal-site matching and the Elk Grove checkpoint. The Lodi source reconciliation is dated November 8, with service-date and grade-label follow-up on November 11. CDE means California Department of Education.

## Where the work stands

- **Attendance:** The 2025–26 statewide CDE files provide school-level TK/K attendance *estimates*, not observed annual attendance.
- **District check:** Ventura has a 17-school comparison between these estimates and district-reported attendance.
- **Meals:** The 2024–25 FNS10 claims have been checked and possible site-to-school links prepared for review, but they do not identify kindergarten meals.
- **Participation rates:** A statewide kindergarten meal participation rate has not been established from the available records.

Go to the [results guide](../results/README.md) to open any of these files.

## Findings checked against sources

### Statewide attendance, 2025–26

After removing CDE administrative placeholder school codes, 6,165 school-level records have positive TK/K Census enrollment. Of these, 5,912 have the absence data needed to calculate an estimate of average attendance per day.

The estimate takes TK/K Census enrollment and subtracts combined TK/K absence days divided by 180. The 180 days are assumed, not verified for every school. The calculation's coverage does not tell us whether its attendance estimates are accurate. [Statewide file](../results/2025_26/statewide_school_denominator_proxies.csv)

### Ventura, 2025–26

For 17 matched schools, the district-reported TK/K average daily attendance is 1,179.14 students per day. The Census-based estimate totals 1,186.06; the cumulative-enrollment alternative totals 1,236.06. Census-based estimates are closer at 13 schools, cumulative estimates at two, with two ties. The original district workbook was rechecked as part of the October 31 audit.

This describes those 17 schools. It does not validate either estimate statewide. [Comparison CSV](../results/2025_26/ventura_17_school_ada_validation.csv)

### Lodi kindergarten meals, 2025–26

The district workbook records 70,667 breakfasts and 203,639 lunches across 31 matched kindergarten meal schools. The school-level model uses Census enrollment, a 180-day benchmark, and a proportional allocation of grouped TK/K absences to K. The pooled estimates are 24.6 breakfasts and 70.9 lunches per 100 modeled kindergarten attendance days. Each ratio counts meals relative to modeled attendance exposure. The source workbook does not give meal service dates, and the `Preschool` label does not establish where TK meals were recorded. [Lodi handoff and verification](../studies/lodi_2025_26/README.md)

### Statewide meal claims, 2024–25

The conservative FNS10 matching method identifies 6,282 possible links among 9,985 normalized sponsor/site pairs. A different earlier method found 6,515 out of 9,988 pairs; the two methods should not be treated as equivalent. Neither establishes the identities of meal-service sites.

The November 4 directory comparison yielded 6,274 unique exact district-and-school-name candidates among the same 9,985 pairs. The review also identified 18 high-scoring fuzzy suggestions and 1,830 unique school-name candidates with a sponsor/district mismatch. These are review queues. The manual ledger rejected the automated Golden Hill Elementary link from the Fullerton sponsor to San Diego Unified. [Directory comparison](fns10_pubschls_2026_11_04_comparison.md) · [Cross-sponsor review](fns10_cross_sponsor_review_2026_11_04.md) · [Manual ledger](../results/2024_25/fns10_sponsor_manual_review_ledger_2026_11_04.csv)

FNS10 records claimed meal counts across grades. [FNS10 review files](../results/README.md#202425-statewide-meal-claims)

## Corrections to earlier work

- **Lodi:** An initial retrieval missed eight schools. Use the corrected [35-school CDE extract](../results/2025_26/lodi_unified_school_denominator_proxies.csv), which has 34 calculable estimates, rather than the preliminary 27-school file.
- **Elk Grove:** A preliminary check stopped before the end of the attendance worksheet and mistakenly suggested 16 schools were missing attendance rates. The complete review found K and TK rates for all 43 kindergarten meal sites; the earlier claim was withdrawn.

The [October 31 audit](independent_research_integrity_audit_2026_10_31.md) documents both corrections.

## What needs clarification

Some district meal files have school and grade information, but their measures are not yet ready to combine into kindergarten participation rates.

Elk Grove's grade code `19` has not been confirmed as TK, and the workbook provides attendance rates rather than grade-specific attended days. Ontario-Montclair reports monthly schoolwide attendance; its November meal totals and meal average daily participation (ADP) do not reconcile straightforwardly. Proposed school-name links in both districts also need verification. [District source review](elk_grove_ontario_montclair_new_sources_2026_10_31.md) · [Elk Grove checkpoint](elk_grove_analysis_checkpoint_2026_11_04.md)

For statewide FNS10, the Nutrition Services work concerns comparable 2025–26 meal claims and stable sponsor/site identifiers or a site-to-CDS crosswalk. Kindergarten schedule classifications will come from public CBEDS files. The attendance-records correspondence is a separate effort.

The [research decision log](decisions.md) includes earlier decisions and ideas that were subsequently revisited. The [research archive](archive/README.md) preserves earlier handoffs and memos.
