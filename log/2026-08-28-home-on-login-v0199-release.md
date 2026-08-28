# 2026-08-28 — v0.19.9 Home-on-login release

## Outcome
- PR 11 feature commit `6d314bc` is merged to SDK `main` as `02c27d8`.
- A new cloud sign-in lands on Home. Shared visits appear under **In progress**
  and open only when chosen. One available camera is automatic; two or more
  require **Which camera?**.
- v0.19.9 also carries the v0.19.8 cloud session-end reconciliation so another
  signed-in Mac closes a stale visit screen after the visit ends elsewhere.

## Release evidence
- Exact source: SDK `origin/main` `02c27d8` and desktop version `0.19.9`.
- Gates: root build, all workspace tests, PTP simulator, FTP, multi-room and
  full browser UI gate passed; PR Node 20 and Node 22 CI passed.
- arm64 ZIP: 114082920 bytes, SHA-256
  `29722a24c606d84084acbb88f73803f27b7cd75f87732e169c089cb31923bba4`.
  It passed archive containment, v0.19.9/arm64, deep/strict code-signature and
  exact `NativeMacUpdater` verification.
- arm64 DMG: 124157413 bytes, SHA-256
  `b2ff8348e3debf4ad4db6a95bd81e327c115b21be57d20d66fe8bfad88bf74e6`;
  `hdiutil verify` passed.
- Railway deployment `6b26cfd3-9af6-49b1-b737-5e677b1fdd47` became healthy.
  The live Ed25519-signed manifest names v0.19.9 and its immutable CloudFront
  package streamed with the exact ZIP size/hash. The no-store latest DMG
  streamed with the exact local size/hash.

## Remaining gates
- Install/update both Macs and field-prove Home-on-login, explicit Open,
  one-camera automatic selection, multi-camera choice and cross-Mac visit end.
- A pre-v0.19.7 Mac still needs one direct-DMG recovery because its installed
  verifier invokes Apple's `lipo` shim. Developer ID signing/notarization
  remains required for a reliable first-download experience without Open
  Anyway.
