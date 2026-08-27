# Med Photo v0.18.14 — Hub restart sign-in recovery

Date: 2026-08-27
Code commits: `6458706` (product fix), `7189df9` (bounded internal release snapshots)

## Field failure

Chris added the first Owner, signed in, and turned on **Share this library**.
The desktop shell correctly persisted LAN sharing and restarted the local Hub,
but Hub sessions are deliberately memory-only. The restart invalidated the old
session while an already-open page stayed on Settings. Owner-only controls and
the patient library were hidden, making the intact library look deleted.

Read-only field verification established that the app was still using the same
desktop capture root, the Owner record remained present, and `shareOnLan` was
true. No patient names, photo paths, or other PHI were read or recorded.

## Decision and fix

- A sharing-mode restart continues to require reauthentication. The app must
  make that security boundary explicit instead of trying to preserve an
  in-memory PIN session across a Hub restart.
- Any non-login API `401` now immediately clears stale role UI and routes the
  page to the profile picker with: **Med Photo restarted. Sign in again to
  continue.**
- The sharing action itself enters that sign-in state before the shell restart,
  explaining that the Owner should sign in again to see the library and the
  other-computer address.
- A remote Viewer whose EventSource reconnects after the Hub restart confirms
  the safe signed-out state and takes the same profile-picker path. It can no
  longer remain on an empty-looking stale library.
- The browser gate now destroys an Owner session while the patient library is
  open, proves the picker appears and the stale library is hidden, signs in
  again, and proves the library returns.
- Clinic smokes now allocate an isolated loopback port so a running installed
  app on 3555 can never be mistaken for the disposable smoke server.

## Release evidence

- Desktop internal-test version: **0.18.14 arm64**.
- Signed Railway manifest: live and Ed25519-verified.
- Updater ZIP SHA-256:
  `e44fb9bd96008efae6fb27d278c087794fe1be6ac544f53f108aae714f7dbfb8`.
- First-install DMG SHA-256:
  `8bd86d152653f558a1c58d5e2515a1c4980b8d20198714e754d2924da75aae30`.
- Both public Railway downloads were streamed end-to-end and matched those
  hashes. The stable latest-DMG route resolves to v0.18.14.
- Railway's source-upload proxy rejected accumulated package bundles. Release
  files were instead staged on the existing non-PHI persistent release volume,
  hash-verified there, and promoted by replacing `latest.json` only after the
  immutable versioned package and manifest were in place. Temporary private
  transfer drafts were deleted.

## Gates

- root build: green
- all workspace tests: green
- PTP simulator smoke: green
- FTP smoke: green
- multi-room/shared-library smoke: green
- browser UI gate: green, including expired-session -> sign-in -> library
  restored
- exact Mac ZIP/DMG archive, architecture, bundle version and deep/strict
  code-sign checks: green

## Field next step

On the Hub Mac, update to v0.18.14, sign in as Owner, and keep sharing on. The
app should explicitly ask for the Owner PIN after the restart; after sign-in,
the same library and the other-computer address must return. On the second Mac,
open that address and sign in with the Review profile to prove live synthetic
library updates.
