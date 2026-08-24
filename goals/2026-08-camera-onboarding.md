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
- [ ] Chris onboards a camera end-to-end through the new flow
      (verified by: Chris's session — the field box)

## Waiting on Chris
- Start from the preamble in [[test-environment]], open the Med Photo
  app → Menu → **Add a camera** → pick your body from the dropdown →
  follow the card exactly. Expect: the card's status line flips to
  "checked in" after the first photo, and the photo appears in the
  visit. Tell the agent which model and what the card got wrong, if
  anything — that's a catalog fix, same session.

## Stop clause
If the flow needs per-model FIRMWARE quirks beyond menu text, stop and
open a hardware-page investigation instead of guessing.

## Iteration log
- 2026-08-22 — Catalog (`camera-catalog.js`) + server model field
  landed; UI in progress (agent working in apps/clinic).
- 2026-08-22 (later) — Flow SHIPPED (v0.10.0, all six gates green; first-run
  verified headless). Remaining: the field box — Chris onboards a body
  end-to-end through the new flow.
