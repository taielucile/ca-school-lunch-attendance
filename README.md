# California school meals and attendance

**Attendance denominator estimates and source checks for Feed California Kinders**

This repository documents one part of the [Feed California Kinders project](https://github.com/whippedfruit/Feed-California-Kinders): using California school enrollment and absence records to estimate how many transitional kindergarten (TK) and kindergarten (K) students attend school each day, and checking those estimates against district records when possible.

**Why this matters:** Comparing school meals with attendance requires a denominator that represents the same children, schools, and time periods as the meal records. Public statewide enrollment and absence files do not directly supply annual TK/K attended days by school and grade. The calculations here are therefore **estimates, not observed annual attendance**.

This is a **research record for readers**, not a collaboration or task-assignment hub. You can follow the findings and calculations without running any code. The repository is currently **private**, so GitHub access is required to browse it.

## Find what you need

| I want to… | Open |
| --- | --- |
| Understand the project and see an example | **[Start here: reader's guide](docs/START_HERE.md)** |
| Know what is verified, corrected, or unresolved | [Current research status](docs/current_status.md) |
| Find the statewide or a district CSV | **[Results and file index](results/README.md)** |
| Understand CSV columns and missing values | [2025–26 file guide](docs/reading_2025_26_files.md) |
| Trace a calculation from source to result | [Calculation map](docs/repository_workflow.md) |
| Understand denominator assumptions | [Method note](docs/denominator_method_note.md) |
| Find source data and run commands | [Data and reproduction guide](data/README.md) |

## The basic calculation

For the **2025–26 combined TK/K** estimate:

```text
Estimated students attending per day
= TK/K Census Day enrollment − (combined TK/K days absent ÷ 180)
```

The 180-day year is an **assumption**, not the verified calendar or enrollment duration of every student. Census enrollment counts students on one day. The alternative uses eligible cumulative enrollment, which also does not measure how many days each student was enrolled. Some files allocate combined absence totals across TK, K, and first grade: those **grade-specific estimates are modeled**, not reported attendance.

The [reader's guide](docs/START_HERE.md#how-to-read-an-estimate) includes a worked example.

## What the current results support

- **Statewide, 2025–26:** After excluding administrative placeholder school codes, 6,165 school-level records have positive TK/K Census enrollment; 5,912 have enough absence information for the combined estimate.
- **Ventura:** The 17-school comparison tests the estimates against district-reported TK/K average daily attendance. It does **not** establish statewide accuracy.
- **Meal records:** The separate 2024–25 FNS10 work creates potential meal-site-to-school name matches for review, not confirmed links or kindergarten-specific meal counts.

**No statewide kindergarten meal-participation rate has been established from these sources.** Meal counts and attendance denominators must align by school, grade, dates, and definition before being combined.

These claims reflect the [October 31, 2026 source review](docs/current_status.md). This navigation was revised November 3, 2026; no new analysis is implied.

## Repository layout

| Location | Contents |
| --- | --- |
| [`results/`](results/README.md) | Committed CSVs for statewide and selected districts, validation, and source audits |
| [`docs/`](docs/README.md) | Reader's guide, methodology, decisions, and dated audit notes |
| [`data/`](data/README.md) | Source-file inventory and input instructions; original CDE and district files are **not** committed |
| [`scripts/`](scripts/) | Python and R programs for recent extracts and checks |
| [`R/`](R/) and [`RUN_ALL.R`](RUN_ALL.R) | Earlier R analysis workflow |
| [`tests/`](tests/) | Reproduction and integrity checks |
| [`output/`](output/) | Directories for local reruns; the committed reviewed files are in `results/` |

The [documentation index](docs/README.md) separates current explanations from historical working notes. Older findings are retained for traceability, but the [current status](docs/current_status.md) and dated source audits take precedence for corrected results.

*Original district materials may be held separately in project files and require permission; this repository does not redistribute restricted source workbooks.*
