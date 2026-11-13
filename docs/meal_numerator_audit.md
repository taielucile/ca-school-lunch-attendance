# Meal numerator audit

## Target and interpretation

A meal-per-student-day measure requires meal counts and attendance aligned by date, school, and grade. Breakfast and lunch remain separate. The resulting aggregate is meals per attending student-day; it is not a count of unique students unless the source confirms one meal per student per service and excludes seconds or duplicate transactions.

## Irvine five-day source audit

The [team source snapshot](https://github.com/whippedfruit/Feed-California-Kinders/tree/50d75bbaf1d5565014f5e7303de154ec9e198eaf/Irvine) contains the five daily Meals Served PDFs and the K/PK attendance extract. The [Irvine audit script](../scripts/audit_irvine_meal_reports.py) parses the PDFs with Poppler's `pdftotext`, reconciles all-grade report totals, joins K/PK rows by school, grade, and date, and writes a sensitivity summary. IUSD states that its Pre-Kindergarten (PK) replaced the former Transitional Kindergarten (TK) program, supporting the label mapping while leaving the export population to be confirmed.

From this repository's root, with the team snapshot available locally:

```sh
python scripts/audit_irvine_meal_reports.py /path/to/team/Irvine \
  '/path/to/team/Irvine/extracted data/irvine_k_pk_attendance_2025_11_03_07.csv' \
  output/tables/irvine_five_day_meal_report_audit.csv
```

**Extraction checks**

- The five PDFs contain 466, 471, 469, 468, and 470 item rows. The sum of extracted `Total Quantity` across all grades matches each report's printed total: 15,512; 15,543; 15,454; 16,032; and 16,136.
- The TK/K extraction has 500 school-grade-session rows and no duplicate school-date-grade-meal combinations.
- The meal reports cover 29 K campuses and 28 PK/TK campuses. The attendance extract has 30 K and 28 PK/TK schools. The only K attendance school without a meal-report site is IUSD Virtual Academy Elementary, with five student-days; it is excluded from the campus-based matched sample rather than recoded to zero meals.
- Four school-name variants were normalized to the attendance roster: Beacon Park School/Beacon Park K-8; Cadence Park School/Cadence Park K-8; Solis Park K-8 School/Solis Park K-8; Vista Verde School/Vista Verde K-8.
- The meal reports contain no row for 70 of 570 possible matched school-grade-day-meal combinations: 26 K breakfasts, 34 PK/TK breakfasts, and 10 PK/TK lunches. The rows appear to be a transaction listing, but the available report does not explicitly define whether an omitted combination means zero served or missing data. The calculations below therefore remain conditional on omissions meaning zero.

## What IUSD's meal-count documentation establishes

IUSD's published [2025–26 Nutrition Services Data Confirmation](https://iusd.org/sites/default/files/documents/2025-26%20Nutrition%20Services%20Data%20Confirmation.pdf) says the district records meal counts at point of service and consolidates counts by service date and site. It describes duplicate-PIN prevention for first meals and says second meals, adults' meals, a la carte sales, and damaged meals are separately tracked; second meals are not claimed for reimbursement. This supports interpreting the reports as operational meal-service data, but it does **not** establish that this particular `Total Quantity` export includes only reimbursable first meals or specifies how zero-count combinations are exported. The document is districtwide policy documentation for 2025–26, not a data dictionary for the five extracted reports.

Accordingly, retain the zero-row and quantity/unit assumptions below until the report's export definition is confirmed. The provisional counts are meal-report quantities per attendance student-day, not yet verified reimbursable first meals per student-day.

## Provisional aggregate results

| Grade group | Matched attendance student-days | Breakfast quantity | Breakfast per student-day | Lunch quantity | Lunch per student-day |
|---|---:|---:|---:|---:|---:|
| Kindergarten | 8,698 | 1,729 | 19.88% | 2,915 | 33.51% |
| IUSD PK/TK | 5,401 | 949 | 17.57% | 1,108 | 20.51% |
| Combined matched campuses | 14,099 | 2,678 | 18.99% | 4,023 | 28.53% |

These figures treat absent report rows as zero quantities. They are short-window descriptive estimates for November 3–7, 2025, not annual meal take-up rates. The matched-campus denominator excludes IUSD Virtual Academy and includes all 28 PK/TK attendance sites.

### Sensitivity to omitted meal rows

| Combined campus sample | Report quantity | Attendance days across all slots | Attendance days on slots with a report row | Quantity per 100 attendance days across all slots | Quantity per 100 attendance days on reported slots |
| --- | ---: | ---: | ---: | ---: | ---: |
| Breakfast | 2,678 | 14,099 | 10,937 | 18.99 | 24.49 |
| Lunch | 4,023 | 14,099 | 13,634 | 28.53 | 29.51 |

The all-slot calculation assumes the unlisted quantities are zero. The reported-slot calculation changes the population to the school-grade-date combinations with a row for that meal. It cannot recover the full-sample rate if omitted quantities are missing. Both calculations use recorded daily attendance and retain the November 3–7 window.

## Checks needed before treating these as results

1. Confirm the field definition and scope of `Total Quantity` for `Breakfast Meal` and `Lunch Meal`, including whether it is first meals only, includes second meals, and whether one unit is one served meal.
2. Confirm that omitted school-grade-session combinations represent zero meals rather than missing export rows.
3. Confirm that PK reporting applies to the same IUSD PK/TK students included in attendance. The district's public program description supports the name mapping, but the report's row semantics still need confirmation.
4. Keep the campus-based primary sample separate from Rio Valley's homeschool/independent-study model unless meal location and target population can be aligned.

No annualization, FRPM-based imputation, or combination of breakfast and lunch is used. The 2024–25 annual public-data denominator analysis remains separate.
