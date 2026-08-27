# Cloud camera setup routing v0.19.3 — 2026-08-27

## Field defect

Chris opened **Settings → Change how the camera connects** in a cloud clinic.
The app showed the retired transport chooser and then asked for the relay
address and infrastructure access token. That was the old local/test relay
workflow, not the new per-camera cloud workflow.

## Correction

- In cloud-authoritative mode, Settings now opens the same model-first camera
  flow as Cameras → Add a camera.
- Selecting a supported FTP camera creates its unique server-side profile and
  displays only the values that belong in that camera: protocol, host, port,
  username, password and folder.
- Staff never paste the relay control origin or token.
- A stale cloud page already sitting on the old Internet Relay tile redirects
  back to the model-first flow rather than exposing the legacy form.
- **Not sure / another camera** now asks for the closest supported model instead
  of falling through to local transport choices.
- Legacy local synthetic builds keep their existing direct/relay test chooser.

## Evidence and release

- SDK commit: `df96174`.
- Root build and every workspace test passed: clinic 88 + one expected skip,
  cloud API 36, relay 34, desktop 25, plus all other workspaces.
- Required PTP simulator, FTP and multi-room smokes passed; the browser UI gate
  passed.
- Arm64 ZIP SHA-256:
  `91ed819e426c1070bcd836f4f473b08072e43b02d0021ed7c87b48411f4af02f`.
- Arm64 DMG SHA-256:
  `f9e65fdeae4582b8c7577fb47883407a831cbcf21a4cbf11bc661731ddd43a10`.
- Railway deployment `c374dc68-9306-4d54-bd1d-a938398b5345` reports
  `SUCCESS`; the live Ed25519 manifest verifies as v0.19.3 and the CloudFront
  package stream matches the signed ZIP hash.
- The latest direct DMG route returns v0.19.3 with `no-store`.

Synthetic-only remains mandatory. The current relay is plain FTP; no real PHI
until FTPS/TLS, BAA and the production compliance gates are complete.
