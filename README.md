# California school meals and attendance

**Attendance denominator analysis for [Feed California Kinders](https://github.com/whippedfruit/Feed-California-Kinders)**

This repository documents school-level attendance denominator estimates for transitional kindergarten (TK) and kindergarten (K) in California. It combines California Department of Education (CDE) enrollment and absenteeism records with district attendance and meal data to assess what can be measured, estimated, and compared across sources.

## Research scope

School meal participation analyses depend on denominators aligned with the same schools, grades, and reporting periods as meal records. Statewide public CDE files report Census Day enrollment and combined TK/K absences, but not duration-weighted annual attended days by school and grade. The analyses therefore construct attendance proxies, assess their coverage, and compare them with district-reported attendance where compatible records are available.

## Research files

| Resource | Contents |
| --- | --- |
| [Project overview](docs/START_HERE.md) | Research scope, analytical approach, and Ventura example |
| [Results](results/README.md) | Statewide and district estimates, validation files, and meal-source reviews |
| [Research status](docs/current_status.md) | Source-checked findings, corrections, and unresolved questions |
| [Lodi 2025–26 kindergarten meal review](studies/lodi_2025_26/README.md) | Verified 31-school tables, source snapshots, R reproduction, and QA for Angela's reporting and visualization |
| [2025–26 variable guide](docs/reading_2025_26_files.md) | File structure, fields, and missingness |
| [Denominator methods](docs/denominator_method_note.md) | Measurement assumptions and sensitivity specifications |
| [Calculation map](docs/repository_workflow.md) | Links between source files, scripts, checks, and outputs |
| [Documentation index](docs/README.md) | District analyses, source audits, and earlier work |
| [Source files and reproduction](data/README.md) | Input versions and commands |

## Main 2025–26 attendance estimate

```text
Estimated TK/K average daily attendance
    = TK/K Census Day enrollment − (combined TK/K days absent / 180)
```

The 180-day term is an assumed school-year benchmark; Census enrollment does not account for individual enrollment duration. Alternative specifications use cumulative enrollment or allocate grouped absences to grades. The [method note](docs/denominator_method_note.md) describes these choices and their limitations.

## Source-checked findings

As of the October 31, 2026 source review:

- **Statewide:** 6,165 non-placeholder school records had positive TK/K Census enrollment; 5,912 supported the combined attendance estimate.
- **Ventura:** [17 matched schools](results/2025_26/ventura_17_school_ada_validation.csv) have district-reported TK/K average daily attendance for comparison with the Census- and cumulative-based estimates.
- **Meal records:** The [2024–25 FNS10 analysis](results/README.md#202425-statewide-meal-claims) produces candidate meal-site/school links, not confirmed kindergarten-specific meal counts or a statewide kindergarten meal-participation rate.

See [research status](docs/current_status.md) and the [October 31 source audit](docs/independent_research_integrity_audit_2026_10_31.md) for corrections and evidentiary scope.

## Code and outputs

| Location | Contents |
| --- | --- |
| [`results/`](results/README.md) | Committed derived CSV and JSON files |
| [`scripts/`](scripts/) | 2025–26 extraction, verification, and matching scripts |
| [`R/`](R/) and [`RUN_ALL.R`](RUN_ALL.R) | Earlier 2024–25 analysis |
| [`tests/`](tests/) | Integrity and regression checks |
| [`data/`](data/README.md) | Source inventory and required input filenames |
| [`docs/`](docs/README.md) | Methods, district notes, audits, and historical decisions |

Original CDE and district inputs are managed separately. Committed `results/` files and new local `output/` runs should be compared using the documented source versions and processing steps.

*Statewide and earlier district findings were last checked October 31, 2026. The Lodi handoff and analysis were checked November 8, 2026.*
