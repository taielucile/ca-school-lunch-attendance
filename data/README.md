# Raw data

Raw CDE and district source files are intentionally excluded from version control.

Place the following exact files in `data/raw/` before running the full pipeline:

| File | Role |
|---|---|
| `cdenroll2425.txt` | 2024–25 Census Day enrollment; individual TK and K counts |
| `absenteeismreason25-v2.txt` | 2024–25 Student Absenteeism by Reason; combined TK–K eligible cumulative enrollment and absence days |
| `cbedsora24b.txt` | 2024–25 CBEDS; K/TK program classifications |
| `cdenroll2526.txt` | 2025–26 Census Day enrollment used for the same-year Irvine district-attendance check |
| `irvine_k_pk_attendance_2025_11_03_07.csv` | Transcribed Irvine K and PK/TK daily attendance for November 3–7, 2025 |
| `lodi_kindergarten_enrollment_measures_2025_26.csv` | Extracted Lodi Kindergarten `Highest Eligible` and `Last Day` measures for the 7/29/2025–5/29/2026 eligibility period |

The Irvine attendance CSV contains 58 school-grade rows: 30 Kindergarten and 28 PK/TK. The district reports identify PK as Pre-Kindergarten; Irvine program documentation identifies Pre-Kindergarten as the program formerly known as Transitional Kindergarten. The pipeline therefore combines PK/TK and K for the short-window Irvine validation.

The 2025–26 Irvine comparison is a five-day validation check, not an annual denominator. It must not be annualized and treated as observed full-year student-days.

The pipeline treats CDE suppression explicitly and does not convert suppressed values to zero.


## Lodi Kindergarten eligibility-report extract

The Lodi extract contains 31 schools. The source report is filtered to Kindergarten and the July 29, 2025–May 29, 2026 eligibility date range. It reports both `Highest Eligible` and `Last Day`; the latter is defined in the source as the number of enrolled students on the last day of the selected date range.

Both fields total 3,481 and are identical school-by-school in the extracted report. They are retained for source triangulation, not treated as observed expected or attended student-days. The raw extract is excluded from version control with the other source data.
