# project-status — WHAT IS DONE

Rewritten 2026-08-22 after the 2026-08-21/22 field marathon (see
[[log/2026-08-21-med-photo-field-day]]; July history in earlier logs).
Clinic app **v0.18.14** (2026-08-27, see
[[log/2026-08-27-hub-restart-signin-recovery-v01814]]), branch
`claude/camera-sdk-adapter-pattern-4pj5r8` (repo default).

## 2026-08-27 cloud-authoritative pivot
- Chris replaced the end-user local Capture Hub / **Share this library**
  direction with one cloud clinical library visible to every authorized app
  ([[cloud-authoritative-library]], goal [[2026-08-cloud-clinical-library]]).
- SDK `f2ce0a1` removes the packaged sharing UI/API/IPC and always starts the
  installed app loopback-only. It migrates a legacy `shareOnLan: true`
  preference to false without touching any local capture.
- New `@medphoto/clinical-cloud-domain` foundation (9 adversarial tests):
  organization/location scoping, reviewer read-only, camera→active-visit
  routing, explicit Unassigned queue, upload-id/SHA idempotency, opaque object
  keys, PHI-free closed audit facts, referential integrity, soft deletion.
- This is synthetic foundation only—not a working cloud app and not a HIPAA
  claim. v0.18.14 remains live; no release/AWS resource/BAA/local data changed.
  Full gates passed; see [[log/2026-08-27-cloud-authoritative-library-pivot]].

## 2026-08-27 patient record organization
- ✅ The clinic reference app now presents a patient record rather than only a
  visit start: name, DOB, an optional short photo-workflow note, visit/photo
  timeline, existing Compare, and an in-place Edit action (SDK `154c2b5`).
  Stable patient ids and historic visit folders are preserved on edit; review
  users cannot edit. Consent displays a deliberately honest **Not recorded**
  placeholder until the separate signed-permission data model is built.
- Browser coverage opens a patient, changes DOB/note, leaves/reopens to prove
  persistence, creates a second real FTP visit, and compares two visits. This
  closes the patient-page/Compare UI-gate item in [[2026-08-simplicity-pass]].
  The cloud library will carry the same organization after its current
  PostgreSQL/API/object-access work is complete; this change does not claim
  real-PHI AWS readiness.

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
  visit / Today / Patients zones; one left drawer everywhere; brand =
  Home; no dead ends; non-destructive Change camera; bottom-left status
  chip; Camera setup page (Menu) is the permanent home of every
  camera's sign-in values with rename/remove.
- **Multi-room** ([[2026-09-multi-room]]): camera login = room, named at
  add-time; per-room simultaneous visits; ONE shared patient library;
  room strip; `?room=` pins a device to a room. Real-second-body field
  test still open.
- **Retired same-LAN multicomputer proof** (v0.18.11): one packaged Capture Hub owned
  the cameras and only capture store; a local Owner could share the library on
  stable port 3555 and copy a private-network address. Independently signed-in
  Safari/Chrome Viewers received the same patient library and live SSE events,
  started no adapters and could not change Hub sharing. This was authenticated HTTP
  for synthetic data only; pinned TLS, device enrollment and native discovery
  are still required before patient use.
  v0.18.14 fixed the sharing restart transition: memory-only sessions still
  require the Owner PIN again, but local and remote pages now leave stale
  Settings/library views, show the profile picker, and restore the same library
  after sign-in. This end-user flow was retired by SDK `f2ce0a1`; explicit CLI
  LAN tests remain engineering fixtures only.
- **Camera identity, not dates** (v0.16, goal
  [[2026-09-camera-identity]] — supersedes the earlier-photo DATE gate,
  [[earlier-photo-guard]]): a photo pushed by the visit's camera while
  the visit is live ALWAYS files; EXIF only teaches per-camera clock
  offsets, surfaced as set-your-clock advice on Cameras. First stored
  photo BINDS the body's EXIF serial to the camera entry; a different
  serial (or clearly-wrong model, catalog-checked) warns loudly but
  never blocks a store. New cameras are "waiting for first sign-in"
  (hidden from the picker) until their login connects. A photo
  arriving with NO visit open is buffered (never dropped), stays quiet
  during patient-facing work, and appears only on the camera that received it.
- **Honest camera presence** ([[camera-presence]]): pill green only on
  evidence; amber waiting/disconnected; 5 s drop watcher + plain alert.
- **In-app updates** ([[in-app-updates]]): 6 AM daily + boot checks,
  corner-chip one-click install, self-restart under launchd; survives
  bare launchd PATH and rewritten package-lock. v0.18.13 lets the installed
  desktop shell update before account sign-in through an HttpOnly,
  loopback-only capability; ordinary browsers and LAN viewers remain blocked.
  Safe progress/error state is pollable without exposing patient/session data.
  v0.18.14 is live on the Railway release volume with the signed updater ZIP
  and stable first-install DMG independently streamed and hash-verified.
- **Self-contained Mac app** (`@medphoto/desktop-app`): packaged Electron
  window + clinic runtime, no checkout/Node/browser required. The signed
  updater verifies and atomically installs releases from Railway; v0.18.7
  added a visible startup/recovery window. v0.18.8 fixes first-install ZIPs:
  browser download + Finder/Archive Utility extraction no longer materializes
  AppleDouble `._*` files that invalidate Electron's framework signature.
  v0.18.9 bounds startup page and clinic navigation loads, retries with a fresh
  renderer, recovers a renderer that crashes after launch, and falls back to a
  native macOS error (or exits) instead of bouncing indefinitely in the Dock.
  v0.18.10 adds a verified DMG first-install path with an Applications shortcut,
  aggressively raises the real window above Finder/System Settings, and makes a
  losing second instance exit immediately instead of waiting behind an invisible
  dialog. The DMG is served separately from signed updater history on Railway.
  v0.18.13 adds a fixed, allowlisted **Download latest installer** recovery when
  a Mac rejects automatic verification; Railway resolves that no-store pointer
  to the current immutable DMG while signed updater history remains separate.
- **Camera-first language + onboarding** (v0.11): "room" is banned
  user-facing (gate-enforced); "Which camera?" chips at visit start;
  model-first connect flow with per-model instructions from
  [[camera-catalog]] (10 models, R5 II passive-mode warning).
- **Multi-user** ([[multi-user-model]], goal [[2026-09-logins-and-roles]],
  v0.11–v0.12): three roles (Owner/Staff/Review), PIN profile-picker
  sign-in, People page (first person added = Owner, turns access on),
  role-checked APIs + audit.log, review = read-only home. Solo mode
  sacred: 0 users = no auth anywhere. v0.18.12 immediately enters the
  profile picker after the first Owner is created, and moves identity,
  Owner-only People access and working Sign out into the top-right profile
  menu. Settings no longer contains a session action. Field test with a
  teammate remains open. v0.18.14 makes Hub-restart reauthentication explicit
  and prevents a stale signed-out page from looking like an empty library.
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
- ✅ **Self-contained Mac app + signed in-app updater** shipped for the
  arm64 internal-test channel in **v0.18.7** (SDK commits `d746071`,
  `53ed95f`, `b231454`). Railway serves a closed Ed25519-signed manifest and immutable
  ZIP; the app verifies signature, SHA-256, code signature, bundle ID,
  version and architecture, defers active visits, atomically replaces the
  `/Applications` bundle, health-checks the restart and rolls back on
  failure. Live proof included an intentionally caught failed restart that
  restored v0.18.2, followed by successful v0.18.4 → v0.18.5 → v0.18.6
  self-updates with local relay/test configuration retained. v0.18.7 adds an
  immediate startup window and a persistent recovery screen; exact
  quarantine, clean-launch and forced-child-failure tests passed. Railway now
  stores immutable 0.18.6 + 0.18.7 artifacts on a persistent `/data` volume,
  so later source deploys no longer resend all historical ZIPs. See
  [[log/2026-08-26-signed-mac-updater-live]] and
  [[log/2026-08-26-mac-bootstrap-recovery]].
- Remaining distribution gates are explicit: the other arm64 Mac needs one
  manual v0.18.8 bootstrap, then **Check for updates** works; public
  Gatekeeper installation still needs Developer ID signing/notarization;
  the Intel packaging path builds and verifies, but final x64 is not hosted.
- ✅ **Finder-safe Mac bootstrap** shipped in **v0.18.8** (SDK commit
  `1279efa`). The v0.18.7 ZIP contained 143 AppleDouble `._*` entries. The
  updater's `ditto` extractor masked them, but Finder materialized them inside
  Electron Framework and broke the code signature, causing the Dock-bounce
  failure. Packaging now disables copyfile metadata, rejects AppleDouble and
  unsafe entries, standard-extracts the exact ZIP, and deep/strict verifies
  the extracted app; the publisher and updater enforce the same AppleDouble
  rejection. Railway serves the signed 0.18.8 arm64 package from the durable
  release volume while preserving 0.18.6 and 0.18.7 URLs. Independent exact-
  artifact validation passed. Gatekeeper's first-download warning remains an
  Apple Developer ID/notarization dependency, not an archive defect. See
  [[log/2026-08-26-finder-safe-mac-release]].
- ✅ **Mac startup recovery v0.18.9** shipped (SDK commit `bace836`). The
  desktop shell no longer waits forever on an Electron renderer: initial loads
  have deadlines, the main page gets one fresh-window retry, and post-load
  renderer crash/unresponsive/main-frame failure triggers recovery while the
  local camera service stays alive. If HTML recovery also fails, a native
  versioned error appears; if even native UI is unavailable, the process exits
  instead of bouncing forever. An independent exact-artifact test killed the
  renderer and observed one replacement renderer, one window, and the same
  healthy service. Railway serves the signed arm64 v0.18.9 ZIP with SHA-256
  `5faeefff642a0c1ec6478bd3784b2afb260ec8d4173087373c1673cdfcfe1199`
  while preserving v0.18.6-v0.18.8. Field retry on the affected M1/Tahoe Mac
  remains the final confirmation; Developer ID/notarization remains the
  separate warning-free distribution gate. See
  [[log/2026-08-26-mac-startup-recovery-v0189]].
- ✅ **Finder-first DMG bootstrap v0.18.10** shipped to the internal-test
  download surface (SDK commit `0fa055d`). Railway serves the exact verified
  arm64 DMG at a separate immutable `/v1/bootstrap/` route; signed updater
  history remains on `/v1/packages/`. The DMG contains Med Photo plus an
  Applications shortcut and passes DMG verification, arm64/version checks and
  deep/strict code-sign verification. All workspace tests and the PTP, FTP,
  multi-room, relay and browser UI gates pass. A clean, unquarantined M1/Tahoe
  launch produced one healthy service and one visible window. A realistic
  quarantined repro stopped inside macOS `_dyld_start` before Electron/Med Photo
  code ran, which confirms that source-level recovery cannot make unsigned
  first downloads reliable. Developer ID signing/notarization remains the
  honest public-distribution gate. See
  [[log/2026-08-26-mac-dmg-bootstrap-v01810]].
- ✅ **Same-LAN Hub/browser Viewer v0.18.11** shipped (SDK commit `911d466`).
  An Owner can turn on sharing from the packaged Hub, which restarts on port
  3555 and displays its private-network URL. A second computer signs in through
  Safari/Chrome and sees the same library and live events; it creates no second
  photo store. Full tests/smokes/UI gate and a dynamic two-session proof passed.
  Railway serves the signed arm64 v0.18.11 ZIP with SHA-256
  `a6edecc3989583684e12ff4748eebdf260a9c9e65484033fd7c23dbe93d2a9bd`.
  This route is synthetic-only HTTP until TLS/device enrollment lands. See
  [[log/2026-08-26-same-lan-multicomputer-v01811]].
  First field update: one Mac self-updated; a second returned the safe
  verification refusal. The exact published v0.18.10 updater independently
  downloaded and verified the live v0.18.11 package, so the signed release/key
  is not presently reproduced as bad. Retry/direct-DMG field isolation remains.
- ✅ **Profile-first sign-in v0.18.12** shipped (SDK commit `94a1cb5`). Adding
  the first Owner now reloads directly into the profile picker, so access is
  never left in stale solo mode. The signed-in initials button opens a
  top-right account menu with name, role, Owner-only Manage people and a tested
  Sign out back to the picker; the redundant Settings row is gone. The noisy
  broken-upload Wi-Fi banner and matching camera-card warning were removed,
  while transfer rejection/storage safety remain unchanged. Railway serves the
  signed arm64 updater ZIP with SHA-256
  `254c06f07da04ca45c884d21a087e29ac0905377d284e0ab564f8f45a6e11c78`
  and the direct-download DMG with SHA-256
  `038792ede397eb81a3a22fff2e63bfbefee96bceb689a451afd245148d419462`.
