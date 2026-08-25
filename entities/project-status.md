# project-status — WHAT IS DONE

Rewritten 2026-08-22 after the 2026-08-21/22 field marathon (see
[[log/2026-08-21-med-photo-field-day]]; July history in earlier logs).
Clinic app **v0.18.0** (2026-08-25, see
[[log/2026-08-25-camera-transfer-and-recoverable-delete]]), branch
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
  Since v0.16: PER-CAMERA relay sign-ins (one login per camera on the
  one listener, synced idempotently from the app; files route by the
  login that sent them; per-login presence incl. the primary's own
  row — never the any-camera aggregate). Old relays/apps keep working.

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
- **Camera identity, not dates** (v0.16, goal
  [[2026-09-camera-identity]] — supersedes the earlier-photo DATE gate,
  [[earlier-photo-guard]]): a photo pushed by the visit's camera while
  the visit is live ALWAYS files; EXIF only teaches per-camera clock
  offsets, surfaced as set-your-clock advice on Cameras. First stored
  photo BINDS the body's EXIF serial to the camera entry; a different
  serial (or clearly-wrong model, catalog-checked) warns loudly but
  never blocks a store. New cameras are "waiting for first sign-in"
  (hidden from the picker) until their login connects. A photo
  arriving with NO visit open is buffered (never dropped) AND now
  raises a banner — mid-visit it offers one-click adoption (v0.16.2).
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
- Multi-room second-body test; Railway project token deletion (Chris —
  token was pasted in chat, treat as burned). R6 III wrong clock no
  longer blocks anything (v0.16 identity-over-dates) — Cameras page
  advises setting it.
- Camera-identity field pass (Chris): R6 III on its own relay sign-in
  files into its own visit; ending lands on the patient record.

## 2026-08-25 addendum
- ✅ **Recoverable live photo removal** shipped in Med Photo **v0.18.0**
  (SDK commit `4d6194d`): every completed live tile has a touch-sized trash
  control, the full-screen viewer has the same action, removal moves the
  photo and RAW preview into local `.trash/`, and a 10-second batch Undo
  restores bytes plus manifest state. Deleted manifest tombstones survive
  later captures/restarts; review-only users cannot change photos.
- Field A/B on the same relay: a Nikon Z8 delivered a three-JPEG backlog
  slowly and produced one refused/truncated attempt; a Canon R6 Mark II
  then delivered 17 JPEGs quickly with zero failures. Relay-to-Mac pulls
  were immediate. Current verdict: the bottleneck is the Z8-to-relay
  compatibility path, not the relay in general. See
  [[log/2026-08-25-camera-transfer-and-recoverable-delete]].
- **Mac release foundation** exists but is not a production updater:
  signed non-PHI manifest verification (`33b2751`), a filesystem-backed
  non-PHI release service (`6092011`, Railway preparation `11beff8`), and
  operator signing/notarization guidance in SDK PR #5. The separate Railway
  project was not verified or deployed in that session. A self-contained
  app/package builder, manifest signer + embedded production public key,
  updater integration, and controlled artifact upload remain open. See
  [[log/2026-08-25-mac-release-runbook]].
- ✅ **Capture Hub LAN foundation**: the clinic app now binds only to
  localhost by default; explicit `--lan` requires a local user/PIN and opens
  the Hub to office workstations. Signed-out state/events disclose no PHI,
  PINs use scrypt with legacy migration, rapid guesses lock out, and request
  bodies are bounded. Independent attack testing and all camera/UI gates
  passed. This is **not approved for real-patient LAN use yet**: TLS/device
  enrolment and idle auto-lock remain required. See
  [[log/2026-08-25-capture-hub-foundation]].
