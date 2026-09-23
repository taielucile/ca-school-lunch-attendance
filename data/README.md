# Raw data

Raw CDE files are intentionally excluded from version control.

Place the following exact files in `data/raw/` before running the pipeline:

| File | Role |
|---|---|
| `cdenroll2425.txt` | 2024–25 Census Day enrollment; individual TK and K counts |
| `absenteeismreason25-v2.txt` | 2024–25 Student Absenteeism by Reason; TK–K cumulative enrollment and absence days |
| `cbedsora24b.txt` | 2024–25 CBEDS; school calendar/program information including K/TK program type |

The pipeline treats suppression explicitly and does not convert suppressed values to zero.
