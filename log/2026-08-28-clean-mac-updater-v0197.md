# 2026-08-28 — clean-Mac updater v0.19.7

## Field report
- A second Mac safely rejected an in-app update after macOS said the `lipo`
  command required Xcode Command Line Tools.
- A non-Owner account could not reach the installer fallback. Software Update
  is device maintenance and should not depend on clinical role.

## Decision and implementation
- Replace the runtime `lipo -archs` call with a strict direct read of the
  no-follow 64-bit Mach-O executable header. Accept only arm64 or x86_64.
- Show Software Update to Owner, Staff and Review in the installed app. Permit
  all three only when the request carries the private HttpOnly desktop
  capability; retain existing role denials for ordinary browser/LAN requests.
- v0.19.6 cannot self-repair because the broken verifier is in that installed
  app. Use the direct v0.19.7 DMG once on that Mac; subsequent updates use the
  fixed verifier.

## Delivery evidence
- Feature commit: SDK `d416ab8`.
- Code PR: CamLink-SDK 9; Node 20 and 22 CI passed.
- Main merge: SDK `9941b0f`.
- Local gates: root build, full workspaces, PTP simulator, FTP, multi-room and
  browser UI gate all passed.
- Exact package gate: the built native updater verified the real v0.19.7 ZIP
  without invoking `lipo`; ZIP integrity, arm64/version and deep/strict
  code-signature checks passed; DMG checksum verification passed.
- Live Railway release deployment: `1915b82e-f709-4ff7-a1dd-ee301d1432a0`;
  `/healthz` returned `ok` and the Ed25519 latest manifest verified as v0.19.7.
- Immutable CloudFront ZIP: 114082711 bytes, SHA-256
  `e269bca45c0dbcfd440b67c05424d2de5f3e4e841bdcea1f371e0f36d7d71e0f`.
- No-store latest arm64 DMG: 124157235 bytes, SHA-256
  `4593489df9f22190e40dfae569fa049b262ffcae47437b927f25b0df8399efe1`.

## Remaining gate
- The internal build is still ad-hoc signed. Apple Developer ID signing and
  notarization are required before first download can be warning-free and
  reliable without Open Anyway.
- Field-install the v0.19.7 DMG on the affected clean Mac, then prove the next
  signed in-app update there without Command Line Tools.

No PHI, camera password, signing key, presigned URL or provider token was
written to source, logs or the vault.
