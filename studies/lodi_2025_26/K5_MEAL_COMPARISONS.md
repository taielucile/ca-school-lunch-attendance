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

[School-by-grade results](outputs/lodi_186_school_grade_absence_adjusted_rates.csv) · [Breakfast figure](figures/01_breakfast_absence_adjusted_R.pdf) · [Lunch figure](figures/02_lunch_absence_adjusted_R.pdf) · [Combined figure](figures/03_combined_absence_adjusted_R.pdf)

## Modeled attendance

At each school, multiply a grade's fall Census Day enrollment by 180 and subtract its allocated share of reported absence days. The share is that grade's Census enrollment divided by the Census enrollment in its CDE absence reporting group. The groups are TK/K, grades 1–3, and grades 4–6. TK and grade 6 enrollment enter the allocations. The figures display K–5.

The model assigns the same number of absence days per Census-enrolled student to grades in the same reporting group at a school. CDE absences cover eligible cumulative enrollment during the year. The allocation uses a fall enrollment snapshot. The ratios measure reported meals per modeled student-day and cannot identify the share of individual students receiving meals. In the combined figure, 1.0 is one reported breakfast or lunch per modeled attended student-day on average.

## Proposed district follow-up

Confirm which dates the breakfast and lunch counts cover. Request recorded K–5 attendance for those dates, in student-days by grade at each of the 31 schools. Ask where TK meals are reported, including whether some are in the Kindergarten totals. The source workbook has Preschool and Kindergarten categories with no separate TK category. Preschool counts are excluded from the figures. The meal reporting dates and TK coding remain unconfirmed.

## Reproduce

From the repository root, run the following with R and `ggplot2` installed.

```sh
Rscript studies/lodi_2025_26/code/redraw_lodi_aligned_in_R.R
```

The script reads the [meal and enrollment inputs](outputs/lodi_31_school_grade_meal_census_for_R.csv) and [grouped absence inputs](outputs/lodi_31_school_absence_group_inputs_2025_26.csv) and writes the CSV and figures to `lodi_r_rendered_figures/`. The absence input preserves the CDE source row references. The source counts come from the [team workbook](https://github.com/whippedfruit/Feed-California-Kinders/blob/main/Lodi/cleaned%20data/Lodi%20Data_copy.xlsx). See the [successful R run](https://github.com/taielucile/ca-school-lunch-attendance/actions/runs/45235444258) and [source QA](internal/QA_AND_OPEN_QUESTIONS.md) for provenance and the earlier kindergarten checks.
