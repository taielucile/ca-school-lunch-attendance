# Ontario-Montclair: monthly meal / ADP reporting-period consistency check
**Internal descriptive QA | 31 October 2026 | source: user-uploaded 2025–26 workbook**

## Question

Can the workbook's monthly reported Breakfast, Lunch and Supper quantities be treated as measured over exactly the same service days used in the **average daily participation (ADP)** columns in `Source ADA ADP`?

**No, not on the existing evidence.** This is a new consistency finding that strengthens the earlier caution about schoolwide ADA versus grade-specific attendance.

## How the check works

For each of the **32** school blocks, **10 months (August 2025–May 2026)** and **three meal types**, compare:

```
Q_month,meal = [the Source meals school/month TOTAL] / [corresponding Source ADA ADP value]
Q_gradeonly = [school/month TOTAL minus the STUDENTS EXITED row] / [same ADP]
```

The quotients are **diagnostic ratios**; they are **not observed school days**, attendance days, distinct children, or participation rates. An approximate service-day interpretation would require an ADP definition and identical eligible populations, dates, and accounting conventions.

All **960 school × month × meal-type** source combinations were present. The workbook's school/month TOTAL values reconcile arithmetically to the sum of explicitly labeled grade rows plus `STUDENTS EXITED`. The check uses the correct matching month and meal-type columns in *both* original source sheets. A separate diagnostic, `Q_gradeonly`, tests whether removing `STUDENTS EXITED` explains anomalies. It does **not**.

### Main result

| Month / meal type | Calendar weekdays | Median total / ADP | Median grade-only / ADP | Schools where grade-only quotient exceeds weekdays by over 0.5 |
| --- | ---: | ---: | ---: | ---: |
| Sep 2025 Breakfast | 22 | 22.52 | 22.50 | 16 of 32 |
| Sep 2025 Lunch | 22 | 22.84 | 22.83 | 26 of 32 |
| Nov 2025 Breakfast | 20 | 26.03 | 26.03 | **32 of 32** |
| Nov 2025 Lunch | 20 | 26.02 | 26.01 | **32 of 32** |
| Nov 2025 Supper | 20 | 25.97 | 25.97 | **32 of 32** |
| Feb 2026 Lunch | 20 | 18.85 | 18.83 | 0 of 32 |
| Mar 2026 Lunch | 22 | 21.00 | 20.76 | 1 of 32 |

**November's result is especially important:** 26 implied days across all school/meal combinations despite only 20 Monday–Friday dates in November 2025, *even after* excluding `STUDENTS EXITED`. This cannot be interpreted as straightforward one-meal-per-student-per-instructional-day school service for that named calendar month. It does **not** independently determine whether the meal totals, ADP, reported month label, or definition of coverage is at issue.

Some large February–May anomalies disappear when the `STUDENTS EXITED` category is excluded, making its definition another specific question for the district. The 17 previously identified school-month discrepancies in the Supper-related **ADA** column remain distinct from this new **ADP/monthly quantity** inconsistency.

## Interpretation boundaries

- A calendar's weekdays are an *upper reference for ordinary Monday–Friday school service*, **not an independently confirmed number of district instructional days**; school closures could reduce exposure. Non-school-day food programs or different accounting rules could change the relationship.
- `ADP` may not be computed using the same numerator, student population, or month as the printed grade/source meal totals. Do **not** solve for instructional days by dividing one field by another.
- Even if the monthly ADP fields reconcile, the accompanying `ADA` values describe **whole-school attendance**, not TK/K grade-level attending students or days.
- Source totals under the meal headings include `STUDENTS EXITED` values with an **undefined** meaning. Their inclusion or exclusion must be explicitly documented; they are **not** independently verified distinct children or reimbursable meals.
- This audit uses only the **2025–26 Ontario-Montclair upload**; it does not change the separate **2024–25 FNS10** matching request, school-year alignment, or the public CBEDS schedule-classification plan.

## Reproduction

`scripts/diagnose_ontario_month_ADP_2526.R` reads the locally held original upload via `readxl`, matches source school × month × meal type, checks November by assertion and writes a 30-row aggregate summary plus an **internal** school/month diagnostic.

`results/2025_26/ontario_adp_monthly_consistency_summary_review_only.csv` contains the complete **30 month × meal-type summaries** only; it does not disclose the underlying school-level quantities. Its columns record both the full-source TOTAL/ADP and grade-only/ADP values, counts of quotients exceeding the weekday reference, and maxima. It is **diagnostic metadata, not a denominator dataset**.

## Questions requiring source clarification before any rate computation

1. How was **ADP** calculated for Breakfast, Lunch and Supper (exact numerator, divisor, service dates and treatment of `STUDENTS EXITED`)?
2. What does the month **NOVEMBER** in each original source sheet mean? Were the printed meal totals and ADP calculated over the same actual window?
3. Are the grade rows and `STUDENTS EXITED` category additive service quantities or different report populations?
4. Can the district provide **TK and K attended student-days by school and month**, rather than schoolwide ADA, plus instructional/service days, to align with monthly grade-specific meal counts?

**Decision: Not rate-ready.** Preserve the monthly descriptive meal counts with their report labels. Do not infer a service-day denominator or recalculate 'corrected participation' from these inconsistent source measures.
