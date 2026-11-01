# Contributing to the research

This is a shared research workspace. Changes should be easy for another team member to review, reproduce, and interpret.

## Before using or changing a result

1. **Check the source.** Confirm the school year, file version, population, and whether you have the *complete* source—not just an initial extract.
2. **Check the output.** Compare row counts, school identifiers, joins, missing values, and totals against the source. A script running successfully does not establish that the extract is complete.
3. **Check the meaning.** State whether a value is observed, estimated, or reported by a meal program. Confirm the grade, unit, and reporting period before comparing datasets.

Keep Census enrollment, student attendance, meal counts, and meal average daily participation (ADP) separate. The 180-day attendance calculation is an assumption. Public absence totals combine TK and K, and separate grade-level estimates require additional assumptions.

## Making a change

Use a branch and pull request for changes to data preparation, school matching, methods, or reported figures. A useful pull request explains:

- **What changed and why**, including any source or field definitions that matter.
- **What was checked**, with the source files, record counts, tests, and reconciliation results.
- **What is still uncertain**, including names that need manual review or quantities that do not refer to the same population.

Keep original CDE and district files outside Git. Derived outputs must not contain restricted source data. Do not turn a missing school-grade-meal row into zero unless the source supports that interpretation.

Record substantive research choices in [`docs/decisions.md`](docs/decisions.md). For the latest methods, source checks, and research limitations, see the [documentation guide](docs/README.md).

## Reviewing a contribution

Check that the change preserves the intended **school, grade, year, and measure**; that its totals and identifiers reconcile; and that reported findings do not go beyond what the source establishes. A proposed school-name link is not a confirmed site identity until supported by records.
