# 2026-08-26 — Finder-safe Mac release v0.18.8

## Why this session happened
The arm64 v0.18.7 app opened when extracted with the updater's `ditto` path,
but a normal browser download followed by Finder/Archive Utility extraction
only bounced in the Dock on another Mac. Chris required a first install that
does not depend on Terminal.

## Root cause
The published ZIP contained 143 AppleDouble `._*` entries. Finder materialized
those entries as real files inside Electron Framework. macOS then reported
unsealed framework contents and rejected the app's code signature. The prior
test extractor translated the same entries back into metadata, masking the
real first-install failure.

## Fix shipped
- SDK commit `1279efa` bumps the desktop app to v0.18.8.
- Mac packaging uses a metadata-free ZIP path, preserves symlinks, rejects
  AppleDouble/outside-root/traversal entries, standard-extracts the final ZIP,
  and runs deep/strict code-sign verification on the extracted app.
- The release publisher repeats the AppleDouble, standard-extraction, version,
  architecture, and full code-sign gates before hashing/signing.
- The native updater refuses AppleDouble-containing archives.
- The signed arm64 v0.18.8 package is live on Railway with SHA-256
  `8e1b75a7e45e4599110499f627670f0988c3997f019097e2c8848a7634766a86`.
  Durable storage still serves immutable v0.18.6 and v0.18.7 package URLs.

## Verification
- Root build, typecheck, and all workspace tests green.
- PTP simulator, local FTP, multi-room, relay, and full browser UI gates green.
- Exact v0.18.8 ZIP: no `__MACOSX`, no AppleDouble, standard unzip clean,
  bundle v0.18.8 arm64, deep/strict code signature valid.
- Independent agent ran the exact native updater verifier and a fresh launch;
  both passed.
- Live Railway manifest signature verified against the embedded Ed25519 public
  key, and a full live package stream matched the signed SHA-256.

## What is still external
The internal build remains ad-hoc signed. macOS quarantine therefore still
requires one Control-click Open / Open Anyway approval on first install. A
warning-free double-click install needs Apple Developer Program access,
Developer ID Application signing, and Apple notarization/stapling. No archive
or Railway change can replace that Apple trust chain.

## Other-Mac follow-up
The affected machine is an Apple M1 with 8 GB on macOS Tahoe, so the published
arm64 architecture is correct. v0.18.8 still bounced after Open Anyway, before
the app could show its startup/recovery page. The build Mac has zero valid
code-signing identities. This field result elevates Developer ID signing and
notarization from a public-distribution polish item to the active first-install
blocker; do not spend another cycle on Intel builds or Terminal quarantine
workarounds for this M1.

## Data safety
The installed app was moved to Trash recoverably. The application data under
Application Support was deliberately preserved. No captures or patient data
entered logs, commits, the release package name, Railway metadata, or this
vault note.
