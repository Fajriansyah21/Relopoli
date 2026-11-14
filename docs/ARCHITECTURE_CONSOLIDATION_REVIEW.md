# Relopoli — Architecture Consolidation Review

> **Status:** REVIEW FINDINGS — not yet converted into new LOCKED decisions  
> **Scope:** Architecture Review Decisions 1–74, Master Source of Truth, Progress 19, Progress 20, and Roblox/Luau implementation feasibility  
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

The architecture decisions strengthen this design with explicit mutation plans, version checks, copy-on-write, post-commit processing, and in-session recovery.

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

**Status: ADDRESSED by LOCKED Decision 52 — Separate Victory Evaluation From Game-End Mutation.**  
**Related decisions:** 5, 26, 29, 31, 32, 46, 52

The source flow says Victory Detection is followed by Victory Validation, Game State = ENDED, Winner Set, Turn Controller STOP, and Gameplay STOP. The architecture must distinguish the read-only evaluation of victory rules from the authoritative state change that applies Game End.

**Recorded resolution in Decision 52:**
1. Victory Evaluator reads an authoritative snapshot and evaluates it against a specific StateVersion. It cannot mutate Match State or directly set the winner.
2. The evaluation result carries EvaluatedStateVersion.
3. State Manager validates that version against the current StateVersion. A stale result is rejected and reevaluated against the latest snapshot.
4. If no victory is found, the Victory Check completes and the Global Victory Gate may be released only while its triggering context remains current.
5. If victory is found, Game-End is submitted as a dedicated mutation through State Manager's canonical candidate-state commit pipeline.
6. The Global Victory Gate stays locked throughout evaluation and Game-End application. After Game End commits, the gate is terminal and no later gameplay mutation or continuation is admitted.
7. Evaluators and post-commit workers cannot directly mutate authoritative gameplay state.
8. Failures leave the gate locked and are handled through the established retry/recovery rules.

RF-08 is closed at the architecture-contract level. The source-defined victory conditions remain unchanged; implementation and failure-path behavior still require Roblox validation and testing.

### RF-09 — Checkpoint Integrity Hash Needs a Defined, Feasible Contract

<sup>Addressed by Decision 54 — Deterministic Checkpoint Serialization and Integrity Contract.</sup>

**Related decisions:** 39, 40, 41, 43, 50, 54  
A hash requires a deterministic representation of the checkpoint: stable key ordering, supported value types, treatment of references, and a defined algorithm. The current decision does not specify these.

An integrity hash can help detect accidental data changes, but it is not a substitute for server authority or validation. The design should not assume that a hash alone makes in-memory state secure.

**Resolution:** Decision 54 defines deterministic serialization, supported value/reference boundaries, a SHA-256 digest through a vetted or verified capability, format/canonicalization versioning, creation-time calculation and pre-recovery verification, and the limited threat boundary. Roblox Studio prototyping remains a required feasibility gate; this documentation decision is not implementation or test evidence.

### RF-10 — Checkpoint Policy Has Overlapping Responsibilities

<sup>Addressed by Decision 55 — Single Checkpoint Manager Ownership.</sup>

**Related decisions:** 37–43, 50, 54, 55  
Checkpoint retention, memory budget, event-driven creation, and non-blocking failure are compatible, but their responsibilities overlap. A single Checkpoint Manager contract should own:
- eligibility at stable boundaries;
- candidate creation and validation;
- memory estimation and retention;
- protection of checkpoints currently in use;
- failure reporting and retry scheduling;
- recovery capability status.

Decision 55 establishes the Checkpoint Manager as the single owner of these policy and lifecycle responsibilities while preserving State Manager and Recovery Executor authority boundaries. Numerical memory budgets, checkpoint counts, retry thresholds, and performance targets remain unselected and must be measured in Roblox Studio rather than guessed.

---


### RF-11 — Clarify Which Roblox Server-Authority Model Is Intended

<sup>Addressed by Decision 53 — Conventional Server-Authoritative Runtime Model.</sup>

**Related decisions:** 12, 13, 15, 53  
The project uses “server authoritative” as a trust-boundary principle: the server decides gameplay outcomes and clients send intent. Roblox also documents a specific engine Server Authority model with its own Workspace settings, Input Action System, simulation synchronization, prediction, rollback, and resimulation requirements.

These are related but not interchangeable concepts. The current Relopoli design, where clients present server-confirmed movement and gameplay outcomes, does not by itself establish that the experience intends to enable Roblox's engine Server Authority mode.

**Resolution:** Relopoli uses the conventional server-authoritative model built around server-side gameplay logic and validated client-server requests. It does not currently adopt Roblox's engine Server Authority simulation model. Any future adoption requires a separate architecture review and explicit decision. The existing server trust boundary and client presentation responsibilities remain unchanged.


### CI-01 — Checkpoint Retention Could Delete the Only Verified Recovery Baseline

**Status: ADDRESSED by LOCKED Decision 56 — Preserve a Verified Recovery Baseline.**  
**Related decisions:** 38, 39, 40, 41, 43, 50, 54, 55, 56

Decision 40 requires retaining a previous verified checkpoint until its replacement is successfully verified. Decision 41 also permits deleting the oldest checkpoint that is not currently in use when the memory budget is insufficient. Read together, these rules did not explicitly protect the only remaining verified checkpoint from memory-pressure cleanup.

**Recorded resolution in Decision 56:**
1. Checkpoint Manager identifies and protects at least one verified checkpoint as the recovery baseline whenever one exists.
2. The baseline cannot be deleted or replaced until a newer checkpoint has been created, validated, and accepted as its verified replacement.
3. Other older checkpoints may be removed only if they are not in active Recovery use and their removal preserves the baseline.
4. If memory is insufficient without deleting the sole baseline, creation of the new checkpoint is rejected and the existing baseline is retained.
5. A failed checkpoint creation does not cancel an already committed gameplay mutation; normal gameplay may continue under Decision 43's conditions.
6. The system must report limited or unavailable recovery capability honestly when no verified checkpoint exists.

CI-01 is closed at the architecture-contract level. This does not guarantee recovery after server failure or replace Decision 50's committed-operation preservation requirements.

---


### CI-02 — Operation Journal Integrity Failure Needs an Explicit Recovery Boundary

**Status: ADDRESSED by LOCKED Decision 57 — Fail-Closed Recovery on Operation Journal Integrity Failure.**  
**Related decisions:** 33–38, 48–50, 56, 57

Decision 50 requires committed-operation records to reconstruct mutations after a checkpoint and requires RECOVERY_REQUIRED when those records are incomplete, inconsistent, or cannot be integrity-verified. It did not explicitly define whether recovery may replay uncertain records, infer an ambiguous operation's outcome, or replace it with a new operation identity.

**Recorded resolution in Decision 57:**
1. Do not replay records whose integrity, identity, ordering, or committed status cannot be established.
2. Do not infer whether an ambiguous operation committed or did not commit, and do not recreate it under a new OperationId.
3. Retain the Recovery Lock and RECOVERY_REQUIRED while required history remains unverifiable.
4. Preserve available identifiers, version/context information, and failure reasons for diagnosis without treating diagnostics as proof of a gameplay outcome.
5. Continue recovery only when required committed-operation history is verifiable and the Recovery Completion Gate passes.
6. Do not discard committed mutations, select an unsafe older checkpoint, or fabricate authoritative state.

CI-02 is closed at the architecture-contract level. Decision 57 does not define automatic journal repair or guarantee that every integrity failure can be recovered.

---


### CI-03 — Operation Journal Mutability and Retention Need an Explicit Contract

**Status: ADDRESSED by LOCKED Decision 58 — Append-Only Operation Journal.**  
**Related decisions:** 12, 14, 16–17, 33–38, 48–50, 57–58

Decisions 50 and 57 depend on authoritative committed-operation records to reconstruct state and to prevent replay or inference when history is uncertain. The architecture needed an explicit rule preventing committed records from being silently changed or removed, while allowing corrections and safe retention.

**Recorded resolution in Decision 58:**
1. Committed journal records are immutable and cannot be edited, overwritten, or silently removed.
2. Corrections and compensating actions are new records referencing prior records, with distinct OperationIds.
3. Journal ordering and integrity information must be sufficient for Recovery to verify committed history.
4. Archival or removal from active storage is permitted only when verifiable recovery evidence for every still-needed committed mutation is preserved. Otherwise, records remain retained.
5. Only the server-authoritative runtime may append authoritative records; clients cannot directly mutate the journal.
6. Recovery consumes only records whose identity, integrity, ordering, and committed status are verifiable.

CI-03 is closed at the architecture-contract level. Decision 58 does not prescribe a storage engine, hash-chain format, archive implementation, or repair procedure.

---


### CI-04 — Operation Journal Integrity Needs Tamper-Evident Record Linkage

**Status: ADDRESSED by LOCKED Decision 59 — Hash Chain Integrity for the Operation Journal.**  
**Related decisions:** 50, 54, 57–59

Decision 58 makes committed journal records immutable and append-only, but immutability rules alone do not provide a verifiable way to detect unexpected changes, insertion, reordering, or truncation in the stored record history.

**Recorded resolution in Decision 59:**
1. Each record links to the preceding record's integrity digest, with a defined genesis value for the first record.
2. Each record digest covers a deterministic canonical representation including ordering identity, OperationId, committed content, previous digest, and other authoritative fields.
3. SHA-256 must be provided by a vetted implementation or verified platform capability, consistent with Decision 54. No homegrown cryptographic hash is permitted.
4. Recovery verifies chain integrity and continuity before replay. Broken or unverifiable history invokes Decision 57 and remains RECOVERY_REQUIRED.
5. A trusted chain-head reference bound to authoritative recovery metadata is required to detect suffix truncation or replacement. Its persistence and atomic-update mechanism remain implementation details requiring prototype validation.
6. Hash chaining is tamper-evident under the stated trust boundary, not proof of authenticity or protection against a compromised server able to alter both records and trusted metadata.

CI-04 is closed at the architecture-contract level. Roblox feasibility, trusted-head persistence, and performance remain unvalidated until prototyped.

---


### CI-05 — Operation Journal Growth and Verification Boundaries Need an Explicit Structure

**Status: ADDRESSED by LOCKED Decision 60 — Segmented Operation Journal.**  
**Related decisions:** 50, 57–60

Decisions 58 and 59 establish immutable append-only records and continuous hash-chain integrity. The architecture also needs an explicit structure for organizing long journal histories and verifying their continuity without resetting the chain at arbitrary boundaries.

**Recorded resolution in Decision 60:**
1. The journal is organized into ordered segments with stable identities and verifiable sequence ranges.
2. Each segment links to the preceding segment's terminal record hash. Segment boundaries do not reset the hash chain.
3. Segment boundary metadata supports verification of contents, ordering, and linkage.
4. A segment closes only after its records and linkage are verified and its accepted terminal hash is safely bound to authoritative journal metadata.
5. Recovery verifies segment identity, sequence continuity, record integrity, and inter-segment linkage. Missing or unverifiable required history invokes Decision 57.
6. Segmentation does not authorize pruning or deletion; Decision 58's evidence-preserving retention rule remains in force.
7. Segment sizing and closure cadence remain implementation choices subject to Roblox Studio prototype and performance validation.

CI-05 is closed at the architecture-contract level. Bounded verification performance and the atomic persistence mechanism for accepted segment boundaries remain unvalidated.

---


### CI-06 — Recovery Needs an Authoritative Reference for the Accepted Checkpoint and Journal Boundary

**Status: ADDRESSED by LOCKED Decision 61 — Authoritative Journal Recovery Manifest.**  
**Related decisions:** 16, 23–25, 33–43, 50–61

The checkpoint and segmented Operation Journal contracts establish recoverable data and integrity linkage, but Recovery also needs an authoritative reference identifying which checkpoint baseline and exact committed journal boundary form the accepted recovery history.

**Recorded resolution in Decision 61:**
1. Maintain a versioned manifest identifying the Journal, format versions, accepted checkpoint baseline, latest accepted segment boundary, last committed sequence, and trusted terminal record hash.
2. Bind the manifest to the relevant StateVersion/version-domain references without collapsing the distinct version domains required by Decision 51.
3. Coordinate manifest advancement with authoritative journal and commit publication so it cannot point beyond verified committed records or omit an accepted journal boundary.
4. Use monotonic manifest versioning and a crash-safe publication protocol. The concrete storage transaction or prepare/commit mechanism remains implementation-defined.
5. Before replay, validate manifest integrity and format support against checkpoint, segment, sequence, terminal-hash, and StateVersion evidence.
6. Missing, stale, corrupt, contradictory, or unreconcilable manifest evidence invokes Decision 57. Recovery must not guess or replay uncertain history.
7. A digest alone is not proof of authenticity; trusted status depends on server authority and protected persistence/publication.
8. Roblox persistence, interruption behavior, and consistency with journal/checkpoint publication require prototype validation.

CI-06 is closed at the architecture-contract level. No claim is made that Roblox provides the required atomic persistence behavior without implementation testing.

---


### CI-07 — Long Journal Replay Needs a Safe Intermediate Recovery Acceleration

**Status: ADDRESSED by LOCKED Decision 62 — Intermediate Journal Replay Checkpoints.**  
**Related decisions:** 38–43, 50, 54–57, 60–62

The accepted checkpoint baseline and verified Operation Journal provide the authoritative recovery path, but replaying a long committed journal history from the baseline may become increasingly expensive. An intermediate replay checkpoint can accelerate Recovery, provided it cannot weaken baseline protection or committed-mutation preservation.

**Recorded resolution in Decision 62:**
1. Intermediate replay checkpoints are derived recovery accelerators, not replacements for the protected verified baseline.
2. They may be created only at stable committed boundaries and must bind to the source baseline, Journal identity, manifest generation, sequence, segment, and terminal record hash.
3. They require deterministic serialization and integrity validation under Decision 54, plus safe acceptance/publication through the Recovery Manifest under Decision 61.
4. If an intermediate replay checkpoint is invalid, Recovery may ignore it and replay the complete required committed journal suffix from the still-verified accepted baseline, but only when all required evidence is valid.
5. If the baseline or required journal/manifest evidence is unverifiable, Decision 57 applies. No committed mutation may be discarded, duplicated, or inferred.
6. Intermediate checkpoint retention cannot violate Decision 56's protected-baseline rule or remove evidence required for Recovery.
7. Cadence, cost, crash behavior, fallback correctness, and performance require Roblox Studio prototype validation.

CI-07 is closed at the architecture-contract level. No implementation or performance result is claimed.

---


### CI-08 — Large Journal Replay Needs a Bounded and Resumable Work Contract

**Status: ADDRESSED by LOCKED Decision 63 — Bounded Recovery Replay Budget.**  
**Related decisions:** 14, 19–27, 33–39, 48–51, 57, 60–63

A long committed-operation history may make a single Recovery execution excessively large. Replay therefore needs bounded work slices and a safe continuation boundary without weakening atomic mutations, lock ownership, or the Recovery Completion Gate.

**Recorded resolution in Decision 63:**
1. Recovery replay runs in bounded batches with measurable limits selected through Roblox Studio profiling; no arbitrary numeric budget is fixed by the architecture.
2. Progress advances only after a complete batch and its state, ordering, integrity evidence, and journal position are verified. The cursor binds to the last fully accepted committed sequence and segment/hash.
3. Budget exhaustion is a controlled yield, not completion. The match remains RECOVERY_REQUIRED and gameplay stays blocked.
4. Continuation requires valid RecoveryId/lock ownership and revalidation of StateVersion, manifest generation, journal boundary, and cursor. If ownership is relinquished, lock release and reacquisition must follow Decision 35.
5. A batch boundary cannot split an individual mutation or create an ambiguous commit. Resume must neither skip nor replay an accepted mutation as a new operation.
6. The Recovery Completion Gate remains mandatory. Any uncertain progress or inconsistent evidence invokes existing fail-closed recovery behavior.
7. Batch sizing, timing, yield/resume, lock behavior, and performance require Roblox Studio prototype and interruption testing.

CI-08 is closed at the architecture-contract level. No runtime performance or implementation result is claimed.

---


### CI-09 — Resumable Recovery Progress Needs Verifiable Evidence

**Status: ADDRESSED by LOCKED Decision 64 — Verified Recovery Progress Attestation.**  
**Related decisions:** 23–27, 33–39, 49–57, 60–64

Decision 63 permits Recovery to yield between bounded replay batches, but a saved cursor alone is insufficient evidence that the preceding batch was fully and correctly accepted. Recovery needs a verifiable record binding the accepted progress boundary to the resulting state and authoritative recovery context.

**Recorded resolution in Decision 64:**
1. Each completed batch must produce an attestation identifying RecoveryId, manifest generation, Journal, source checkpoint, and executor context.
2. The attestation binds the exact last accepted committed sequence, segment, terminal hash, resulting StateVersion/version domains, and deterministic canonical state integrity digest under Decision 54.
3. It records validation evidence proving ordered application without omission or duplicate application. Failed or incomplete batches cannot be accepted progress.
4. Publication must be crash-safe and coordinated with authoritative Recovery metadata so accepted progress cannot exist without its corresponding state boundary.
5. Resume validates the attestation and all referenced authoritative evidence. Stale or mismatched attestations cannot be used as cursors.
6. If the newest attestation is invalid, Recovery may use an earlier independently verified boundary or reconstruct from the still-verified baseline and complete required journal range. If no safe path exists, Decision 57 applies.
7. An attestation proves only intermediate progress. It does not satisfy the Recovery Completion Gate or permit gameplay resume.
8. Persistence, crash interruption, fallback, lock reacquisition, and verification costs require Roblox Studio prototype validation.

CI-09 is closed at the architecture-contract level. No runtime implementation or crash-safety result is claimed.

---


### CI-10 — Recovery Diagnostics Need an Independent Integrity-Protected Audit Trail

**Status: ADDRESSED by LOCKED Decision 65 — Recovery Integrity Audit Trail.**  
**Related decisions:** 12, 33–39, 48–64

Recovery lifecycle and verification events are important for diagnosing failures and understanding why Recovery succeeded, yielded, or remained blocked. Those diagnostics must not be mixed into the authoritative Operation Journal or allowed to determine gameplay state.

**Recorded resolution in Decision 65:**
1. Maintain a separate, server-generated, append-only Recovery Audit Trail. It is observational evidence, not a source of truth for gameplay mutations or operation commitment.
2. Record significant lifecycle and integrity events, including lock transitions, baseline/manifest/journal validation, replay outcomes, attestation decisions, yield/continuation, failures, and completion-gate outcomes.
3. Give events unique identities and monotonic stream ordering, referencing RecoveryId and relevant authoritative identifiers where available. Wall-clock timestamps are diagnostic only.
4. Make the trail tamper-evident through deterministic event representation, SHA-256 linkage, and an independently maintained trusted audit-chain head.
5. Minimize event contents and filter client-facing diagnostics so secrets, private player data, and unnecessary authoritative payloads are not exposed.
6. Audit write or verification failure is reported as incomplete audit coverage. It does not alter gameplay state, operation commitment, or Recovery's authoritative success/failure; those remain governed by the existing state, journal, manifest, lock, and completion-gate contracts.
7. Retention, storage, integrity verification, and failure behavior require Roblox Studio prototype validation.

CI-10 is closed at the architecture-contract level. No audit storage, tamper-resistance, or runtime performance result is claimed.

---


### CI-11 — Recovery Fault Reporting and Retry Semantics Need a Shared Contract

**Status: ADDRESSED by LOCKED Decision 66 — Structured Recovery Fault Classification.**  
**Related decisions:** 14, 33–39, 48–57, 63–65

Recovery failures and controlled continuation outcomes need consistent machine-readable classifications so the Recovery Executor, Audit Trail, and authorized diagnostics do not assign conflicting meanings to the same event. Retry behavior must also remain subordinate to operation idempotency and fail-closed recovery rules.

**Recorded resolution in Decision 66:**
1. Faults use stable machine-readable codes, categories, severity, phase/stage, RecoveryId, and safe references to affected recovery objects.
2. Initial categories cover integrity, manifest, checkpoint, lock, replay, attestation, persistence, and execution-context failures. The registry can be extended through a documented compatible process.
3. Expected bounded-budget exhaustion under Decision 63 is a controlled yield, not automatically a fault or replay failure.
4. Each fault declares a retry disposition: RETRY_SAFE, RETRY_AFTER_REVALIDATION, or NO_AUTOMATIC_RETRY. These labels cannot bypass lock ownership, idempotency, commit, or fail-closed requirements.
5. Retry safety must follow the fault's defined semantics and existing authoritative contracts; a generic transient label is not proof that replay is safe.
6. Classified faults integrate with Decision 65's non-authoritative Audit Trail, while client-facing diagnostics remain filtered.
7. Fault classification does not grant gameplay resume; the existing Recovery Completion Gate remains mandatory.
8. Registry coverage, retry handling, audit integration, and diagnostic filtering require Roblox Studio prototype and failure-injection testing.

CI-11 is closed at the architecture-contract level. No runtime fault registry or retry behavior is claimed as implemented or validated.

---


### CI-12 — Repeated Recovery Attempts Need a Bounded Circuit-Breaking Policy

**Status: ADDRESSED by LOCKED Decision 67 — Recovery Circuit Breaker.**  
**Related decisions:** 33–39, 48–57, 63–66

Repeated automatic Recovery attempts against a persistent fault or unavailable dependency can waste bounded resources and repeat unsafe work. The architecture therefore needs an explicit policy for blocking attempts and permitting only controlled probes after re-evaluation.

**Recorded resolution in Decision 67:**
1. The breaker has CLOSED, OPEN, and HALF_OPEN states. OPEN blocks covered automatic attempts while the match remains RECOVERY_REQUIRED.
2. Only configured fault classes/dependency conditions contribute to opening the breaker. Expected replay-budget yield is not a breaker failure.
3. Thresholds/windows and breaker scope must be deterministic and bounded, preventing unrelated Recovery contexts from being blocked without an explicit shared-dependency policy.
4. HALF_OPEN permits only a bounded probe after re-evaluation and under existing lock, context, integrity, and idempotency requirements. Failed probes reopen the breaker.
5. Decision 66 retry dispositions and underlying recovery contracts remain authoritative. The breaker cannot make an unsafe or ambiguous operation retryable.
6. Circuit state/evidence must survive or be safely reconstructed after interruption; untrusted breaker state fails closed.
7. Lock lifecycle, Recovery Completion Gate, and gameplay resume rules are unchanged. Transitions and probes integrate with Decision 65's observational Audit Trail.
8. Reset/override is explicit, authorized, scoped, and auditable. Time passage alone does not clear unresolved faults.
9. Roblox Studio testing remains required for thresholds, concurrency, restart reconstruction, probe bounds, idempotency, and persistence failure.

CI-12 is closed at the architecture-contract level. No runtime Circuit Breaker is claimed as implemented or validated.

---


### CI-13 — Recovery Requires a Controlled Human-Escalation Path

**Status: ADDRESSED by LOCKED Decision 68 — Recovery Escalation Protocol.**  
**Related decisions:** 33–39, 49–57, 63–67

When automatic Recovery cannot safely proceed, the system needs an explicit operational path for authorized review. Without one, a match may remain blocked without a defined way to investigate or record a final disposition. Human intervention must not become a bypass around Recovery integrity or completion requirements.

**Recorded resolution in Decision 68:**
1. Explicit conditions trigger escalation, including persistent Circuit Breaker OPEN conditions, no-automatic-retry faults, and evidence that cannot be safely verified or restored automatically.
2. The match remains RECOVERY_REQUIRED. Escalation cannot release the Recovery Lock, complete Recovery, or resume gameplay.
3. A durable/reconstructible EscalationId-bound record tracks Recovery context, fault, stage, safe evidence references, and validated lifecycle transitions.
4. Protected diagnostics and every administrative action require server-side authorization. Player-facing diagnostics remain filtered.
5. Interventions are typed, reasoned, scoped, validated, and audited. They cannot rewrite committed journal history, fabricate evidence, replace trusted integrity heads, or roll back committed gameplay.
6. Any intervention that continues Recovery returns to the normal pipeline and must pass the applicable integrity/context checks and existing Recovery Completion Gate.
7. Escalation does not implicitly reset the Circuit Breaker or override Decision 66 retry dispositions.
8. Persistence/reconstruction, audit coverage, authorization, concurrency, and no-bypass behavior require Roblox Studio prototype testing.

CI-13 is closed at the architecture-contract level. No administrative console, escalation service, or intervention workflow is claimed as implemented or validated.

---


### CI-14 — Recovery Coordination Needs Match-Scoped Isolation

**Status: ADDRESSED by LOCKED Decision 69 — Recovery Isolation Boundary.**  
**Related decisions:** 12, 18–20, 33–39, 45–57, 60–68

When a server hosts multiple matches, a stalled or failed Recovery must not implicitly occupy shared mutation coordination or alter another match's Recovery state. At the same time, independent Recovery workloads still need bounded aggregate resource governance.

**Recorded resolution in Decision 69:**
1. Every Recovery is bound to MatchId and RecoveryId. Recovery-owned locks, queues, evidence, fault counters, Circuit Breaker state, and escalation records are scoped accordingly.
2. Mutation ordering and Recovery serialization are per-match. A match's Recovery cannot acquire a global gameplay mutation lock or occupy another match's queue.
3. Checkpoints, journal segments, manifests, attestations, audit streams, and administrative actions validate their match/recovery scope. Cross-match references are rejected unless covered by an explicit coordination contract.
4. Recovery failure, OPEN Circuit Breaker, or pending escalation in one match cannot mutate another match's gameplay, Recovery status, lock, queue, or completion gate.
5. Explicit cross-match operations must declare their full scope and use deterministic coordination, validation, and failure handling.
6. Server-wide admission control may bound aggregate CPU/work, memory, concurrency, and storage. It must safely defer/reject new work without corrupting active matches.
7. Fair scheduling, stale callback rejection, and cross-match isolation require Roblox Studio prototype tests under concurrency and resource exhaustion.

CI-14 is closed at the architecture-contract level. No multi-match isolation scheduler or runtime resource governor is claimed as implemented or validated.

---


### CI-15 — Concurrent Recovery Work Needs Deterministic Priority and Fair Scheduling

**Status: ADDRESSED by LOCKED Decision 70 — Priority-Based Recovery Scheduling with Fairness Guarantee.**  
**Related decisions:** 33–39, 63, 67, 69

With multiple matches requiring Recovery, server-wide resource limits need an explicit dispatch policy. Continuations may benefit from reduced restart overhead, but unbounded continuation preference could starve newly waiting matches.

**Recorded resolution in Decision 70:**
1. The scheduler distinguishes ACTIVE_CONTINUATION, NEW_VALIDATED, RESOURCE_WAITING, and RESOURCE_DEFERRED tasks.
2. Ordering within classes uses stable scheduling metadata and deterministic tie-breaking, not wall-clock timestamps alone.
3. Continuation preference is bounded by safe work slices and requeueing. Aging or fair rotation, per-match limits, and concurrency controls prevent indefinite monopolization.
4. Global resource admission remains bounded and may safely defer/reject work without mutating waiting or active Recovery state.
5. Before dispatch, task eligibility, MatchId/RecoveryId context, lock ownership, and terminal/cancelled/escalated state are revalidated.
6. Scheduling priority cannot bypass replay budgets, retry dispositions, Circuit Breaker, escalation restrictions, isolation, or Recovery Completion Gate.
7. Deterministic ordering, fairness under sustained arrivals, quotas, resource exhaustion, stale queue entries, and restart behavior require Roblox Studio prototype tests.

CI-15 is closed at the architecture-contract level. No runtime scheduler or fairness guarantee is claimed as implemented or validated.

---


### CI-16 — Recovery Scheduling Needs Explicit Admission and Queue Bounds

**Status: ADDRESSED by LOCKED Decision 71 — Recovery Scheduler Admission Control.**  
**Related decisions:** 63, 67, 69–70

Priority scheduling alone does not determine whether a request may enter the pending queue or consume an active Recovery slot. Admission needs bounded capacity checks and a distinct dispatch-time revalidation boundary.

**Recorded resolution in Decision 71:**
1. Admission outcomes distinguish REJECTED, DEFERRED, QUEUED, and ADMITTED. Queue admission does not grant an active execution slot or permission to mutate Recovery state.
2. Initial validation binds authorization, MatchId/RecoveryId, current eligibility, metadata/context, and applicable fault, Circuit Breaker, escalation, and lock constraints.
3. Active concurrency, per-match limits, bounded work budgets, memory, and storage are governed by explicit conservative limits. Unknown capacity is not treated as unlimited.
4. Deferred requests hold neither active slots nor long-lived Recovery Locks. Deferred retention and pending queues are bounded, with explicit reject/expiry outcomes.
5. Dispatch revalidates current context, state/version, lock, eligibility, retry disposition, Circuit Breaker, escalation, and stage evidence.
6. Queue insertion, active-slot reservation, and status publication must be coordinated against concurrent requests, with rollback on failed admission.
7. Deferred work re-enters through Decision 70's priority/fairness policy. Admission cannot bypass replay budgets, isolation, escalation, or Recovery Completion Gate.
8. Queue bounds, admission races, resource exhaustion, deferred re-admission, reservation rollback, and stale dispatch context require Roblox Studio prototype tests.

CI-16 is closed at the architecture-contract level. No runtime Admission Control implementation or capacity guarantee is claimed.

---


### CI-17 — Recovery Queue State Must Survive Interruption Without Becoming Authoritative

**Status: ADDRESSED by LOCKED Decision 72 — Durable Recovery Queue State.**  
**Related decisions:** 35, 60–65, 69–71

Recovery work may be QUEUED or DEFERRED when a server stops. Losing all scheduling metadata can strand valid work, while blindly replaying persisted entries can create duplicate execution, stale reservations, or unsafe dispatch.

**Recorded resolution in Decision 72:**
1. QueueEntryId and stable enqueue sequence bind each record to MatchId and RecoveryId. Durable QUEUED/DEFERRED acknowledgement requires successful persistence or an approved durable publication boundary.
2. Queue records contain bounded scheduling metadata only. They do not duplicate authoritative gameplay or Recovery state.
3. Restart reconstruction begins in a non-executable reconciliation state. Schema, integrity, identity, scope, transitions, retention, and current eligibility are checked before an entry can be considered.
4. Restored entries must pass current Admission Control, scheduling/fairness, resource checks, and dispatch-time validation. Old capacity reservations and lock ownership are not restored from queue data.
5. Duplicate and ambiguous persistence/dispatch outcomes are reconciled through stable identity and authoritative Operation Journal/Recovery evidence, never queue status alone.
6. Corrupt, stale, unsupported, duplicate, or cross-match-inconsistent entries are quarantined/rejected, not silently repaired into executable work.
7. Pending retention and terminal tombstones are bounded but must prevent duplicate resurrection within the defined retry horizon. Authoritative gameplay and Recovery evidence is not cleaned up as queue data.
8. Queue lifecycle and reconciliation integrate with Decision 65's observational Audit Trail. Interruption, duplicate delivery, concurrent reconstruction, changed capacity, and lock reacquisition require Roblox Studio prototype tests.

CI-17 is closed at the architecture-contract level. No durable queue implementation or platform-level persistence guarantee is claimed.


### CI-18 — Recovery Queue Transition History Needs Independent Tamper Evidence

**Status: ADDRESSED by LOCKED Decision 73 — Tamper-Evident Recovery Queue Records.**  
**Related decisions:** 59–61, 65–72

Decision 72 makes queue state durable and reconstructible, but durable records alone do not establish whether queue transition history was altered, truncated, reordered, or rolled back. Rebuilding a trusted head from the same untrusted queue data would not independently detect those failures.

**Recorded resolution in Decision 73:**
1. Every queue transition appends a new record bound to QueueEntryId, MatchId, RecoveryId, a monotonic sequence, transition type, schema/version, and previous-record hash.
2. Canonical deterministic serialization defines the exact hash input. Timestamps are diagnostic only and never determine ordering or repair.
3. The queue integrity chain is a separate scheduling-only integrity domain. It is not the gameplay Operation Journal and cannot prove a gameplay operation committed or Recovery completed.
4. A separately protected trusted anchor/head establishes the expected chain boundary. The queue records cannot be their own sole trust authority; rollback and concurrent publication protection must be explicitly designed.
5. A transition record is persisted and validated before the new head/status is published or acknowledged. Crash ambiguity is reconciled by stable identity and sequence, with conflict-safe serialized publication.
6. Restart verification detects altered, missing, duplicated, reordered, truncated, stale, or conflicting records before queue restoration can become executable.
7. Verification failure quarantines the affected queue scope and keeps it non-executable. Fault classification, Circuit Breaker, escalation, and observational Audit Trail integration follow Decisions 66–68 and 65 respectively.
8. Segmentation and bounded retention preserve verifiable boundaries and Decision 72's duplicate-prevention horizon. Only the server-side queue owner may append records or publish trusted heads.
9. Roblox DataStoreService transaction/CAS capabilities are not assumed. Crash-safe publication, trusted-head protection, and failure behavior require prototypes against actual platform primitives.

CI-18 is closed at the architecture-contract level. No cryptographic guarantee, privileged-storage-compromise protection, Roblox runtime implementation, or platform persistence guarantee is claimed.


### CI-19 — Recovery Scheduling Fairness Must Survive Server Interruption

**Status: ADDRESSED by LOCKED Decision 74 — Persistent Recovery Fairness Metadata.**  
**Related decisions:** 65, 69–73

Decision 70 defines priority and fairness scheduling, while Decisions 72–73 make queue entries durable and their transition history verifiable. However, without persisted fairness metadata, reconstruction could reset waiting order or accumulated priority-aging credit after repeated server interruptions. Newly arriving work could then repeatedly overtake older eligible work.

**Recorded resolution in Decision 74:**
1. Fairness metadata is bound to QueueEntryId, MatchId, RecoveryId, and the stable enqueue sequence from Decision 72.
2. The scheduler persists bounded priority class and validated fairness/wait credit, with references to Decision 73's integrity records.
3. Credit is updated only through server-controlled, verifiable scheduler transitions or another explicitly trusted mechanism. Raw client timestamps and unverified wall-clock values cannot grant priority.
4. Restart reconstruction uses verified enqueue order, priority class, and persisted credit under Decision 70's deterministic tie-breaking and fairness rules. Repeated reconstruction cannot reset or inflate credit.
5. Aging is bounded. Fairness never overrides eligibility, Admission Control, replay budgets, Circuit Breaker, escalation, isolation, lock requirements, or dispatch-time validation.
6. Restored fairness position does not restore capacity reservations, active slots, locks, or dispatch authorization. Work re-enters current admission and scheduling.
7. Fairness metadata integrity follows Decision 73; observational audit follows Decision 65. Retention and schema evolution follow Decisions 72–73.
8. Repeated restart, clock jumps, duplicate updates, credit rollback, long-waiting versus new work, changed capacity, and aging caps require Roblox Studio prototype tests.

CI-19 is closed at the architecture-contract level. No guarantee of eventual execution under capacity or safety constraints, runtime implementation, or platform-level trusted clock is claimed.



---

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
| 0 | Resolve RF-08 to RF-11 and freeze contracts | Remaining versioning, victory mutation, checkpoint, and Roblox authority contracts are explicit |
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

**Architecture findings: ADDRESSED.** RF-01 through RF-08 are addressed by LOCKED Decisions 45–52; RF-09 is addressed by Decision 54; RF-10 is addressed by Decision 55; and RF-11 is addressed by Decision 53.

**Implementation readiness: NOT YET.** All findings are addressed at the architecture-contract level, but required Roblox Studio prototypes and the minimum acceptance test matrix have not been completed or evidenced by this review. Implementation readiness must remain NOT YET until those validations support it. This review is documentation analysis, not evidence of Roblox Studio implementation or testing.

No prior LOCKED decision is silently changed by this report. Any correction or refinement must be approved as a new, traceable decision and recorded in the Architecture Review Decision Log.