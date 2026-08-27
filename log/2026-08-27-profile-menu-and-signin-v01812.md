# 2026-08-27 — profile menu and first-Owner sign-in (v0.18.12)

## Field request

Chris created the first Owner but Med Photo stayed open in its stale solo-mode
session. The Settings page also displayed a Sign out label whose hidden button
did not provide a usable path. He asked for the familiar top-right profile
pattern and asked to remove the repeated broken-upload/Wi-Fi warning.

## Decision and implementation

- Creating the first person still makes that person Owner, but the successful
  request now immediately reloads the app into the profile picker. No one is
  silently signed in, and the operator does not need to discover a manual
  refresh or Settings workaround.
- The signed-in initials chip is now a 44 px account button. Its anchored menu
  shows the current name and friendly role label, gives Owners a Manage people
  shortcut, and signs out back to the profile picker. Escape and outside click
  close it; Review cannot see the Owner shortcut.
- Removed the Sign out row from Settings. Settings remains for app/device
  configuration; the current person's session lives with their identity.
- Removed both user-facing forms of the truncated-upload warning: the global
  SSE banner and the recent-failure caption on Camera setup. Transfer rejection,
  retry behavior and internal presence counts remain intact; only the noisy UI
  was removed.
- Corrected the project record: no-visit photos are retained quietly and shown
  only with the receiving camera, rather than interrupting patient-facing work.

## Verification

All required gates passed on 2026-08-27:

- monorepo `npm run build` and `npm run typecheck`
- every workspace test (`npm test`; clinic 77 passed, 1 expected skip;
  desktop 22 passed)
- PTP simulator smoke, FTP smoke and two-camera/multi-room smoke
- full headless Chromium UI gate, including automatic first-Owner transition,
  wrong/right PINs, Owner account menu, Manage people shortcut, working sign
  out, Review role trimming, Escape close and server-side Review 403
- arm64 ZIP: clean archive, deep/strict code-sign verification, version
  0.18.12 and exact arm64 architecture
- DMG integrity verification

## Release evidence

- SDK commit: `94a1cb5` on
  `claude/camera-sdk-adapter-pattern-4pj5r8` (pushed)
- signed manifest version/platform: `0.18.12` / `darwin-arm64`
- ZIP SHA-256:
  `254c06f07da04ca45c884d21a087e29ac0905377d284e0ab564f8f45a6e11c78`
- DMG SHA-256:
  `038792ede397eb81a3a22fff2e63bfbefee96bceb689a451afd245148d419462`
- Railway release transfer: `d4d02ae4-2847-447e-aefd-c08d5354cada`
- Railway DMG transfer: `f38602b0-dc05-46eb-a854-41d766987ef6`
- Railway read-only runtime restore: `f9952552-4076-40d8-ac2e-8556753aae76`
- live manifest signature verified against the public key embedded in the app
- live streamed ZIP and DMG hashes matched the local artifacts byte-for-byte
- actual native updater check from v0.18.11 returned available v0.18.12

This remains the synthetic/internal-test channel. The same-LAN viewer is HTTP
until pinned TLS/device enrollment, and warning-free first-download installation
still requires Apple Developer ID signing/notarization.
