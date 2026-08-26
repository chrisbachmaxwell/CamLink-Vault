# 2026-08-26 — Mac startup recovery v0.18.9

## Why this session happened
The Finder-safe v0.18.8 arm64 app still remained in the Dock without a window
on the affected Apple M1, 8 GB, macOS Tahoe Mac after Open Anyway. An earlier
unsigned build had opened on that same machine, so Developer ID signing could
not honestly be treated as the sole explanation.

## Concrete lifecycle gap
The desktop main process awaited the first Electron page and later the local
clinic page without a deadline. It also lacked recovery for a renderer that
crashed, became unresponsive, or failed its main frame. A stalled renderer
could therefore leave a live application process with no useful window: the
same externally visible shape as indefinite Dock bouncing.

## Fix shipped
- SDK commit `bace836` bumps the arm64 desktop app to v0.18.9.
- Startup-page and local-clinic navigations have bounded deadlines.
- The clinic page retries once in a new BrowserWindow.
- Renderer crash, unresponsive, and main-frame load failure after startup
  replace the renderer while keeping the camera service alive.
- If HTML recovery cannot load, the main process shows a native macOS error
  with the app version and states that photos/settings were not changed.
- If macOS cannot create even the native error, the process exits rather than
  remaining as an indefinite Dock-only process.

## Verification
- Root build, typecheck, and every workspace test passed.
- PTP simulator, local FTP, multi-room, relay, and full browser UI gates passed.
- Desktop tests: 20/20, including bounded operations and late rejection safety.
- Final ZIP is arm64 v0.18.9, archive-clean, deep/strict code-sign valid, and
  passed the exact native updater verifier.
- Independent LaunchServices test opened one 1440x948 window and a healthy
  local v0.18.9 service. Killing only its renderer kept the main process and
  service alive, created exactly one replacement renderer, and left exactly
  one visible window.
- The signed live Railway manifest verifies against the embedded Ed25519 key.
  A complete public package download matched SHA-256
  `5faeefff642a0c1ec6478bd3784b2afb260ec8d4173087373c1673cdfcfe1199`.
  Immutable v0.18.6-v0.18.8 package URLs remain available.

## Release operation learned
Railway's edge rejected the 448 MB full immutable snapshot with HTTP 413. The
safe volume workflow succeeded: deploy only the verified v0.18.9 package and
manifests, copy them into `/data/releases`, verify the persisted SHA, then
restore the small read-only service runtime that serves the durable volume.
No historical package was removed or overwritten.

## Remaining field gate
The affected M1/Tahoe Mac must replace v0.18.8 with the live v0.18.9 app and
try Open Anyway once. This release fixes and exposes the concrete silent-
startup failure path, but the exact field cause is not declared closed until
that Mac opens or shows the new native recovery message. Apple Developer ID
signing/notarization remains the separate requirement for a warning-free first
download.

## Data safety
Testing used isolated profiles and synthetic state. The release path contains
no captures. Existing Application Support data was not removed. No patient
data entered logs, commits, release metadata, or the vault.
