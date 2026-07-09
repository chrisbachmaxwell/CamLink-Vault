# Project status — WHAT IS DONE

Last updated: 2026-07-09 (patient-records Phase A loop). Update this
page in the same session as any meaningful repo work.

## Milestones (from the original spec)
- ✅ M0 monorepo, CI, docs skeleton
- ✅ M1 core SDK + MockCameraAdapter + certification suite (9 checks)
- ✅ M5 clinic reference app ([[clinic-app]])
- ✅ PTP plan P1–P3+P5: protocol stack, Canon PTP/IP adapter, simulator,
  wizard integration (see docs/PTP-PLAN.md in repo)
- ✅ Knowledge vault: created, backfilled, published to
  `github.com/chrisbachmaxwell/CamLink-Vault`; SDK `CLAUDE.md` / `AGENTS.md`
  point agents at it
- ✅ **Phase A — Patient records & visits** ([[2026-07-patient-records]]):
  local `patients.json` index, nested visit folders, create/match API +
  front-desk UI, grouped history, explicit unfiled migration, extended smoke
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

## Quality gates (all green as of 2026-07-09 patient-records loop)
- Unit/integration tests across 7 workspaces (SDK + 5 adapter/ptp packages
  + clinic-app); clinic alone has 18 vitest cases
- Clinic-app smoke (`ptp-simulator`): wizard → session, then two visits for
  one patient + one visit for a same-named patient with different DOB into
  distinct `patients/<id>/visits/` folders
- Adapter certification suite passes for mock, CCAPI-sim, PTP-sim

## Where things live
- Code: `chrisbachmaxwell/CamLink-SDK`, branch
  `claude/camera-sdk-adapter-pattern-4pj5r8` (repo default; no PRs — the
  branch is the mainline).
- Knowledge: `chrisbachmaxwell/CamLink-Vault` (private), local at
  `~/CamLink-Vault`, manual `git push` checkpoints.
