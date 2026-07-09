# 2026-07-09 — Architect-required Phase A fixes

Worker session after [[2026-07-09-architect]] rejected DONE. Scope: only
the three items under "Architect review" on [[2026-07-patient-records]].
No Phase B. Adapter packages untouched.

## Decisions made
1. **Flaky gate — order-independent assertion** (not deterministic
   CaptureSession downloads). Concurrent download is intentional for
   throughput; the product cares that all files land, not store finish
   order. Same approach already used in `packages/sdk/test/session.test.ts`.
2. **Folder traversal — reject in CaptureSession constructor** via
   `assertSafeSessionFolder` (absolute POSIX/Windows, `..` segments, NUL).
   Fail closed at the public API before any StorageProvider join.
3. **Unfiled minor — implement the missing already-filed assertion**
   rather than rename the test.

## Mistakes caught
- None new this session; the architect correctly identified the missed
  adapter-mock flake and the public-API traversal hole.

## Patterns confirmed
- Three gates + iteration-log-per-push kept the vault and SDK in lockstep.
- 10 consecutive full-suite runs is a useful proof bar for race flakes.

## Commits (CamLink-SDK `claude/camera-sdk-adapter-pattern-4pj5r8`)
- `db01c8d` — adapter-mock order-independent assertion
- `f4f8a1e` — CaptureSession folder traversal rejection + tests
- `3b2b69a` — unfiled already-filed assertion

## Proof
- Gates after each fix: `npm run build`, `npm test`,
  `node apps/clinic/test/smoke.mjs ptp-simulator` — all green.
- Flake proof: **10/10 consecutive `npm test` PASS** (tallied after
  `db01c8d`).

## Status left for architect
Goal page Status remains **IN PROGRESS**. Gates box re-checked with the
architect's dated note marked RESOLVED. Architect flips DONE after
re-review; then Phase B [[2026-07-visit-compare-ui]].
