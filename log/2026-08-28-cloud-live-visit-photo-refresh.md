# Cloud live-visit photo refresh — 2026-08-28

## Field report

The shared-library visit view showed five stored photos while the cloud had
already accepted seven. Leaving the visit and opening it again immediately
showed all seven, proving that storage and the authoritative cloud projection
were current while the visible visit UI was stale.

No patient name, photo, credential, provider payload or other PHI is recorded
here.

## Cause and correction

- Direct-to-cloud camera uploads do not pass through the local Hub, so they do
  not produce its local `session` SSE event.
- The browser already refreshed cloud history and camera/visit projections
  every three seconds, but `refreshRooms()` applied the fresh visit only to
  Home/dashboard state. It did not re-render a visit already on screen.
- While the current view is a live visit, `refreshRooms()` now resolves that
  visit by its camera id and feeds its newest active summary to
  `renderSession()`. Existing patient/compare/add-camera no-auto-navigation
  rules remain unchanged.
- A focused regression assertion protects the cloud refresh-to-visible-visit
  path. Desktop package version is advanced to 0.19.6 in the feature PR.

## Evidence boundary

- Feature commit: `21eb8cd` on `codex/live-visit-auto-refresh`.
- Code PR: `chrisbachmaxwell/CamLink-SDK#8`, merged to `main` as `de0a2d9`.
- Local gates on fresh `origin/main`: root build and all workspace tests
  passed; PTP simulator, FTP and multi-room smokes passed; the browser UI gate
  passed.
- GitHub Actions: Node 20 and Node 22 passed on code PR 8.
- Exact merged-main integration build and all workspace tests passed. The
  arm64 package passed ZIP integrity, DMG verification, version 0.19.6,
  arm64 architecture and deep/strict code-signature validation.
- The Railway latest manifest is v0.19.6 and its Ed25519 signature verifies
  against the app's release public key. The live immutable CloudFront ZIP is
  114082024 bytes with SHA-256
  `1739a7b8c7ca4e775a89955d6f997443dd15f5711784cf4e0801a37df97aec98`.
- The live direct-download DMG is 124156200 bytes with SHA-256
  `05ba39453ba7df0405536cbee62433e1a11c64962585418df496762f2399fbe1`.
- Deployment proof is complete. Field proof that an already-open visit updates
  after the physical camera sends a new photo remains open.
