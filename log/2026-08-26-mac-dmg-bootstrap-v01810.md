# 2026-08-26 — Finder-first DMG bootstrap v0.18.10

## Why this session happened
The affected Apple M1, 8 GB, macOS Tahoe Mac confirmed v0.18.9 in Finder,
completed both Open Anyway prompts, and still showed only a bouncing Dock icon.
Chris explicitly rejected Terminal-based recovery; first install must explain
itself and work through Finder.

## What changed
- SDK commit `0fa055d` bumps the desktop app to v0.18.10.
- `package:mac` now emits and verifies a compressed DMG containing Med Photo
  and an Applications shortcut, while retaining the ZIP as the signed in-app
  updater artifact.
- The desktop shell repeatedly raises the real window above Finder/System
  Settings during launch. A losing second instance exits immediately instead
  of waiting on an unparented native dialog that can be invisible.
- The release service gained a strict, read-only `/v1/bootstrap/` DMG route
  backed by `/data/bootstrap`. This surface is intentionally separate from
  Ed25519-signed `/v1/packages/` updater history.

## Live bootstrap evidence
- Railway serves
  `Med-Photo-0.18.10-darwin-arm64.dmg` with immutable caching and
  `application/x-apple-diskimage`.
- Complete live download SHA-256:
  `301bc070af2ea784268bc91afc1bc5d689c9a4bcdd4cb796c244efd66b5d45d7`.
- The existing signed updater channel remains at v0.18.9 and its historical
  packages were not replaced or removed.

## Verification
- Root build, typecheck, and every workspace test passed.
- PTP simulator, local FTP, multi-room, relay and complete browser UI gates
  passed.
- Desktop tests: 20/20. Release-service tests: 13/13.
- Exact v0.18.10 ZIP and DMG are arm64, version-correct, archive-clean and pass
  deep/strict code-sign verification; the ZIP passes the actual native updater
  verifier.
- A clean unquarantined M1/Tahoe launch produced a healthy v0.18.10 service and
  exactly one visible 1440 x 948 Med Photo window. A second launch remained
  bounded to one primary instance.

## Critical boundary learned
A realistic quarantined test entered App Translocation and stayed in macOS
`_dyld_start` with a 96 KB main process, zero children, no Electron/JavaScript,
no clinic server and no window. The same fake-quarantined Applications copy was
rejected by `spctl`. Med Photo's main code, focus recovery and error UI are not
reachable in that state. Automation cannot perfectly reproduce the human Open
Anyway exception, but this evidence means another source-level Electron tweak
cannot honestly promise reliable unsigned first install.

## Decision
The DMG is the best internal Finder-only bootstrap and should be field-tested,
but Developer ID signing and notarization are the required reliable public-
download fix. The earlier unsigned build opening on the same Mac is preserved
as a true observation; it does not override the newly reproduced pre-code
Gatekeeper boundary.

## Data safety
All tests used synthetic isolated profiles. The bootstrap and release service
contain no captures. No patient data entered logs, commits, Railway release
metadata or the vault.
