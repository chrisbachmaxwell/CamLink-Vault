# 2026-08-25 — Unassigned camera photos stay off patient screens

Chris caught a patient-facing interruption: a photo arriving from a camera
with no active visit raised a global banner, including while staff were
showing a patient their gallery.

## Decision

- Never delete the photo. It stays locally on disk, outside every patient
  record, until a human decides where it belongs.
- Do not surface it in a patient view, Compare, or a live visit banner.
- Surface the count only on the Cameras card for the camera that received
  it: “photo(s) waiting outside a visit”. This keeps the responsibility
  with the person managing that selected camera and keeps patient review
  calm.

## Shipped

- SDK commit `18c639c` — `Keep unassigned photos off patient screens`.
- `GET /api/unfiled` now includes the buffering camera identity when known;
  legacy unfiled sessions remain unassigned.
- Browser UI gate verifies both boundaries: no banner over an active visit,
  and the receiving camera card alone shows the retained photo.

## Verification

- `npm run build` — green.
- Clinic unfiled unit test — green (4 tests).
- `node apps/clinic/test/smoke.mjs ptp-simulator`, `ftp`, and `multi-room`
  — green.
- `node apps/clinic/test/ui-gate.mjs` — green.
- Whole-workspace `npm test` remains environment-red in the two already
  documented areas: UDP 1900 announcer delivery and macOS missing
  `127.0.0.2`; all clinic tests relevant to this change pass.
