# project-status — WHAT IS DONE

Rewritten 2026-08-22 after the 2026-08-21/22 field marathon (see
[[log/2026-08-21-med-photo-field-day]]; July history in earlier logs).
Clinic app **v0.15.0** (2026-08-24, see
[[log/2026-08-24-signin-and-never-drop]]), branch
`claude/camera-sdk-adapter-pattern-4pj5r8` (repo default).

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
  gate + learned per-camera clock offsets + held-photo buffer resolved
  in place by the live banner ("It was just taken" adoption teaches
  wrong clocks). Since v0.15.0 held sessions never appear in the
  patient library — capture-time banners are the filing moment.
- **Honest camera presence** ([[camera-presence]]): pill green only on
  evidence; amber waiting/disconnected; 5 s drop watcher + plain alert.
- **In-app updates** ([[in-app-updates]]): 6 AM daily + boot checks,
  corner-chip one-click install, self-restart under launchd; survives
  bare launchd PATH and rewritten package-lock.
- **Mac app** (`npm run install-app -w @medphoto/clinic-app`):
  Med Photo.app + generated icon in Applications/Spotlight, launchd
  server-at-login, Chromium app-mode window (no browser chrome).
- **Camera-first language + onboarding** (v0.11): "room" is banned
  user-facing (gate-enforced); "Which camera?" chips at visit start;
  model-first connect flow with per-model instructions from
  [[camera-catalog]] (10 models, R5 II passive-mode warning).
- **Multi-user** ([[multi-user-model]], goal [[2026-09-logins-and-roles]],
  v0.11–v0.12): three roles (Owner/Staff/Review), PIN profile-picker
  sign-in, People page (first person added = Owner, turns access on),
  role-checked APIs + audit.log, review = read-only home. Solo mode
  sacred: 0 users = no auth anywhere. Field test with a teammate open.
- **Never-drop photo buffer** (v0.12): a capture with no visit open is
  filed as a held "Photo without a visit" session — the app can no
  longer lose a photo it received (Z8 incident, 2026-08-24). Held
  sessions live on disk, resolved via the live banner (v0.15.0 removed
  the Unfiled library section; photos are never deleted).
- **Named, clickable camera pill** (v0.12): pill shows the camera's
  name; clicking opens Camera setup (not for review role). v0.12.1:
  with several cameras it focuses (visit's camera / pin / only camera)
  or aggregates with worst-news-wins ("All N cameras connected" vs one
  troubled camera named / "X of N not connected"); per-camera status
  lights on the Camera setup page; disconnect alerts name the camera.
- Patient records, visits, patient page + compare — Phases A/B,
  shipped July–August.
- **Dashboard home + actionable updates** (v0.13.0): In-progress zone
  lists every live visit with Open/End; Cameras-at-a-glance tiles; the
  update-blocked banner names WHO is in a visit and offers "End X's
  visit & update". Relay-mode camera list gained rename; default camera
  name is "Camera 1" (Room 1 migrated).
- **JPEG steering** (v0.13.1): DECIDED — no RAW preview extraction.
  A RAW arriving shows a model-specific warning with the exact menu
  path to switch that camera to JPEG ([[camera-catalog]] jpegAdvice);
  RAW files still store and download. v0.13.2: starting a visit from
  the patient page asks "Which camera?" exactly like home (and relay
  mode never shows a fake picker).
- **Left-drawer shell** (v0.14.0, [[design-doctrine]]): four
  destinations ≤3 clicks (Home dashboard / Patients / Cameras /
  Settings), collapsible drawer persisted per device, roles trim the
  drawer, update chip at the drawer's bottom.
- **Patient library v2** (v0.15.0, goal [[2026-09-patient-library]]):
  search-first library of PATIENT RECORDS (never folders — system/
  legacy name-only sessions never pose as patients; Unfiled section
  removed, filing happens at capture time via the live banners; files
  stay on disk under captures/). Empty visits are never saved (folder
  discarded only if it holds nothing but manifest.json) and legacy
  0-photo visits are hidden. Full-screen gallery (arrows/keys,
  filename + taken time) + per-photo download + whole-visit zip
  (store-only, zero deps); RAW downloadable without preview; visit
  lists collapse past 6.

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
