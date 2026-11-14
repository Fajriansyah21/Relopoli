# Contributing to Relopoli Documentation

## Source authority and document roles

Keep gameplay authority and architecture decisions distinct:

1. [Master Source of Truth](docs/MASTER_SOURCE_OF_TRUTH.md) is authoritative for consolidated gameplay rules and defines the source conflict policy.
2. [Architecture Review Decision Log](docs/ARCHITECTURE_REVIEW_DECISIONS.md) is authoritative for explicitly approved architecture decisions. Only entries marked LOCKED are approved.
3. [Progress 19 — Master Flow](docs/progress/PROGRESS_19_MASTER_FLOW.md), [Progress 20 — Edge Case & Exploit Audit](docs/audit/PROGRESS_20_EDGE_CASE_EXPLOIT_AUDIT.md), and relevant system progress documents provide source/history context according to the Master Source of Truth hierarchy.
4. [Architecture Consolidation Review](docs/ARCHITECTURE_CONSOLIDATION_REVIEW.md) contains analysis and review findings, not approved decisions by itself.
5. [Architecture Review Summary](docs/ARCHITECTURE_REVIEW_SUMMARY.md) and [Architecture Index](docs/ARCHITECTURE_INDEX.md) are navigation/status documents. They must link to canonical content rather than duplicate it.
6. UI and visual documents govern presentation details only.

If a conflict appears, apply the conflict policy in the Master Source of Truth. Do not let an analysis finding or proposal silently override a locked gameplay rule.

## Rules for changes

- Do not silently edit or reinterpret locked gameplay rules or approved architecture decisions.
- Keep historical records intact; add a new dated decision or revision instead.
- Mark unresolved points as `UNRESOLVED / NEEDS DESIGN DECISION`.
- Distinguish source-backed rules from analysis, implementation proposals, and test results.
- Keep each decision or rule in one canonical document; use links elsewhere.
- Include affected systems, reason for change, edge cases, and migration implications.
- Update the changelog when repository structure, canonical status, or approved decisions change.

## Review checklist

- [ ] The change has an explicit design decision where required.
- [ ] Related system documents are identified.
- [ ] Turn flow and resolution priority are checked.
- [ ] Economy and victory implications are checked.
- [ ] Edge cases and exploit paths are reviewed.
- [ ] UI reflects server-authoritative state.
- [ ] Summary/index links remain accurate.
- [ ] Changelog is updated.
