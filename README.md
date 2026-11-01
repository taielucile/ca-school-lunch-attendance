# California School Meals and Attendance

This repository contains the code, data extracts, and notes from my work on Feed California Kinders. I’ve been looking at how California’s public enrollment and absenteeism data can be used to estimate attendance in transitional kindergarten (TK) and kindergarten (K), and how those estimates compare with the records districts have provided.

## Why attendance is difficult to measure

California publishes Census Day enrollment and annual absence totals, but the public files do not give us the total number of days each TK/K student was expected to attend. Enrollment on one day is not the same as enrollment throughout the year.

The main estimate used here is:

```text
Estimated TK/K average daily attendance
    = Census Day TK/K enrollment − (TK/K absence days / 180)
```

The 180 days are an assumption. The absence data combine TK and K, so the separate grade estimates in some files also require an assumption about how absences are distributed between grades. None of these calculations should be mistaken for recorded grade-level attendance.

## Work in the repository

- **2024–25:** Compared Census-based and cumulative-enrollment-based attendance estimates for Irvine and Lodi. Both depend on assumptions about how long students were enrolled.
- **2025–26:** Built school-level attendance estimates from California Department of Education (CDE) enrollment and absenteeism files. The [district notes](docs/district_denominators_2025_26.md) explain which schools have usable data and how missing records are handled.
- **Ventura:** Compared the 2025–26 estimate with reported TK/K average daily attendance for 17 matched schools. The [Ventura review](docs/ventura_tkk_ada_validation_2026-10.md) includes the school-by-school results.
- **District meal files:** Checked the school, grade, and date information in the available files, including Elk Grove and Ontario-Montclair. Some records are useful for comparison; others still need clarification before meals and attendance can be combined.
- **Statewide meal claims:** Reviewed 2024–25 FNS10 breakfast and lunch claims and prepared possible matches between meal-service sites and CDE schools. Those matches still need confirmation. FNS10 does not report kindergarten meals separately.

The [documentation index](docs/README.md) links to the methods, data sources, and individual checks.

## Where to find things

| Folder | Contents |
| --- | --- |
| [`R/`](R/) | Original R analyses, including the Irvine and Lodi work |
| [`scripts/`](scripts/) | Data preparation and source checks, mostly for 2025–26 |
| [`results/2024_25/`](results/2024_25/) | FNS10 site-matching review files |
| [`results/2025_26/`](results/2025_26/) | Attendance estimates, district extracts, and source checks |
| [`docs/`](docs/README.md) | Methods, source notes, validation, and earlier project materials |
| [`tests/`](tests/) | Tests for data processing and reproducibility |

The original CDE and district files are kept outside the repository. Their filenames and uses are listed in [data/README.md](data/README.md).

## Running the analyses

With the required original files in `data/raw/`, the 2024–25 R workflow and tests can be run with:

```sh
Rscript RUN_ALL.R
Rscript tests/test_pipeline.R
```

The Lodi R module also requires the `dplyr`, `readr`, and `stringr` packages.

For the 2025–26 CDE extract:

```sh
python scripts/build_denominators_2526.py \
  data/raw/cdenroll2526.txt \
  data/raw/absenteeismreason26.txt \
  output/2025_26
```

The Python tests that do not require the original source files can be run separately:

```sh
python -m unittest discover -s tests -p 'test_*2526.py' -v
```

Passing those tests does not replace a check against the complete source files. The [October 30 execution record](docs/verified_end_to_end_execution_2026_10_30.md) and [October 31 source audit](docs/independent_research_integrity_audit_2026_10_31.md) describe what was checked and what remains unresolved.

The distinction to keep in mind when using these files is simple: meal counts are not student counts, meal average daily participation is not school attendance, and modeled attendance is not observed attendance. The school, grade, year, and reporting period must line up before a meal rate can be calculated.
