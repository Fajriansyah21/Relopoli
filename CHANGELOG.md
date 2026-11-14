# Changelog

All notable documentation changes are recorded here.

## 2026-11-13
- Initialized the repository documentation structure.
- Added the consolidated Master Source of Truth.
- Added available Progress and system documents, UI/visual references, property catalog, and preliminary review backlog.
- Preserved historical progress documents as source records; they do not override newer locked decisions.

## 2026-11-14
- Locked Decision 63 (Bounded Recovery Replay Budget) and recorded cross-decision consistency finding CI-08 as addressed. Updated the consolidation review, summary, and index. Batch sizing, safe yield/resume, lock behavior, and replay performance remain subject to Roblox Studio prototype validation.
- Locked Decision 62 (Intermediate Journal Replay Checkpoints) and recorded cross-decision consistency finding CI-07 as addressed. Updated the consolidation review, summary, and index. Replay-checkpoint cadence, crash safety, fallback correctness, and performance remain subject to Roblox Studio prototype validation.
- Locked Decision 61 (Authoritative Journal Recovery Manifest) and recorded cross-decision consistency finding CI-06 as addressed. Updated the consolidation review, summary, and index. Crash-safe manifest publication and consistency with checkpoint/journal commits remain subject to Roblox Studio prototype validation.
- Locked Decision 60 (Segmented Operation Journal) and recorded cross-decision consistency finding CI-05 as addressed. Updated the consolidation review, summary, and index. Segment sizing, closure cadence, and bounded verification performance remain subject to Roblox Studio prototype validation.
- Locked Decision 59 (Hash Chain Integrity for the Operation Journal) and recorded cross-decision consistency finding CI-04 as addressed. Updated the consolidation review, summary, and index. Roblox SHA-256 capability, trusted chain-head persistence, and performance still require prototype validation.
- Locked Decision 58 (Append-Only Operation Journal) and recorded cross-decision consistency finding CI-03 as addressed. Updated the consolidation review, summary, and index; RF-01–RF-11 and CI-01–CI-03 are addressed at the architecture-contract level. Roblox implementation validation remains outstanding.
- Locked Decision 57 (Fail-Closed Recovery on Operation Journal Integrity Failure) and recorded cross-decision consistency finding CI-02 as addressed. Updated the consolidation review, summary, and index; all RF-01–RF-11 and CI-01–CI-02 are addressed at the architecture-contract level, while implementation validation remains outstanding.
- Locked Decision 56 (Preserve a Verified Recovery Baseline) to resolve cross-decision consistency finding CI-01 across checkpoint retention and memory-budget rules. Updated the consolidation review, summary, and index; all RF-01–RF-11 and CI-01 are addressed at the architecture-contract level, while Roblox Studio validation remains outstanding.
- Locked Decision 55 (Single Checkpoint Manager Ownership) and recorded RF-10 as addressed. All RF-01–RF-11 architecture findings are now addressed at the documentation-contract level; Roblox Studio prototypes and acceptance tests remain outstanding.
- Locked Decision 54 (Deterministic Checkpoint Serialization and Integrity Contract) and recorded RF-09 as addressed. Updated the consolidation review, summary, and index; RF-10 remains unresolved.
- Locked Decision 53 (Conventional Server-Authoritative Runtime Model) and recorded RF-11 as addressed. Updated the consolidation review, summary, and index; RF-09 and RF-10 remain unresolved.
- Locked Decision 52 (Separate Victory Evaluation From Game-End Mutation) and recorded RF-08 as addressed.
- Updated the consolidation review, summary, and index: Decisions 1–52 are LOCKED, RF-01–RF-08 are addressed, and RF-09–RF-11 remain unresolved.

- Locked Decision 51 (Separated Version Domains) and recorded RF-07 as addressed.
- Updated the architecture review summary and index: Decisions 1–52 are LOCKED, RF-01–RF-08 are addressed, and RF-09–RF-11 remain unresolved.
- Added a central architecture/documentation index and an architecture review summary.
- Updated the consolidation review to mark RF-01–RF-08 as addressed by Decisions 45–52 and RF-09–RF-11 as unresolved.
- Corrected the implementation dependency phase and review verdict to reflect the current finding status.
- Updated repository entry points and contribution guidance to clarify canonical document ownership and avoid duplicated decision text.
