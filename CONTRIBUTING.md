# Contributing

This repository is an active collaborative research workflow.

## Guardrails

- Keep raw CDE and district files out of Git.
- Do not treat an assumed 180-day school year as observed expected attendance days.
- Preserve TK/K aggregation where the public source combines the grades.
- Keep observed quantities separate from assumption-dependent reconstructions.
- Do not treat the Irvine five-day validation as validation of an annual denominator.
- Do not treat Lodi school-wide attendance as TK/K attendance ground truth.

Use a branch and pull request for changes that alter data construction, matching, denominator definitions, validation logic, or reported results. Document substantive research decisions in `docs/decisions.md`.
