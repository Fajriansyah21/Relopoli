# Relopoli — Architecture Review Summary

> Status snapshot: 2026-11-14  
> Scope: the architecture-review discussion and the resulting repository records.  
> This document is a navigation summary, not a second decision log or a replacement for gameplay source documents.

## 1. Executive recap

The architecture review has covered the game's orchestration model, domain-system boundaries, server authority, state mutation pipeline, post-commit effects, victory handling, recovery, checkpoints, and Roblox Luau feasibility.

**Current recorded outcome:**
- **75 architecture decisions are LOCKED** in the [Architecture Review Decision Log](ARCHITECTURE_REVIEW_DECISIONS.md).
- **All eleven architecture findings (RF-01–RF-11) and twenty cross-decision consistency findings (CI-01–CI-20) have been addressed** by Decisions 45–55.
- **No consolidation findings remain unresolved at the architecture-contract level.**
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

Decisions 33–43 and 49–50 record the core recovery and checkpoint constraints. Decision 54 defines deterministic checkpoint serialization and integrity validation; Decision 55 centralizes checkpoint policy and lifecycle ownership in one Checkpoint Manager. Decision 53 confirms the conventional server-authoritative runtime model.

### F. Roblox Luau feasibility and implementation preparation

The consolidation review identifies engineering constraints around shallow table cloning/freezing, deep Copy-on-Write, non-yielding commit sections, memory/performance profiling, effect retry failure injection, checkpoint behavior, and disconnect/reconnect testing.

It also records a distinction that still needs a decision: conventional server-authoritative gameplay using server scripts and validated remotes versus Roblox's engine Server Authority mode.

See sections 4, 6, and 7 of the [Consolidation Review](ARCHITECTURE_CONSOLIDATION_REVIEW.md).

## 3. Decision coverage: Decisions 1–72

The complete wording and status of every decision live only in the [Architecture Review Decision Log](ARCHITECTURE_REVIEW_DECISIONS.md). To avoid duplicated or drifting copies, this summary groups the decision ranges rather than reproducing all decision text:

| Decision range | Subject |
|---|---|
| 1–11 | Architecture layers, turn orchestration, resolution, ownership, economy, bankruptcy, and atomic commit responsibility |
| 12–18 | Server authority, remote request contracts, idempotency, dice/movement authority, persistence boundary, async context, and module dependencies |
| 19–28 | Serialized mutations, FIFO ordering, staged plans, Copy-on-Write, versioning, controlled reads, recalculation, and root swap |
| 29–32 | Post-commit effects, effect registry, dependency ordering, victory retry, and progression gate |
| 33–43 | Recovery executor and lock, recovery completion, verified resume, checkpoint creation, validation, retention, memory, and failure handling |
| 44–52 | Consolidation review and corrective decisions for candidate-state commit, global victory gating, atomic effect publication, effect idempotency, recovery completion ordering, committed-mutation preservation, separated version domains, and separated victory evaluation from Game-End mutation |
| 53–75 | Conventional server-authoritative runtime, deterministic checkpoint integrity, single Checkpoint Manager ownership, verified recovery-baseline protection, fail-closed recovery on operation-journal integrity failure, append-only Operation Journal, hash-chain integrity, segmented Operation Journal, authoritative Journal Recovery Manifest, intermediate Journal replay checkpoints, bounded Recovery replay budget, verified Recovery progress attestation, Recovery Integrity Audit Trail, structured Recovery fault classification, Recovery Circuit Breaker, Recovery Escalation Protocol, Recovery Isolation Boundary, Priority-Based Recovery Scheduling with Fairness Guarantee, Recovery Scheduler Admission Control, Durable Recovery Queue State, Tamper-Evident Recovery Queue Records, Persistent Recovery Fairness Metadata, and Recovery Scheduler Observability |

Decisions 45–55 close the eleven architecture findings RF-01–RF-11. Decisions 56–75 resolve cross-decision consistency findings CI-01–CI-20. They refine the architecture mechanisms and do not silently rewrite source gameplay rules.

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
| RF-09 | Checkpoint integrity hash lacked deterministic serialization and threat boundaries | Decision 54: Deterministic Checkpoint Serialization and Integrity Contract |
| RF-10 | Checkpoint lifecycle responsibilities overlapped | Decision 55: Single Checkpoint Manager Ownership |
| RF-11 | Roblox server-authority runtime model was unspecified | Decision 53: Conventional Server-Authoritative Runtime Model |
| CI-01 | Memory-pressure cleanup could delete the only verified recovery baseline | Decision 56: Preserve a Verified Recovery Baseline |
| CI-02 | Operation Journal integrity failure lacked an explicit fail-closed recovery boundary | Decision 57: Fail-Closed Recovery on Operation Journal Integrity Failure |
| CI-03 | Operation Journal mutability and retention lacked an explicit contract | Decision 58: Append-Only Operation Journal |
| CI-04 | Operation Journal lacked tamper-evident record linkage and trusted-head verification | Decision 59: Hash Chain Integrity for the Operation Journal |
| CI-05 | Operation Journal lacked explicit segment structure and verification boundaries | Decision 60: Segmented Operation Journal |
| CI-06 | Recovery lacked an authoritative reference for the accepted checkpoint and journal boundary | Decision 61: Authoritative Journal Recovery Manifest |
| CI-07 | Long journal replay lacked a safe intermediate recovery accelerator | Decision 62: Intermediate Journal Replay Checkpoints |
| CI-08 | Large journal replay lacked bounded, resumable work slices | Decision 63: Bounded Recovery Replay Budget |
| CI-09 | Resumable Recovery progress lacked verifiable evidence bound to resulting state | Decision 64: Verified Recovery Progress Attestation |
| CI-10 | Recovery diagnostics lacked an independent integrity-protected audit trail | Decision 65: Recovery Integrity Audit Trail |
| CI-11 | Recovery fault reporting and retry semantics lacked a shared contract | Decision 66: Structured Recovery Fault Classification |
| CI-12 | Repeated Recovery attempts lacked a bounded circuit-breaking policy | Decision 67: Recovery Circuit Breaker |
| CI-13 | Recovery lacked a controlled human-escalation path when automation cannot safely proceed | Decision 68: Recovery Escalation Protocol |
| CI-14 | Recovery coordination lacked match-scoped isolation and bounded multi-match resource governance | Decision 69: Recovery Isolation Boundary |
| CI-15 | Concurrent Recovery work lacked deterministic priority and fair scheduling | Decision 70: Priority-Based Recovery Scheduling with Fairness Guarantee |
| CI-16 | Recovery scheduling lacked explicit admission stages, capacity checks, and bounded queues | Decision 71: Recovery Scheduler Admission Control |
| CI-17 | Recovery queue state could be lost or unsafely replayed after server interruption | Decision 72: Durable Recovery Queue State |
| CI-18 | Durable Recovery queue history lacked independent tamper evidence and trusted-head rollback detection | Decision 73: Tamper-Evident Recovery Queue Records |
| CI-19 | Recovery fairness metadata could reset or lose waiting priority after interruption | Decision 74: Persistent Recovery Fairness Metadata |
| CI-20 | Recovery Scheduler lacked bounded operational visibility into queue health, delays, and bottlenecks | Decision 75: Recovery Scheduler Observability |

### Remaining findings

No consolidation findings RF-01–RF-11 or cross-decision consistency findings CI-01–CI-20 remain unresolved at the architecture-contract level. The required Roblox Studio prototypes, performance measurements, and acceptance tests remain outstanding; documentation closure is not implementation evidence.


## 5. Source-of-truth boundaries

Keep these document roles distinct:

1. **Gameplay rules:** [Master Source of Truth](MASTER_SOURCE_OF_TRUTH.md) and the relevant historical system documents.
2. **Approved architecture mechanisms:** [Architecture Review Decision Log](ARCHITECTURE_REVIEW_DECISIONS.md).
3. **Analysis and unresolved findings:** [Architecture Consolidation Review](ARCHITECTURE_CONSOLIDATION_REVIEW.md).
4. **Broader validation work:** [Review Backlog](REVIEW_BACKLOG.md).
5. **Historical progress records:** [progress/](progress/), [systems/](systems/), [ui/](ui/), [visual/](visual/), and [audit/](audit/).

A review finding is not an approved rule. A proposal is not LOCKED until explicitly approved and recorded. A documentation decision is not implementation evidence.

## 6. Recommended next work

1. Prototype the shared state pipeline and failure boundaries in Roblox Studio, including deterministic checkpoint serialization and digest verification.
2. Measure checkpoint memory use, retention, retry thresholds, and performance under realistic match conditions, including recovery-baseline protection.
3. Execute the minimum acceptance test matrix in the Consolidation Review, including concurrency, retry, victory gating, recovery, checkpoint, disconnect, and exploit cases.
4. Update implementation readiness only when test evidence supports it.

## 7. Repository hygiene rules

- Do not duplicate full decision text in this summary.
- Do not duplicate the Master Source of Truth inside review documents.
- Keep each unresolved finding in the Consolidation Review as its canonical analysis location.
- Keep each approved architecture decision in the Decision Log as its canonical status location.
- Use links from README and this summary for navigation.
- Preserve historical Progress documents as records, not as competing current specifications.
