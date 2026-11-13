# Contributing to Relopoli Documentation

## Source hierarchy
1. Master Source of Truth.
2. Progress 19 — Master Flow.
3. Progress 20 — Edge Case & Exploit Audit.
4. Latest locked system progress for the relevant mechanic.
5. Older progress history.
6. UI documentation for presentation details only.

The detailed source hierarchy and conflict policy in the Master Source of Truth remain authoritative.

## Rules for changes
- Do not silently edit or reinterpret locked gameplay rules.
- Keep historical records intact; add a new dated decision or revision instead.
- Mark unresolved points as `UNRESOLVED / NEEDS DESIGN DECISION`.
- Distinguish source-backed rules from analysis, implementation proposals, and test results.
- Include affected systems, reason for change, edge cases, and migration implications.

## Review checklist
- [ ] The change has an explicit design decision.
- [ ] Related system documents are identified.
- [ ] Turn flow and resolution priority are checked.
- [ ] Economy and victory implications are checked.
- [ ] Edge cases and exploit paths are tested.
- [ ] UI reflects server-authoritative state.
- [ ] Changelog is updated.
