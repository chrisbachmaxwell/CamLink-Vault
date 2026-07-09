# Project status — WHAT IS DONE

Last updated: 2026-07-09. Update this page in the same session as any
meaningful repo work.

## Milestones (from the original spec)
- ✅ M0 monorepo, CI, docs skeleton
- ✅ M1 core SDK + MockCameraAdapter + certification suite (9 checks)
- ✅ M5 clinic reference app ([[clinic-app]])
- ✅ PTP plan P1–P3+P5: protocol stack, Canon PTP/IP adapter, simulator,
  wizard integration (see docs/PTP-PLAN.md in repo)
- ⏳ P4a USB tether transport — designed, not built (see [[roadmap]])
- ⏳ M2 native kits (iOS/Android) — scaffolds only
- ⏳ M6 npm publish pipeline — not started

## Hardware proof (the thing that matters)
- 2026-07-08: **Canon EOS R10** — full pipeline on camera's own Wi-Fi.
  Wizard pairing → test photo → physical shutter → patient folder.
  Runs degraded (no remote shutter, 0x2002) — physical shutter works.
- 2026-07-09: **Canon EOS R6 Mark III** — full pipeline. Required decoding
  a brand-new event record (0xc1b6) from a field hex dump. CR3/RAW handled
  with preview sidecars. See [[canon-eos-r6-mark-iii]].
- Session run "r6 test": 4 CR3 photos → `captures/r6-test/2026-07-08T22-53-23/`.

## Quality gates (all green as of 2026-07-09)
- 67 unit/integration tests across 6 packages
- Clinic-app smoke test drives the real wizard endpoints against the PTP
  simulator (exercises pairing, handoff, test shot, session filing)
- Adapter certification suite passes for mock, CCAPI-sim, PTP-sim

## Where the code is
Everything pushed to `chrisbachmaxwell/CamLink-SDK`, branch
`claude/camera-sdk-adapter-pattern-4pj5r8` (repo default). No open PRs —
the branch IS the mainline.
