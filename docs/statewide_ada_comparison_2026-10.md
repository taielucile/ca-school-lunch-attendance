# Statewide district ADA alignment check (2024–25)

**Status:** results recorded from the October 25 internal district-ADA analysis; source exhibit, calculation scripts, and intermediate CSVs have **not** been committed or rerun in this repository. This is a provenance and handoff note, not an independent reproduction.

## Research question and unit

Does a district-level Census/absence attendance proxy agree in aggregate with California's reported **school district ADA**? This is a **district-level, TK/K–3 comparison**, not a school-level TK/K attendance validation or a meal take-up analysis. Do not pool its statistics with the 64-school Irvine/Lodi denominator sensitivity panel.

The candidate district proxy is `Census enrollment − absence days / D`, using an assumed `D = 180` instructional days unless separately documented. The benchmark is the CDE School District ADA exhibit's **B-1 Current Year ADA** line. The two quantities do not necessarily cover the same students, programs, or attendance periods.

## Reported audit results (pending independent rerun)

| Item | Reported result |
| --- | ---: |
| CDE district rows examined | 937 |
| All-charter districts lacking B-1 ADA | 7 |
| Districts retained | 930 |
| Aggregate TK/K–3 proxy difference relative to benchmark | +0.26% |
| Districts with absolute relative difference ≤1% | 56% |
| Districts with absolute relative difference ≤2% | 75% |
| Districts with absolute relative difference ≤5% | 90% |

These are reported summary figures, **not recomputed outputs of this repository**. The 930 count is an alignment result, not a claim that every California district or school was covered. Percentages are rounded; the precise calculation denominator and missingness rules must be verified from the original artifacts before publication.

## Interpretation and exclusions

CDE district ADA B-1 and the Census/absenteeism proxy have different coverage. Charter, nonpublic/community-day, and county-operated populations can differ across sources. Independent-study and summer special-education ADA, students excluded from the public absenteeism file because of short enrollment spells, early-admission TK, Census timing, suppressed-absence imputation, and school-calendar variation can affect differences. The working 180-day assumption does not apply equally everywhere (e.g., Los Angeles uses 183 in the audit notes). A Mt. Baldy anomaly requires explicit investigation rather than silent deletion.

**Do not interpret close aggregate agreement as validation of individual schools, kindergarten alone, school-level meal participation, or the true duration-weighted expected-attendance exposure.** Offsetting district errors can produce a small statewide difference.

## Reproduction handoff / acceptance criteria

Recover and review the original `20_district_ada_pilot.py`, `21_audit_document.py`, `code/run_pass3.sh`, CDE exhibit transcription, and `exhibit_definitions_and_alignment.csv` from the research workspace. These are **not yet present** here. Preserve input download dates, original source links, hashes, and the explicit exhibit B-1 extraction rules. Independently check 937 input district rows, seven documented exclusions, 930 unique district identifiers, grade coverage, suppressed-absence imputation, aggregation weights, the +0.26% calculation, and district-level percentage distributions. Audit Mt. Baldy and calendar exceptions. Commit code and **nonrestricted** small test fixtures only after checking sharing permissions; do not commit district-provided source documents or potentially restricted records by default.

Until that is done, label this work **reported, not independently reproduced in this repo**.
