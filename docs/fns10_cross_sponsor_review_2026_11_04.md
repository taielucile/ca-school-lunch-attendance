# Cross-sponsor school-name review — November 4, 2026

## What was actually checked

The 2024–25 statewide FNS10 matching audit had **1,830** meal sponsor/site pairs whose normalized site name was unique in the November 4 CDE directory but whose **sponsor name did not match the district name** under the earlier matching rule. These pairs account for **91,838,125 claimed lunches** and **53,013,647 breakfasts**. They were **not** accepted automatically.

I classified all 1,830 sponsor/site pairs by their organization-name pattern, checked whether the same CDS candidate was present in the **2024–25 CBEDS matching export**, flagged conflicts with other strong name candidates, and used **positive TK/K enrollment in the 2025–26 CDE Census file** as a *review-priority indicator only*. The 2025–26 enrollment values are **not** participation denominators for 2024–25 FNS10.

## Classification

| Candidate category | Pair count | 2024–25 claimed lunches | Interpretation |
| --- | ---: | ---: | --- |
| Sponsor name also names school | 69 | 2,783,896 | Sponsor/site and official school labels coincide |
| Sponsor name resembles shortened official district name | 1221 | 67,278,858 | E.g. sponsor 'Modesto City' vs district 'Modesto City High'; still needs formal confirmation |
| Sponsor has several uniquely name-matched sites | 412 | 17,012,377 | Possible CMO/food-service agency/network sponsor; no direct one-to-one proof |
| Other cross-sponsor one-site cases | 128 | 4,762,994 | School name aligns but no obvious organizational affiliation evidence |

- **1801 / 1,830** candidates have the **same CDS** under the earlier 2024–25 CBEDS fallback and the 2026 public directory. This is cross-year *school-code concordance* within CDE sources; it **does not independently establish meal-site identity**.
- **0** candidates share a CDS with another strong exact/cross-sponsor name pair in the same comparison. These require special care before treating source rows as distinct school identities.
- **1284 / 1,830** candidate schools have positive **2025–26** TK/K Census enrollment, making them directly relevant review priorities for the kindergarten-focused research. That enrollment year differs from 2024–25 FNS10 and is used only for triage.
- **1779 Active; 51 Closed** in the November 2026 directory (status is not necessarily historical status).

## Source-verified interpretation of sponsor mismatches

The **California CDE CNIPS FAQ** explains that sponsor names need not match CNIPS exactly; a sponsor is usually a school district and a site is usually a school. CNIPS distinguishes sponsor-level and site-level IDs, and CDS fields are not generally stored from the POS file (see https://www.cde.ca.gov/ls/nu/cn/faq.asp). CDE also explains that nutrition JPAs can serve multiple school districts (https://www.cde.ca.gov/ls/nu/sn/mbnsdsnp082009.asp).

**Example:** The FNS10 sponsor 'Modesto City' includes schools under the official CDE 'Modesto City High' district. The *Modesto City Schools* website confirms that Modesto City Schools comprises **two separate school districts** (https://wright.mcs4kids.com/o/mcs/page/enrollment). That **supports the institutional explanation** for the name mismatch, but not each meal-site record individually.

**Example:** The Santa Clarita Vlly Sch Food Svs Agency JPA appears as an official CDE Joint Powers Authority (https://sd.cde.ca.gov/SchoolDirectory/details?cdscode=19407090000000). Its 2024 food procurement documentation lists multiple member districts (https://docs.isitesoftware.com/snaf-assets%2Fdistrict%2Fsantaclaritavsfsa%2Ffiles%2FBids%2F24-25%2FRFP%202007%2FGold%20Star%20Proposal%20and%20Executed%20Contract.pdf). A sponsor-to-school-district mismatch may be a legitimate administrative structure, **not an incorrect school match**.

## First external-source review (November 4)

The automated candidate files are preserved as **unreviewed** snapshots; subsequent manual decisions are in a separate [review ledger](../results/2024_25/fns10_sponsor_manual_review_ledger_2026_11_04.csv).

- **Santa Clarita JPA:** All **30** unique-school-name candidate sites (including **29** with 2025–26 TK/K enrollment) belong, according to the directory, to the **four districts named in the agency's 2024–25 RFP**: Castaic, Newhall, Saugus and Sulphur Springs. This corroborates the *sponsor's multi-district organizational relationship*, not any individual meal-site ID.
- **Modesto City:** **24** candidate sites appear under **Modesto City Elementary / Modesto City High**, which the Modesto City Schools website confirms are two districts in the same organization (**12** have 2025–26 positive TK/K enrollment). Their source sponsor label 'Modesto City' is consistent with the umbrella name, but still lacks a program-site key.
- **Chula Vista:** **40** candidate sites (all with 2025–26 positive TK/K enrollment) are under CDE's **Chula Vista Elementary** district. This supports the abbreviated district-name interpretation, but the FNS10 sponsor-to-CNIPS linkage has not been independently checked.
- **Definite false automated candidate:** FNS10 sponsor **'Fullerton'**, site **'Golden Hill Elementary'**, was automatically assigned **CDS 37683380108266**, which the CDE directory places in **San Diego Unified**. Fullerton has **Golden Hill School for Creative & Performing Arts**, **CDS 30665066028054**, a more plausible *unconfirmed alternative*. The San Diego CDS is **rejected for this Fullerton record**. This illustrates why even a statewide-unique name can misidentify a school when the sponsor/district is not checked.

These checks document organizational plausibility for **94** cross-sponsor candidate pairs and reject **one** wrong CDS. **None of the 94 site identities has been accepted as an authoritative nutrition-site-to-CDS match.**

The **29 candidates without concordant 2024–25 CBEDS and 2026 CDS suggestions** remain a high-risk review stratum, not an invitation to replace historical school identities with the latest similarly named campus. For historical results, prioritize source-year school identity and the original FNS10 sponsor/site record.

## Actionable review order

1. Start with positive-TK/K candidate schools whose source sponsor either **names the school** or appears to be a **shortened district name**, and whose 2024–25 CBEDS and 2026 directory CDS candidates agree. This gives a manageable first review group.
2. Review **multi-school sponsor organizations in batches** (one sponsor relationship checked once, then verify each school/site), rather than searching 30+ individual names in isolation. The sponsor-group table is sorted by the number of relevant TK/K schools.
3. For charter management groups, food-service agencies and JPAs, require organization/site evidence (2024–25 school listing, vendor/sponsor roster, or district confirmation); simple name and network similarity alone is insufficient.
4. Investigate unmatched or ambiguous candidate CDS duplicates, 2026-closed schools, and differing historical CDS before accepting a match.
5. Keep a decision log with confirmed/rejected identity, date and source URL. No fuzzy or cross-sponsor candidate is counted as a verified link yet.

## Files

- [All 1,830 cross-sponsor cases, with fields to record decisions](../results/2024_25/fns10_cross_sponsor_1830_categorized_2026_11_04.csv)
- [Up to 400 priority TK/K school candidates](../results/2024_25/fns10_cross_sponsor_tkk_review_priority_2026_11_04.csv)
- [Sponsor group summary](../results/2024_25/fns10_cross_sponsor_sponsor_groups_2026_11_04.csv)
- [Machine-readable counts and scope](../results/2024_25/fns10_cross_sponsor_triage_summary_2026_11_04.json)

**Scope and limits:** The source already contained 1,830 unique statewide school-name candidates; this is a *triage and validation step*, not 1,830 new school matches. The current directory is a November 2026 snapshot, while the claims are for 2024–25. All proposed links require independent program-site identity verification; aggregate schoolwide meals never become kindergarten-specific counts.
