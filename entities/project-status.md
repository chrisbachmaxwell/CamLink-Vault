# Project status — WHAT IS DONE

Last updated: 2026-07-09 (architect-required fixes landed; awaiting
re-review). Update this page in the same session as any meaningful repo work.

## Milestones (from the original spec)
- ✅ M0 monorepo, CI, docs skeleton
- ✅ M1 core SDK + MockCameraAdapter + certification suite (9 checks)
- ✅ M5 clinic reference app ([[clinic-app]])
- ✅ PTP plan P1–P3+P5: protocol stack, Canon PTP/IP adapter, simulator,
  wizard integration (see docs/PTP-PLAN.md in repo)
- ✅ Knowledge vault: created, backfilled, published to
  `github.com/chrisbachmaxwell/CamLink-Vault`; SDK `CLAUDE.md` / `AGENTS.md`
  point agents at it
- 🔶 **Phase A — Patient records & visits** ([[2026-07-patient-records]]):
  implemented; architect-required fixes landed 2026-07-09 (`db01c8d`
  flaky gate, `f4f8a1e` folder traversal, `3b2b69a` already-filed test).
  Status still IN PROGRESS pending architect re-review — do not mark DONE
  until that flips.
- ⏳ Phase B visit-compare UI · Phase C clinic lockdown · Phase D USB tether
  (see [[roadmap]])
- ⏳ M2 native kits (iOS/Android) — scaffolds only
- ⏳ M6 npm publish pipeline — not started

## Hardware proof (the thing that matters)
- 2026-07-08: **Canon EOS R10** — full pipeline on camera's own Wi-Fi.
  Wizard pairing → test photo → physical shutter → patient folder.
  Runs degraded (no remote shutter, 0x2002) — physical shutter works.
- 2026-07-09: **Canon EOS R6 Mark III** — full pipeline INCLUDING a real
  patient-session run: 4 CR3 photos filed to
  `captures/r6-test/2026-07-08T22-53-23/` with manifest. Required decoding
  the brand-new 0xc1b6 event record from a field hex dump; RAW/CR3 shots
  render in the session grid via embedded-JPEG `.thumb.jpg` sidecars, with
  a one-time in-app JPEG advisory. See [[canon-eos-r6-mark-iii]].

## Quality gates (worker re-verified 2026-07-09 after architect fixes)
- `npm run build` green; `node apps/clinic/test/smoke.mjs ptp-simulator` green
- `npm test`: **10/10 consecutive green** after `db01c8d` (order-independent
  adapter-mock assertion). SDK session tests now cover folder traversal
  rejects (absolute / `..` / NUL) + nested accept.
- Unit/integration tests across 7 workspaces; clinic 18 vitest cases; SDK
  session suite 15 tests
- Adapter certification suite passes for mock, CCAPI-sim, PTP-sim

## Where things live
- Code: `chrisbachmaxwell/CamLink-SDK`, branch
  `claude/camera-sdk-adapter-pattern-4pj5r8` (repo default; no PRs — the
  branch is the mainline).
- Knowledge: `chrisbachmaxwell/CamLink-Vault` (private), local at
  `~/CamLink-Vault`, manual `git push` checkpoints.
