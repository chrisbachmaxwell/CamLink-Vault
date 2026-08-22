# Camera presence — green means evidence

Field lesson 2026-08-21: the pill showed green "connected" with the
camera OFF. For push transports (FTP / relay), "connected" only meant
OUR listener was up. Doctrine since: **the UI never claims the camera is
on without evidence.**

## Evidence chain (shipped v0.9.0–v0.9.2)
- `CameraFtpServer.stats.perUser[login]`: live authed control-connection
  count (cameras hold one open between shots, NOOP keepalives), plus
  lastSeenAt (any authed command) and lastUploadAt.
- Relay: `/v1/health` carries `camera:{connected,lastSeenAt}`; every
  `/v1/next` answer carries `X-Camera-Connected` / `X-Camera-Last-Seen`
  headers; `CloudRelayAdapter` records them into its stats.
- Clinic `/api/state`: `cameraPresence` per room + top-level.

## Pill states (per-room truth; also feeds room chips, camera-setup page,
## home note)
- GREEN: live link, or activity <60 s ("Camera active 40s ago").
- AMBER wait: never seen → "Waiting for the camera — take one photo to
  check in" (many bodies only dial when they SEND — field lesson
  2026-08-22); gone quiet → "Camera off? Last seen 12 minutes ago".
- AMBER dropped: a 5 s server watcher catches live→dead transitions
  (suppressing the normal post-transfer hang-up via lastUploadAt <15 s),
  broadcasts `cameraPresence` → pill flips immediately + one plain
  banner: "The camera disconnected — check that it is on and connected
  to Wi-Fi." Reconnect clears it.
- RED stays "our own listener/config is down".

Relay caveat: drop detection lags up to ~30 s (long-poll reporting
rhythm); local FTP ≈5 s.

Ratchet: ui-gate FAILS if the pill is green before first camera contact,
and requires green on a real push.
