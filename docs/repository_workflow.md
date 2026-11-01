# Working with the data

I keep the original CDE and district files separate from the code and derived tables in this repository. The [source notes](sources.md) and [file list](../data/README.md) identify what each analysis uses.

## Checking an extract

For school-level files, I compare the list of County-District-School (CDS) codes with the complete source before using the results. I also check the number of records, missing or suppressed values, and calculated totals. A successful script run is not enough to show that every school was included.

The source year and reporting period matter just as much as the arithmetic. The public CDE absence totals combine TK and kindergarten. The 180-day attendance estimate uses an assumed calendar, and separate grade estimates allocate the combined absence total. I keep those estimates labeled rather than treating them as recorded attendance.

## Linking meals and attendance

Meal records and attendance records need to refer to the same school, grade, and period. Meal counts are quantities served or claimed, depending on the file; they are not counts of individual students. Meal average daily participation (ADP) is also different from student average daily attendance (ADA).

Where a district file has school names but no matching CDS code, I keep possible matches in review tables until the identity can be checked. Missing records stay missing unless the source makes clear that they mean zero.

## Keeping track of changes

For changes to a calculation or source file, I record the version used, what changed, and how the new output was checked. The [decision log](decisions.md) records choices that affect interpretation. Earlier notes remain available when a later source check changes a result.

The [October 31 source audit](independent_research_integrity_audit_2026_10_31.md) is the most recent detailed check of the files discussed here.
