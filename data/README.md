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

The Irvine attendance CSV contains 58 school-grade rows: 30 Kindergarten and 28 PK/TK. The district reports identify PK as Pre-Kindergarten; Irvine program documentation identifies Pre-Kindergarten as the program formerly known as Transitional Kindergarten. The pipeline therefore combines PK/TK and K for the short-window Irvine validation.

The 2025–26 Irvine comparison is a five-day validation check, not an annual denominator. It must not be annualized and treated as observed full-year student-days.

The pipeline treats CDE suppression explicitly and does not convert suppressed values to zero.
