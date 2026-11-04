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

## Historical cloud photo proof (v0.19.4–v0.20.3)
Issuing or rotating a cloud camera profile proves only that setup values exist;
it does not prove the camera accepted them. The cloud API persists
`lastUploadAt` and an opaque `lastUploadPhotoId` only when the upload digest and
metadata completion succeed. The guided setup records a baseline, asks for one
test photo, and accepts only newer evidence for the exact camera. It then shows
the received image and changes the label to **Camera verified**. Existing
profiles without evidence remain waiting until their next upload.

## Current cloud connection (0.20.4 released, 2026-11-04)
Chris clarified that setup should yield a dependable Connected / Not connected
indicator and automatic arrival when shooting, without repeated test steps.
The old cloud projection hard-coded `cameraConnected`/`live` false while some
screens colored historical upload verification green. SDK PR 20 (`d050ea6`)
separates these facts. The API reads existing authenticated relay `/v1/health`
and maps only each scoped active camera profile's exact login. No account-wide
aggregate can prove another camera is connected. Calls have a two-second
body-inclusive deadline, 256 KiB limit and two-second success cache. Failures
keep the camera list available with unknown connection status.

Home, Cameras and camera checks show current connection plus last completed
photo separately. Green requires live sign-in evidence checked within 12
seconds; requests failing or aging out show Status unavailable. Starting a
visit remains possible while a camera is asleep/disconnected. New-photo proof
still requires a newer completed upload for that exact camera and says Photo
received; disconnection does not erase photo history. Saved camera checks open
directly without changing credentials. A live FTP connection does not prove
that automatic transfer is enabled or that the next photo completed.

Required local gates pass, including multi-camera isolation, status expiry,
outage/recovery and disconnect after receipt. The code-only backend and signed desktop release are deployed and verified;
installation and physical R6 Mark II power-cycle/automatic-transfer proof remain open.
See [[log/2026-11-04-live-camera-status]]. (Verify after: 2026-12.)
