# 2026-08-27 — signed-out update recovery v0.18.13

## Field report

Two arm64 Macs exposed separate update failures after account setup:

- the Mac with the first Owner could see **Check for updates** on the profile
  picker, but the server returned `Sign in first`;
- another Mac downloaded the update, then reported that it could not be
  verified and was not installed.

The live v0.18.12 manifest signature, package hash and exact native verifier all
passed locally. That makes the second failure Mac-specific rather than evidence
of a corrupt release on Railway. The working app remained unchanged.

## Decision and implementation

- Update permission before sign-in belongs to the installed desktop shell, not
  to an unauthenticated HTTP route. The Electron host now installs a private
  HttpOnly cookie scoped to its random startup token and `127.0.0.1`. Only a
  loopback packaged update request carrying that capability bypasses the profile
  session gate. A normal local browser and every LAN Viewer still receive 401.
- Signed-out `/api/state` now includes only closed, non-PHI update progress and
  safe messages. It never includes a patient, visit, camera credential or user
  name. A signed-out active-visit conflict is generic for the same reason.
- If automatic verification fails, the app explains that the current copy was
  not changed and offers **Download latest installer**. Electron opens only the
  exact allowlisted Railway recovery URL; arbitrary external navigation remains
  denied.
- Railway now serves `/v1/bootstrap/darwin-arm64/latest.dmg` with `no-store`.
  It resolves the current platform/version manifest to an immutable versioned
  DMG in the separate bootstrap store. Signed updater packages remain on their
  existing immutable route.

## Release proof

- SDK commit `ad0c474` pushed to
  `claude/camera-sdk-adapter-pattern-4pj5r8`.
- v0.18.13 arm64 ZIP SHA-256:
  `a55336fc35ef6f203714405725ec6d46c8ecae3914f8abf972519e963ec5c503`.
- v0.18.13 arm64 DMG SHA-256:
  `16ba21d79289b0f1b9975562d501b32fe45cbdd5c9286d74b30aa6f813b3da94`.
- The exact v0.18.12 -> v0.18.13 native verifier passed locally.
- Full build, typecheck, all workspace tests, PTP simulator smoke, FTP smoke,
  multi-room smoke and browser UI gate passed. Clinic tests: 78 passed with one
  expected reconnect skip; desktop tests: 23 passed; release service tests: 15
  passed.
- Railway deployment `8cdd4813-01f6-4ea4-ab7b-0dc6e8f93bf7` is SUCCESS.
  Live health is 200, the signed latest manifest verifies as v0.18.13, streamed
  ZIP/DMG hashes match the values above, immutable URLs are 200, and the stable
  installer pointer is 200 with `cache-control: no-store`.

No patient data, app library, camera configuration or private signing material
was written to the repository, Railway release metadata or this vault note.
