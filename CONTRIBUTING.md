# Contributing to the California school meals and attendance analysis

This repository is a working research record. Contributions should make analyses easier to verify **without changing a substantive decision silently**.

## How to propose work

1. Read the [new researcher guide](docs/START_HERE.md), [current status](docs/current_status.md), and the relevant methods/source notes.
2. Agree on the specific task and access permissions with the project lead or repository owner. The [open questions table](docs/START_HERE.md#what-can-i-work-on) is a starting point, not an assignment list.
3. Work in a separate branch or pull request where available. Explain the research question, source file and version, files changed, run steps, tests, and any limitations.
4. Keep proposed interpretations separate from verified source facts. When correcting a result, preserve and identify the prior version and explain what changed.
5. Request review before merging changes to estimates, matching rules, school inclusion, or measurement definitions.

## Do not commit

- Student-level or personally identifying records, restricted district workbooks, credentials, or unapproved extracts.
- Unverified school-name links presented as official CDS matches.
- Output that mixes 2024–25 meal counts with 2025–26 attendance estimates to produce participation rates.
- Suppressed cells turned into zeros or modeled attendance relabeled as observed.

## Minimal handoff template

**Question:** What exact research or source question was checked?

**Inputs:** Source, year, school/grade population, filename, link and hash/version when available.

**Work:** Code/steps used, output files, and any reproducibility checks.

**Finding:** Numerically grounded result, with correct units and scope.

**Limits / next decision:** What is still unknown, and who can resolve it?

This repository is maintained alongside the [team's source repository](https://github.com/whippedfruit/Feed-California-Kinders). If a file belongs to the team rather than this analysis, preserve its provenance and avoid copying restricted inputs.
