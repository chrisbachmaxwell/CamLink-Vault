# Project status — WHAT IS DONE

Last updated: 2026-07-09 (evening — vault-creation session). Update this
page in the same session as any meaningful repo work.

## Milestones (from the original spec)
- ✅ M0 monorepo, CI, docs skeleton
- ✅ M1 core SDK + MockCameraAdapter + certification suite (9 checks)
- ✅ M5 clinic reference app ([[clinic-app]])
- ✅ PTP plan P1–P3+P5: protocol stack, Canon PTP/IP adapter, simulator,
  wizard integration (see docs/PTP-PLAN.md in repo)
- ✅ Knowledge vault: created, backfilled, published to
  `github.com/chrisbachmaxwell/CamLink-Vault`; SDK repo `CLAUDE.md` points
  agents at it (commit f0de6b6)
- ⏳ P4a USB tether transport — designed, not built (see [[roadmap]])
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

## Quality gates (all green as of 2026-07-09)
- 67 unit/integration tests across 6 packages
- Clinic-app smoke test drives the real wizard endpoints against the PTP
  simulator (exercises pairing, handoff, test shot, session filing)
- Adapter certification suite passes for mock, CCAPI-sim, PTP-sim

## Where things live
- Code: `chrisbachmaxwell/CamLink-SDK`, branch
  `claude/camera-sdk-adapter-pattern-4pj5r8` (repo default; no PRs — the
  branch is the mainline).
- Knowledge: `chrisbachmaxwell/CamLink-Vault` (private), local at
  `~/CamLink-Vault`, manual `git push` checkpoints.
