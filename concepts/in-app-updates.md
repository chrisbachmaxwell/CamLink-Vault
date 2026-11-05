# In-app updates — signed packaged contract

Chris (2026-08-21/27): downloading Med Photo onto another computer is useful
only if that installed app can keep itself current without Terminal. Update
access is part of the desktop shell, not part of clinical authorization.

## Production-shaped path
- The packaged Electron shell checks the non-PHI Railway release service at
  boot, on the existing daily schedule, and when the corner chip or Settings
  button is clicked.
- Railway serves the closed Ed25519-signed manifest. A separate private,
  versioned S3 release bucket serves the immutable ZIP through read-only
  CloudFront. The current direct bootstrap DMG is served by Railway. The
  signing private key remains offline; only its public key is embedded in
  the app.
- Before staging, the native updater verifies manifest signature, SHA-256,
  platform, semantic version, minimum supported version, archive containment,
  bundle id, app version, architecture and macOS code signature.
- Architecture verification reads the 64-bit Mach-O header directly. It must
  never invoke `lipo` or require Xcode Command Line Tools on a clinic Mac.
- Installation is refused during an active visit. Otherwise it uses sibling
  same-volume atomic renames, launches the candidate, waits for a nonce-bound
  health proof and restores the backup automatically on failure.
- The updater never uses `git pull`, npm or a source checkout in a packaged
  app. Those remain developer-only behavior.

## Authentication separation
The desktop shell gives its loopback child an HttpOnly startup capability.
That allows Check for updates before clinical sign-in while ordinary browsers
and network peers remain blocked. AWS/Cognito login failure, account
revocation, or a clinical API outage must never prevent an app from checking
or installing a signed release. The release service contains no PHI.
Owner, Staff and Review may all maintain the installed desktop app through
this private capability; clinical role permissions do not govern software
maintenance.

## First install and recovery
The direct DMG is a separate bootstrap surface from signed updater history.
It is the recovery door when an old app cannot verify/apply an update. Public,
warning-free first install still requires Apple Developer ID signing and
notarization; the internal synthetic build may require macOS Open Anyway.
Specifically, affected pre-v0.19.7 verifiers (including v0.19.5/v0.19.6)
invoked `lipo`, so a clean Mac may require one manual v0.19.7 DMG install
before the no-developer-tools updater can take over.

Operator procedure and exact gates: repo `docs/RELEASE-PUBLISHING.md`.

## Current published evidence — 2026-11-05
Arm64 **0.20.5** is live through Railway deployment
`f3c1d3be-7d8b-4d63-8e83-df9b44e2e13a` (SUCCESS). Public Ed25519 manifest,
complete immutable ZIP and no-store DMG match the tested package. SDK PR 21
merged as `a78ec71` after all six gates and Node 20/22 CI. The merged source
tree matches the package receipt. Fresh-profile packaged startup is verified.

The installed Mac is **0.20.5**, verified by plist, native UI and exact bytes
of all six reviewed UI modules. Remote activation initially failed; after
Chris opened the update flow, the app restarted at 0.20.5 with the existing
visit still showing 11 photos and the saved R6 III entry intact. The exact
install/guard click sequence was not observed; do not claim guard validation
from this outcome. No agent-ended visit or forced replacement occurred.
Saved-camera review correctly explains that the prior password cannot be
shown again after restart, and offers an explicit new camera password. No
rotation was performed. Physical camera work stays paused. See
[[log/2026-11-05-r6iii-live-setup]].

Previous history: `/Users/chrismaxwell/MedPhoto-Package-Audit/0.20.4-release`.
New history: `/Users/chrismaxwell/MedPhoto-Package-Audit/0.20.5-release`.
These roots contain only `manifests/` and `packages/`. DMG and receipts belong
in `/Users/chrismaxwell/MedPhoto-Clinical-Stage-0.20.5`. The Railway bundle
carries only the current bootstrap DMG; signed ZIP history retains three
previous releases. Only the release service was deployed; no clinical API,
relay, credentials, policies or provider settings changed. (Verify after: 2026-12.)
