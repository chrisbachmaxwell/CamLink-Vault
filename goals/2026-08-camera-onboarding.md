# Goal: Model-first camera onboarding — pick the model, the app knows the rest

Status: IN PROGRESS (opened 2026-08-22).

Context: Chris (2026-08-22): "Connect a camera" screen = pick an
already-added camera (live status; tap → its values + steps) or "Add a
new camera" → dropdown of camera models → that model's own connection
instructions. Knowledge lives in the catalog
([[camera-catalog]], `apps/clinic/public/camera-catalog.js`). First-run
lands on this flow; the old transport-tile wizard remains as the
"Not sure / another camera" fallback and behind Menu → Change camera.

## Done when (verified by:)
- [x] Flow implemented behind the existing gates (2026-08-22, v0.10.0) (verified by: ui-gate
      drives add-a-camera through the model picker)
- [x] First-run lands on the connect flow (2026-08-22, headless check) (verified by: ui-gate — fresh
      state opens on Connect, not the transport tiles)
- [x] R5 Mark II warning shown when that model is picked (2026-08-22) (verified by:
      gate asserts 'passive' in the rendered card)
- [x] One primary action per screen; Wi-Fi/server/login tasks, direct Add,
      read-only saved inspection and explicit password replacement (2026-09-05, browser UI gate).
- [x] Browser gate rejects historic uploads and photos from another camera;
      interrupted proof checks recover without reporting success (2026-09-05).

## Waiting on Chris
- [ ] Onboard a physical camera end-to-end with synthetic photos.
  Open the app with `open -a "Med Photo"`, then Software Update. In Cameras,
  choose **Add a camera**, choose the model and follow **Wi-Fi → server →
  login → test photo**. Expected: only a new completed photo from this camera
  shows **Camera connected**. With no visit open, the test photo stays in
  Unassigned; with a visit open, it goes into that camera's active visit.
  Reopen the saved camera and confirm Test camera does not replace its login.

## Stop clause
If the flow needs per-model FIRMWARE quirks beyond menu text, stop and
open a hardware-page investigation instead of guessing.

## Iteration log
- 2026-08-22 — Catalog (`camera-catalog.js`) + server model field
  landed; UI in progress (agent working in apps/clinic).
- 2026-08-22 (later) — Flow SHIPPED (v0.10.0, all six gates green; first-run
  verified headless). Remaining: the field box — Chris onboards a body
  end-to-end through the new flow.

- 2026-09-05 — Guided setup and sign-in/role recovery audited with synthetic
  browser and actual HTTP fixtures. Source/release evidence in
  [[log/2026-09-05-camera-setup-access-audit]]. Firmware menu text unchanged;
  the physical-camera gate remains open.
