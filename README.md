# California School Meals and Attendance

My research files for Feed California Kinders. I use California enrollment and absence records to estimate attendance in transitional kindergarten (TK) and kindergarten (K), and compare those estimates with district attendance and school meal records.

## New to the project?

**[Start with the new researcher guide](docs/START_HERE.md).** It explains the research question, what the files can and cannot establish, a ten-minute tour, and specific unanswered questions where a new RA could contribute. For how to propose and document changes, see [Contributing](CONTRIBUTING.md).

**Current status:** Analyses and source checks are in progress. The latest reviewed interpretation is dated October 31, 2026; there is **no verified statewide TK/K meal participation rate**. This repository is **private**, so new collaborators need GitHub access before they can use these links.

## Start here

| Looking for… | Open |
| --- | --- |
| The latest findings and corrections | [Research status](docs/current_status.md) |
| The statewide 2025–26 school attendance estimates | [Statewide CSV](results/2025_26/statewide_school_denominator_proxies.csv) |
| Attendance estimates for a particular district | [District file list](results/README.md#district-files) |
| A comparison with actual district-reported attendance | [Ventura's 17-school comparison](results/2025_26/ventura_17_school_ada_validation.csv) |
| The 2024–25 statewide meal-claim matching work | [FNS10 files and notes](results/README.md#202425-statewide-meal-claims) |
| What the CSV columns mean | [Guide to the 2025–26 files](docs/reading_2025_26_files.md) |

The [results guide](results/README.md) explains what each file contains. For methods, source records, and earlier analyses, use the [documentation index](docs/README.md).

## The attendance question

California publishes enrollment counts and school absence totals, but not the exact annual school-by-grade attended days needed for this work. Census Day enrollment is a count on one day, not a record of how long each student was enrolled.

For combined TK/K, the main estimate is:

```text
Estimated students attending per day
  = Census Day TK/K enrollment − (TK/K days absent ÷ 180)
```

The 180-day school year is an assumption. The public absence figures combine TK and K. Some files also estimate TK, K, and grade 1 separately by allocating the combined absence totals across grades; those numbers are not observed grade-specific attendance.

The Ventura comparison tests how the combined TK/K estimates compare with one district's reported attendance. It does not establish which method is closest in every district.

## Meal records

I also examine whether the meal records can be matched to the same schools, grades, and reporting periods as the attendance data. The 2024–25 statewide FNS10 records contain meals claimed by service site, not kindergarten meals or the number of individual students served. The school-name links in this repository are candidates for review, not confirmed matches.

There is not yet a statewide kindergarten meal participation rate from these records. See [research status](docs/current_status.md) for the unresolved definitions and source requests.

## Files and code

- [Results](results/README.md) — statewide and district CSVs, Ventura, FNS10, and file checks.
- [New researcher guide](docs/START_HERE.md) — research orientation and specific places to help.
- [Contribution guide](CONTRIBUTING.md) — review process and a short research handoff template.
- [Documentation](docs/README.md) — methods, source audits, decisions, and earlier notes.
- [Source files and how to run the analyses](data/README.md) — what to download or obtain, where the inputs go, and the commands.
- [R code](R/) and [RUN_ALL.R](RUN_ALL.R) — the original 2024–25 analysis.
- [Python and R scripts](scripts/) — 2025–26 extracts, source checks, and matching.
- [Tests](tests/) — checks for processing and reproducibility.

Raw CDE and district files are kept separately. The committed results are derived files; they do not replace the original sources.

*Research status and source verification last reviewed October 31, 2026.*
