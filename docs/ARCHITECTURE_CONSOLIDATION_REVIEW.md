# Relopoli — Architecture Consolidation Review

> **Status:** REVIEW FINDINGS — not yet converted into new LOCKED decisions  
> **Scope:** Architecture Review Decisions 1–44, Master Source of Truth, Progress 19, Progress 20, and Roblox/Luau implementation feasibility  
> **Purpose:** Identify consistency gaps and define a dependency-aware implementation path before Roblox implementation.

---

## 1. Executive Summary

The architecture has a coherent core direction:

- Turn Controller remains the authority for Turn Flow.
- Domain Systems own their mechanics but do not directly mutate authoritative state.
- Server-side validation and serialized mutation protect critical gameplay state.
- Asset ownership is derived from one authoritative source.
- Derived values and Victory checks use current state.
- Game End is a hard gameplay stop.
- Client UI and animation are presentation/input surfaces, not gameplay authority.

The 44 decisions strengthen this design with explicit mutation plans, version checks, copy-on-write, post-commit processing, and in-session recovery.

**Overall assessment:** The architecture is a viable design direction for Roblox Luau, but it is not yet implementation-ready. Several ordering and recovery semantics must be clarified first. The highest-risk gaps are the post-commit effect lifecycle, Victory Check gating, and checkpoint restoration semantics.

This is a documentation review. It does not establish that any system has been implemented, profiled, or tested in Roblox Studio.

---

## 2. REVIEW FINDINGS — Critical

### RF-01 — Mutation Pipeline Ordering Needs One Canonical Definition

**Related decisions:** 5, 21, 22, 23, 25, 26, 27, 28  
**Source alignment:** Progress 20 requires sequential state changes, atomic operations, recalculation, then Global Victory Check.

Decision 5 describes:

`Validate → Commit → Recalculate → Victory Check`

Decision 26 refines this to recalculating derived values against the candidate state before publishing the new root:

`Prepare Candidate → Recalculate → Validate Candidate → Root Swap → Victory Check`

These can be reconciled, but the log does not explicitly state that Decision 26 refines the earlier meaning of “Commit” in Decision 5. Without one canonical pipeline, an implementation could incorrectly publish primary state before derived values are ready.

**Required clarification:** Define root swap as the authoritative commit boundary and make pre-swap recalculation part of candidate preparation.

Suggested canonical flow:

1. Accept operation into FIFO mutation queue and assign queue sequence.
2. Read the latest immutable snapshot and record BaseStateVersion.
3. Build the copy-on-write candidate.
4. Revalidate operation preconditions and BaseStateVersion.
5. Recalculate all affected derived state against the candidate.
6. Validate the complete candidate.
7. Prepare all commit metadata required to accompany the candidate.
8. Swap the active root without yielding and increment StateVersion.
9. Run required post-commit effects.
10. Permit subsequent gameplay mutations only when required global gates have completed.

### RF-02 — A Later Mutation Could Commit Before Victory Check Completes

**Related decisions:** 5, 19, 20, 29, 31, 32  
**Source alignment:** Progress 20 requires a Global Victory Check after each relevant state change and a hard stop after Game End.

Decision 31 blocks gameplay-continuation effects until Victory Check completes. However, it does not explicitly prevent another already-queued mutation, asynchronous Trade, or Transaction from committing before that check finishes.

This creates a dangerous interval:

`Mutation A commits → Victory Check pending → Mutation B commits → Victory Check A detects Game End`

Mutation B may have changed gameplay after the state already satisfied a victory condition.

**Required clarification:** Define a global post-commit gate for all subsequent gameplay mutations that could affect or depend on victory. The gate is released only after the corresponding Victory Check has completed and the Game-End state has been applied if required. UI-only effects may remain independent.

### RF-03 — Effect Registry Publication Must Be Atomic With Its Mutation

**Related decisions:** 28, 29, 30, 31  
Decision 30 says the Effect Registry is part of authoritative Match State and each successful commit produces its required effects. It does not explicitly say when the effect records become visible.

If root swap succeeds but the Effect Registry entries are created afterward, a failure between those steps can leave a committed mutation with no discoverable post-commit work.

**Required clarification:** Stage the complete required-effect records in the candidate state before root swap. The root swap must publish the committed gameplay changes and their pending effect records together. Only after publication may workers process those effects.

### RF-04 — Effect Status Alone Does Not Guarantee Exactly-Once Execution

**Related decisions:** 8, 9, 14, 17, 28, 29, 30, 34  
An effect can perform its action and then fail before its status changes from PROCESSING to COMPLETED. A retry may then repeat the action.

The current statuses (PENDING, PROCESSING, COMPLETED, FAILED) do not by themselves solve this uncertainty.

**Required clarification:** Every effect handler must be idempotent by EffectId, or its effect and completion record must be committed atomically through a defined mechanism. In particular:
- Victory evaluation should be safe to repeat against the same authoritative version.
- Game-End application must be guarded against duplicate execution.
- Client presentation updates should carry version/identity information so duplicate delivery does not create duplicate gameplay.
- Gameplay continuation must be guarded by TurnId/ResolutionId and must not advance twice.

### RF-05 — Recovery Completion Gate Conflicts With Resume Ordering

**Related decisions:** 33, 36, 37  
Decision 36 requires all required effects to be COMPLETED before leaving RECOVERY_REQUIRED. Decision 37 says pending effects are processed after the Recovery Completion Gate passes.

Those instructions imply opposite orderings.

**Required clarification:** Recovery should first acquire its exclusive lock, validate state and operation context, process/retry all required pending effects, resolve ambiguous operations, and run Victory Check. It should then run the Recovery Completion Gate. Only after the gate passes may the match leave RECOVERY_REQUIRED and resume Turn Controller from a verified PendingStep.

---

## 3. REVIEW FINDINGS — High

### RF-06 — Checkpoint Fallback Can Rewind Committed Gameplay

**Related decisions:** 28, 29, 30, 33, 36, 37, 38, 39, 40, 41, 42, 43  
**Source alignment:** Progress 20 states that completed operations are not rolled back.

Checkpoint rules say an invalid newest checkpoint may fall back to an earlier verified checkpoint. However, no append-only operation journal or replay mechanism is defined to reapply committed mutations that occurred after that older checkpoint.

Restoring an older checkpoint directly could erase a completed purchase, payment, transfer, elimination, or other committed operation. That would conflict with the no-rollback rule.

**Required clarification:** Decide what a checkpoint means:
- If it is a recovery verification marker, it must not replace newer authoritative state.
- If it is a restorable snapshot, recovery needs a reliable committed-operation journal and replay rules before an older checkpoint can safely replace current state.

Until that is designed, do not implement fallback by simply assigning an older checkpoint as the active root.

### RF-07 — StateVersion Scope Is Ambiguous Once Effect Registry Is Match State

**Status: ADDRESSED by LOCKED Decision 51 — Separated Version Domains.**  
**Related decisions:** 23, 25, 30, 34, 36, 39, 47, 51

Decision 30 places the Effect Registry in authoritative Match State, while Decisions 23 and 25 use StateVersion to validate gameplay snapshots and Mutation Plans. Without explicit boundaries, routine effect-status, recovery-lock, or checkpoint-catalog updates could invalidate gameplay plans or leave metadata consistency unprotected.

**Recorded resolution in Decision 51:**
- `StateVersion` protects Gameplay State and Derived State and increments only after a successful gameplay-state commit.
- `EffectRegistryVersion` protects Effect Registry records and status changes.
- `RecoveryVersion` protects recovery status and recovery-lock lifecycle metadata.
- `CheckpointCatalogVersion` protects checkpoint catalog metadata.
- Gameplay snapshots and Mutation Plans validate only `StateVersion`; independent metadata changes do not make them stale.
- Recovery validates the relevant metadata versions and the latest applicable gameplay StateVersion.
- Checkpoints record their represented StateVersion without incrementing it.
- Diagnostics use identifiers and timestamps rather than gameplay StateVersion.
- Decision 47's atomic publication requirement remains in force: gameplay changes and required Effect Registry records publish together, with the registry version advancing as part of that publication.

RF-07 is therefore closed at the architecture-contract level. Implementation details and concurrency behavior still require validation during Roblox implementation and testing.

### RF-08 — Victory Check Is Both a Rule Evaluation and a State-Changing Outcome

**Related decisions:** 5, 26, 29, 31, 32  
The source flow says Victory Detection is followed by Victory Validation, Game State = ENDED, Winner Set, Turn Controller STOP, and Gameplay STOP.

The architecture treats Victory Check as a post-commit effect, but the winning outcome itself changes authoritative state.

**Required clarification:** Separate:
1. Read-only victory evaluation against a specific committed StateVersion.
2. A validated Game-End mutation submitted through State Manager, if a victory condition is met.
3. The terminal gate that prevents any later gameplay mutation.

This avoids allowing a post-commit worker to mutate Game State outside the State Manager.

### RF-09 — Checkpoint Integrity Hash Needs a Defined, Feasible Contract

**Related decisions:** 39, 40, 41, 43  
A hash requires a deterministic representation of the checkpoint: stable key ordering, supported value types, treatment of references, and a defined algorithm. The current decision does not specify these.

An integrity hash can help detect accidental data changes, but it is not a substitute for server authority or validation. The design should not assume that a hash alone makes in-memory state secure.

**Required clarification:** Specify the threat being addressed and prototype deterministic serialization, hash calculation, and verification before relying on this mechanism.

### RF-10 — Checkpoint Policy Has Overlapping Responsibilities

**Related decisions:** 37–43  
Checkpoint retention, memory budget, event-driven creation, and non-blocking failure are compatible, but their responsibilities overlap. A single Checkpoint Manager contract should own:
- eligibility at stable boundaries;
- candidate creation and validation;
- memory estimation and retention;
- protection of checkpoints currently in use;
- failure reporting and retry scheduling;
- recovery capability status.

The numerical memory budget, checkpoint count, and performance thresholds remain unselected and should be measured in Roblox Studio rather than guessed.

---


### RF-11 — Clarify Which Roblox Server-Authority Model Is Intended

**Related decisions:** 12, 13, 15  
The project uses “server authoritative” as a trust-boundary principle: the server decides gameplay outcomes and clients send intent. Roblox also documents a specific engine Server Authority model with its own Workspace settings, Input Action System, simulation synchronization, prediction, rollback, and resimulation requirements.

These are related but not interchangeable concepts. The current Relopoli design, where clients present server-confirmed movement and gameplay outcomes, does not by itself establish that the experience intends to enable Roblox's engine Server Authority mode.

**Required clarification:** Explicitly state whether Relopoli will use:
- the conventional server-authoritative model built around server scripts and validated RemoteEvents; or
- Roblox's engine Server Authority model, with its required runtime configuration and client/server simulation architecture.

Do not mix assumptions from the two models without a deliberate design and prototype.

## 4. ROBLOX LUAU FEASIBILITY

### Feasible With Explicit Engineering Constraints

**Server authority:** The source architecture's server-authoritative model is consistent with Roblox's client-server model. ServerScriptService is server-only and is not replicated to clients. RemoteEvents provide asynchronous one-way client/server communication; they do not provide the application's RequestId deduplication, authorization, or idempotency rules automatically.

**Copy-on-write:** Luau supports table cloning and freezing. However, `table.clone()` is shallow, and `table.freeze()` is also shallow. Nested tables require deliberate recursive copy/freeze logic or a carefully designed immutable data structure. A shallow clone/freeze would not satisfy Decision 22 or 24 by itself.

**No-yield commit:** A short, centralized, no-yield commit section is a reasonable application-level atomicity boundary in the server's serialized mutation path. It is not a database transaction and does not protect against every process/server failure. Keep network waits, player input, UI waits, and long calculations outside the commit section.

**Memory/performance:** Copy-on-write, immutable snapshots, Effect Registry records, and retained checkpoints all have memory and CPU costs. The actual state size and mutation frequency must be profiled before choosing copy granularity, retention count, or memory budget.

### Required Roblox Prototypes

1. Deep copy-on-write of nested Game State sections without mutating shared branches.
2. Recursive immutability enforcement and detection of accidental mutable references.
3. Root swap and StateVersion increment under the single mutation executor.
4. FIFO behavior when multiple RemoteEvents arrive close together.
5. Effect retry after injected errors at every boundary between action and status update.
6. Victory Check failure and recovery without allowing another relevant mutation through.
7. Checkpoint creation, validation, retention, and memory measurement under a realistic match.
8. Player disconnect/reconnect while a blocking UI or Bankruptcy PendingStep is active.

Relevant official references:
- Roblox table library: https://create.roblox.com/docs/reference/engine/libraries/table
- Roblox Luau tables, shallow clone/freeze, and recursive patterns: https://create.roblox.com/docs/luau/tables
- Roblox ServerScriptService: https://create.roblox.com/docs/reference/engine/classes/ServerScriptService
- Roblox RemoteEvent: https://create.roblox.com/docs/reference/engine/classes/RemoteEvent
- Roblox client-server runtime: https://create.roblox.com/docs/projects/client-server

---

## 5. SOURCE RULES VS ARCHITECTURE DECISIONS

The following remain source-backed gameplay/integration rules and must not be silently changed by this architecture review:

- Turn Controller owns Turn Flow; domain systems return resolution results.
- Resolution priority remains GAME_END > PLAYER_ELIMINATED > TURN_END > EXTRA_ROLL > CONTINUE.
- News may defer TURN_END until its blocking card is acknowledged, while PLAYER_ELIMINATED and GAME_END take priority.
- All movement types use the shared Movement Engine and server-authoritative logical destination.
- Bankruptcy rescue resumes the prior resolution without repeating completed effects; Final Bankruptcy aborts the current chain and turn.
- Trade and Transaction are asynchronous, not turn-bound, do not reserve assets, and require final validation against current ownership.
- Pending proposals are not ownership; completed operations are not rolled back.
- Game End cancels pending proposals and blocks subsequent gameplay mutation.
- Victory uses current authoritative ownership, active-player count, and current derived values.

The architecture review may define safer implementation mechanisms for these rules, but must not invent new gameplay behavior where the source has no decision.

---

## 6. DEPENDENCY-AWARE IMPLEMENTATION ORDER

Do not begin by implementing every Domain System independently. Establish the shared state pipeline first.

| Phase | Scope | Exit criteria |
|---|---|---|
| 0 | Resolve RF-07 to RF-11 and freeze contracts | Remaining versioning, victory mutation, checkpoint, and Roblox authority contracts are explicit |
| 1 | Game State schema, ownership source, IDs, version model, immutable read API | State ownership and version semantics are testable |
| 2 | FIFO Mutation Queue, Mutation Plan, Copy-on-Write, candidate validation, derived recalculation, root swap | Invalid plans have zero side effects; stale plans rejected |
| 3 | Post-Commit Effect Registry, idempotent handlers, Victory/Game-End gate | Retry cannot duplicate effects; no relevant mutation passes a pending Victory gate |
| 4 | Turn Controller state machine, Resolution Queue, context validation, Remote Request contract | Duplicate/late requests and stale contexts cannot advance gameplay |
| 5 | Domain integration: Movement/Landing, Economy/Bankruptcy, Property/Crown, News/Jail/Transport, Trade/Transaction | Each system uses the same state contracts and source gameplay rules |
| 6 | In-session recovery and Checkpoint Manager | Recovery cannot rewind completed operations or resume an invalid PendingStep |
| 7 | Client UI, replication, animation, and presentation | Client presentation never determines gameplay outcomes |
| 8 | Full integration, exploit, disconnect, failure-injection, and performance testing | Source-backed scenarios pass in Roblox Studio test sessions |

The exact order within Phase 5 may follow dependency relationships between domain systems, but all systems must use the shared State Manager contracts.

---

## 7. MINIMUM ACCEPTANCE TEST MATRIX

Before declaring the architecture implementation-ready, test at least:

1. Two simultaneous requests attempt to purchase the same unowned Property.
2. A stale Mutation Plan arrives after another operation changes StateVersion.
3. A transfer changes Crown/Set/L5 victory eligibility.
4. Victory becomes true while another gameplay mutation is queued.
5. A post-commit effect performs its action and errors before marking COMPLETED.
6. Victory Check fails repeatedly and reaches the recovery threshold.
7. Recovery starts while an effect is PROCESSING.
8. Recovery fails during cleanup and releases or invalidates its lock safely.
9. Recovery finds a pending effect and verifies completion before leaving RECOVERY_REQUIRED.
10. The newest checkpoint fails integrity validation while later committed operations exist.
11. A checkpoint cannot be created because the memory budget is exhausted.
12. A player disconnects during Bankruptcy recovery or a blocking News UI.
13. Game End occurs while Trade/Transaction proposals remain pending.
14. Client sends duplicate, replayed, stale, malformed, and rate-limited requests.
15. Character reset interrupts visual movement while logical movement remains server-authoritative.

For every test, assert both the expected result and the absence of unintended side effects.

---

## 8. CONSOLIDATION VERDICT

**Architecture direction: SOUND.** The responsibility boundaries, server authority, sequential mutation, source-of-truth ownership, and Turn Controller orchestration form a coherent foundation.

**Implementation readiness: NOT YET.** RF-01 through RF-06 have been addressed by LOCKED Decisions 45–50. RF-07 through RF-11 remain unresolved and must be closed before the shared architecture contracts are treated as implementation-ready. The remaining findings concern version scopes, the boundary between victory evaluation and Game-End mutation, checkpoint integrity and ownership, and the intended Roblox server-authority model. The review is documentation analysis, not evidence of Roblox Studio implementation or testing.

No prior LOCKED decision is silently changed by this report. Decisions 45–50 address RF-01 through RF-06. RF-07 through RF-11 remain open and are not approved design decisions. Any correction or refinement must be approved as a new, traceable decision and recorded in the Architecture Review Decision Log.