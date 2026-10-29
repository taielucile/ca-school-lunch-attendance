# Ventura TK/K ADA comparison (2025–26)

**Status:** summary results from the October 2026 internal validation report. The original Ventura workbook, matching crosswalk, extraction code, and observed ADA records have **not** been independently rerun or committed here. Do not describe this note as a complete reproducible analysis.

## Design

Compare three 2025–26 school-level proxies against **observed combined TK/K ADA** for **17 matched Ventura schools**, joined by CDS code. Homestead is excluded from the validated set. The target is TK/K **average daily attendance**, not a meal-participation rate. The comparison does not validate separate TK and K attendance because the public CDE `GRTKKN` absence band combines the grades.

With `D=180`, the candidate quantities are:

- **P0:** Census TK/K enrollment (no absence adjustment).
- **P1:** Census TK/K enrollment − combined TK/K absence days / 180.
- **P2:** eligible cumulative TK/K enrollment − combined TK/K absence days / 180.

These are assumptions about annual exposure; they are not observed student-specific expected attendance days.

## Reported matched-school totals

| Measure | ADA / proxy | Relative difference from observed |
| --- | ---: | ---: |
| Observed TK/K ADA | 1,179.14 | reference |
| P1: absence-adjusted Census | 1,186.06 | +0.59% |
| P2: absence-adjusted cumulative | 1,236.06 | +4.83% |
| P0: unadjusted Census | 1,263.00 | +7.11% |

The original report states P1 is closer at **13** schools, P2 at **2**, and the proxies tie at **2**. These figures are recorded as reported, not independently recomputed here. The aggregate P1 difference is `(1186.06 / 1179.14 - 1) * 100 ≈ 0.587%`; rounding conventions explain the reported +0.59% / +0.6% descriptions.

## Limits and decisions

This is a single district, a single school year, and a small matched sample. It does **not** validate statewide or 2024–25 estimates, does not identify separate TK/K grade-specific exposure, and does not validate meal numerator alignment. It cannot establish P1 as universally best. The assumed 180 days, entry/exit timing, and potentially different attendance and Census populations remain limitations. The source analysis also records four low-exposure outliers (below 75% of Census) requiring follow-up; do not erase them without an auditable reason.

## Reproduction handoff / acceptance criteria

Recover the original Ventura attendance workbook, ADA benchmark, school CDS crosswalk, source files, and scripts. Verify all 17 school matches and Homestead exclusion; recheck original grade/meal table layouts (including Will Rogers' differing column arrangement), school totals, and definitions of observed ADA. Recalculate P0/P1/P2 by school, compare with benchmark, reconcile the aggregate totals above and 13/2/2 school comparison, and document every unmatched or suppressed record. Store a source manifest and checksums, and add executable tests with permission-cleared synthetic fixtures before calling the analysis reproduced. Do not upload restricted district files.
