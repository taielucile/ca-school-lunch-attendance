# Lodi Unified K–5 meal comparisons

Preliminary research update for November 25, 2026. The analysis covers the 31 schools in Lodi's meal workbook matched to 2025–26 California Department of Education (CDE) school records.

## Results

For each grade, the pooled rates divide total reported meals across the matched schools by total modeled attended student-days for that grade and multiply by 100.

| Grade | Breakfasts per 100 modeled attended student-days | Lunches per 100 modeled attended student-days |
| --- | ---: | ---: |
| K | 24.6 | 70.9 |
| 1 | 28.9 | 74.0 |
| 2 | 28.8 | 75.0 |
| 3 | 29.6 | 78.8 |
| 4 | 28.1 | 75.6 |
| 5 | 25.9 | 75.3 |

Kindergarten had the lowest pooled breakfast and lunch rates. Within schools, kindergarten was below first grade at 20 schools for breakfast and 20 for lunch. It was below every grade from 1 through 5 at 10 schools for breakfast and 10 for lunch. School counts are separate for each meal.

[School-by-grade results](outputs/lodi_186_school_grade_absence_adjusted_rates.csv). The final report figures use the same rates, but match the Ventura styling and omit embedded titles and notes. See the reproduction instructions below. The earlier PDFs in `figures/` are archived pre-report drafts, not the report figures.

## Modeled attendance

At each school, multiply a grade's fall Census Day enrollment by 180 and subtract its allocated share of reported absence days. The share is that grade's Census enrollment divided by the Census enrollment in its CDE absence reporting group. The groups are TK/K, grades 1–3, and grades 4–6. TK and grade 6 enrollment enter the allocations. The figures display K–5.

The model assigns the same number of absence days per Census-enrolled student to grades in the same reporting group at a school. CDE absences cover eligible cumulative enrollment during the year. The allocation uses a fall enrollment snapshot. The ratios measure reported meals per modeled student-day and cannot identify the share of individual students receiving meals. In the combined figure, 1.0 is one reported breakfast or lunch per modeled attended student-day on average.

## Proposed district follow-up

Confirm which dates the breakfast and lunch counts cover. Request recorded K–5 attendance for those dates, in student-days by grade at each of the 31 schools. Ask where TK meals are reported, including whether some are in the Kindergarten totals. The source workbook has Preschool and Kindergarten categories with no separate TK category. Preschool counts are excluded from the figures. The meal reporting dates and TK coding remain unconfirmed.

## Reproduce

From the repository root, run the following with R, `ggplot2`, and Poppler (`pdftoppm`) installed.

```sh
Rscript studies/lodi_2025_26/code/render_lodi_figures.R
```

The script reads the [meal and enrollment inputs](outputs/lodi_31_school_grade_meal_census_for_R.csv) and [grouped absence inputs](outputs/lodi_31_school_absence_group_inputs_2025_26.csv) and checks all 558 archived rates and pooled grade totals, then writes three title-free PDFs, three 200-dpi PNGs, and `Lodi_K-5_Plot_Values.csv` to `lodi_r_rendered_figures/`. The earlier [R script](code/redraw_lodi_aligned_in_R.R) is retained for historical reproduction only. The absence input preserves the CDE source row references. The source counts come from the [team workbook](https://github.com/whippedfruit/Feed-California-Kinders/blob/main/Lodi/cleaned%20data/Lodi%20Data_copy.xlsx). See the [successful R run](https://github.com/taielucile/ca-school-lunch-attendance/actions/runs/45235444258) and [source QA](internal/QA_AND_OPEN_QUESTIONS.md) for provenance and the earlier kindergarten checks.

## Final report figure specification

| Figure | Output basename | Rate |
| --- | --- | --- |
| 1 | `01_Lodi_Breakfast` | Breakfasts per 100 estimated days of student attendance |
| 2 | `02_Lodi_Lunch` | Lunches per 100 estimated days of student attendance |
| 3 | `03_Lodi_Combined_Meals` | Breakfasts plus lunches per estimated day of student attendance |

All six grades are shown on each school row; points can overlap. Kindergarten is pink and grades 1–5 use five blues. Titles and methodological notes belong in the report, not in the image files. The figures are descriptive, not shares of individual students. Exact meal reporting dates and the transaction definition remain unconfirmed. The updated report requests attendance for the same dates as the meal records.

The three input CSV Git blob hashes were verified against the report reproduction package on November 25. An independent recalculation of all 558 plotted rates matched within 1e-10. The [dedicated R reproduction workflow](../../.github/workflows/lodi-report-figures.yml) executes the renderer, checks that all six exports exist, and archives the regenerated figures. The [original November 25 figure checksums](figures/FINAL_FIGURES_SHA256.txt) identify the exact delivered PDF and PNG files. The manifest records originals, not regenerated CI outputs; original binary files are not yet tracked. PDF metadata, fonts and rendering-library versions can differ across platforms, so regenerated bytes need not match these hashes.

## November 25 independent verification

All 31 report appendix rows were checked against the archived K rates (school names, breakfast and lunch counts, and rounded rates). No mismatches were found. Independent recalculation from the two matched input tables produced maximum absolute differences of 4.98e-14 for breakfast, 5.69e-14 for lunch, and 5.11e-15 for combined rates. The report now distinguishes pooled grade comparisons from within-school comparisons and requests recorded K–5 attendance for the meal-reporting period. Exact source dates, transaction definitions, and TK meal coding remain unresolved.
