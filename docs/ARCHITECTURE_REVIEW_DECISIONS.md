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
