# District meal-source coverage audit — October 30, 2026

## What was checked

Compared the **current `main` tree** of the shared team repository, `whippedfruit/Feed-California-Kinders`, against the 2025–26 CDE denominator extracts in this branch. This is an inventory of **visible named files**, not a claim that all nutrition records are usable or that their service periods and grade definitions align.

## Districts with identified meal-source files

| District | Meal-source evidence in shared repository | TK/K Census school records | Calculable TK/K estimates | 2025–26 extract status |
| --- | --- | ---: | ---: | --- |
| Lodi Unified | `Lodi/cleaned data/Lodi Data_copy.xlsx`; district analysis | 35 | 34 | Complete source-backed extract; 27-school earlier version superseded |
| Ventura Unified | `Ventura Unified/extracted data/Ventura Meal clear_copy.xlsx` | 17 | 17 | Complete; observed ADA comparison and Angela integration tested |
| Irvine Unified | `Irvine/Meals Served 2025.11.03.pdf` through `11.07.pdf` | 31 | 30 | Extract exists; meal data cover only a five-day window |
| Ojai Unified | `Ojai Unified/raw data/Ojai Meal Totals 25-26 copy.xlsx` | 5 | 5 | Extract exists; one source documents 172 vs 180 instructional days |
| Chino Valley Unified | `Chino/July 2025 to March 2026 - Meals by School & Grade.xls` | 24 | 24 | **Added by follow-up:** extract from official statewide school table |
| Davis Joint Unified | `Davis Joint Unified/raw data/Davis Joint Unified Meal cleaned_copy.xlsx` | 11 | 9 | **Added by follow-up:** extract from official statewide school table |
| Oak Park Unified | `Oak Park Unified/raw data/Oak Park Meals served by grade 12.20.25-6.30.26_copy.pdf` | 3 | 3 | **Added by follow-up:** extract from official statewide school table; partial-year window |
| Elk Grove Unified | No clearly identified named district meal file in current shared repository tree | 47 | 44 | Extract exists; **meal-source status unverified** |
| Ontario-Montclair | No clearly identified named district meal file in current shared repository tree | 26 | 26 | Extract exists; **meal-source status unverified** |

**Caution:** This file inventory does not establish whether the Chino workbook is actually school-grade-meal data for the same calendar period, or whether Davis and Oak Park contain usable TK/K numerators. The meal-source classification must be checked by reading workbook fields and reporting dates. Also, file names are not proof that the source includes a full school year.

**Denominator coverage for all nine listed districts:** 199 TK/K Census school records, 192 calculable combined TK/K proxies, 7 missing or suppressed. The three newly identified meal-source districts contribute 38 records and 36 calculable proxies. The nine-district group includes two districts with **unverified** meal-source coverage and should not be called nine matched meal/attendance districts.

## Rebuild

```sh
python scripts/build_denominators_2526.py \
  data/raw/cdenroll2526.txt \
  data/raw/absenteeismreason26.txt \
  output/full

python scripts/extract_additional_meal_districts_2526.py \
  output/full/school_denominator_proxies_2025_26.csv \
  output/additional
```

The extractor requires exact county–district CDS identifiers and asserts each school name's district. It writes wide school files, long TK/K/grade-1 sensitivity files, and an additional-district quality summary. The GitHub Actions full-source workflow checks **Chino 24/24**, **Davis 11/9**, and **Oak Park 3/3** against the source-wide output.

## Before Angela or Dr. Penner use these as denominators

1. Check the **exact school and grade coverage** of each meal workbook. Schoolwide totals are not TK/K meals.
2. Align meal service periods with attendance periods. The 180-day assumption is a **full-year model**, not a valid denominator for a five-day or partial-year meal window without additional attendance information.
3. Verify calendars and program classifications from CBEDS, particularly half-day versus full-day kindergarten and charter/independent-study programs.
4. Treat TK and K separately allocated absence estimates, and grade 1 allocated from GR13, as **sensitivity assumptions**, not measured grade-specific ADA.
5. Do not join 2024–25 statewide FNS10 meals to 2025–26 denominators and call the resulting ratio participation.
6. Seek official sponsor/site identifiers or a site-to-CDS crosswalk for unresolved statewide FNS10 links. Name similarity alone does not establish an administrative match.

## Status

This audit corrects the earlier six-district coverage claim and prepares three additional district extracts. It does **not** claim a finished nine-district meal participation analysis. Verify the latest Actions run and extract commit before sharing these files.
