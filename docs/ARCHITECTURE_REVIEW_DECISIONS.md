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
