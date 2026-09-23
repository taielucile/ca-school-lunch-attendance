# Validation report

## Statewide backbone checks

The 2024–25 Census Day school-total file defines the left-join universe.

- 10,591 unique school-level Census TA rows.
- Census grade columns sum to total enrollment for every school row.
- 6,295 Census schools have positive combined TK+K enrollment before pseudo-entity exclusions.
- 6,234 of the 10,591 Census schools have a school-level GRTKKN absenteeism row.
- 6,204 of the 6,295 positive-TK/K Census schools have a GRTKKN absenteeism row.
- 291 positive-TK/K schools have a matched GRTKKN row with at least one core metric suppressed.
- Suppression is retained as unknown, not recoded to zero.

These counts differ from earlier kindergarten-only diagnostics because the primary unit is now combined TK+K following the PI decision.

## Focus districts

After excluding CDS school codes 0000000 and 0000001 and requiring positive Census TK+K enrollment:

### Irvine Unified

- 30 schools in the focus universe.
- 30 have usable unsuppressed TK/K denominator inputs.
- Census TK+K enrollment across usable schools: 3,172.
- Eligible cumulative TK+K enrollment: 3,417.
- Observed TK+K absence days: 33,152.

### Lodi Unified

- 34 schools in the focus universe.
- 33 have usable unsuppressed TK/K denominator inputs.
- One real-school row, Valley Robotics Academy, has a suppressed TK/K absenteeism cell; its Census TK+K enrollment is 9.
- Census TK+K enrollment across the 33 usable schools: 2,632.
- Eligible cumulative TK+K enrollment: 2,823.
- Observed TK+K absence days: 43,256.

## Denominator regression benchmark

Using a 180-day full-year benchmark:

- Irvine: Census proxy = 537,808; cumulative proxy = 581,908; cumulative is 8.19995% larger.
- Lodi: Census proxy = 430,504; cumulative proxy = 464,884; cumulative is 7.98599% larger.

For non-charter schools only:

- Irvine: 29 usable schools; cumulative proxy is 8.75742% larger.
- Lodi: 29 usable schools; cumulative proxy is 8.52118% larger.

Thus the roughly eight-percent aggregate difference is not being driven solely by charter schools.

## Reproducibility status

The R pipeline now contains all cleaning, joining, validation, denominator, and focus-district modules. A regression test stores the expected Irvine/Lodi benchmark totals.

The current execution environment used to assemble the repository does not have R installed, so the R scripts have not been executed in that environment. The same transformations were independently reproduced against the raw files in Python to establish the benchmark values stored in the regression test. The next local/R-enabled run should execute `Rscript tests/test_pipeline.R` before any memo result is treated as frozen.
