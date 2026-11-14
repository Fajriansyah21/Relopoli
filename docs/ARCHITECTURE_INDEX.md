# Relopoli Documentation Index

This index is the navigation entry point for the repository's design and architecture documentation. It points to canonical documents instead of copying their contents.

## Source authority

Use these documents according to their scope:

1. [Master Source of Truth](MASTER_SOURCE_OF_TRUTH.md) — canonical gameplay rules, system behavior, and source hierarchy.
2. [Architecture Review Decision Log](ARCHITECTURE_REVIEW_DECISIONS.md) — the canonical record of approved architecture decisions. Decisions 1–52 are LOCKED.
3. [Architecture Consolidation Review](ARCHITECTURE_CONSOLIDATION_REVIEW.md) — analysis, review findings, feasibility notes, implementation dependencies, and acceptance tests. Findings are not decisions by themselves.
4. [Architecture Review Summary](ARCHITECTURE_REVIEW_SUMMARY.md) — concise map of what has been reviewed, what is resolved, and what remains open.
5. [Review Backlog](REVIEW_BACKLOG.md) — broader system, economy, technical, and UX validation work. It is not a replacement for the architecture findings above.

If documents appear to conflict, follow the source hierarchy and conflict policy in the Master Source of Truth. A later explicit LOCKED decision may refine architecture mechanisms, but must not silently change gameplay rules.

## Documentation map

| Area | Location | Purpose |
|---|---|---|
| Gameplay authority | [Master Source of Truth](MASTER_SOURCE_OF_TRUTH.md) | Consolidated rules and system architecture |
| Architecture decisions | [Decision Log](ARCHITECTURE_REVIEW_DECISIONS.md) | Approved decisions 1–57 |
| Architecture analysis | [Consolidation Review](ARCHITECTURE_CONSOLIDATION_REVIEW.md) | RF-01–RF-11, Luau feasibility, implementation order, acceptance matrix |
| Review recap | [Review Summary](ARCHITECTURE_REVIEW_SUMMARY.md) | One-page overview of review outcomes |
| Review backlog | [Review Backlog](REVIEW_BACKLOG.md) | Remaining broader validation tracks and hypotheses |
| Progress history | [progress/](progress/) | Master Flow and historical progress records |
| Domain systems | [systems/](systems/) | Economy, movement, property, jail, trade, transaction, news, crown |
| User interface | [ui/](ui/) | Player screen, ownership visuals, assets panel, settings |
| Visual direction | [visual/](visual/) | Visual identity and presentation direction |
| Edge-case audit | [audit/](audit/) | Progress 20 exploit and edge-case audit |
| Design references | [../design/](../design/) | Property catalog reference |

## Maintenance rules

- Keep each rule or decision in one canonical location.
- Link to canonical sources rather than pasting duplicate copies into summaries.
- Preserve historical progress records; do not rewrite history to imitate current decisions.
- Record new approved architecture decisions in the Decision Log and update the Summary/Changelog only as navigation or status references.
- Keep unresolved findings visibly unresolved until an explicit decision is approved.
- Distinguish documentation approval from Roblox Studio implementation and test evidence.

## Current architecture review status

- Decisions 1–58: **LOCKED**.
- RF-01–RF-08: addressed by Decisions 45–52.
- RF-09: addressed by Decision 54.
- RF-10: addressed by Decision 55.
- RF-11: addressed by Decision 53.
- Cross-decision consistency finding CI-01: addressed by Decision 56.
- Cross-decision consistency finding CI-02: addressed by Decision 57.
- Cross-decision consistency finding CI-03: addressed by Decision 58. see the [Review Summary](ARCHITECTURE_REVIEW_SUMMARY.md).
- Implementation readiness: **NOT YET**.
