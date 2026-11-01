# California School Meals and Attendance

Research code, derived data, and documentation maintained by **Taiel Lucile** for work on **Feed California Kinders**. This is an individual research repository that project colleagues can consult, not the team's shared workspace.

## What we're studying

We are examining how school meal records can be compared with student attendance in California public schools, with a focus on **transitional kindergarten (TK) and kindergarten (K)**.

One challenge is that the public California Department of Education (CDE) data do not report the exact annual school-by-grade attendance measure we need. We can estimate combined TK/K attendance from Census Day enrollment and reported absences, but an estimate is not the same as recorded days attended.

The project compares these estimates with district attendance records where possible and checks whether meal records refer to the same schools, grades, and reporting periods. **We have not established a statewide kindergarten meal participation rate.**

## Current work

| Data and period | What we've done | What remains uncertain |
| --- | --- | --- |
| **2024–25 CDE enrollment and absenteeism** | Compared two ways of estimating combined TK/K annual attendance in Irvine and Lodi. | Neither method measures each student's actual expected attendance days. |
| **2025–26 CDE enrollment and absenteeism** | Built school-level TK/K estimates statewide. Among 6,165 records without administrative placeholder school codes, 5,912 have enough data for an estimate. | Calculation coverage is not validation against observed attendance; some records represent nontraditional programs. |
| **2025–26 Ventura district records** | Compared estimated TK/K average daily attendance with the district's reported attendance at 17 matched schools. | Results from one district cannot establish which estimate works best statewide. |
| **2025–26 district meal and attendance files** | Reviewed available school, grade, and reporting-period information, including Elk Grove and Ontario-Montclair. | Grade definitions, school identifiers, and attendance periods do not always line up with meal counts. |
| **2024–25 statewide FNS10 meal claims** | Reconciled source meal counts and prepared school-name matching candidates for review. | Exact-name candidates are not confirmed site identifiers, and FNS10 does not identify kindergarten meals separately. |

**Current as of October 31, 2026.** See the [documentation guide](docs/README.md) for detailed findings, source versions, and subsequent updates.

## How the attendance estimate works

The main public-data calculation is:

```text
Estimated daily TK/K attendance
  = TK/K Census Day enrollment − (reported TK/K absent days ÷ 180)
```

Here, **180** is an assumed number of instructional days, not a verified count for every school. The publicly reported absence total combines TK and kindergarten. Separate TK, K, and first-grade estimates in some output files divide combined-grade absences using enrollment shares; they are **model-based checks**, not observed grade-specific attendance.

These terms are not interchangeable:

- **Meal count:** number of meals reported, not number of individual students.
- **Average daily attendance (ADA):** average number of students attending per day for the population and period specified by the source.
- **Estimated attendance:** an approximation calculated from enrollment and absences, subject to the assumptions above.
- **Meal average daily participation (ADP):** a meal-program measure; it is not school attendance.

Details and limitations are in the [denominator methods note](docs/denominator_method_note.md).

## Find your way around

| Location | Contents |
| --- | --- |
| [`R/`](R/) and [`RUN_ALL.R`](RUN_ALL.R) | Main 2024–25 R workflow and district checks |
| [`scripts/`](scripts/) | 2025–26 processing, source checks, and school-name review tools |
| [`results/2024_25/`](results/2024_25/) | Statewide FNS10 matching candidates and audit summaries |
| [`results/2025_26/`](results/2025_26/) | CDE-based school attendance estimates, district extracts, and review tables |
| [`docs/`](docs/README.md) | Methods, data sources, validation, research decisions, and past notes |
| [`tests/`](tests/) | Checks for reproducibility and data integrity |

Source workbooks and raw CDE files are **not included in this repository**. See [data requirements](data/README.md) and [source documentation](docs/sources.md).

## Reproduce the work

Use the original files listed in [`data/README.md`](data/README.md), placed in `data/raw/`. The R workflow also uses `dplyr`, `readr`, and `stringr` for its Lodi module.

**2024–25 R workflow and regression checks:**

```sh
Rscript RUN_ALL.R
Rscript tests/test_pipeline.R
```

**Source-independent 2025–26 Python checks:**

```sh
python -m unittest discover -s tests -p 'test_*2526.py' -v
```

**Rebuild 2025–26 public CDE school estimates:**

```sh
python scripts/build_denominators_2526.py \
  data/raw/cdenroll2526.txt \
  data/raw/absenteeismreason26.txt \
  output/2025_26
```

The Python checks test code and retained review files; they do **not** replace a full run on the original source data. The [research-integrity workflow](.github/workflows/research-integrity.yml) runs source-independent checks on pull requests. The [full-source workflow](.github/workflows/fck-2025-26-repro.yml) runs separately when source access is available. The [October 30 execution report](docs/verified_end_to_end_execution_2026_10_30.md) records a successful full-source run, and the [October 31 integrity audit](docs/independent_research_integrity_audit_2026_10_31.md) documents independent source checks and remaining limits.

## Working with these files

Keep original data separate from derived outputs, retain school identifiers as **text** (including leading zeroes), and check the **school year, grade, and reporting period** before joining files. Missing or suppressed attendance values should remain missing—not be treated as zero. School-name matches are candidates until supported by source identifiers.

See the [repository workflow notes](docs/repository_workflow.md) and [research decision log](docs/decisions.md) for how the analyses are checked and documented.
