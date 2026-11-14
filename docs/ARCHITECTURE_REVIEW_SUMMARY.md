# Relopoli — Architecture Review Summary

> Status snapshot: 2026-11-14  
> Scope: the architecture-review discussion and the resulting repository records.  
> This document is a navigation summary, not a second decision log or a replacement for gameplay source documents.

## 1. Executive recap

The architecture review has covered the game's orchestration model, domain-system boundaries, server authority, state mutation pipeline, post-commit effects, victory handling, recovery, checkpoints, and Roblox Luau feasibility.

**Current recorded outcome:**
- **52 architecture decisions are LOCKED** in the [Architecture Review Decision Log](ARCHITECTURE_REVIEW_DECISIONS.md).
- **Eight consolidation findings (RF-01–RF-08) have been addressed** by Decisions 45–52.
- **Three findings (RF-09–RF-11) remain unresolved** and still require explicit design decisions.
- The architecture direction is assessed as sound, but implementation readiness remains **NOT YET**.
- The repository is a documentation repository. These records do not prove that the systems have been implemented or tested in Roblox Studio.

## 2. What has been reviewed

### A. Gameplay orchestration and system responsibilities

The review established and examined:
- Turn Controller as the owner of turn flow, resolution sequencing, pause/resume, and Turn End.
- Explicit turn and resolution states, with traceable process context.
- Domain Systems responsible for their own mechanics rather than taking over global turn flow.
- A managed Resolution Chain and monotonic resolution priority:
  `GAME_END > PLAYER_ELIMINATED > TURN_END > EXTRA_ROLL > CONTINUE`.
- A single authoritative ownership source for ownership-dependent calculations.
- Separate responsibilities for Economy, State Manager, derived-state calculators, and Victory Controller.

Related canonical records: Decisions 1–11 and 18; [Master Source of Truth](MASTER_SOURCE_OF_TRUTH.md); [Progress 19 Master Flow](progress/PROGRESS_19_MASTER_FLOW.md).

### B. Server authority and client communication

The review covered:
- Server-owned authoritative gameplay state and outcomes.
- Client requests as intent, not trusted gameplay results.
- Standard request contracts, RequestId deduplication, rate limiting, and rejection without side effects.
- Server-authoritative dice and logical movement.
- Separation of live match state from persistent player data.
- Validation of asynchronous results against TurnId, ResolutionId, and OperationId.

Related canonical records: Decisions 12–17; [Progress 20 Edge Case & Exploit Audit](audit/PROGRESS_20_EDGE_CASE_EXPLOIT_AUDIT.md).

### C. State mutation and atomic commit

The review developed a controlled mutation pipeline:
- Serialized FIFO mutation execution.
- Staged Mutation Plans and latest-state validation.
- Copy-on-Write candidate state and version checks.
- Controlled state reads and version-bound snapshots.
- Derived-state recalculation before root publication.
- Fail-closed behavior when recalculation fails.
- A short, non-yielding root-swap boundary.

Decisions 45–52 further consolidated the candidate-state pipeline and its interaction with victory, effects, and recovery.

Related canonical records: Decisions 19–28 and 45; [Consolidation Review](ARCHITECTURE_CONSOLIDATION_REVIEW.md).

### D. Post-commit effects and victory handling

The review covered:
- Separation of gameplay commit from post-commit work.
- An authoritative Effect Registry and dependency ordering.
- Retry behavior and the requirement for idempotent effect handlers.
- A global gate preventing later relevant gameplay mutations while Victory Check is pending.
- The boundary between evaluating victory conditions and applying a terminal Game-End state.

Decisions 29–32 and 46–48 define the earlier approved parts. Decision 52 now separates read-only, StateVersion-bound Victory Evaluation from the validated Game-End mutation through State Manager, while retaining the Global Victory Gate.

### E. Recovery and checkpoints

The review covered:
- Server-controlled recovery with a single recovery executor and lock lifecycle.
- Recovery completion gates and safe resume from a verified PendingStep.
- Stable-boundary checkpoint creation, version/integrity checks, retention, memory budgeting, and non-blocking checkpoint failure.
- The rule that completed gameplay operations must not be rolled back.
- The danger of restoring an older checkpoint without a committed-operation journal/replay mechanism.

Decisions 33–43 and 49–50 record approved architecture constraints. RF-09 and RF-10 remain open for integrity and checkpoint-manager contracts.

### F. Roblox Luau feasibility and implementation preparation

The consolidation review identifies engineering constraints around shallow table cloning/freezing, deep Copy-on-Write, non-yielding commit sections, memory/performance profiling, effect retry failure injection, checkpoint behavior, and disconnect/reconnect testing.

It also records a distinction that still needs a decision: conventional server-authoritative gameplay using server scripts and validated remotes versus Roblox's engine Server Authority mode.

See sections 4, 6, and 7 of the [Consolidation Review](ARCHITECTURE_CONSOLIDATION_REVIEW.md).

## 3. Decision coverage: Decisions 1–52

The complete wording and status of every decision live only in the [Architecture Review Decision Log](ARCHITECTURE_REVIEW_DECISIONS.md). To avoid duplicated or drifting copies, this summary groups the decision ranges rather than reproducing all decision text:

| Decision range | Subject |
|---|---|
| 1–11 | Architecture layers, turn orchestration, resolution, ownership, economy, bankruptcy, and atomic commit responsibility |
| 12–18 | Server authority, remote request contracts, idempotency, dice/movement authority, persistence boundary, async context, and module dependencies |
| 19–28 | Serialized mutations, FIFO ordering, staged plans, Copy-on-Write, versioning, controlled reads, recalculation, and root swap |
| 29–32 | Post-commit effects, effect registry, dependency ordering, victory retry, and progression gate |
| 33–43 | Recovery executor and lock, recovery completion, verified resume, checkpoint creation, validation, retention, memory, and failure handling |
| 44–52 | Consolidation review and corrective decisions for candidate-state commit, global victory gating, atomic effect publication, effect idempotency, recovery completion ordering, committed-mutation preservation, separated version domains, and separated victory evaluation from Game-End mutation |

Decisions 45–52 specifically close the eight findings described below. They refine the architecture mechanisms and do not silently rewrite source gameplay rules.

## 4. Consolidation findings status

### Addressed by approved decisions

| Finding | Concern | Recorded resolution |
|---|---|---|
| RF-01 | Mutation pipeline ordering was ambiguous | Decision 45: Canonical Candidate-State Commit Pipeline |
| RF-02 | A later mutation could pass before Victory Check completed | Decision 46: Global Victory Check Gate |
| RF-03 | Effect Registry publication could be separated from its mutation | Decision 47: Atomic Effect Registry Publication |
| RF-04 | Effect status alone did not guarantee safe exactly-once retry | Decision 48: Effect Idempotency and Retry Safety |
| RF-05 | Recovery completion and resume ordering conflicted | Decision 49: Recovery Completion Gate Before Gameplay Resume |
| RF-06 | Older checkpoint fallback could rewind committed gameplay | Decision 50: Checkpoint Recovery Must Preserve Committed Mutations |
| RF-07 | Gameplay StateVersion scope was ambiguous across effect, recovery, and checkpoint metadata | Decision 51: Separated Version Domains |
| RF-08 | Victory evaluation and the authoritative Game-End mutation had overlapping responsibilities | Decision 52: Separate Victory Evaluation From Game-End Mutation |

### Still unresolved

| Finding | Open question | Why it matters |
|---|---|---|
| RF-09 | What deterministic serialization and integrity-hash contract is feasible, and what threat is it intended to detect? | Prevents reliance on an underspecified hash or treating it as a security boundary |
| RF-10 | What is the single ownership contract for Checkpoint Manager responsibilities? | Avoids overlapping eligibility, validation, retention, memory, in-use protection, retry, and recovery rules |
| RF-11 | Which Roblox server-authority model is intended: conventional server-authoritative scripts/remotes or engine Server Authority mode? | Prevents mixing incompatible assumptions about simulation, prediction, rollback, and networking |

Decisions 51 and 52 close RF-07 and RF-08 respectively. RF-09 through RF-11 remain open; they must not be represented as LOCKED decisions.

## 5. Source-of-truth boundaries

Keep these document roles distinct:

1. **Gameplay rules:** [Master Source of Truth](MASTER_SOURCE_OF_TRUTH.md) and the relevant historical system documents.
2. **Approved architecture mechanisms:** [Architecture Review Decision Log](ARCHITECTURE_REVIEW_DECISIONS.md).
3. **Analysis and unresolved findings:** [Architecture Consolidation Review](ARCHITECTURE_CONSOLIDATION_REVIEW.md).
4. **Broader validation work:** [Review Backlog](REVIEW_BACKLOG.md).
5. **Historical progress records:** [progress/](progress/), [systems/](systems/), [ui/](ui/), [visual/](visual/), and [audit/](audit/).

A review finding is not an approved rule. A proposal is not LOCKED until explicitly approved and recorded. A documentation decision is not implementation evidence.

## 6. Recommended next work

1. Resolve RF-09 through RF-11 one at a time, recording each approved decision in the Decision Log before proceeding to the next.
2. Update the relevant architecture contracts and this status summary only after the corresponding decision is approved.
3. Prototype the shared state pipeline and failure boundaries in Roblox Studio.
4. Execute the minimum acceptance test matrix in the Consolidation Review, including concurrency, retry, victory gating, recovery, checkpoint, disconnect, and exploit cases.
5. Update implementation readiness only when test evidence supports it.

## 7. Repository hygiene rules

- Do not duplicate full decision text in this summary.
- Do not duplicate the Master Source of Truth inside review documents.
- Keep each unresolved finding in the Consolidation Review as its canonical analysis location.
- Keep each approved architecture decision in the Decision Log as its canonical status location.
- Use links from README and this summary for navigation.
- Preserve historical Progress documents as records, not as competing current specifications.
