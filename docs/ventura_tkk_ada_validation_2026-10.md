# Ventura TK/K ADA comparison (2025–26)

**Status:** Rebuilt from the district's attendance workbook and the official 2025–26 CDE Census and Absenteeism by Reason files. All 17 matched schools reproduce the published numeric values and closer-proxy classifications. The statewide district comparison is a separate analysis.

## Design

Compare three 2025–26 school-level proxies against **observed combined TK/K ADA** for **17 matched Ventura schools**, joined by CDS code. Homestead is excluded from the validated set. The target is TK/K **average daily attendance**, not a meal-participation rate. The comparison does not validate separate TK and K attendance because the public CDE `GRTKKN` absence band combines the grades.

With `D=180`, the candidate quantities are:

- **P0:** Census TK/K enrollment (no absence adjustment).
- **P1:** Census TK/K enrollment − combined TK/K absence days / 180.
- **P2:** eligible cumulative TK/K enrollment − combined TK/K absence days / 180.

These are assumptions about annual exposure; they are not observed student-specific expected attendance days.

## Reproduced matched-school totals

| Measure | ADA / proxy | Relative difference from observed |
| --- | ---: | ---: |
| Observed TK/K ADA | 1,179.14 | reference |
| P1: absence-adjusted Census | 1,186.06 | +0.59% |
| P2: absence-adjusted cumulative | 1,236.06 | +4.83% |
| P0: unadjusted Census | 1,263.00 | +7.11% |

P1 is closer at **13** schools, P2 at **2**, and the proxies tie at **2**. The aggregate P1 difference is `(1186.06 / 1179.14 - 1) * 100 ≈ 0.587%`; rounding conventions explain the reported +0.59% / +0.6% descriptions.

## Limits and decisions

This is a single district, a single school year, and a small matched sample. It does **not** validate statewide or 2024–25 estimates, does not identify separate TK/K grade-specific exposure, and does not validate meal numerator alignment. It cannot establish P1 as universally best. The assumed 180 days, entry/exit timing, and potentially different attendance and Census populations remain limitations. Observed combined TK/K ADA divided by TK/K Census enrollment ranges from **90.37% to 96.23%** across the 17 schools. None falls below 75% using that definition. The older note mentions four low-exposure outliers without giving their school or grade keys or the exposure formula. They could not be reconciled to this comparison and are not grounds for excluding rows.

## Reproduce from source

Use the [official CDE downloads and checksums](../data/README.md#202526-cde-attendance-estimates) and the [team ADA workbook](https://github.com/whippedfruit/Feed-California-Kinders/tree/50d75bbaf1d5565014f5e7303de154ec9e198eaf/Ventura%20Unified/extracted%20data) named `Ventura 8:13:2025 - 6:4:2026 ADA clear_copy.xlsx` (SHA-256 `858457fa80dc5d539a551993dd59ec491153230c0c9838561f19f5a9db255782`). The workbook stays in the team repository.

Run with Python and `openpyxl` installed:

```sh
python scripts/build_denominators_2526.py \
  data/raw/cdenroll2526.txt data/raw/absenteeismreason26.txt output/2025_26
python scripts/reproduce_ventura_2526.py \
  output/2025_26/district_56_72652_school_proxies_2025_26.csv \
  output/tables/ventura_17_school_ada_rebuild.csv \
  --observed-workbook '/path/to/Ventura 8:13:2025 - 6:4:2026 ADA clear_copy.xlsx'
```

The workbook join uses an explicit ATLAS alias and normalizes school suffixes, then retains the 14-digit CDE school codes. Pierpont has a K attendance row and zero TK Census enrollment. Homestead has 1.04 K ADA in the workbook and no matching positive-TK/K Census record. It is the only unmatched workbook school. All 17 CDE records matched and supplied combined absence data. See the [published table](../results/2025_26/ventura_17_school_ada_validation.csv).
