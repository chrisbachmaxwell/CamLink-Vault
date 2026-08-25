# Project status — WHAT IS DONE

Last updated: 2026-07-09 (architect re-review — reconnect goal DONE and
merged; Phase B is next). Update this page in the same session as any
meaningful repo work.

## Milestones (from the original spec)
- ✅ M0 monorepo, CI, docs skeleton
- ✅ M1 core SDK + MockCameraAdapter + certification suite (9 checks)
- ✅ M5 clinic reference app ([[clinic-app]])
- ✅ PTP plan P1–P3+P5: protocol stack, Canon PTP/IP adapter, simulator,
  wizard integration (see docs/PTP-PLAN.md in repo)
- ✅ Knowledge vault: created, backfilled, published to
  `github.com/chrisbachmaxwell/CamLink-Vault`; SDK `CLAUDE.md` / `AGENTS.md`
  point agents at it
- ✅ **Phase A — Patient records & visits** ([[2026-07-patient-records]],
  DONE 2026-07-09, architect re-review): local `patients.json` index
  (atomic writes, DOB collision keys), nested
  `patients/<id>-<slug>/visits/<ts>/` via a validated CaptureSession
  `folder` option (traversal rejected, `f4f8a1e`), create/match API +
  front-desk UI, history grouped patient → visits (legacy manifests still
  read), explicit-only unfiled migration, extended smoke. Fixes:
  `db01c8d` `f4f8a1e` `3b2b69a`. Chris's real-office R6 III sanity pass
  still open on the goal page.
- ✅ **R. Camera power-cycle reconnect** ([[2026-07-camera-reconnect]],
  DONE 2026-07-09, architect re-review; merged to mainline): announcer
  interface re-join (GUID stable), server-side reconnect watch (no
  browser tab), different-address reconnect + persist, mid-session visit
  survival, plain-language UI waiting state, hard-rule guard script.
  Hardware proof still open: Chris's three R6 III power-cycle drills on
  the goal page.
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

## Quality gates (architect independently re-verified 2026-07-09 late)
- `npm run build` green; `node apps/clinic/test/smoke.mjs ptp-simulator`
  green (incl. multi-visit + same-name-DOB patient-records checks)
- `npm test`: **10/10 consecutive green**, run by the architect on top of
  the worker's own 10/10 (fix `db01c8d`, order-independent adapter-mock
  assertion). Traversal rejects (absolute / `..` / NUL) probed directly
  against the built SDK.
- 89 unit/integration tests across 7 workspaces (clinic 18, sdk 22)
- Adapter certification suite passes for mock, CCAPI-sim, PTP-sim

## Where things live
- Code: `chrisbachmaxwell/CamLink-SDK`, branch
  `claude/camera-sdk-adapter-pattern-4pj5r8` (repo default; no PRs — the
  branch is the mainline).
- Knowledge: `chrisbachmaxwell/CamLink-Vault` (private), local at
  `~/CamLink-Vault`, manual `git push` checkpoints.

## 2026-08-25 addendum
- ✅ **Recoverable live photo removal** shipped in Med Photo **v0.18.0**
  (SDK commit `4d6194d`): every completed live tile has a touch-sized trash
  control, the full-screen viewer has the same action, removal moves the
  photo and RAW preview into local `.trash/`, and a 10-second batch Undo
  restores bytes plus manifest state. Deleted manifest tombstones survive
  later captures/restarts; review-only users cannot change photos.
- Field A/B on the same relay: a Nikon Z8 delivered a three-JPEG backlog
  slowly and produced one refused/truncated attempt; a Canon R6 Mark II
  then delivered 17 JPEGs quickly with zero failures. Relay-to-Mac pulls
  were immediate. Current verdict: the bottleneck is the Z8-to-relay
  compatibility path, not the relay in general. See
  [[log/2026-08-25-camera-transfer-and-recoverable-delete]].
