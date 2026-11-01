# Repository workflow

This repository documents Taiel Lucile's research for Feed California Kinders, including data preparation, analysis, and source checks.

The code, derived files, and notes document analyses carried out for the project. Original district records and raw CDE source files are stored separately.

## Before using a result

1. Check the full source. Verify the school year, source version, eligible schools, and grades. Make sure an extract includes every qualifying source record, not just the records successfully retrieved.
2. Check the output. Reconcile school identifiers, row counts, missing values, joins, and totals against the complete original files. Passing code tests alone does not establish that an extract is complete.
3. Check what the measure means. Distinguish observed attendance from model-based estimates, meal quantities from individual students, and meal average daily participation (ADP) from student average daily attendance (ADA). Confirm that comparisons use matching grades and reporting periods.

The 180-day attendance calculation is an assumption, not an observed attendance-day count for every student or school. Public absenteeism files combine TK and K. Separate grade estimates in the output involve additional assumptions.

## Maintaining the analysis

Substantive changes to calculations, source processing, school matching, or reported findings are made on a separate branch and reviewed before merging. The record of a change should state what changed, the input version, the checks performed, and any remaining uncertainty.

Keep original and restricted source files out of Git. Preserve suppressed and missing values rather than treating them as zero. School-name matching produces review candidates, not confirmed identities.

The [research decision log](decisions.md) records important methodological choices. The [documentation guide](README.md) links to current results and their supporting source checks.
