# Statewide district ADA alignment check (2024–25)

**Status:** results recorded from the October 25 internal district-ADA analysis; source exhibit, calculation scripts, and intermediate CSVs have **not** been committed or rerun in this repository. This is a provenance and handoff note, not an independent reproduction.

## Research question and unit

Does a district-level Census/absence attendance proxy agree in aggregate with California's reported **school district ADA**? This is a **district-level, TK/K–3 comparison**, not a school-level TK/K attendance validation or a meal take-up analysis. Do not pool its statistics with the 64-school Irvine/Lodi denominator sensitivity panel.

The candidate district proxy is `Census enrollment − absence days / D`, using an assumed `D = 180` instructional days unless separately documented. The October 25 methods note identifies the benchmark as the **B-1 Current Year ADA** line of the 2024–25 Annual School District ADA exhibit, posted with the [2025–26 P-1 funding exhibits](https://ias.cde.ca.gov/apportionment/PrincipalApportionmentWebExhibit?CertificationType=Non&ReportType=P1&SchoolYear=2025). The two quantities do not necessarily cover the same students, programs, or attendance periods.

## Reported audit results (pending independent rerun)

| Item | Reported result |
| --- | ---: |
| CDE district rows examined | 937 |
| All-charter districts lacking B-1 ADA | 7 |
| Districts matched across grade spans | 930 |
| Districts with positive B-1 TK/K–3 ADA | 850 |
| Aggregate TK/K–3 proxy difference relative to benchmark | +0.26% |
| Districts with absolute relative difference ≤1% | 56% |
| Districts with absolute relative difference ≤2% | 75% |
| Districts with absolute relative difference ≤5% | 90% |

These are reported summary figures, **not recomputed outputs of this repository**. The 930 count is an alignment result, not a claim that every California district or school was covered. The three threshold percentages refer to the 850 districts with positive B-1 TK/K–3 ADA. The aggregate compares the sum of district proxies with the sum of reported TK/K–3 ADA for that span. The percentages are rounded; the original rows and calculations still need to be recovered or rebuilt.

## Interpretation and exclusions

CDE district ADA B-1 and the Census/absenteeism proxy have different coverage. Charter, nonpublic/community-day, and county-operated populations can differ across sources. Independent-study and summer special-education ADA, students excluded from the public absenteeism file because of short enrollment spells, early-admission TK, Census timing, suppressed-absence imputation, and school-calendar variation can affect differences. The working 180-day assumption does not apply equally everywhere (e.g., Los Angeles uses 183 in the audit notes). A Mt. Baldy anomaly requires explicit investigation rather than silent deletion.

**Do not interpret close aggregate agreement as validation of individual schools, kindergarten alone, school-level meal participation, or the true duration-weighted expected-attendance exposure.** Offsetting district errors can produce a small statewide difference.

## Reproduction handoff / acceptance criteria

Recover and review the original `20_district_ada_pilot.py`, `21_audit_document.py`, `code/run_pass3.sh`, CDE exhibit transcription, and `exhibit_definitions_and_alignment.csv` from the research workspace. These are **not yet present** here. Preserve input download dates, original source links, hashes, and the explicit exhibit B-1 extraction rules. Independently check 937 input district rows, seven documented exclusions, 930 unique district identifiers, grade coverage, suppressed-absence imputation, aggregation weights, the +0.26% calculation, and district-level percentage distributions. Audit Mt. Baldy and calendar exceptions. Commit code and **nonrestricted** small test fixtures only after checking sharing permissions; do not commit district-provided source documents or potentially restricted records by default.

Until that is done, label this work **reported, not independently reproduced in this repo**.


## November 12 source search

The October 25 methods note identifies the certification, the 850-district TK/K–3 denominator, and the imputation order for suppressed absence cells: district, then county, then state. It flags Mt. Baldy because reported absence days exceed Census enrollment multiplied by 180. The named scripts, transcription, district alignment table, and anomaly diagnostic were not found in either project repository or by filename in the project files. The reported counts and percentage thresholds above still require those artifacts or a source-backed reconstruction with an explicit certification, population definition, and treatment of missing and suppressed rows. The [Ventura rebuild](ventura_tkk_ada_validation_2026-10.md) uses a different school year, grade band, and unit of analysis.


The public files reproduce the Mt. Baldy flag. For San Bernardino district `36-67793`, the regular campus (CDS `36677936036065`) has one TK/K–3 Census enrollee, in grade 1. Its school-level absenteeism rows report 104 TK/K absence days and 272 grade 1–3 absence days, against 58 eligible cumulative enrollee records across the two bands. Subtracting 376 days from the single Census enrollee's assumed 180 produces a negative proxy. The separate District Office Census record has 14 TK/K–3 enrollees. That difference shows why school-record placement and population alignment matter, but the public files do not establish why the counts were assigned to different records. Retain the flag and audit the placement before interpreting a district estimate.
