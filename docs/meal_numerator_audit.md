# Meal numerator audit

## Target and interpretation

A meal-per-student-day measure requires meal counts and attendance aligned by date, school, and grade. Breakfast and lunch remain separate. The resulting aggregate is meals per attending student-day; it is not a count of unique students unless the source confirms one meal per student per service and excludes seconds or duplicate transactions.

## Irvine five-day source audit

The companion [Feed California Kinders repository](https://github.com/whippedfruit/Feed-California-Kinders/tree/7d6c3824b4beb3fcc89f9d4ff2eb6908da38a443/Irvine) contains daily Meals Served PDFs for November 3–7, 2025 and the K/PK attendance source PDFs. I extracted the school-grade-session rows from the five daily reports and matched the district labels to the existing attendance CSV. This was a manual PDF-to-text extraction and audit in the verification workspace: the source PDFs are in the companion repository, but this repository does not yet contain a parser or derived school-day-grade numerator file. The reported aggregates therefore cannot yet be rebuilt from this repository alone. IUSD states that its Pre-Kindergarten (PK) replaced the former Transitional Kindergarten (TK) program, supporting the PK/TK alignment for this district.

**Extraction checks**

- The five PDFs contain 466, 471, 469, 468, and 470 item rows. The sum of extracted `Total Quantity` across all grades matches each report's printed total: 15,512; 15,543; 15,454; 16,032; and 16,136.
- The TK/K extraction has 500 school-grade-session rows and no duplicate school-date-grade-meal combinations.
- The meal reports cover 29 K campuses and 28 PK/TK campuses. The attendance extract has 30 K and 28 PK/TK schools. The only K attendance school without a meal-report site is IUSD Virtual Academy Elementary, with five student-days; it is excluded from the campus-based matched sample rather than recoded to zero meals.
- Four school-name variants were normalized to the attendance roster: Beacon Park School/Beacon Park K-8; Cadence Park School/Cadence Park K-8; Solis Park K-8 School/Solis Park K-8; Vista Verde School/Vista Verde K-8.
- The meal reports contain no row for 70 of 570 possible matched school-grade-day-meal combinations: 26 K breakfasts, 34 PK/TK breakfasts, and 10 PK/TK lunches. The rows appear to be a transaction listing, but the available report does not explicitly define whether an omitted combination means zero served or missing data. The calculations below therefore remain conditional on omissions meaning zero.

## Provisional aggregate results

| Grade group | Matched attendance student-days | Breakfast quantity | Breakfast per student-day | Lunch quantity | Lunch per student-day |
|---|---:|---:|---:|---:|---:|
| Kindergarten | 8,698 | 1,729 | 19.88% | 2,915 | 33.51% |
| IUSD PK/TK | 5,401 | 949 | 17.57% | 1,108 | 20.51% |
| Combined matched campuses | 14,099 | 2,678 | 18.99% | 4,023 | 28.53% |

These figures treat absent report rows as zero quantities. They are short-window descriptive estimates for November 3–7, 2025, not annual meal take-up rates. The matched-campus denominator excludes IUSD Virtual Academy and includes all 28 PK/TK attendance sites.

## Checks needed before treating these as results

1. Confirm that `Total Quantity` for `Breakfast Meal` and `Lunch Meal` means meals served (or reimbursable meals claimed) and whether one unit is one meal.
2. Confirm that school-grade-session combinations omitted from these transaction reports represent zero meals rather than missing exports.
3. Confirm that PK reporting applies to the same IUSD PK/TK students included in attendance. The district's public program description supports the name mapping, but the report's row semantics still need confirmation.
4. Keep the campus-based primary sample separate from Rio Valley's homeschool/independent-study model unless meal location and target population can be aligned.

No annualization, FRPM-based imputation, or combination of breakfast and lunch is used. The 2024–25 annual public-data denominator analysis remains separate.
