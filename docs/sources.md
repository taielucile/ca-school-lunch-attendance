# Data and methodological sources

This file records external sources used to interpret the public files, district validation data, and denominator assumptions.

## California Department of Education

### Absenteeism by Reason

The public 2024–25 Absenteeism by Reason file provides eligible cumulative enrollment, students with one or more absence, average days absent, total days absent, and absence reasons by reporting category and grade span.

Data: https://www.cde.ca.gov/ds/ad/filesabr.asp  
File structure: https://www.cde.ca.gov/ds/ad/fsabr.asp

CDE states that cells are suppressed with an asterisk when the selected student population (eligible cumulative enrollment) is 10 or less. The pipeline therefore preserves suppression as unknown rather than converting it to zero.

The public TK/K reporting category does not include total Expected Attendance Days. The denominator workflow therefore treats expected attendance exposure as unobserved rather than reconstructing it from absence days alone.

### Census Day enrollment

Data: https://www.cde.ca.gov/ds/ad/filesenrcensus.asp

The pipeline uses both the 2024–25 and 2025–26 Census Day files.

The 2024–25 file supplies the TK and K Census enrollment counts used in the annual public-data denominator constructions. Census Day enrollment is a point-in-time snapshot and is not treated as annual duration-weighted exposure.

The 2025–26 file is used for the same-year Irvine district-attendance check. Across the full Irvine school-level Census extract there are 47 school rows, with 1,296 TK students and 2,022 K students (3,318 combined). The district attendance reports cover a 30-school subset whose same-year Census enrollment is 1,170 TK and 1,873 K (3,043 combined).

### CALPADS Student Absence Summary

CALPADS documentation is used to distinguish public aggregate absenteeism measures from the underlying student-school attendance concepts. STAS includes Expected Attendance Days and Days Attended at the student-school level. Expected Attendance Days is the duration-weighted exposure concept relevant to the target denominator.

The public school-by-grade Absenteeism by Reason release does not expose the sum of Expected Attendance Days needed to construct annual school × TK/K attended student-days directly.

CALPADS FAQ: https://www.cde.ca.gov/ds/sp/cl/calpadsfaqs.asp

### CBEDS kindergarten program definitions

Glossary/instructions: https://www.cde.ca.gov/ds/dc/cb/gisif.asp

CDE defines full-day kindergarten/TK as exceeding four hours, exclusive of recess, and part-day as up to four hours of instruction per day. CBEDS program type is used as a program/schedule descriptor, not as a measure of student attendance exposure.

## Irvine district validation sources

### District attendance reports

The Irvine district files supplied through the Feed-California-Kinders project contain separate K and PK daily attendance reports for November 3–7, 2025.

The transcribed validation input contains:

- 30 K school rows and 8,703 K student-days over five days;
- 28 PK/TK school rows and 5,401 PK/TK student-days; and
- 14,104 combined TK/K observed student-days.

For the 30 schools represented in the attendance reports, mean daily TK/K attendance is 2,820.8 compared with same-year CDE Census TK/K enrollment of 3,043, an aggregate ratio of 0.926980. This is treated as a five-day descriptive validation check, not as an annual denominator.

Source repository: https://github.com/whippedfruit/Feed-California-Kinders

### Irvine PK/TK terminology

Irvine Unified states that Pre-Kindergarten (PK) replaced the program formerly known as Transitional Kindergarten (TK). This supports aligning the district PK attendance report with the CDE TK category for the Irvine validation.

IUSD Pre-Kindergarten/TK: https://iusd.org/about/iusd-enrollment/pre-kindergarten-tk  
2025–26 grade placement: https://iusd.org/sites/default/files/documents/Grade%20Level%20Placement%20for%20ALL%202025-26_0.pdf

## Lodi district-data assessment

The Lodi files in Feed-California-Kinders contain grade-specific meal counts and school-wide Average Daily Attendance. Their grade-level ADP measures describe meal Average Daily Participation rather than student attendance. These measures are therefore not used as grade-specific attendance ground truth.

The meal data contain separate `Preschool` and `Kindergarten` categories. No documentation located in the repository establishes that `Preschool` represents TK. Lodi's own program materials treat Transitional Kindergarten and preschool as distinct programs, so the workflow does not relabel Preschool as TK or combine Preschool and Kindergarten as a TK/K numerator without additional documentation.

### Lodi Kindergarten eligibility-report fields

The original Lodi workbook also contains a report filtered to `Grade Levels = Kindergarten` and an `Eligibility Date Range` of July 29, 2025 through May 29, 2026. Its headings include `Participants Approved`, `Highest Eligible`, and `Last Day`. A report footnote defines `Last Day` as the number of enrolled students on the last day of the selected date range.

The extracted 31-school Kindergarten report has `Highest Eligible = Last Day` at every school. Each field totals 3,481. Because the workbook conversion places the school-name and numeric portions of this wide report in separate row blocks, the original PDF was also inspected directly. The PDF confirms that the blocks are horizontally paginated portions of the same Kindergarten-filtered report and preserve the same 31-school order. The school-level pairing is therefore treated as verified against the source PDF, not assumed from the workbook layout. The pipeline compares that report-side quantity descriptively with same-year CDE Kindergarten Census enrollment for the same 31 matched schools, which totals 1,763.

The report fields are not interpreted as student-specific expected attendance days. Their role is source triangulation: they document another Kindergarten-specific enrollment/eligibility quantity while leaving annual duration-weighted attendance exposure unidentified.

Source workbook: `Lodi/extracted data/UCI Project - Student Research.xlsx` in the Feed-California-Kinders repository.

Source repository: https://github.com/whippedfruit/Feed-California-Kinders  
Lodi TK policy: https://www.lodiusd.net/boardpolicies/6000/6170-1  
Lodi TK information: https://www.lodiusd.net/enrollment/transitional-kindergarten

## Focus-district calendar evidence

### Irvine Unified

Irvine Unified's audited 2024–25 Schedule of Instructional Time reports 180 actual kindergarten days for the traditional calendar. IUSD's 2024–25 calendar materials also describe 180 instructional days.

This supports 180 as a district calendar benchmark for IUSD-operated schools. It does not imply that every cumulatively enrolled child had 180 expected attendance days.

### Lodi Unified

Lodi Unified Board Policy 6111 states that district calendars offer 180 days of instruction. This supports 180 as a district calendar benchmark, subject to school/charter-specific calendar exceptions.

## Interpretation rule

Calendar days offered by a school/district and student-level expected attendance days are different quantities. The former can justify a full-year benchmark; it cannot solve mobility or partial-year enrollment exposure.

Likewise, a short-window comparison of Census enrollment with observed daily attendance cannot identify annual expected attendance exposure. The gap between enrollment and attendance includes ordinary absences and may also reflect enrollment changes.

## Charter calendar and sample audit sources

### Irvine Chinese Immersion Academy

A public 2024–25-era job description states that instructional assistants work 180 days as set in the school calendar and that work hours reflect student attendance. This is supporting evidence for a 180-day school calendar benchmark, not a student-level exposure measure.

### Aspire Public Schools

Public comparison material for FY 2024–25 reports Aspire Public Schools at 180 school days. School-specific 2024–25 calendars were also located for Aspire Vincent Shalvey Academy and Aspire River Oaks Charter School.

### Joe Serna Jr. Charter

A school-specific 2024–25 instructional calendar was located through Lodi Unified. The repository does not encode a student-specific expected-attendance measure from that calendar.

### Rio Valley Charter

Public 2024–25 materials describe Rio Valley as a TK–12 homeschool/independent-study charter. The program model is flagged separately because the relationship between enrollment, attendance, and campus-based meal access may differ substantively from a conventional school setting.
