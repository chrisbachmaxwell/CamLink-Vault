# 2026-07-09 — Patient records Phase A work loop

## Decisions made
- Local index at `captures/patients.json` (no DB). Stable 12-hex ids.
- Visit path: `patients/<id>-<slug>/visits/<ISO-ts>/` via CaptureSession
  explicit `folder` + optional `patientId`/`visitId` on the manifest.
- Same name + different DOB = distinct patients; same name + same DOB =
  collision rejected.
- Legacy flat folders are **unfiled** until an explicit
  `POST /api/unfiled/file` — never auto-moved (HIPAA).
- Legacy `POST /api/session { patientName }` kept for smoke/compat; UI
  prefers `patientId`.

## Mistakes caught
- `sanitizeFolderName` lowercases — must not run visit ISO timestamps
  through it (`T` → `t`). Added `sanitizeVisitId` that preserves case.
- Concurrent photo stores can finish out of order; SDK test now sorts
  before asserting paths (pre-existing flake, not a product bug).

## Patterns confirmed
- Adapter boundary untouched; clinic app owns patient index + filing.
- Three gates (build / test / ptp-simulator smoke) caught nothing after
  the visitId sanitization fix — good loop discipline.
- Staged `vault-updates/` transfer worked: goals system + HIPAA page now
  live in CamLink-Vault.

## Commits pushed (CamLink-SDK `claude/camera-sdk-adapter-pattern-4pj5r8`)
- `9309110` Remove applied vault-updates staging
- `af4abc8` PatientIndex module + tests
- `dc6cdba` Visit folders + manifest patientId/visitId
- `70ef1ce` Create/match API + front-desk UI
- `6c8a3d2` History grouped by patient → visits
- `781a505` Unfiled list + explicit migration
- `5071486` Extended smoke (multi-visit + same-name DOB)

## What a human should test by hand
1. From CamLink-SDK: `npm run build && npm start -w @camlink/clinic-app`
2. Open http://localhost:3333 — finish wizard (Practice mode / PTP sim is fine).
3. Front desk: type a name, Create patient (add DOB), Start visit, shoot,
   End session. Confirm folder under `captures/patients/<id>-…/visits/…`.
4. Create a second patient with the **same name** and a **different DOB**;
   start a visit — must land in a different `patients/<other-id>-…` tree.
5. If you have old `captures/<slug>/<timestamp>/` folders: they should show
   under **Unfiled sessions**; File into a patient only when you choose.
6. With the R6 III (Waiting on Chris): create 3 patients, 2 visits each —
   does the front desk feel right?

## Next
Phase B: [[2026-07-visit-compare-ui]].
