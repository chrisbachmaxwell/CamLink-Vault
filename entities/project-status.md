# project-status — WHAT IS DONE

Rewritten 2026-08-22 after the 2026-08-21/22 field marathon (see
[[log/2026-08-21-med-photo-field-day]]; July history in earlier logs).
Clinic app **v0.9.2**, branch `claude/camera-sdk-adapter-pattern-4pj5r8`
(repo default).

## Product identity
- Renamed **CamLink → Med Photo** repo-wide 2026-08-21 (packages
  `@medphoto/*`; config migrates `camlink-clinic.json` → `med-photo.json`
  losslessly; GitHub repo names still say CamLink — rename pending on
  Chris's dashboard).

## Transports (all behind [[adapter-pattern]], all cert-suite green)
- **PTP/IP (EOS Utility mode)** — field-proven on R10 and R6 Mark III
  (July milestones M0–M5 + P1–P3+P5 all done; see July status in git
  history of this page).
- **FTP push** ([[ftp-push-transfer]]) — embedded zero-dep FTP server;
  field-proven with R6 III on LAN. Multi-login (one per room), hot
  add/remove without restart, per-login presence, conversation tracer.
- **Cloud Relay** ([[three-tier-connectivity]], [[med-photo-relay]]) —
  live on Railway, single-port FTP demux, pipe-not-store, presence
  headers, FTP tracer. TEST PHOTOS ONLY (HIPAA gate:
  [[hipaa-local-first]]). Built-in provisioning: the app ships knowing
  its relay — zero typing, doctrine-enforced by the browser gate.

## Clinic app (the product surface)
- **Home** (screen map + flow rules in [[design-doctrine]]): Start a
  visit / Today / Patients zones; one header menu everywhere; brand =
  Home; no dead ends; non-destructive Change camera; bottom-left status
  chip; Camera setup page (Menu) is the permanent home of every
  camera's sign-in values with rename/remove.
- **Multi-room** ([[2026-09-multi-room]]): camera login = room, named at
  add-time; per-room simultaneous visits; ONE shared patient library;
  room strip; `?room=` pins a device to a room. Real-second-body field
  test still open.
- **Earlier-photo guard** ([[earlier-photo-guard]]): EXIF capture-time
  gate + learned per-camera clock offsets + held-photo buffer surfaced
  in Unfiled + one-click adoption that teaches wrong clocks.
- **Honest camera presence** ([[camera-presence]]): pill green only on
  evidence; amber waiting/disconnected; 5 s drop watcher + plain alert.
- **In-app updates** ([[in-app-updates]]): 6 AM daily + boot checks,
  corner-chip one-click install, self-restart under launchd; survives
  bare launchd PATH and rewritten package-lock.
- **Mac app** (`npm run install-app -w @medphoto/clinic-app`):
  Med Photo.app + generated icon in Applications/Spotlight, launchd
  server-at-login, Chromium app-mode window (no browser chrome).
- Patient records, visits, patient page + compare, unfiled filing —
  Phases A/B, shipped July–August.

## Verification gates (ALL green before any push)
build · npm test (10 workspaces) · smoke ptp-simulator · smoke ftp ·
smoke multi-room · ui-gate (headless Chromium: click-path doctrine,
two-room drive, turnover, camera-setup page, zero-typing relay, honest
presence pill).

## Open field items
- **Canon R5 Mark II**: logs in to relay, transfer fails — ACTIVE, FTP
  tracer deployed, passive-mode prime suspect
  ([[canon-eos-r5-mark-ii]], goal [[2026-08-r5ii-ftp-dialect]]).
- Multi-room second-body test; R6 III clock set (hours wrong — see
  [[earlier-photo-guard]]); Railway project token deletion (Chris —
  token was pasted in chat, treat as burned).
