# FNS10 matching against CDE public directory (November 4, 2026)

**Source:** uploaded `pubschls.xlsx`, downloaded November 4, 2026 (SHA-256 `6f9d924b7f7a4c8c5591568a6d387f76fb31b0e15a720d9351bbcfb72729e4ff`), compared against the **existing 2024–25 FNS10** sponsor/site review extract built from the original Nutrition Services workbook. This does not change the underlying FNS10 totals.

## Comparison

- Baseline October CBEDS: **6,282 / 9,985** exact normalized-name *candidates* (not verified links).
- November 4 CDE directory, time-screened: **6,274 / 9,985** unique exact district-plus-school-name candidates (**62.83%**).
- 75 pairs not exact in the earlier CBEDS analysis now have a unique exact candidate in this directory; 83 previously exact pairs are no longer exact under the new directory/time screen.
- **6,199** old exact candidates remain exact with the **same CDS code**. 0 old exact pairs now have a different exact CDS candidate (review before acceptance).
- Unique exact candidates account for **405,201,445 / 557,472,855 lunches (72.69%)** and **237,079,040 / 327,641,211 breakfasts (72.36%)**.
- **18** additional high-scoring fuzzy *suggestions* for review, **zero automatically accepted**.

## How fuzzy matching was handled

Names were normalized for case, diacritics, punctuation, and common district suffixes. Unique exact matches were separated from ambiguous exact matches. When no exact match existed, candidate names were ranked first **inside the matching district** using a weighted similarity measure (55% normalized edit similarity, 45% token Dice similarity). High-scoring review candidates require score at least 0.90 and a margin of at least 0.05 over runner-up. Cross-sponsor matches were ranked separately and **never treated as confirmed links**, even with an identical school name. The 2026 directory includes closed and merged entries; records opened after June 2025 or closed before July 2024 were screened out when dates were available, with missing dates retained.

## Important limits

Neither exact nor fuzzy matching establishes that a nutrition service site is a single school. The directory is updated dynamically and its 2026 names/statuses may not represent 2024–25. The resulting candidates need a review ledger, especially when sponsors operate multiple schools or meal-service sites. FNS10 claims count meals, not distinct students or TK/K meals. Do not compute kindergarten meal participation from these schoolwide claims.

## Inspectable output

- [Full pair-level comparison](../results/2024_25/fns10_pubschls_2026_11_04_all_candidates_review_only.csv)
- [Top 500 nonexact pairs by claimed lunch volume](../results/2024_25/fns10_pubschls_2026_11_04_review_priority_500.csv)
- [Machine-readable summary](../results/2024_25/fns10_pubschls_2026_11_04_summary.json)

All candidates have an `UNREVIEWED` decision. These are **new directory-based matching results**, not the earlier CBEDS school catalog analysis.
