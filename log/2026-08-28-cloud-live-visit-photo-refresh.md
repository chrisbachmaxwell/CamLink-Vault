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
- Code PR: `chrisbachmaxwell/CamLink-SDK#8`, open and not merged at this log
  checkpoint.
- Local gates on fresh `origin/main`: root build and all workspace tests
  passed; PTP simulator, FTP and multi-room smokes passed; the browser UI gate
  passed.
- GitHub Actions: Node 20 and Node 22 passed on code PR 8.
- `main` merge SHA: not merged.
- Release/package publication: not performed. Version 0.19.6 is source intent
  only until integration and release evidence exist.
- Deployment/live app proof: not performed. The current live release remains
  v0.19.5.
