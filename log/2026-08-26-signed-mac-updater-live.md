# 2026-08-26 — signed Mac updater live

## Goal

Make **Check for updates** work in the self-contained Med Photo app copied to
another Mac. This release boundary carries application bytes and closed
non-PHI metadata only; it never sends captures, clinic records, camera
credentials or application logs.

## Shipped

- SDK `d746071` — packaged clinic-to-Electron IPC, native updater, offline
  Ed25519 publisher, embedded public key, read-only Railway release service,
  strict manifests/artifacts and operator runbook.
- SDK `53ed95f` — live-restart fix, v0.18.6, smaller English-only internal Mac
  artifact, temporary-package cleanup and correct immutable HEAD responses.
- Railway arm64 internal-test channel is healthy and serves signed v0.18.6.
- The private signing key stays owner-only outside the repo and Railway; only
  its public half is compiled into the app.

The updater fails closed on unsigned/tampered/wrong-platform/wrong-version
packages. It verifies manifest signature, SHA-256, macOS code signature,
bundle identifier, Info.plist version and exact executable architecture. An
active visit defers download/install. Promotion uses same-volume atomic
renames under `/Applications`, keeps a backup, launches through a detached
helper, waits for a private nonce health proof and restores the backup on any
failure.

## Mistake caught by the live proof

The first real v0.18.2 → v0.18.3 attempt installed nothing and correctly
rolled back. The helper itself ran with `ELECTRON_RUN_AS_NODE=1` and inherited
that switch into the GUI app, so Electron exited before writing the health
proof. The helper now removes that variable for both updated-app and
rollback-app launches. An adversarial regression test plus an independent
real child-process check cover it.

After the fix, live v0.18.4 → v0.18.5 and v0.18.5 → v0.18.6 updates both
completed through the app API, restarted healthy, reported up to date, and
retained the existing relay/test configuration. The final installed bundle is
arm64 v0.18.6 with identifier `com.medphoto.desktop`; deep/strict code-sign
verification passes. Failed/stale update-only files were moved to the Mac
Trash (recoverable); photo/config storage was untouched and app backups were
kept.

## Verification

- root build and typecheck green
- every workspace test green (clinic 71 passed / 1 expected skip; desktop
  17; release service/publisher 10)
- PTP simulator, FTP, multi-room and test-relay smokes green
- full browser UI gate green
- the final arm64 v0.18.6 package passed exact archive/code-sign/version/
  architecture inspection; an earlier x64 packaging candidate passed the
  same platform gate, but final x64 v0.18.6 is not produced or hosted
- independent agent streamed the live Railway package, matched its signed
  SHA-256, verified the installed embedded key/signature and confirmed live
  v0.18.6 + `behind: 0` with no active visit

## Operational boundaries / next

- The already-copied older arm64 app on another Mac needs **one manual v0.18.6
  replacement** because its build predates the updater. Every later version
  can use **Check for updates**.
- Current Railway source uploads fit one arm64 release, but preserved multi-
  version history or arm64+x64 together exceeds the upload ceiling. The
  internal channel therefore serves the latest arm64 snapshot only. Move
  immutable artifacts to durable object/release storage before production.
- Ad-hoc code signing is enough for this internal test after the user's manual
  Gatekeeper approval. A normal public first download still requires Apple
  Developer ID signing and notarization.
- This updater does not implement the separate multi-computer shared-data/
  Capture Hub viewer promise.
