# Relopoli — Review Backlog (Preliminary)

> Status: Initial review hypotheses, not locked gameplay rules.
> This document is an analysis backlog. It does not modify or supersede the Master Source of Truth.

## Review principles
- Preserve locked rules unless a design decision explicitly changes them.
- Separate source-derived rules from implementation assumptions and test findings.
- Every issue should have severity, reproducible scenario, expected result, actual result, and owner.
- Do not add gameplay rules merely to fill undocumented gaps. Mark them UNRESOLVED / NEEDS DESIGN DECISION.

## Priority review tracks

### P0 — System integration and correctness
- Build a traceability matrix from each system rule to its authoritative owner and implementation module.
- Test Turn Controller ownership of Turn Start, Turn End, Extra Roll, and deferred resolution.
- Test Resolution Result priority: GAME_END > PLAYER_ELIMINATED > TURN_END > EXTRA_ROLL > CONTINUE.
- Verify movement, Start detection, First Lap, and Landing Resolution ordering for normal, forced, transport, and Jail-exit movement.
- Test Bankruptcy recovery resume points and final-elimination abort behavior.
- Verify all atomic operations complete before Global Victory Check.
- Test pending Trade/Transaction against ownership changes, disconnect, expiration, and stale client state.

### P1 — Economy simulation and balance
- Simulate starting capital, Start rewards, First Lap, property acquisition/upgrades, rent, Crown rewards, News effects, shields, Second Life, and liquidation.
- Measure game duration, elimination timing, balance distribution, property concentration, and comeback probability.
- Stress-test high rent combinations and reward multipliers, including the absence of a Rent Cap where specified.
- Compare outcomes across player counts and player strategies.
- Record assumptions and distributions; do not change locked values without an explicit design review.

### P1 — Roblox technical architecture
- Define server-owned game state and client intent contracts.
- Specify RemoteEvent/RemoteFunction validation, request IDs, rate limits, and idempotency.
- Define authoritative dice resolution and movement completion signals.
- Design persistence boundaries, schema versioning, recovery behavior, and data-loss handling.
- Define module ownership and dependency direction to avoid circular system control.
- Profile server work, replication, UI updates, and character movement under realistic player counts.

### P2 — UX and playtesting
- Test readability of board, property ownership, player state, modifiers, and blocking decisions on mobile and desktop.
- Measure decision time and confusion around News, Trade, Transaction, Jail, and Bankruptcy flows.
- Run first-time-player usability tests and observe onboarding friction.
- Test reconnect and spectator experience.
- Collect qualitative feedback before adding new mechanics.

## Initial risks to validate (hypotheses, not findings)
1. Many interacting systems may create a large state-space and difficult regression burden.
2. Large rent multipliers and compounding modifiers may create runaway economic swings.
3. Long blocking flows or asynchronous proposals may increase downtime between turns.
4. Server-authoritative rules need concrete concurrency and idempotency tests, not only UI locks.
5. Visual richness must be balanced against board readability and Roblox device performance.

## Required evidence before closing an issue
- Reproducible test case or simulation seed.
- Expected behavior traced to the relevant locked source.
- Actual behavior and logs/metrics.
- Impact and severity.
- Decision: fix implementation, request design decision, or accept documented behavior.
