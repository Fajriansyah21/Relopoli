# Relopoli — Architecture Review Decision Log

> Purpose: Record decisions approved during the architecture review so they remain traceable in the repository.
> Status labels: **LOCKED** = explicitly approved; **PROPOSAL** = not yet approved; **REVIEW FINDING** = analytical observation.
> This log records architecture and implementation decisions. It does not silently rewrite source gameplay rules in the Master Source of Truth.

## Decision 1 — Four-Layer Architecture
**Status: LOCKED**

Relopoli architecture is organized into four layers:

1. **Orchestration Layer** — Turn Controller owns gameplay flow, turn order, pause/resume, and Turn End.
2. **Domain Systems** — Economy, Property, Crown, Movement, News, Jail, Transport, Trade, and Transaction own their respective gameplay mechanics.
3. **State & Validation Layer** — Game State Manager handles validation, state mutation, and consistent mutation ordering.
4. **Global Rules Layer** — Victory & Game-End Controller checks global win conditions, elimination, and the hard Game-End gate.

Domain Systems must not arbitrarily mutate critical gameplay state. Critical changes use a consistent validation and mutation path.

## Decision 2 — Explicit Turn State Machine
**Status: LOCKED**

The Turn Controller uses explicit states:

- `TURN_START`
- `PRE_ROLL`
- `RESOLVING`
- `WAITING_INPUT`
- `RESULT_CHECK`
- `EXTRA_ROLL`
- `TURN_END`
- `ABORTED` / `GAME_ENDED`

Process context is traceable through `TurnId`, `ResolutionId`, `OperationId`, `CurrentPhase`, and `PendingStep`. The purpose is to prevent stale process results from affecting a new turn and to support precise pause/resume. The Turn Controller remains the central flow authority.

## Decision 3 — Resolution Chain Standards
**Status: LOCKED**

1. **Monotonic Result:** resolution priority may remain the same or move higher, never lower:
   `GAME_END > PLAYER_ELIMINATED > TURN_END > EXTRA_ROLL > CONTINUE`.
2. **Managed Resolution Queue:** sequential resolutions, including News chains and Special Movement, are managed by the Turn Controller. Avoid unmanaged recursive calls. No artificial gameplay cap is imposed on Lucky Steps.
3. **Fresh-State Resume:** resumed processes use the latest authoritative server state, not a stale snapshot, and revalidate their context.

These are architecture and implementation standards, not changes to gameplay rules.

## Decision 4 — Single Source of Truth for Asset Ownership
**Status: LOCKED**

Asset Ownership is the only source of truth for ownership-dependent calculations:

- Property System does not maintain a duplicate authoritative ownership copy.
- Crown System does not cache authoritative district Property counts.
- Victory System does not use historical ownership.
- Set Completion is computed from current ownership.
- Crown Reward is computed from current ownership.
- Each transfer commits atomically before derived-state recalculation and Global Victory Check.

## Decision 5 — Commit → Recalculate → Victory Check
**Status: LOCKED**

Every relevant state mutation follows this order:

1. Validate the latest state and operation preconditions.
2. Commit the operation atomically.
3. Recalculate affected derived state, including Set, district Property count, Crown, L5, and active players.
4. Run Global Victory Check.
5. Continue gameplay or end the game.

For elimination, all required cleanup completes before Victory Check. Victory Check must not run midway through cleanup.

## Decision 6 — Every Asset Sale Is a Separate Atomic Operation
**Status: LOCKED**

For each asset sale during Liquidation:

1. Player selects one asset.
2. Server validates current ownership and asset condition.
3. State Manager commits that sale atomically.
4. Recalculate affected Set, Property, Crown, and other derived state.
5. Run Global Victory Check.
6. If there is no Game End and Balance remains negative, allow another sale.
7. If Balance is non-negative, Liquidation ends.
8. If no assets remain and Balance is negative, proceed to Final Bankruptcy.

If Game End occurs after a sale, stop further Liquidation.

## Decision 7 — Economy Creates Payment Plan, State Manager Executes It
**Status: LOCKED**

- Economy calculates obligations, recipients, Shield use, Bankruptcy outcome, and creates the Payment Plan.
- State Manager revalidates the latest state and executes Balance changes/payment atomically.
- Property and Crown systems own their domain asset rules and reset logic.
- Victory Controller checks after relevant state changes.

Example: with Balance 5K and Rent 8K while Shield is active, the payer pays 5K, Shield covers 3K, and the recipient receives the full 8K. Shield is consumed for one negative-balance event.

## Decision 8 — Pending Payment + Operation ID
**Status: LOCKED**

Each Payment Plan has a unique `OperationId`. The obligation remains pending throughout Bankruptcy recovery; an asset sale is not itself payment. Once ability to pay is determined, State Manager executes the payment exactly once. The recipient receives money exactly once. If Final Bankruptcy occurs, the resolution aborts and no further payment action from that process may execute.

This is an approved architecture proposal, not a claim that the original gameplay documents already specify this mechanism.

## Decision 9 — Terminal Payment Status
**Status: LOCKED**

Each Payment Plan has one of these statuses:

- `PENDING` — waiting for obligation resolution.
- `COMPLETED` — payment successfully distributed.
- `ABORTED` — process stopped due to Final Bankruptcy or Game End.

A terminal status cannot be reactivated or executed again. This is an approved architecture proposal.

## Decision 10 — Bankruptcy Process Persistence
**Status: LOCKED**

During a match session, Bankruptcy status remains in authoritative server Game State if the player disconnects:

- Disconnect does not automatically abort the Payment Plan.
- Disconnect does not automatically sell assets or eliminate the player.
- If the player returns to the same match server, resume from the last `PendingStep`.
- Completed operations must not execute again.
- Recovery after the match server ends or crashes is not defined by this decision and requires a separate design decision.

## Decision 11 — State Manager as Atomic Commit Executor
**Status: LOCKED**

Responsibility split:

1. **Domain Systems** calculate gameplay rules and submit state-change commands/intents.
2. **State Manager** validates the latest conditions and executes the state mutation as a short commit.
3. **Derived Calculators** recalculate derived values such as Set, Property Count, Crown, and other derived state.
4. **Victory Controller** checks global victory conditions after commit and recalculation.

Roblox implementation constraint: atomicity here does not mean a built-in database transaction. It means final validation and all writes in the commit are performed without yielding in the middle. UI waits, network waits, and other asynchronous waits must happen outside the critical commit section.

---

## Decision 12 — Server as the Sole Gameplay Authority
**Status: LOCKED**

Proposed trust boundary:

- Server-owned gameplay logic and authoritative state reside in server-only code, such as `ServerScriptService`.
- `ReplicatedStorage` may contain shared modules, constants, configuration, and remotes, but is not an authority boundary.
- Client scripts in `StarterPlayerScripts` and `StarterGui` handle input and presentation only.
- Client sends player intent, such as requesting a dice roll or selecting an asset to sell.
- Server validates the request against current authoritative state, calculates outcomes, commits mutations, and replicates official results.
- Never trust client-calculated balances, ownership, dice results, movement outcomes, Jail/Crown status, or victory state.

This trust boundary is an approved architecture decision. The client is an input and presentation surface, never the authority for gameplay outcomes.


## Decision 13 — Standardized Remote Request Contract
**Status: LOCKED**

Every gameplay request sent by a client must follow a standardized contract:

1. Include a unique `RequestId` to identify the request.
2. Include only the action type and required payload.
3. Server validates player identity, current Turn phase, action permission, and latest authoritative Game State.
4. Server detects duplicate `RequestId` values so one request cannot be executed repeatedly.
5. Server applies rate limits to protect against request spam.
6. Invalid requests are rejected without side effects.
7. The server sends the official result back to the client.

`RequestId` identifies a communication request. `OperationId` identifies a gameplay operation. They are separate identifiers and must not be conflated.


## Decision 14 — Idempotent Request Replay
**Status: LOCKED**

The server handles repeated client requests idempotently:

- Server stores the result of each processed request, keyed by player identity, match identity, and `RequestId`.
- If an identical request is resent, server returns the previously recorded result without executing the gameplay operation again.
- If the same `RequestId` is reused with a different payload, server rejects the request.
- A request that is still being processed must not execute again in parallel.
- Deduplication records remain available for as long as needed to prevent duplicate execution within the match session.
- Requests that are expired or belong to an old Turn context must be revalidated.

This decision complements Decision 13. `RequestId` deduplication prevents repeated request execution, while `OperationId` continues to identify the underlying gameplay operation.


## Decision 15 — Server-Authoritative Dice & Movement
**Status: LOCKED**

- Server independently generates the official dice result.
- Server determines the number of movement steps using the dice result and gameplay rules.
- The server-side Movement Engine manages the official player position and movement.
- Client only presents movement animation based on the official server result.
- Client must not submit a final position and have it trusted as authoritative.
- Landing Resolution is processed only from the official position determined by the server.
- Delayed or failed client animation must not change gameplay outcomes.

This separates authoritative gameplay outcomes from client-side visual presentation.


## Decision 16 — Match State Persistence Boundary
**Status: LOCKED**

- **Live Match State** is held in the match server's memory as the authoritative state while the match is running.
- **Player Persistent Data**, such as permanent profile and progression, is handled through DataStoreService.
- DataStoreService is not used for every in-match gameplay mutation.
- Match recovery after a server crash is not automatically guaranteed by this decision.
- If cross-server Match Recovery is desired later, it requires a separate design covering snapshots, validation, and duplicate-operation prevention.

This separates persistent player data from the live state of an active match.


## Decision 17 — Context Validation for Asynchronous Results
**Status: LOCKED**

- Each asynchronous process carries the relevant context identifiers: `TurnId`, `ResolutionId`, and `OperationId`.
- Before an asynchronous result is applied, the server validates whether its process context is still valid.
- Results from an ended Turn or Resolution must not mutate gameplay state.
- If Game End occurs, all pending gameplay processes follow the established Game End cancellation rules.
- Completed operations must not be rolled back or executed again.
- A still-valid process may resume from its last `PendingStep`.

This decision protects the authoritative state from stale asynchronous results and complements Fresh-State Resume and Request Deduplication.


## Decision 18 — One-Way Module Dependency
**Status: LOCKED**

- Turn Controller may coordinate Domain Systems.
- Domain Systems may use State Manager services through defined contracts.
- Domain Systems must not take over Turn Controller responsibilities.
- Domain Systems must not form circular calls with one another.
- Cross-domain interactions that require multiple systems are coordinated through the Orchestration Layer.
- Derived Calculators read state and calculate derived values; they do not perform gameplay mutations themselves.
- Victory Controller receives the results of state changes and performs the global checks.

This defines dependency direction and responsibility boundaries. It does not require every gameplay flow to execute in one fixed linear sequence.


## Decision 19 — Serialized State Mutation Queue
**Status: LOCKED**

- All operations that change critical Game State enter through one State Manager execution path.
- Mutations are processed sequentially rather than overwriting one another.
- Each operation is revalidated immediately before commit.
- One operation must finish its commit before the next operation begins its commit.
- Operations waiting for player input or network activity must not hold the commit queue.
- Operations that fail validation are rejected without side effects.
- Each operation retains its `OperationId` for traceability and duplicate-execution prevention.

This queue serializes critical state mutations only. It does not require animations, UI, or all gameplay processes to run sequentially.


## Decision 20 — FIFO Mutation Ordering
**Status: LOCKED**

- Operations are processed in the order received by the State Manager (First In, First Out).
- Each operation receives a unique queue sequence number.
- An operation may not bypass earlier queued operations merely because it originates from a different system.
- Validation is still performed immediately before commit.
- An operation that is no longer valid is rejected, and queue processing continues.
- If Game End occurs, the hard Game-End gate applies. Gameplay operations that have not committed must not continue mutating state.
- Completed operations are not rolled back or executed again.

This makes mutation order traceable according to the order in which the server accepted operations.


## Decision 21 — Staged Mutation Plan
**Status: LOCKED**

- Domain Systems prepare a mutation plan without directly changing authoritative Game State.
- State Manager validates the complete plan against the latest state.
- All intended changes are prepared as a Mutation Plan before commit.
- If validation or preparation fails, no state is changed.
- Once prepared, State Manager executes the commit without yielding and without invoking asynchronous processes.
- Only successfully committed operations may trigger derived-state recalculation and Global Victory Check.
- The implementation must include a recovery mechanism for commit-time failures so the game is not left in a partially mutated state.

This separates mutation preparation from execution. The exact recovery mechanism must be designed and tested during implementation; this decision does not assume a built-in Roblox transaction facility.


## Decision 22 — Copy-on-Write State Commit
**Status: LOCKED**

- State Manager reads the latest authoritative Game State.
- The Mutation Plan produces a candidate state without modifying the active state.
- Only affected state sections are copied and updated using Copy-on-Write.
- The candidate state is validated as a whole before commit.
- If validation fails, the candidate is discarded and the active state remains unchanged.
- If validation succeeds, State Manager swaps the root Game State reference to the candidate in a short commit without yielding.
- Other systems must read state through the official State Manager access path and must not retain mutable references to old state.

Implementation must avoid copying the entire Game State for every operation without need. Memory and performance costs must be measured during Roblox implementation.

This decision extends the Staged Mutation Plan. It does not imply that Roblox provides a built-in transaction facility.


## Decision 23 — Versioned State Commit
**Status: LOCKED**

- Authoritative Game State maintains a monotonically increasing `StateVersion`.
- Each Mutation Plan records the `BaseStateVersion` from which it was prepared.
- Immediately before commit, State Manager compares the plan's `BaseStateVersion` with the active state's current version.
- If the versions match, the commit may proceed.
- If the versions differ, the candidate is stale and must not be committed.
- The Mutation Plan must be rebuilt from the latest state and validated again.
- `StateVersion` increments only after a successful commit.

This version check supplements FIFO mutation ordering and Copy-on-Write by preventing a candidate built from stale state from replacing a newer active state.


## Decision 24 — Controlled State Access API
**Status: LOCKED**

- State Manager provides the official API for reading authoritative Game State.
- Other systems receive read-only views or snapshots.
- Domain Systems must not directly mutate authoritative state tables.
- All mutations must be submitted through a Mutation Plan.
- Read access must not expose mutable table references that can alter active state.
- State Manager is the sole owner of the root Game State reference.

This protects the mutation pipeline by preventing systems from bypassing validation, commit ordering, and StateVersion checks.


## Decision 25 — Version-Bound Read Snapshot
**Status: LOCKED**

- Every read snapshot carries the StateVersion at which it was created.
- Snapshots are immutable and cannot mutate the active authoritative Game State.
- A calculation that produces a Mutation Plan records the source snapshot version as its BaseStateVersion.
- Before commit, State Manager validates BaseStateVersion against the current active StateVersion.
- If the version has changed, the stale plan is rejected and the calculation must be rebuilt from the latest state and revalidated.
- Older snapshots may still be used for UI or historical presentation when the consumer does not require the latest authoritative state.

This aligns controlled read access with Versioned State Commit and prevents calculations based on stale state from being committed.


## Decision 26 — Recalculate Before State Swap
**Status: LOCKED**

- Derived Calculators recalculate all affected derived values against the candidate Game State before it becomes active.
- Recalculated values are included in the candidate state.
- The complete candidate state is validated for consistency before commit.
- State Manager swaps the active root Game State only after recalculation and validation succeed.
- Victory Check runs after the successful state swap.
- Other systems must not observe a partially updated state containing new primary data with stale derived values.

This extends the Copy-on-Write commit flow so the active Game State is published only as a consistent whole.


## Decision 27 — Fail-Closed Recalculation
**Status: LOCKED**

- If recalculation of affected derived values fails, the candidate state is rejected.
- The active root Game State remains unchanged.
- StateVersion does not increment for the rejected operation.
- Victory Check does not run for the failed operation.
- The operation is marked failed and its failure is recorded for debugging.
- The system must not silently fall back to stale derived values from the previous state.

This ensures that a recalculation failure cannot publish a partially updated or internally inconsistent Game State.


## Decision 28 — Atomic Root Swap Boundary
**Status: LOCKED**

- The active root Game State may only be replaced through a dedicated State Manager commit function.
- Root replacement occurs within one critical section without yielding.
- All validation and recalculation must finish before this commit function is invoked.
- If commit preconditions are not satisfied, the previous active root remains in place.
- Once the root replacement succeeds, the operation is considered committed and must not be executed again.
- A failure occurring after commit must not trigger automatic re-execution of the operation.

This defines a clear boundary between pre-commit failure and post-commit failure. It does not assume Roblox provides a built-in transaction for Lua tables.


## Decision 29 — Post-Commit Effect Separation
**Status: LOCKED**

- A successful root state swap marks the mutation operation as committed.
- Post-commit effects execute after commit and outside the critical section.
- Each post-commit effect has its own identity and execution status.
- A failed effect may be retried under an explicit retry policy without re-running the committed mutation.
- An effect that has already succeeded must not be executed again.
- Gameplay-critical effects, including Victory Check, require a stronger recovery mechanism than presentation-only effects such as UI notifications or animations.

This separates authoritative state mutation from subsequent work and prevents post-commit failures from duplicating committed gameplay operations.


## Decision 30 — Post-Commit Effect Registry
**Status: LOCKED**

- Each successful commit produces a registry of its required post-commit effects.
- Each effect records an EffectId, OperationId, effect type, and execution status.
- Effect statuses are PENDING, PROCESSING, COMPLETED, and FAILED.
- The registry is part of the authoritative Match State.
- PENDING or FAILED effects may be processed again under an explicit retry policy.
- COMPLETED effects must not be executed again.
- The registry is scoped to the lifetime of the match server session and does not guarantee recovery after a server crash.

This provides traceability between committed mutations and their outstanding post-commit work without implying cross-server durability.


## Decision 31 — Effect Dependency Ordering
**Status: LOCKED**

- A post-commit effect may declare dependencies on other effects.
- Gameplay-continuation effects must wait until Victory Check has completed.
- Presentation-only effects, such as UI updates, may run independently when they do not affect gameplay progression.
- The Effect Registry may execute an effect only after all its declared dependencies are COMPLETED.
- If a dependency fails, dependent effects remain blocked until the dependency completes.
- The dependency graph must not contain circular dependencies.

This preserves required gameplay ordering without forcing unrelated presentation effects to execute serially.


## Decision 32 — Victory Check Retry and Game Progression Gate
**Status: LOCKED**

- A failed Victory Check remains in FAILED status.
- The system retries the check according to an explicit retry policy.
- Gameplay Continuation remains blocked until Victory Check completes successfully.
- If the retry limit is reached, the match enters SYSTEM_ERROR or RECOVERY_REQUIRED.
- This condition pauses gameplay and does not automatically end the match or declare a winner.
- Recovery must use an explicit server-side mechanism.

This prevents gameplay from advancing while the authoritative victory outcome is unknown, without treating a system failure as a gameplay result.


## Decision 33 — Server-Controlled Recovery
**Status: LOCKED**

- Only the server is authorized to execute match recovery.
- Clients cannot directly request changes to internal match recovery status.
- Recovery validates StateVersion and the latest committed operation.
- Recovery inspects the Effect Registry to identify unfinished post-commit work.
- Recovery resumes pending effects without re-executing mutations that have already committed.
- If state consistency cannot be verified, the match remains blocked in RECOVERY_REQUIRED.
- Recovery must not invent or assume gameplay outcomes.

This keeps recovery under the same server authority that governs gameplay and preserves the distinction between committed mutations and unfinished post-commit effects.


## Decision 34 — Single Recovery Executor
**Status: LOCKED**

- Only one Recovery Executor may be active for a match at a time.
- Recovery uses an internal server-side lock.
- An effect being processed by recovery must not be processed concurrently by another worker.
- Each recovery attempt has a unique RecoveryId.
- Recovery revalidates StateVersion before continuing work.
- If recovery fails, the lock is released safely and the match remains in RECOVERY_REQUIRED.
- A subsequent recovery attempt uses the latest authoritative state rather than assumptions from the previous attempt.

This prevents concurrent recovery attempts or workers from processing the same post-commit effect at the same time.


## Decision 35 — Recovery Lock Lifecycle
**Status: LOCKED**

- Recovery lock states are ACQUIRED, RELEASED, and INVALIDATED.
- A lock is bound to its RecoveryId.
- Only the Recovery Executor that owns the lock may release it.
- Every recovery execution path must release the lock through guaranteed cleanup, including error paths.
- A timeout must not automatically permit a second recovery executor to run concurrently.
- If lock ownership cannot be verified, the match remains in RECOVERY_REQUIRED until the server establishes that recovery can safely proceed.

This lifecycle prevents both abandoned locks and unsafe concurrent recovery execution.


## Decision 36 — Recovery Completion Gate
**Status: LOCKED**

Before a match may leave RECOVERY_REQUIRED, the server must:

1. Confirm that no other recovery process is active.
2. Confirm that all required post-commit effects are COMPLETED.
3. Confirm that no mutation operation remains in an ambiguous state.
4. Validate consistency between the Game State and its Derived State.
5. Confirm that Victory Check has completed.
6. Ensure StateVersion remains valid throughout the verification process.
7. Only then restore the match to the appropriate gameplay state.

If any verification fails, the match remains in RECOVERY_REQUIRED.

Recovery is not considered complete merely because its execution stopped without an error; the server must verify that the match state is safe to resume.


## Decision 37 — Resume From Verified Checkpoint
**Status: LOCKED**

- Recovery retains a reference to the latest verified gameplay checkpoint within the match server session.
- After the Recovery Completion Gate passes, the server reads the latest valid Turn and Resolution context.
- Turn Controller resumes from the PendingStep that remains valid.
- Effects already marked COMPLETED are not executed again.
- Pending effects are processed according to the Effect Registry and its dependency rules.
- If the Turn or Resolution context is no longer valid, the server must not guess the next gameplay step; the match remains in recovery for further handling.
- This checkpoint is scoped to the match server session and does not guarantee recovery after a server crash.

This defines a verified in-session resume point without implying cross-server persistence.


## Decision 38 — Stable-Boundary Checkpoint
**Status: LOCKED**

A gameplay checkpoint may be updated only when all of the following conditions are true:

1. No mutation is currently being processed.
2. All required effects from the preceding commit have completed.
3. Victory Check has completed.
4. Turn and Resolution Context are at a valid boundary.
5. No recovery process is active.

The previous verified checkpoint is retained whenever these conditions are not all satisfied.

This prevents recovery from selecting a checkpoint captured while gameplay is only partially processed.


## Decision 39 — Checkpoint Version and Integrity Validation
**Status: LOCKED**

- Every checkpoint has a unique CheckpointId.
- Every checkpoint records the StateVersion at which it was created.
- Every checkpoint records its associated TurnId and ResolutionId.
- Every checkpoint has an integrity hash to detect unexpected data changes or corruption.
- Before a checkpoint is used, the server validates its integrity hash and version consistency.
- If validation fails, the checkpoint is rejected and the server falls back to an earlier verified checkpoint.
- If no valid checkpoint is available, the match remains in RECOVERY_REQUIRED.
- The integrity hash is for detecting corruption or unexpected changes and does not replace server-side security validation.

This makes checkpoint integrity and provenance verifiable before recovery uses the checkpoint.


## Decision 40 — Bounded Checkpoint Retention
**Status: LOCKED**

- Retain a bounded set of the newest verified checkpoints.
- The newest valid checkpoint is the primary recovery candidate.
- Do not delete a previous checkpoint until its replacement has been successfully verified.
- A checkpoint currently in use by recovery must not be deleted.
- Apply limits to checkpoint count and memory usage so retention remains bounded.
- When a limit is reached, remove the oldest checkpoint that is not in use.
- This retention policy applies within the lifetime of the match server session.

This balances fallback availability with bounded memory usage and does not imply persistence across server crashes.


## Decision 41 — Checkpoint Memory Budget
**Status: LOCKED**

- Checkpoint Manager has a dedicated memory budget.
- Each checkpoint estimates its memory usage when created.
- Before storing a new checkpoint, the system checks the available budget.
- If the budget is insufficient, the oldest checkpoint that is not currently in use may be removed.
- If the budget remains insufficient, the new checkpoint is not created and the previous verified checkpoint is retained.
- Checkpoint creation failure is recorded for debugging.
- Gameplay stability must not be sacrificed merely to preserve additional recovery checkpoints.

This keeps checkpoint retention bounded and prevents recovery history from consuming memory needed for stable match execution.


## Decision 42 — Event-Driven Checkpoint Creation
**Status: LOCKED**

- Checkpoints are created in response to important events rather than on a fixed time interval.
- Eligible events include reaching a stable boundary, completing an important operation that changes match state, and successfully completing recovery.
- A checkpoint must not be created while a mutation, required effect, or Victory Check remains incomplete.
- When multiple eligible events occur close together, checkpoint creation may be coalesced into one checkpoint at the next stable boundary.

This avoids excessive checkpoint creation while preserving important in-session recovery points.


## Decision 43 — Non-Blocking Checkpoint Failure
**Status: LOCKED**

- Failure to create a checkpoint does not cancel a mutation that has already committed.
- The match may continue gameplay when all normal gameplay conditions are satisfied.
- The previous verified checkpoint is retained.
- Checkpoint creation failure is recorded with its reason and the relevant StateVersion context.
- Checkpoint Manager may retry checkpoint creation at a subsequent stable boundary.
- If no valid checkpoint is available, the system marks recovery capability as limited and must not fabricate a replacement checkpoint.

This keeps checkpoint creation as a protective layer without undoing valid committed gameplay operations.


## Decision 44 — Architecture Consolidation Review
**Status: LOCKED**

- Conduct a consolidation review of the 43 preceding locked architecture decisions before implementation planning.
- Audit consistency across decisions and identify contradictions, overlaps, and unresolved dependencies.
- Keep architecture decisions distinct from source-backed gameplay rules.
- Assess feasibility for implementation in Roblox Luau and identify assumptions requiring prototypes or tests.
- Produce an implementation sequence based on dependencies.
- Record findings separately from locked decisions; do not silently alter or reinterpret prior decisions during the review.

This review is a consolidation and readiness assessment, not evidence that the systems have been implemented or tested in Roblox.


## Decision 45 — Canonical Candidate-State Commit Pipeline
**Status: LOCKED**

All critical gameplay mutations use one canonical candidate-state pipeline:

1. State Manager accepts the operation through the FIFO Mutation Queue.
2. State Manager reads the latest immutable snapshot and records its BaseStateVersion.
3. The operation builds a Mutation Plan and Copy-on-Write candidate state without modifying the active root.
4. State Manager validates operation preconditions and confirms the BaseStateVersion is still current.
5. Derived Calculators recalculate all affected derived values against the candidate state.
6. State Manager validates the complete candidate state for consistency.
7. Required post-commit effect records and operation metadata are prepared as part of the candidate state.
8. State Manager performs the root swap without yielding and increments StateVersion.
9. The operation is marked COMMITTED at the authoritative commit boundary.
10. Post-commit effects execute outside the critical section under their own identity, status, dependency, and retry rules.

The root swap publishes the gameplay state, recalculated derived state, committed-operation metadata, and required post-commit effect records as one authoritative candidate. No active state or effect registry entry may be published partially.

This decision establishes the canonical ordering for the mutation pipeline. It does not by itself resolve effect idempotency, Victory Check gating, or recovery ordering; those remain separate review findings requiring explicit decisions.


## Decision 46 — Global Victory Check Gate
**Status: LOCKED**

Every committed mutation that can affect victory activates a global gameplay-progression gate after the atomic Root Swap.

1. The gate prevents subsequent gameplay mutations from committing until the Victory Check associated with the newly committed StateVersion has completed.
2. Victory Check evaluates the authoritative state at the StateVersion produced by the triggering commit.
3. If no victory condition is met, the gate is released and queued gameplay mutations may continue in their defined order.
4. If victory is detected, Game End is applied through the State Manager's canonical mutation pipeline. An Effect Worker or Victory Check worker must not directly mutate authoritative gameplay state.
5. If Victory Check fails, the gate remains locked. The system enters the defined Recovery path; gameplay mutation processing must not resume until the check is successfully resolved.
6. Non-gameplay presentation effects may proceed independently where they do not mutate or depend on gameplay progression.

This gate serializes victory-sensitive gameplay progression across the post-commit Victory Check boundary. It does not replace the canonical candidate-state commit pipeline or the separate effect identity, idempotency, and recovery rules.


## Decision 47 — Atomic Effect Registry Publication
**Status: LOCKED**

The Effect Registry is part of the authoritative Match State and must be published atomically with the gameplay mutation that requires its post-commit effects.

1. Every mutation that requires post-commit effects must include all required Effect Records in its candidate state before Root Swap.
2. The atomic Root Swap publishes gameplay state, derived state, committed-operation metadata, and the required Effect Registry records together.
3. Effect Workers may process only Effect Records that are visible in committed authoritative state.
4. There must be no observable state in which the gameplay mutation is marked COMMITTED while a required Effect Record is absent from the committed Effect Registry.
5. If candidate preparation or validation fails, none of the candidate's gameplay state, metadata, or Effect Registry records may be published.

This decision defines atomic publication, not exactly-once execution or retry semantics. Effect identity, idempotency, and recovery remain governed by their separate decisions and review findings.


## Decision 48 — Effect Idempotency and Retry Safety
**Status: LOCKED**

Post-commit effects use stable identities and explicit completion semantics to prevent duplicate gameplay state transitions during retries and recovery.

1. Every Effect Record has a unique, stable `EffectId`. All retries of the same logical effect reuse that identity.
2. Every effect handler must inspect the effect's committed status and prior result before attempting execution.
3. A gameplay-mutating effect and its `COMPLETED` status must be applied through one atomic State Manager commit. The gameplay transition must not become committed separately from the completion record that prevents its duplicate application.
4. Retry processing may execute only effects that are not already completed. An effect marked `COMPLETED` must never be applied again.
5. `PROCESSING` does not mean completed. Recovery must inspect the authoritative committed state and effect identity before deciding whether the effect needs execution or can be marked completed.
6. For external or presentation effects, exactly-once execution is not guaranteed when the destination system does not support deduplication. Where supported, pass the stable `EffectId` as the destination's idempotency key.

The target guarantee is effectively-once gameplay state transition, not a universal exactly-once guarantee for every Roblox-side or external effect.


## Decision 49 — Recovery Completion Gate Before Gameplay Resume
**Status: LOCKED**

Recovery may restore gameplay progression only after all recovery completion conditions have been verified against authoritative state.

1. Recovery may enter `COMPLETED` only after every required effect is completed or authoritatively verified as already completed.
2. Authoritative gameplay state and all required derived state must be consistent.
3. Victory Check must have successfully completed against the latest applicable StateVersion.
4. The Turn/Resolution context, including the applicable `PendingStep`, must be valid and resumable.
5. No other recovery may be active, and no mutation or effect may remain in an ambiguous in-flight state.
6. Gameplay Resume is permitted only after all conditions above are satisfied and Recovery has reached `COMPLETED`.
7. If any condition cannot be verified, Recovery must remain locked and the system must enter or remain in `RECOVERY_REQUIRED`. Gameplay must not resume based on guessed or incomplete state.

`Recovery Completed` is the sole authorization boundary for restoring gameplay progression.


## Decision 50 — Checkpoint Recovery Must Preserve Committed Mutations
**Status: LOCKED**

A checkpoint is a recovery baseline, not a substitute for the authoritative record of committed mutations.

1. Every committed mutation must have an authoritative operation record sufficient to establish its committed identity and ordering for recovery.
2. Recovery identifies a valid checkpoint and reconstructs the committed state changes that occurred after that checkpoint using the authoritative committed-operation records.
3. A mutation already marked committed must not be re-executed as a new operation during reconstruction. Replay or reconstruction must preserve its committed identity and avoid applying its gameplay effect twice.
4. If the required operation records are incomplete, inconsistent, or cannot be integrity-verified, the system must enter or remain in `RECOVERY_REQUIRED`.
5. The system must not silently fall back to an older checkpoint when doing so could discard committed gameplay mutations.
6. The exact operation-journal format, retention, and storage mechanism remain to be specified separately.

This decision establishes the preservation requirement for committed mutations during checkpoint recovery; it does not yet select a concrete journal implementation.


## Decision 51 — Separated Version Domains
**Status: LOCKED**

Authoritative Match State uses separate version domains so gameplay concurrency validation is not invalidated by independent effect, recovery, or checkpoint metadata updates.

1. **Gameplay `StateVersion`** protects authoritative Gameplay State and its Derived State. It increments only after a successful gameplay-state commit through the canonical State Manager pipeline.
2. **`EffectRegistryVersion`** protects Effect Registry records and processing metadata. It increments whenever an Effect Registry record or status is changed.
3. **`RecoveryVersion`** protects recovery status and recovery-lock lifecycle metadata. It increments whenever that recovery metadata changes.
4. **`CheckpointCatalogVersion`** protects checkpoint catalog metadata. It increments whenever the catalog changes, including checkpoint addition, removal, or catalog-status changes.
5. Gameplay read snapshots and Mutation Plans use `StateVersion` and `BaseStateVersion` only. Effect, recovery, or checkpoint metadata changes do not by themselves make a gameplay Mutation Plan stale.
6. Recovery validates the version domains relevant to the records and lifecycle it reads or changes. It must still validate the latest applicable gameplay `StateVersion` before relying on gameplay state.
7. Each checkpoint records the gameplay `StateVersion` it represents. Creating or cataloging a checkpoint does not increment gameplay `StateVersion`.
8. Diagnostic and logging records do not require a gameplay version. They retain the relevant identifiers and timestamps needed for traceability.
9. Version separation does not weaken Decision 47: gameplay mutation data and all required Effect Registry records must still be published atomically in the same candidate-state root swap. The Effect Registry version advances as part of that publication.

This decision defines the scope of each version domain. It does not change gameplay rules or remove the requirement to validate the relevant versions at each authoritative boundary.


## Decision 52 — Separate Victory Evaluation From Game-End Mutation
**Status: LOCKED**

Victory determination and the authoritative Game-End state change are separate responsibilities.

1. **Victory Evaluator is read-only.** It evaluates the authoritative gameplay snapshot for a specific `StateVersion`. It must not mutate Match State, set the winner, or directly stop gameplay.
2. The evaluation result includes the `EvaluatedStateVersion` and the outcome of the applicable victory rules.
3. **State Manager validates the result.** Before acting on it, State Manager confirms that `EvaluatedStateVersion` still matches the current gameplay `StateVersion`. A stale result is rejected and Victory Evaluation must be repeated against the latest authoritative snapshot.
4. When the validated result indicates no victory, the corresponding Victory Check is marked successfully completed and the Global Victory Gate may be released, provided its triggering context is still current.
5. When the validated result indicates victory, Game-End is submitted as a dedicated mutation through State Manager's canonical candidate-state commit pipeline. The mutation validates the winner and applicable state conditions before committing the terminal Game-End state.
6. The Global Victory Gate remains locked throughout evaluation and any required Game-End mutation. Once Game End commits, the gate becomes terminal: no subsequent gameplay mutation or gameplay continuation may be admitted.
7. Victory Evaluator, Effect Workers, and other post-commit workers must never directly mutate authoritative gameplay state. They may submit validated intents or results to State Manager under the established contracts.
8. If evaluation, version validation, or Game-End mutation fails, the gate remains locked and the existing retry/recovery rules apply. The system must not release gameplay progression based on an unknown or uncommitted outcome.

This decision makes Victory Evaluation a version-bound read operation and Game End a separately validated authoritative mutation. It refines Decision 46 without changing the victory rules or winner conditions defined by the gameplay sources.

## Decision 53 — Conventional Server-Authoritative Runtime Model
**Status: LOCKED**

Relopoli will use the conventional Roblox server-authoritative model built around server-side gameplay logic and validated client-server requests. It will not adopt Roblox's engine Server Authority simulation model as part of the current architecture.

1. Authoritative gameplay logic and Match State remain owned by server-side scripts and systems, consistent with Decision 12.
2. Clients communicate player intent through the established request contract. The server validates requests, determines gameplay outcomes, commits authoritative mutations, and publishes official results, consistent with Decisions 13 and 15.
3. Client-side movement, animation, prediction, and presentation do not determine or override authoritative gameplay outcomes.
4. The architecture does not assume or require the engine Server Authority runtime configuration, Input Action System integration, simulation rollback, or resimulation behavior.
5. Any future adoption of Roblox's engine Server Authority model requires a separate architecture review and explicit approved decision. It must not be mixed into the conventional model implicitly.

This decision clarifies the intended runtime model. It does not change the existing server trust boundary, gameplay rules, or client presentation responsibilities.

## Decision 54 — Deterministic Checkpoint Serialization and Integrity Contract
**Status: LOCKED**

Checkpoint integrity validation requires a deterministic and explicitly versioned representation of checkpoint data.

1. **Deterministic serialization:** The same logical checkpoint data must produce the same canonical serialized representation. Serialization must use stable key ordering and consistent value encoding.
2. **Supported values and references:** The checkpoint format must explicitly constrain supported value types. Object references must be represented through stable identifiers rather than live Instance references or other non-portable runtime references.
3. **Integrity algorithm:** The integrity digest must use SHA-256 through a vetted implementation or a verified platform-provided capability. The project must not invent or rely on a homegrown cryptographic hash algorithm.
4. **Format versioning:** Each checkpoint must identify its checkpoint data/schema format version and canonicalization version so validation can apply the correct representation rules.
5. **Creation and verification:** The digest is calculated from the canonical representation when the checkpoint is created and recalculated from that representation before the checkpoint is accepted for recovery.
6. **Threat boundary:** The digest is intended to detect accidental corruption or unexpected data changes. It is not proof of authenticity, a substitute for server authority, or protection against a compromised server or privileged attacker able to alter both data and digest.
7. **Recovery behavior:** A checkpoint whose canonical representation cannot be produced, whose format is unsupported, or whose digest does not match must be rejected. Recovery must continue to obey Decision 50: committed mutations must be preserved, and the system must not silently select an older checkpoint if doing so could discard committed mutations.
8. **Feasibility gate:** Deterministic serialization, digest calculation, and verification must be prototyped and validated in Roblox Studio before this mechanism is relied upon in implementation. The concrete encoding rules and integration details may be specified during that prototype, provided they satisfy this contract.

This decision defines the integrity contract without claiming that Roblox runtime feasibility or performance has already been implemented or tested.

## Decision 55 — Single Checkpoint Manager Ownership
**Status: LOCKED**

A single Checkpoint Manager owns the checkpoint policy and lifecycle coordination. This centralizes checkpoint responsibilities without transferring authority over authoritative gameplay state or recovery execution.

1. **Eligibility and creation:** The Checkpoint Manager determines whether the match is at an eligible stable boundary and coordinates checkpoint candidate creation.
2. **Validation:** It coordinates checkpoint format, version, provenance, and integrity validation before a checkpoint is considered usable.
3. **Retention and memory:** It owns checkpoint retention policy, memory-budget enforcement, and removal of checkpoints that are no longer protected or needed.
4. **In-use protection:** It protects any checkpoint currently selected or held by an active Recovery process from retention cleanup or replacement.
5. **Failure handling:** It records checkpoint creation and validation failures, exposes their status, and coordinates bounded retry scheduling without blocking ordinary gameplay solely because checkpoint creation failed, consistent with Decision 43.
6. **Recovery capability status:** It exposes whether verified checkpoints and required recovery material are available. This status is informational input to the Recovery process, not permission to execute or complete Recovery.
7. **Authority boundary:** The Checkpoint Manager must not directly mutate authoritative Match State, commit gameplay mutations, select gameplay outcomes, or independently execute Recovery. State Manager remains the authority for state mutation, and the established Recovery Executor remains responsible for Recovery execution and completion gates.
8. **Preservation rules:** Checkpoint selection and cleanup must preserve the committed-mutation recovery requirements in Decision 50. A checkpoint must not be deleted or selected in a way that could cause committed mutations to be lost.

This decision centralizes checkpoint policy and lifecycle ownership while preserving the existing State Manager and Recovery Executor authority boundaries. Numeric retention limits, memory budgets, and retry thresholds remain subject to profiling and validation in Roblox Studio.

## Decision 56 — Preserve a Verified Recovery Baseline
**Status: LOCKED**

Checkpoint retention and memory-budget enforcement must preserve the match's minimum verified recovery capability.

1. **Recovery baseline:** Checkpoint Manager must identify and protect at least one verified checkpoint as the recovery baseline whenever one exists.
2. **Replacement before removal:** The current recovery baseline must not be deleted or replaced until a newer checkpoint has been successfully created, validated, and accepted as a verified replacement.
3. **Retention cleanup:** Other older checkpoints may be removed to satisfy retention or memory limits only when they are not protected by an active Recovery process and their removal does not violate the recovery-baseline requirement.
4. **Insufficient memory:** If a new checkpoint cannot be stored without deleting the only verified recovery baseline, Checkpoint Manager must reject the new checkpoint creation and retain the existing baseline.
5. **Gameplay continuity:** Failure to create a replacement checkpoint does not cancel or roll back an already committed gameplay mutation. Gameplay may continue only under the normal conditions established by Decision 43.
6. **No fabricated capability:** If no verified checkpoint exists, the system must report limited or unavailable recovery capability as applicable. It must not label an unverified checkpoint as a recovery baseline.

This decision refines Decisions 40, 41, and 43 by establishing a minimum recovery-baseline protection rule. It does not guarantee recovery after server failure or replace the committed-operation preservation requirements in Decision 50.

## Decision 57 — Fail-Closed Recovery on Operation Journal Integrity Failure
**Status: LOCKED**

Recovery must fail closed whenever the authoritative committed-operation records required to reconstruct gameplay state cannot be verified.

1. **No uncertain replay:** Recovery must not replay an operation record whose integrity, identity, ordering, or committed status cannot be established.
2. **No inferred outcome:** An ambiguous operation must not be assumed to be either committed or uncommitted. Recovery must not infer its gameplay outcome from incomplete evidence.
3. **No replacement identity:** Recovery must not recreate an ambiguous operation under a new OperationId as a workaround for missing or unverifiable records.
4. **Recovery remains blocked:** The Recovery Executor must retain the recovery lock and keep the match in RECOVERY_REQUIRED while required operation records remain incomplete, inconsistent, or unverifiable.
5. **Diagnostic evidence:** The system must preserve and expose the available record identifiers, OperationIds, relevant version/context information, and failure reason for diagnosis without treating diagnostic data as proof of a committed gameplay outcome.
6. **Resume condition:** Recovery may continue only after the integrity and ordering of the required committed-operation history can be established and all existing Recovery Completion Gate conditions are satisfied.
7. **No rollback or fabricated state:** This decision does not authorize discarding committed mutations, selecting an unsafe older checkpoint, or fabricating a replacement authoritative state. Decisions 50 and 56 remain in force.

This decision establishes a fail-closed response to uncertain operation history. It does not define an automatic journal-repair mechanism or guarantee that every integrity failure is recoverable.

## Decision 58 — Append-Only Operation Journal
**Status: LOCKED**

The authoritative Operation Journal must be append-only for committed operation records.

1. **Immutable committed records:** Once an operation record is committed to the authoritative journal, its contents must not be edited, overwritten, or silently removed.
2. **Corrections by addition:** Any correction, clarification, or compensating action must be represented by a new record that references the prior record. The original committed record remains intact.
3. **Unique operation identity:** Each operation record must carry a unique OperationId. A correction or compensating action is a distinct record and must not reuse the prior OperationId.
4. **Verifiable ordering:** Records must preserve sufficient ordering and integrity information for Recovery to establish the committed operation history. The exact encoding and integrity mechanism remain implementation details subject to validation.
5. **Safe retention boundary:** Journal records may be archived or removed from active storage only under a defined retention procedure that preserves verifiable recovery evidence for every committed mutation still needed to reconstruct authoritative state. If that proof cannot be established, the records must be retained.
6. **Server authority:** Only the server-authoritative runtime may append authoritative operation records. Clients cannot directly create, edit, overwrite, or delete journal records.
7. **Recovery compatibility:** Recovery must consume only records whose identity, integrity, ordering, and committed status can be verified, consistent with Decisions 50 and 57.

This decision defines the immutability and append behavior of authoritative committed-operation history. It does not prescribe a specific database, storage medium, hash-chain format, archival implementation, or journal-repair procedure.

## Decision 59 — Hash Chain Integrity for the Operation Journal
**Status: LOCKED**

The authoritative append-only Operation Journal must use a verifiable hash chain to detect unexpected changes to committed-operation history.

1. **Linked records:** Each journal record must include the integrity digest of the immediately preceding record. The first record in a journal chain uses a defined genesis value.
2. **Record digest:** Each record's digest must be calculated from a deterministic canonical representation that includes, at minimum, its sequence/order identity, OperationId, committed-record content, and previous-record digest. Any additional fields that affect authoritative interpretation must also be covered.
3. **Approved algorithm:** The chain must use SHA-256 through a vetted implementation or a verified platform-provided capability, consistent with Decision 54. The project must not invent or rely on a homegrown cryptographic hash algorithm.
4. **Verification before replay:** Recovery must verify record integrity and chain continuity, including ordering and linkage, before using journal records to reconstruct state. A broken, missing, mismatched, or unverifiable link makes the required history unverifiable and invokes Decision 57: fail closed and remain RECOVERY_REQUIRED.
5. **Trusted chain-head reference:** The system must preserve a trusted reference to the latest accepted chain head, bound to authoritative recovery metadata, so truncation or replacement of a journal suffix cannot be mistaken for a complete valid history. The exact persistence and atomic-update mechanism must be established and tested during implementation.
6. **Threat boundary:** Hash chaining detects unexpected record changes, insertion, reordering, and broken continuity when checked against a trusted chain-head reference. It is not proof of authenticity and does not protect against a compromised server or a privileged attacker able to alter both journal data and trusted metadata.
7. **Feasibility gate:** Canonical record serialization, SHA-256 availability, chain verification, trusted-head persistence, and their performance/recovery behavior must be prototyped and validated in Roblox Studio before the mechanism is relied upon in implementation.

This decision extends the integrity contract to the Operation Journal. It does not replace Decision 58's append-only rule, Decision 57's fail-closed recovery behavior, or Decision 50's committed-mutation preservation requirements. It does not claim that Roblox runtime feasibility or implementation has already been demonstrated.

## Decision 60 — Segmented Operation Journal
**Status: LOCKED**

The authoritative append-only Operation Journal must be organized into ordered, verifiable segments while preserving one continuous integrity history.

1. **Ordered segment identity:** Each segment must have a stable identity and an explicitly verifiable sequence range. Record ordering must remain unambiguous across segment boundaries.
2. **Continuous chain linkage:** Each segment must identify the integrity hash of its preceding segment's terminal record. The first segment uses the defined genesis boundary. Segment boundaries must not reset or weaken the hash chain established by Decision 59.
3. **Segment integrity metadata:** Each segment must preserve verifiable boundary information, including its starting and ending sequence identities and the integrity hashes needed to validate its contents and linkage to adjacent segments.
4. **Safe closure:** A segment may be marked closed only after its records, ordering, and integrity linkage have been verified and its accepted terminal hash has been safely bound to authoritative journal metadata. The exact atomic persistence mechanism must be established and tested during implementation.
5. **Active segment:** The current segment may remain open while new records are appended. Recovery must verify the available records and metadata in that segment and must not treat an incomplete or unverifiable segment as a successfully closed segment.
6. **Recovery continuity:** Recovery must validate segment identity, sequence continuity, record integrity, and inter-segment linkage before replay. Any missing, overlapping, reordered, broken, or unverifiable required segment invokes Decision 57 and leaves the match RECOVERY_REQUIRED.
7. **No implicit deletion:** Segmentation does not authorize deleting, pruning, or discarding journal history. Archival or removal from active storage remains governed by Decision 58 and must preserve verifiable recovery evidence for every committed mutation still needed.
8. **Implementation-defined sizing:** Segment size, closure cadence, and storage layout must be selected through Roblox Studio prototypes and measured performance/memory behavior. No fixed segment size or cadence is mandated by this decision.

This decision structures the journal for bounded verification and management without weakening append-only history, hash-chain continuity, or committed-mutation preservation. It does not claim that segmented storage or its performance has already been implemented or validated.

## Decision 61 — Authoritative Journal Recovery Manifest
**Status: LOCKED**

The recovery system must maintain an authoritative, versioned Recovery Manifest that identifies the accepted checkpoint baseline and the exact verified Operation Journal boundary required to reconstruct committed gameplay state.

1. **Manifest identity and format:** The manifest must identify the Journal, its manifest/schema format version, and the relevant canonicalization/integrity format versions needed to interpret its references.
2. **Checkpoint baseline reference:** The manifest must identify the accepted checkpoint baseline, including the checkpoint identity and the state/version boundary from which journal replay is required. Baseline acceptance and retention remain governed by Decisions 38–43, 50, and 56.
3. **Journal boundary reference:** The manifest must identify the latest accepted segment boundary and, where an active segment exists, its identity and verified boundary metadata. It must record the last committed sequence identity and the corresponding trusted terminal record hash.
4. **State binding:** The manifest must record the authoritative StateVersion or equivalent version-domain references needed to establish that the checkpoint baseline, committed-operation history, and recovered state belong to a consistent recovery history. Version domains remain distinct as required by Decision 51.
5. **Consistent publication:** Manifest advancement must be coordinated with the authoritative journal/commit process so that Recovery cannot accept a manifest that points beyond committed, integrity-verified records or a journal boundary that the manifest does not cover. The implementation must use a crash-safe publication protocol and validate its behavior under interruption; the exact storage transaction or prepare/commit mechanism is implementation-defined.
6. **Monotonic versioning:** Each accepted manifest update must have a monotonically advancing manifest version or generation, with enough identity/integrity information to detect stale, duplicated, or inconsistent publication.
7. **Recovery validation:** Before replay, Recovery must validate manifest integrity and format support, checkpoint identity and baseline compatibility, Journal identity, segment and sequence continuity, terminal hash linkage, and StateVersion consistency against the actual stored evidence.
8. **Fail-closed mismatch:** If the manifest is missing, corrupt, stale, contradictory, unsupported, or cannot be reconciled with the checkpoint and journal evidence, Recovery must not guess, silently select another boundary, or replay uncertain records. It must follow Decision 57 and remain RECOVERY_REQUIRED until the required authoritative history can be verified.
9. **No authority by digest alone:** A manifest digest or hash does not independently prove authenticity. The manifest's trusted status depends on server-authoritative control and a persistence/publication mechanism that protects its accepted version and reference from unauthorized alteration, within the threat boundary stated in Decision 59.
10. **Feasibility gate:** Manifest persistence, crash-safe publication, consistency with journal append/segment closure and checkpoint acceptance, and recovery validation must be prototyped and tested in Roblox Studio before the mechanism is relied upon in implementation.

This decision establishes the authoritative recovery reference without prescribing a specific storage engine or claiming that atomic persistence is already available or implemented in Roblox.

## Decision 62 — Intermediate Journal Replay Checkpoints
**Status: LOCKED**

The recovery system may create intermediate replay checkpoints as derived recovery accelerators, allowing later Recovery attempts to resume from a verified journal boundary closer to the latest committed operation.

1. **Derived artifact, not baseline:** An intermediate replay checkpoint is a derived representation of state produced by applying a verified prefix of committed Operation Journal records to an accepted checkpoint baseline. It does not become or replace the protected verified recovery baseline governed by Decisions 38, 50, and 56.
2. **Stable committed boundary:** Creation is permitted only at a stable boundary after the represented mutations are committed and the corresponding journal records and segment linkage are verifiable. It must not capture a partially applied mutation, pending candidate state, or an unresolved post-commit effect in a way that changes the established recovery semantics.
3. **Journal binding:** Each replay checkpoint must identify the source baseline, Journal identity, manifest generation/version, last included committed sequence, segment identity, and terminal record hash. The binding must establish exactly which verified journal prefix is represented and prevent omission or duplicate replay of committed operations.
4. **Integrity and format validation:** Replay checkpoints must use deterministic, versioned serialization and integrity validation consistent with Decision 54. Recovery must verify the checkpoint's integrity, supported format, source baseline reference, and journal boundary binding before accepting it.
5. **Manifest publication:** An intermediate replay checkpoint may be used by Recovery only after its acceptance is safely recorded in the authoritative Recovery Manifest under Decision 61. Publication must be crash-safe; an unaccepted or partially published replay checkpoint is not a recovery starting point.
6. **Safe fallback:** If an intermediate replay checkpoint is missing, stale, corrupt, unsupported, or inconsistent, Recovery may ignore that derived artifact and reconstruct from the still-verified accepted baseline by replaying the complete required committed journal suffix, provided the baseline and all required journal evidence remain valid. This fallback must preserve every committed mutation and must not replay an operation twice.
7. **Fail-closed when evidence is insufficient:** If the accepted baseline or any required journal record/segment/manifest reference cannot be verified, Recovery must follow Decision 57 and remain RECOVERY_REQUIRED. An invalid intermediate replay checkpoint is never justification to select an unsafe older checkpoint, discard committed mutations, infer operation outcomes, or bypass the Recovery Completion Gate.
8. **Retention and resource policy:** Intermediate replay checkpoints may be retained or removed according to an explicit resource policy only when their removal does not violate the protected baseline requirement in Decision 56 or remove evidence required by the Recovery Manifest and Operation Journal. Failure to create an intermediate replay checkpoint must not undo committed gameplay mutations.
9. **Implementation validation:** Creation cadence, resource cost, deterministic reconstruction, crash interruption, manifest publication, fallback correctness, and Recovery performance must be prototyped and tested in Roblox Studio before intermediate replay checkpoints are relied upon in implementation.

This decision defines intermediate replay checkpoints as optional, verifiable accelerators. It does not guarantee that one is always available, authorize replacement of the protected baseline, or claim that the mechanism has already been implemented or performance-tested.

## Decision 63 — Bounded Recovery Replay Budget
**Status: LOCKED**

Recovery replay must operate within explicit, configurable work budgets so a large committed-operation history cannot require an unbounded single execution. Budget exhaustion is a controlled yield condition, not evidence that Recovery has completed or failed.

1. **Bounded work slices:** The Recovery Executor must process journal replay in bounded batches. The implementation must define measurable limits for work per batch, such as record count and/or elapsed processing budget, based on Roblox Studio profiling. No fixed numeric limit is mandated here.
2. **Verified progress boundary:** Recovery progress may advance only after a complete batch has been applied and its resulting state, operation ordering, integrity evidence, and corresponding journal position have been verified. The resume cursor must identify the exact last fully accepted committed sequence and its segment/hash binding.
3. **No partial-operation yield:** A budget boundary must never interrupt an individual mutation in a way that leaves its commit status ambiguous. An operation must be completed atomically under the existing mutation/commit contract or not counted as replay progress.
4. **Controlled continuation:** When a batch budget is exhausted, the executor may yield at the last verified boundary while the match remains RECOVERY_REQUIRED and gameplay remains blocked. Continuation must not bypass the Recovery Completion Gate.
5. **Lock ownership:** If the same Recovery Executor retains ownership across a controlled yield, its RecoveryId and Recovery Lock ownership must remain valid and exclusive. If it relinquishes execution, it must release the lock only through the safe lifecycle in Decision 35; a subsequent attempt must acquire a valid lock and revalidate the latest authoritative StateVersion, manifest generation, journal boundary, and saved progress cursor before continuing. A stale or unverifiable cursor must not be used.
6. **Revalidation between batches:** Before each subsequent batch, Recovery must validate executor/lock ownership, RecoveryId, relevant StateVersion/version domains, manifest version, and the integrity/continuity of the next required journal range. If the recovery context changed or cannot be verified, the batch must not proceed.
7. **Idempotent continuation:** Resuming from a verified cursor must neither skip nor replay an already accepted committed mutation as a new operation. Operation identity and effect idempotency requirements in Decisions 14, 48, 50, and 57 remain in force.
8. **Budget exhaustion is not completion:** Reaching a per-batch budget does not satisfy the Recovery Completion Gate and does not permit gameplay to resume. Recovery remains RECOVERY_REQUIRED until all required replay, effects, consistency checks, and victory evaluation are complete under Decisions 36 and 49.
9. **Failure behavior:** If a batch fails, its progress boundary is uncertain, or required evidence becomes inconsistent, Recovery must not advance the cursor. It must follow the existing Recovery Lock lifecycle and fail-closed rules in Decisions 33–37 and 57.
10. **Feasibility gate:** Batch sizing, elapsed-work measurement, safe yield/resume behavior, lock lifecycle, memory use, and replay performance must be prototyped and tested in Roblox Studio under realistic long-journal and interruption scenarios before implementation relies on this mechanism.

This decision bounds Recovery work without weakening atomic mutation, journal integrity, exclusive recovery ownership, or the gameplay-resume gate. It does not prescribe numeric budgets or claim that Roblox Studio performance has already been measured.

## Decision 64 — Verified Recovery Progress Attestation
**Status: LOCKED**

Every completed Recovery replay batch must produce a verifiable progress attestation before that batch may be treated as an accepted continuation boundary.

1. **Attestation identity and context:** Each attestation must identify the RecoveryId, the relevant Recovery Manifest generation/version, Journal identity, source checkpoint/replay-checkpoint identity, and the Recovery Executor context under which the batch was processed.
2. **Exact replay boundary:** The attestation must identify the last fully accepted committed sequence, its segment identity, and the corresponding terminal record hash. It must not claim progress beyond the last complete, verified batch.
3. **Resulting state binding:** The attestation must bind to the resulting authoritative StateVersion/version-domain references and an integrity digest calculated from the deterministic, versioned canonical state representation required by Decision 54. The digest must cover the state needed to prove the batch result, not merely the cursor metadata.
4. **Validation evidence:** The attestation must record the batch validation outcome and the integrity/continuity evidence required to establish that all represented operations were applied in order, without omission or duplicate application. An unvalidated, failed, or incomplete batch cannot produce an accepted progress attestation.
5. **Safe publication:** An attestation becomes an accepted continuation boundary only after its contents and referenced state/journal boundary are verified and its publication is safely persisted in coordination with authoritative Recovery metadata. The publication protocol must prevent a crash from making an attestation appear accepted when its corresponding state/progress boundary was not safely committed. The exact persistence and atomic publication mechanism remains implementation-defined and must be tested.
6. **Resume validation:** Before continuing a later batch, Recovery must validate the attestation's integrity, RecoveryId/executor or reacquired-lock context, manifest generation, source baseline, Journal/segment/sequence/hash boundary, and resulting StateVersion/state digest against authoritative stored evidence. A stale or mismatched attestation cannot be used as a resume cursor.
7. **Invalid attestation fallback:** If the newest attestation is missing, corrupt, stale, or inconsistent, Recovery may fall back only to an earlier independently verified accepted attestation whose state and journal boundary remain valid, or reconstruct from the still-verified accepted baseline by replaying the complete required journal range. Such fallback must preserve every committed mutation and must not skip or duplicate an accepted operation.
8. **Fail-closed condition:** If no valid attestation, accepted earlier boundary, or fully verified baseline-plus-journal path can be established, Recovery must follow Decision 57 and remain RECOVERY_REQUIRED. It must not infer progress from an untrusted cursor or allow gameplay to resume.
9. **No replacement of completion gate:** A valid progress attestation proves only a verified intermediate Recovery boundary. It does not prove Recovery is complete, satisfy the Recovery Completion Gate, or permit gameplay to resume. Decisions 36 and 49 remain mandatory.
10. **Feasibility gate:** Deterministic state digest generation, attestation persistence/publication, crash interruption, fallback selection, lock reacquisition, and verification cost must be prototyped and tested in Roblox Studio before implementation relies on this mechanism.

This decision makes resumable Recovery progress evidence-based. It does not prescribe a specific attestation storage format or claim that crash-safe publication or runtime performance has already been implemented or validated.

## Decision 65 — Recovery Integrity Audit Trail
**Status: LOCKED**

The server-authoritative recovery system must maintain a separate, append-only Recovery Integrity Audit Trail that records significant Recovery lifecycle and validation events for diagnosis and accountability. The Audit Trail is observational evidence and is not a source of truth for gameplay state or operation commitment.

1. **Separate authority domain:** The Audit Trail must remain separate from the Operation Journal, Recovery Manifest, checkpoint data, and Recovery Progress Attestations. Audit events must never create, commit, replay, reverse, or otherwise determine gameplay mutations or operation outcomes.
2. **Server-generated events:** Only the server-authoritative runtime may append Recovery Audit events. Clients cannot create, edit, overwrite, or delete authoritative audit records.
3. **Event coverage:** The trail must record significant Recovery lifecycle and integrity events, including Recovery start, lock acquisition/release/invalidation, manifest and baseline validation, journal/segment verification, replay batch outcomes, progress-attestation acceptance/rejection, controlled yield/continuation, Recovery failure, and Recovery Completion Gate outcome.
4. **Event identity and ordering:** Each event must have a unique event identity and an unambiguous monotonic sequence within its audit stream. Events should reference the relevant RecoveryId and relevant manifest, checkpoint, segment, sequence, or attestation identifiers when available. Wall-clock timestamps may be included for diagnosis but must not be the sole ordering authority.
5. **Integrity and immutability:** Audit records must be append-only and tamper-evident. Each event must be represented deterministically and linked to the preceding event's integrity digest, using a vetted SHA-256 capability consistent with Decision 54 and the integrity principles of Decision 59. A trusted audit-chain head must be maintained independently of the Operation Journal chain. Any missing, altered, reordered, or unverifiable audit history must be reported as an audit-integrity problem; it must not be silently presented as complete.
6. **Minimal and safe content:** Audit events must contain only the identifiers, event categories, outcomes, integrity references, and diagnostic context needed to understand Recovery behavior. They must not expose secrets, credentials, private player data, or unnecessary gameplay payloads to clients. Client-facing diagnostics must be explicitly filtered and must not reveal internal authoritative data.
7. **Non-authoritative failure behavior:** Failure to append, persist, or verify an Audit event must not alter, roll back, or fabricate gameplay state; must not change whether an operation is committed; and must not by itself mark Recovery as successful or failed. The system must surface that audit coverage is incomplete. Recovery continues or remains blocked according to its authoritative state, journal, manifest, lock, and completion-gate evidence, not according to the Audit Trail.
8. **Retention and archival:** Audit retention and archival must be governed by an explicit policy that preserves the ability to verify retained audit segments and clearly identifies any retention boundary. Audit cleanup must not mutate Operation Journal records or Recovery evidence. The exact retention duration and storage layout remain implementation-defined.
9. **Feasibility gate:** Event volume, storage cost, hash-chain verification, trusted-head persistence, failure handling, retention, and client diagnostic filtering must be prototyped and tested in Roblox Studio before the Audit Trail is relied upon in implementation.

This decision establishes an independently verifiable diagnostic history for Recovery. It does not make the Audit Trail authoritative for gameplay, guarantee that every audit event can always be persisted, or claim that the mechanism has already been implemented or validated.

## Decision 66 — Structured Recovery Fault Classification
**Status: LOCKED**

The Recovery system must classify Recovery faults using stable, structured fault codes and consistent diagnostic fields so the Recovery Executor, Recovery Integrity Audit Trail, and authorized diagnostic surfaces interpret failures consistently.

1. **Stable fault identity:** Every classified fault must use a stable machine-readable fault code and category. Display text may evolve independently and must not be used as the programmatic identity of a fault.
2. **Required diagnostic context:** A fault record must identify the Recovery phase/stage, fault category and code, severity, relevant RecoveryId, and safe references to the affected manifest, checkpoint, journal/segment/sequence, lock, replay batch, or progress attestation when available. Missing references must be represented explicitly rather than invented.
3. **Initial fault categories:** The initial category set includes:
   - `INTEGRITY_FAILURE`: required integrity digest, hash-chain link, or verification evidence does not match or cannot be verified.
   - `MANIFEST_FAILURE`: Recovery Manifest is missing, corrupt, stale, unsupported, or inconsistent with authoritative evidence.
   - `CHECKPOINT_FAILURE`: required baseline or replay checkpoint is missing, corrupt, unsupported, or fails validation.
   - `LOCK_FAILURE`: Recovery Lock ownership, lifecycle, or exclusivity cannot be verified.
   - `REPLAY_FAILURE`: a replay operation or batch fails, or its completion boundary cannot be established.
   - `ATTESTATION_FAILURE`: Recovery progress attestation is missing, corrupt, stale, or inconsistent with its referenced state and journal boundary.
   - `PERSISTENCE_FAILURE`: required authoritative recovery metadata or progress cannot be safely persisted or published.
   - `CONTEXT_FAILURE`: RecoveryId, StateVersion/version domain, manifest generation, or other required execution context is stale or contradictory.
   Additional codes may be introduced through a compatible, documented extension process without silently changing the meaning of existing codes.
4. **Budget exhaustion is not automatically a fault:** Reaching the bounded replay budget under Decision 63 is a controlled yield/continuation outcome, not inherently a `REPLAY_FAILURE` or `RESOURCE_LIMIT` fault. A genuine resource or execution failure must be classified separately from an expected budget boundary.
5. **Severity and retry disposition:** Each fault must carry a severity and an explicit retry disposition, such as `RETRY_SAFE`, `RETRY_AFTER_REVALIDATION`, or `NO_AUTOMATIC_RETRY`. These fields describe permitted handling; they do not authorize bypassing the Recovery Lock lifecycle, fail-closed rules, or Recovery Completion Gate. If required evidence is ambiguous or unverifiable, automatic retry must not proceed until the relevant context/evidence is restored and revalidated.
6. **No inferred safety:** Retry safety must be determined by the fault's defined semantics and the existing idempotency, commit, journal, and recovery contracts. A generic transient-error label must not be treated as proof that replaying an operation is safe.
7. **Audit integration:** Classified Recovery faults must be referenced by the Recovery Integrity Audit Trail under Decision 65, including stable code, stage, severity, retry disposition, and safe object references. Audit recording remains non-authoritative: audit failure does not change the fault's underlying Recovery semantics.
8. **Safe diagnostic exposure:** Client-facing or player-facing messages must use filtered, non-sensitive descriptions. Internal identifiers, storage details, integrity material, private player data, and server-only diagnostic context must not be exposed unless explicitly authorized for a protected administrative surface.
9. **Fail-closed precedence:** Fault classification does not itself decide whether gameplay may resume. Decisions 33–39, 49–57, and 64 remain authoritative. Any fault that prevents verification of required recovery evidence keeps the match RECOVERY_REQUIRED until the relevant completion conditions are proven.
10. **Feasibility and coverage gate:** The fault-code registry, retry dispositions, audit integration, diagnostic filtering, and handling for each category must be prototyped and tested in Roblox Studio, including interruption, duplicate requests, stale context, lock loss, persistence failure, and ambiguous replay outcomes.

This decision standardizes Recovery fault reporting and handling metadata. It does not guarantee that a fault is recoverable, authorize automatic retries by default, or claim that the classification registry has already been implemented or tested.

## Decision 67 — Recovery Circuit Breaker
**Status: LOCKED**

Recovery must support a Circuit Breaker mechanism to prevent repeated automatic attempts from continuing when a recurring fault or unavailable dependency makes further attempts unsafe, futile, or likely to consume unbounded resources.

1. **Purpose and boundary:** The Circuit Breaker controls whether another automatic Recovery attempt may start. It does not replace the Recovery Executor, Recovery Lock, Operation Journal, Recovery Manifest, Checkpoint Manager, Progress Attestation, Recovery Integrity Audit Trail, or Recovery Completion Gate.
2. **Circuit states:** The mechanism must represent at least:
   - `CLOSED`: automatic attempts may proceed, subject to all existing Recovery validations and gates.
   - `OPEN`: automatic attempts covered by the breaker are blocked. The match remains `RECOVERY_REQUIRED`.
   - `HALF_OPEN`: a bounded, controlled probe may be permitted only after the configured re-evaluation conditions are met. A probe is not permission to resume gameplay or bypass any recovery validation.
3. **Fault eligibility:** Only explicitly configured fault codes/categories and dependency failure conditions may contribute to opening a circuit. Expected bounded replay-budget yield under Decision 63 must not count as a breaker failure. Faults classified as `NO_AUTOMATIC_RETRY` under Decision 66 must not be automatically retried merely because the circuit transitions to HALF_OPEN.
4. **Failure threshold and scope:** Opening criteria must be deterministic and bounded, based on a documented threshold/window and scoped to the relevant RecoveryId, fault class, and/or dependency. Unrelated matches or independent Recovery contexts must not be blocked by a broader shared counter unless an explicit shared dependency policy requires it.
5. **Controlled probing:** HALF_OPEN must permit only a bounded probe with explicit attempt limits and the required lock ownership, context validation, integrity checks, and idempotency guarantees. A failed probe reopens the circuit. A successful probe closes the circuit only for the defined scope; normal Recovery gates still apply.
6. **No unsafe retry:** The Circuit Breaker must not automatically repeat an operation whose commit outcome is ambiguous, replay an operation without idempotency proof, bypass revalidation, or turn an integrity/persistence failure into a retryable condition. Retry disposition remains governed by Decision 66 and the underlying authoritative recovery contracts.
7. **Lock and recovery lifecycle:** Opening the circuit must not force-release or transfer a Recovery Lock. Lock acquisition, renewal, release, and stale-lock handling remain governed by Decision 35. The circuit must not declare Recovery complete or permit gameplay to resume. The Recovery Completion Gate remains mandatory.
8. **Persistence and restart behavior:** Circuit state and the minimum evidence needed to enforce its threshold and scope must be persisted or safely reconstructible across server interruption. If breaker state or its required evidence cannot be trusted, the system must fail closed for the affected Recovery context rather than assume the circuit is CLOSED.
9. **Observability:** Circuit transitions, blocked attempts, probe starts/results, and reset decisions must be represented in the Recovery Integrity Audit Trail under Decision 65. Audit failure remains observational and must not change authoritative breaker or Recovery outcomes.
10. **Reset policy:** Reset or manual override must be explicit, authorized, scoped, and auditable. Time passage alone must not silently authorize a retry when the underlying fault or evidence remains unresolved.
11. **Feasibility and acceptance gate:** Roblox Studio prototyping must validate thresholds, concurrent attempts, server restart reconstruction, lock interaction, HALF_OPEN probe bounds, idempotent retry behavior, audit coverage, and fail-closed handling when breaker persistence is unavailable.

This decision introduces a guard against repeated unsafe or futile Recovery attempts. It does not guarantee fault resolution, authorize unrestricted manual retries, or claim that the Circuit Breaker has already been implemented or tested.

## Decision 68 — Recovery Escalation Protocol
**Status: LOCKED**

When Recovery cannot safely continue automatically, the system must create a structured escalation path for authorized human review without weakening the authoritative Recovery safeguards.

1. **Escalation trigger:** Escalation is required when the Recovery Circuit Breaker remains OPEN for a condition requiring intervention, when a fault is classified as requiring no automatic retry, or when Recovery evidence/metadata cannot be safely verified or restored through the defined automatic process. Trigger criteria must be explicit and tied to the relevant fault and Recovery context.
2. **Match safety:** An escalated match remains `RECOVERY_REQUIRED`. Escalation does not release or transfer the Recovery Lock, mark Recovery complete, permit gameplay, or bypass the Recovery Completion Gate.
3. **Escalation record:** Each escalation must have a stable EscalationId and bind to the relevant RecoveryId, match identity, fault code/category, triggering stage, Circuit Breaker state, safe references to affected recovery evidence, creation sequence/time, and current escalation status. Sensitive payloads and integrity secrets must not be copied into the escalation record.
4. **Lifecycle:** The protocol must represent at least `OPEN`, `ACKNOWLEDGED`, `UNDER_REVIEW`, and a terminal disposition such as `RESOLVED` or `CLOSED_UNRECOVERABLE`. Status transitions must be validated and recorded; timestamps are diagnostic and must not be the ordering authority.
5. **Authorized access:** Only authenticated, server-authorized administrative identities may inspect protected diagnostics, acknowledge, investigate, or submit an intervention. Authorization must be checked server-side for every action. Client-provided role claims or escalation identifiers alone are never authorization.
6. **Filtered diagnostics:** Administrative diagnostics may expose only the minimum information needed to investigate the case. Player-facing messages must remain generic and must not disclose internal storage details, integrity material, private player data, or protected server context.
7. **Intervention boundary:** An administrative intervention must be an explicit, typed, validated action with a recorded actor, reason, target Recovery context, and resulting disposition. It may request a controlled retry, repair/republication of recoverable metadata, or closure as unrecoverable only when the corresponding evidence and policy permit it. It must not silently rewrite or delete committed Operation Journal records, fabricate attestations, replace trusted integrity heads, roll back committed gameplay operations, or skip required verification.
8. **Revalidation before resume:** Any intervention intended to continue Recovery must return control to the normal Recovery pipeline. The system must revalidate the relevant lock ownership, context, checkpoint, manifest, journal/segment integrity, replay boundary, and progress attestation as applicable. Gameplay may resume only after the existing Recovery Completion Gate is satisfied.
9. **Circuit Breaker coordination:** Escalation does not automatically reset or close the Circuit Breaker. Any authorized reset must follow Decision 67's explicit, scoped, auditable reset policy and must not make an ineligible fault retryable under Decision 66.
10. **Persistence and audit:** Escalation records and status transitions must be durably persisted or safely reconstructible. Creation, access-sensitive actions, acknowledgements, investigation transitions, intervention requests/results, and final dispositions must be represented in the Recovery Integrity Audit Trail under Decision 65. If required escalation state cannot be trusted, the case remains fail-closed and gameplay remains blocked.
11. **No implicit authority:** Escalation is an operational workflow, not a new source of gameplay or Recovery authority. Human approval alone cannot override integrity requirements, commit semantics, lock lifecycle, idempotency, or the Recovery Completion Gate.
12. **Feasibility and acceptance gate:** Roblox Studio prototyping must validate server-side authorization, escalation persistence/reconstruction, concurrent administrator actions, audit coverage, filtered diagnostics, intervention validation, Circuit Breaker coordination, and the inability to resume gameplay without successful Recovery verification.

This decision defines the human-review path for Recovery cases that cannot safely proceed automatically. It does not claim that an administrative console, escalation service, or intervention workflow has already been implemented or tested.

## Decision 69 — Recovery Isolation Boundary
**Status: LOCKED**

Recovery execution and its supporting coordination state must be isolated by match so that a fault, stalled process, or escalation in one match does not directly block or mutate unrelated matches hosted by the same server.

1. **Canonical scope:** Every Recovery execution is bound to an explicit `MatchId` and `RecoveryId`. All Recovery-owned locks, executor state, mutation work, fault counters, Circuit Breaker state, escalation records, and progress evidence must be associated with that scope.
2. **Per-match serialization:** Gameplay mutation ordering and Recovery serialization must be scoped to the relevant match. A Recovery operation for one match must not acquire a global gameplay mutation lock or occupy another match's queue.
3. **Lock isolation:** Recovery Lock ownership and lifecycle are match-scoped and RecoveryId-bound. A lock conflict or stale lock for one match must not invalidate or release another match's lock.
4. **State and evidence isolation:** Checkpoints, Operation Journal segments, Recovery Manifest, Progress Attestations, Audit Trail streams, fault classifications, Circuit Breaker state, and escalation records must be bound to the correct match/recovery context. References crossing those boundaries must be rejected unless an explicit authorized cross-match coordination contract exists.
5. **Failure containment:** A Recovery failure, OPEN Circuit Breaker, or pending escalation in one match must not change another match's Recovery status, gameplay state, mutation queue, lock, or completion gate.
6. **Explicit cross-match coordination:** Any operation that intentionally spans multiple matches must declare its complete match scope and use a dedicated coordination mechanism with deterministic ordering, validation, and failure handling. It must not emerge implicitly from shared global mutable state.
7. **Global resource protection:** Match isolation does not remove server-wide resource limits. The server may enforce bounded aggregate concurrency, memory, CPU/work budgets, and storage usage across all active Recoveries. Global admission control must defer or reject new Recovery work safely without corrupting or changing the state of already-running matches.
8. **Fair scheduling:** Global resource admission and scheduling must prevent one match from monopolizing Recovery capacity indefinitely. Per-match limits and bounded work slices should preserve progress opportunities for independent matches without weakening Decision 63's replay budget or Decision 67's Circuit Breaker.
9. **Identity and context validation:** Every asynchronous callback, queued mutation, persisted artifact, and administrative escalation/intervention must validate its MatchId and RecoveryId against the intended scope before applying effects. Stale or cross-match context fails closed for the affected operation.
10. **Observability:** Recovery scheduling, admission/defer/reject outcomes, isolation violations, and cross-match coordination must be recorded with safe match/recovery references in the relevant Audit Trail. Audit failure remains non-authoritative under Decision 65.
11. **Feasibility and acceptance gate:** Roblox Studio prototypes must validate concurrent matches, simultaneous Recoveries, per-match queue independence, global resource exhaustion, fair scheduling, stale callback rejection, cross-match reference rejection, and failure containment under server interruption.

This decision defines match-scoped Recovery isolation with bounded server-wide resource coordination. It does not require unlimited simultaneous Recoveries, claim that all Roblox server resources can be perfectly isolated, or assert that the isolation scheduler has already been implemented or tested.

## Decision 70 — Priority-Based Recovery Scheduling with Fairness Guarantee
**Status: LOCKED**

When multiple matches require Recovery work concurrently, the server must schedule admitted Recovery work using deterministic priority rules while preserving per-match isolation and preventing starvation.

1. **Scheduling scope:** Scheduling decisions operate across eligible Recovery tasks from multiple matches, while all execution state, locks, mutation ordering, and Recovery evidence remain scoped by MatchId and RecoveryId under Decision 69.
2. **Priority classes:** The scheduler must distinguish at least:
   - `ACTIVE_CONTINUATION`: a Recovery already in progress that has safely yielded at a defined batch boundary and is eligible to continue.
   - `NEW_VALIDATED`: a newly initiated Recovery that has passed required admission and initial validation.
   - `RESOURCE_WAITING`: a Recovery that is valid but deferred because current server-wide capacity is unavailable.
   - `RESOURCE_DEFERRED`: a Recovery deferred by a prior resource-limit decision and awaiting a later admission opportunity.
   These classes express scheduling preference only. They do not establish Recovery correctness or permit skipping validation.
3. **Deterministic ordering:** Within each priority class, ordering must use explicit stable scheduling metadata, such as enqueue sequence and bounded wait age. Wall-clock timestamps alone must not be the ordering authority. Tie-breaking must be deterministic and scoped to the scheduler instance.
4. **Fairness and starvation prevention:** Priority preference must not allow ACTIVE_CONTINUATION tasks to monopolize capacity indefinitely. The scheduler must apply bounded work slices, per-match concurrency/usage limits, and a documented aging or fair-rotation policy so eligible waiting matches eventually receive service when capacity becomes available.
5. **Continuation handling:** An ACTIVE_CONTINUATION task may receive preference to avoid unnecessary restart overhead, but after its bounded replay/work slice it must yield at a safe boundary and re-enter scheduling. It must not retain a global server resource reservation indefinitely.
6. **Admission and resource limits:** Server-wide limits for concurrent Recovery tasks, CPU/work budget, memory, and storage remain authoritative. The scheduler may defer or reject new work safely when limits are reached. It must not corrupt, partially publish, or silently alter the Recovery state of tasks that are already running or waiting.
7. **Per-match fairness:** One match must not exceed its configured share or concurrency limit in a way that starves other eligible matches. Multiple Recovery tasks for one match must obey that match's serialization and lock constraints; they cannot execute conflicting mutations concurrently.
8. **Priority cannot override safety:** No scheduling priority may bypass MatchId/RecoveryId context validation, Recovery Lock ownership, Decision 63 replay budgets, Decision 66 retry dispositions, Decision 67 Circuit Breaker state, Decision 68 escalation restrictions, or the Recovery Completion Gate. OPEN Circuit Breaker and escalated cases remain blocked from automatic execution unless their authoritative policies explicitly permit a validated action.
9. **Queue lifecycle and stale work:** Before dispatch, the scheduler must revalidate that the task is still eligible, its context is current, and its Recovery has not completed, been cancelled, escalated, or otherwise become ineligible. Stale queue entries must be discarded safely without applying gameplay mutations.
10. **Observability:** Enqueue, dispatch, yield, defer, reject, aging/rotation, and starvation-prevention outcomes must be recorded with safe MatchId/RecoveryId references in the relevant Audit Trail. Audit recording remains non-authoritative under Decision 65.
11. **Feasibility and acceptance gate:** Roblox Studio prototypes must test deterministic ordering, concurrent matches, continuation preference, fairness under sustained arrivals, per-match quotas, aggregate resource exhaustion, stale queue entries, lock conflicts, Circuit Breaker/escalation interaction, and server restart behavior.

This decision defines deterministic priority scheduling with bounded fairness and server-wide resource admission. It does not promise unlimited Recovery throughput, guarantee progress when capacity never becomes available, or claim that the scheduler has already been implemented or tested.

## Decision 71 — Recovery Scheduler Admission Control
**Status: LOCKED**

A Recovery request must pass an explicit admission decision before it can consume an active Recovery scheduler slot. Admission to the waiting queue and authorization to begin execution are separate decisions; neither replaces validation at dispatch or during Recovery.

1. **Admission stages:** The system must distinguish at least:
   - `REJECTED`: the request is invalid, unauthorized, stale, outside policy, or cannot be safely represented. It must not enter the executable queue or leave a partial Recovery mutation/lock behind.
   - `DEFERRED`: the request is valid but current capacity or policy limits prevent active admission. It may wait for a later re-evaluation if its context remains valid.
   - `QUEUED`: the request has passed initial validation and may wait in the scheduler's bounded pending queue. QUEUED does not mean it owns an active execution slot or may mutate Recovery state.
   - `ADMITTED`: the request has passed the active-capacity check and may proceed to dispatch-time validation before execution.
2. **Initial validation:** Before queue admission, validate the request's authorization, MatchId/RecoveryId binding, current Recovery eligibility, required metadata/context, and applicable fault, Circuit Breaker, escalation, and lock constraints. Invalid or stale requests are rejected without gameplay mutation or partial lock acquisition.
3. **Capacity evaluation:** Admission Control must enforce configured server-wide and per-match limits for active Recovery concurrency, bounded work/CPU budgets, memory, and storage. Resource estimates and thresholds must be explicit, conservative, and observable; unavailable or untrustworthy capacity measurements must not be interpreted as unlimited capacity.
4. **Deferred handling:** A valid request that cannot currently fit within resource limits is marked DEFERRED with a safe reason/category and retained only within bounded queue/storage limits. Deferred work must not hold an active execution slot or a long-lived Recovery Lock merely by waiting for capacity. Its context and eligibility must be revalidated before later admission.
5. **Queue bounds and overload behavior:** Pending queue length, per-match pending requests, and deferred retention must be bounded. When those limits are reached, the system must reject or safely expire excess requests with an explicit outcome. It must not silently drop work or create unbounded memory/storage growth.
6. **Dispatch-time validation:** Immediately before dispatch, revalidate MatchId/RecoveryId, current state/version context, Recovery eligibility, lock ownership/acquisition requirements, Circuit Breaker and escalation status, retry disposition, and the applicable evidence required by the Recovery stage. Passing initial admission is never sufficient authorization to execute against changed state.
7. **Atomic admission bookkeeping:** Queue insertion, active-slot reservation, and admission status publication must be coordinated so concurrent requests cannot exceed configured limits or create duplicate active execution for the same Recovery scope. Any failed admission transaction must leave no partial reservation, lock, or Recovery mutation.
8. **Re-evaluation and fairness:** Deferred and queued requests must be reconsidered when capacity changes, using Decision 70's deterministic priority and fairness policy. Re-evaluation must not bypass its ordering, per-match quotas, or starvation-prevention rules.
9. **No safety override:** Admission Control cannot override Decision 63 replay budgets, Decision 66 retry dispositions, Decision 67 Circuit Breaker, Decision 68 Escalation Protocol, Decision 69 match isolation, or Decision 70 scheduling fairness. Admission does not mark Recovery complete or allow gameplay to resume.
10. **Observability:** Admission requests, validation outcomes, queue/defer/reject reasons, capacity snapshots or safe budget indicators, reservations, expirations, and dispatch revalidation failures must be recorded with safe MatchId/RecoveryId references. Audit integration follows Decision 65 and remains non-authoritative.
11. **Feasibility and acceptance gate:** Roblox Studio prototypes must test concurrent admission races, queue bounds, resource exhaustion, deferred re-admission, stale context, duplicate requests, per-match limits, reservation rollback, server interruption, and dispatch-time revalidation.

This decision defines bounded admission and queue lifecycle for Recovery work. It does not guarantee that deferred work will eventually be admitted, require unreliable exact CPU prediction, or claim that Admission Control has already been implemented or tested.
