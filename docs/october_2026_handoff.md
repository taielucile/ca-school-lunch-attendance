# October 2026 research handoff

The repository's executable `RUN_ALL.R` currently ends with `R/09_lodi_enrollment_triangulation.R`. It does **not** run the statewide 930-district ADA comparison or the Ventura 17-school validation. These analyses are documented here as **reported external results**, pending original input/code recovery and independent reproduction.

| Workstream | Geography / period | Unit | Status | Documentation |
| --- | --- | --- | --- | --- |
| Annual denominator sensitivity | Irvine and Lodi, 2024–25 | School, combined TK/K | Executable in existing R pipeline with required raw files | `docs/denominator_method_note.md` |
| Stability correlations | Irvine and Lodi, 2024–25 | School, combined TK/K | Draft PR #5; separate from main | `docs/october_2026_stability_reproduction.md` on PR branch |
| Statewide ADA alignment | California, 2024–25 | District, TK/K–3 | Reported; code and source exhibit not in repo | `docs/statewide_ada_comparison_2026-10.md` |
| Ventura ADA comparison | Ventura, 2025–26 | School, combined TK/K | Reported; code and source workbook not in repo | `docs/ventura_tkk_ada_validation_2026-10.md` |

**Do not conflate these estimands.** School-level annual student-days, district-level ADA, and meal participation are different quantities. The Irvine five-day meal/attendance analysis remains a separate planned analysis until its aligned numerator and denominator have been audited.

**Next engineering step:** recover original statewide and Ventura scripts, source manifests, crosswalks, and outputs; verify permissions; rerun and test against reported totals; only then integrate executable modules and update `RUN_ALL.R` or add a separate runner. Preserve the existing frozen Irvine/Lodi tests and do not imply a successful end-to-end run that has not occurred.
