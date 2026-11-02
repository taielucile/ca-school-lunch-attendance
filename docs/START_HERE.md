# New researcher guide

**Start here if you have not worked on Feed California Kinders before.** This is Taiel Lucile's analysis repository for one part of a collaborative project. The [team source repository](https://github.com/whippedfruit/Feed-California-Kinders) holds additional district materials.

## The question, in two minutes

California makes school breakfast and lunch available without charge, but transitional kindergarten (TK) and kindergarten (K) schedules may affect children's opportunities to receive meals. We are asking what existing school, attendance, and meal records can *actually* tell us about these patterns.

One key challenge: the statewide data contain school-level enrollment and days absent, **not directly observed school-by-grade annual days attended**. Another: statewide meal claims count meals at service sites, **not TK/K students eating meals**. We therefore investigate attendance estimates, compare them to actual district reports where possible, and test whether meal records can be linked by school, grade, and time.

This repository is research in progress. **There is no validated statewide kindergarten meal-participation rate or causal estimate here.**

## A ten-minute tour

| Time | Open | Learn |
| --- | --- | --- |
| 2 min | [Current research status](current_status.md) | What's verified, corrected, and unresolved |
| 2 min | [Results directory](../results/README.md) | Where to find the actual CSVs |
| 2 min | [Ventura comparison](../results/2025_26/ventura_17_school_ada_validation.csv) and [explanation](ventura_tkk_ada_validation_2026-10.md) | What a district validation looks like |
| 2 min | [Reading the CSVs](reading_2025_26_files.md) | Units, fields, missingness, and proxies |
| 2 min | [Data and reproduction](../data/README.md) | Where source files come from and how analyses run |

**First example:** In Ventura, the 17 matched schools have district-reported combined TK/K ADA of 1,179.14. The Census-minus-absences estimate is 1,186.06; the cumulative-enrollment alternative is 1,236.06. These are summed *average daily students*, not meal totals or annual attended student-days. The first estimate is closer in this district, not necessarily statewide.

## What is where?

- **`README.md`**: overview and quick navigation.
- **`docs/current_status.md`**: latest checked interpretation; prefer this over older meeting notes.
- **`results/2025_26/`**: statewide and selected-district attendance estimates, quality checks, Ventura validation, and district source-review outputs.
- **`results/2024_25/`**: statewide FNS10 meal-claim matching *candidates*, not verified school identities.
- **`docs/`**: methods, data definitions, correction history, and audit trails; [documentation index](README.md).
- **`data/README.md`**: precise input filenames, source links, and run commands; original raw records are not universally in this repository.
- **`scripts/`**: newer extract/verification programs; **`R/`**, **`RUN_ALL.R`**, and **`tests/`**: earlier R workflow and tests.
- **`output/`**: local outputs from reruns; do not assume these match the committed, reviewed `results/` without checking source versions.

## What can I work on?

These are **possible tasks, not assignments**. Check with the project lead or file owner before taking one on.

| Task | Starting material | What a useful handoff looks like | Important boundary |
| --- | --- | --- | --- |
| Check Ontario-Montclair's November ADP mismatch | [Monthly consistency note](ontario_monthly_ADP_measurement_consistency_2026_10_31.md) and [30-row summary](../results/2025_26/ontario_adp_monthly_consistency_summary_review_only.csv) | Confirm the source header/formula/reporting-period definitions; note exactly what remains unknown | Do not infer a 26-day school month or treat schoolwide ADA as TK/K ADA |
| Clarify Elk Grove grade code `19` | [District workbook review](elk_grove_ontario_montclair_new_sources_2026_10_31.md) | Citation to the source-system grade-code definition, or a documented unresolved request | Do not silently rename `19` to TK |
| Review FNS10 site matching | [Candidate links](../results/2024_25/fns10_all_site_link_candidates_2024_25.csv) and [method note](fns10_cde_linkage_review_2026_10.md) | Verified identifier-based links, explicit exclusions, and provenance | Name similarity is not proof of identity |
| Recheck a new CDE file release | [Input guide](../data/README.md) and [execution record](verified_end_to_end_execution_2026_10_30.md) | Source hash comparison, reproducible run, explained differences | New source versions must not quietly replace prior reviewed results |
| Review district denominator comparability | [Coverage inventory](meal_source_district_coverage_audit_2026_10_30.md) | School/grade/period/measurement matrix | Never divide partial-period meals by an annual attendance proxy |

### Before starting or changing a result

1. Read [current status](current_status.md) and the relevant district/method note. Older drafts may contain superseded counts.
2. Confirm the **source**, school identifier, school year, grades, dates, units, missing-value rules, and exact definition of the measure.
3. Reproduce the existing result before proposing a correction; record source filenames or hashes and the command used.
4. Separate **observed**, **estimated**, **candidate match**, and **unverified** in filenames and writing.
5. Keep raw student-level records and restricted district workbooks out of public/shared commits without authorization. Do not publish school-grade extracts simply because a source workbook was shared internally.
6. Share a concise handoff: question, source, method, checked result, what remains unresolved, and paths to code/output. Get review before changing accepted analytical decisions.

## Vocabulary you'll encounter

- **CDE**: California Department of Education.
- **TK / K**: transitional kindergarten / kindergarten.
- **CDS**: California's county-district-school identifier; preserve as text.
- **ADA**: average daily *student attendance*.
- **ADP**: average daily *meal-program participation* as reported; its numerator and service-day divisor must be checked.
- **FNS10**: school meal claims data; a site-level meal count is not a grade-specific participation rate.
- **Census proxy**: Census enrollment minus combined TK/K absence days / **assumed** 180 days. Useful for sensitivity analysis, not measured attendance.
- **Suppressed**: unavailable/confidential cell; never fill with zero.

## Access and collaboration

This analysis repository is **private** as of November 2, 2026. A new RA needs repository access from the owner before browsing it. Some district originals live in the team source repository or team-shared files and require separate access. For contribution workflow and cautious review expectations, see [CONTRIBUTING.md](../CONTRIBUTING.md).

*Orientation based on source-checked documentation dated October 31, 2026. Check [current status](current_status.md) for subsequent changes.*
