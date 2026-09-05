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

## Current published evidence — 2026-09-05
Arm64 v0.20.2 is live: signed latest and immutable CloudFront ZIP agree,
the direct Railway latest DMG returns `Cache-Control: no-store` and its full
bytes match the prepared DMG, and the exact packaged native updater reports
0.20.2 available to a 0.20.1 client in a disposable profile. A fresh-profile
launch of the exact packaged app shows sign-in with its update control and
hidden clinical navigation. These checks do not install the update. Chris's
installed bundle is read-only verified as 0.20.0; physical two-Mac proof remains
open. See [[log/2026-09-05-active-visit-recovery]]. (verify after: 2026-10)

For the next publisher run, use
`/Users/chrismaxwell/MedPhoto-Package-Audit/0.20.2-release` as prior history.
It contains only `manifests/` and `packages/`, retaining 0.20.1/0.20.0/0.19.9.
Bootstrap DMG and receipts live separately in
`/Users/chrismaxwell/MedPhoto-Clinical-Stage-0.20.2`; adding them inside the
history root makes the strict publisher reject it. The incomplete earlier
`0.20.1-verified` directories are not the published bundle and must not be used.
