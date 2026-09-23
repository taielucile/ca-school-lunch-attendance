# Research decision log

## 2026-09-23 — Unit of analysis: combined TK and K

**Decision:** Use the public CDE TK–K band as the primary grade unit rather than allocating the band to kindergarten alone.

**Reason:** Andrew Penner confirmed that combining TK and K is acceptable for the project given the data limitation and noted that TK and K are generally similar in their half-day/full-day schedules.

**Consequence:** The primary analysis no longer requires allocating TK–K absence days to kindergarten using Census Day grade shares. This removes a substantial assumption from the main denominator construction.

---

## 2026-09-23 — Expected attendance exposure remains unidentified

**Status:** Open methodological decision.

The public absenteeism file supplies TK–K eligible cumulative enrollment and total absence days, but not expected attendance days. Census enrollment is a snapshot; cumulative enrollment counts students with different lengths of enrollment.

Therefore:

- `Census TK/K enrollment × 180 - absence days` can underrepresent students who enroll after Census Day and otherwise differs from annual exposure.
- `eligible cumulative TK/K enrollment × 180 - absence days` treats every eligible cumulative student as though they were exposed for a full 180 days.
- Neither is treated as observed student-days attended.

The current task is to compare reasonable approaches in Irvine Unified and Lodi Unified and document their consequences.

---

## 2026-09-23 — PI deliverable

Andrew requested a memo detailing the alternative approaches and the differences produced in Irvine and Lodi. Target: October 15, 2026, with a short presentation at the research meeting.
