# Source files

The original CDE and district files are not committed to this repository. The analyses use local copies in `data/raw/`, while the tables in [results](../results/README.md) are derived outputs.

## 2025–26 CDE attendance estimates

Only these two CDE files are needed to run `scripts/build_denominators_2526.py`:

| Put in `data/raw/` | Source |
| --- | --- |
| `cdenroll2526.txt` | [2025–26 Census Day enrollment](https://www3.cde.ca.gov/demo-downloads/census/cdenroll2526.txt) |
| `absenteeismreason26.txt` | [2025–26 Absenteeism by Reason](https://www3.cde.ca.gov/demo-downloads/attendance/absenteeismreason26.txt) |

These filenames and download locations are used in the [full-source GitHub Actions workflow](../.github/workflows/fck-2025-26-repro.yml). The source copies checked on October 30–31 have SHA-256 hashes:

- `cdenroll2526.txt`: `10d074101bc1aa3e9dc7433200a3825e430e261b1382e5c5f3102d989f4fa149`
- `absenteeismreason26.txt`: `59458d5a12a5c5e104633683f50c741e8d3a7e1e477fd12cc69192aee5581c0a`

These hashes identify the reviewed versions. If the downloads change, compare the new files with the source definitions before treating a rerun as equivalent.

From the repository root:

```sh
python scripts/build_denominators_2526.py \
  data/raw/cdenroll2526.txt \
  data/raw/absenteeismreason26.txt \
  output/2025_26
```

This writes a statewide school file, per-district school files, a district quality summary, and a source manifest to the chosen output folder. The script uses combined TK/K absence counts and an assumed 180-day year. It does not retrieve observed grade-specific attendance or any meal data.

The files already committed in [`results/2025_26/`](../results/README.md#district-files) also include district-specific selections, school/grade reshaping, Ventura comparisons, and workbook-review outputs. Those require additional processing beyond this single command. See the [district extract notes](../docs/district_denominators_2025_26.md) and [full-source execution record](../docs/verified_end_to_end_execution_2026_10_30.md).

## Checks without the original source files

From the repository root:

```sh
python -m unittest discover -s tests -p 'test_*2526.py' -v
```

These checks use small fixtures and committed audit outputs. The [full-source workflow](../.github/workflows/fck-2025-26-repro.yml) uses the original source files for the statewide rebuild.

## Earlier R workflow

`RUN_ALL.R` and `tests/test_pipeline.R` use the following inputs. They are a separate 2024–25 analysis, with some 2025–26 district records used for checks.

| Local filename | What it is |
| --- | --- |
| `cdenroll2425.txt` | [2024–25 CDE Census Day enrollment](https://www3.cde.ca.gov/demo-downloads/census/cdenroll2425.txt), including TK and K |
| `absenteeismreason25-v2.txt` | [2024–25 CDE Absenteeism by Reason](https://www3.cde.ca.gov/demo-downloads/attendance/absenteeismreason25-v2.txt), with TK/K grouped |
| `cbedsora24b.txt` | 2024–25 CBEDS school information; copied from `Statewide/CA_sites_cbedsora24b.txt` in the [team source repository](https://github.com/whippedfruit/Feed-California-Kinders) and renamed locally |
| `cdenroll2526.txt` | 2025–26 Census Day enrollment, also used above |
| `irvine_k_pk_attendance_2025_11_03_07.csv` | Irvine school-by-grade attendance for November 3–7, 2025, in the team's `Irvine/extracted data/` folder |
| `lodi_kindergarten_enrollment_measures_2025_26.csv` | Lodi kindergarten eligibility measures for July 29, 2025–May 29, 2026, in the team's `Lodi/extracted data/` folder |

Place those files in `data/raw/` with the names shown, then run:

```sh
Rscript RUN_ALL.R
Rscript tests/test_pipeline.R
```

The Lodi module uses the R packages `dplyr`, `readr`, and `stringr`. The [full-source workflow](../.github/workflows/fck-2025-26-repro.yml) shows how its source copies were obtained and checked in October 2026.

The Irvine attendance CSV has 30 Kindergarten and 28 PK/TK rows; the district uses “PK” for the program formerly known as TK. Its five school days are not an annual attendance denominator. The Lodi eligibility extract has 31 Kindergarten schools; its `Highest Eligible` and `Last Day` values both total 3,481. Those measures are not observed annual attendance. The separate **35-school Lodi file** under `results/2025_26/` comes from the statewide CDE school-level TK/K extract and should not be confused with this district eligibility report.

## Meal files and district attendance records

These source files are used in separate audits and comparisons. They are not inputs to the basic public CDE estimate above.

- **2024–25 statewide FNS10:** `Statewide/DR-20260729-160143 EXT_PRA_Penner_SNP_FNS10Meals.xlsx` in the team repository, read together with `Statewide/CA_sites_cbedsora24b.txt`. See the [FNS10 review](../docs/fns10_cde_linkage_review_2026_10.md) for the source matching rules and limits.
- **Ventura observed attendance:** `Ventura Unified/extracted data/Ventura 8:13:2025 - 6:4:2026 ADA clear_copy.xlsx` in the team repository. The [17-school comparison](../results/2025_26/ventura_17_school_ada_validation.csv) excludes Homestead, which has no positive-TK/K Census match.
- **Elk Grove and Ontario-Montclair:** `Elk Grove Meal and Attendance Data.xlsx` and `Ontario-Montclair Meal and Attendance Data.xlsx` are supplied research workbooks reviewed in the [October 31 source audit](../docs/elk_grove_ontario_montclair_new_sources_2026_10_31.md). Their detailed school-grade meal extracts are not committed here.

Other district meal sources and their reporting periods are listed in the [district meal-file inventory](../docs/meal_source_district_coverage_audit_2026_10_30.md).

These source files do not all measure the same thing. Check the grade, reporting dates, school identifier, and whether a field counts meals, students, attendance, or meal average daily participation before comparing them. CDE suppressed values are missing, not zeros.
