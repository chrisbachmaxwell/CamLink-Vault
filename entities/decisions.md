# Decisions log

Dated, newest first. One line of context each; details live in linked pages.

- 2026-08-24 — **The patient library lists PATIENT RECORDS, never
  folders** (Chris: orphaned photos in the list "was a mistake").
  System/buffer sessions and legacy name-only folders never pose as
  patients; verification happens AT CAPTURE TIME via the live banners
  — the photographer confirms photos land on the right patient while
  shooting. Unfiled section removed from the library. Photos on disk
  are still never deleted. [[2026-09-patient-library]]
- 2026-08-24 — **A visit without photos is not a visit.** Ending a
  0-photo visit saves nothing (folder discarded only after verifying
  it holds nothing but its manifest); 0-photo visits are hidden from
  all listings. [[2026-09-patient-library]]
- 2026-08-24 — **Photos are for looking at and taking with you**:
  full-screen gallery (arrows, filename, taken time) + per-photo
  download + whole-visit zip, RAW included. [[2026-09-patient-library]]
- 2026-08-24 — **Left drawer shell + dashboard home** (Chris, with
  reference screenshots — reverses 2026-08-21 "no left sidebar", whose
  own revisit condition — real destinations — is now met). FOUR
  destinations, ≤3 clicks deep: Home (dashboard: Start a visit, In
  progress, Cameras at a glance, Today), Patients (search → patient →
  compare; unfiled lives here), Cameras, Settings (bottom of drawer:
  People, updates, connection, IT guide, sign out; company/multi-office
  later). Update chip sits at the drawer's bottom. Roles trim the
  drawer. [[design-doctrine]]
- 2026-08-24 — **A photo that reaches us can never vanish.** A capture
  arriving with no visit open is filed into a held "Photo without a
  visit (<camera>)" session in Unfiled — never dropped. Born from the
  Nikon Z8 field incident: the relay trace proved the upload completed
  (`upload complete 4J6A6738.JPG`), and the app silently discarded it.
- 2026-08-24 — **The pill is a door, not a lamp.** The camera pill
  shows the camera's NAME and clicking it opens Camera setup
  (troubleshoot / rename / connect). Hidden action for review role.
- 2026-08-24 — **One pill, many cameras: focus when obvious, else
  worst news wins** (Chris: one name "won't make sense"). Pill shows
  the visit's camera / the pin / the only camera; a multi-camera home
  aggregates — "All N cameras connected" only when every camera earned
  green; one struggling camera takes the pill BY NAME; 2+ become
  "X of N not connected". Problems are never averaged into green.
  Camera setup page carries a per-camera status light (full picture);
  gate-enforced (ui-gate asserts the plural).
- 2026-08-22 — **"Room" is dead as a word.** Cameras are just NAMED
  cameras; starting a visit = choose the camera (chips in Start a visit;
  device remembers). Internal ids/APIs keep `room` for wire compat.
- 2026-08-22 — **Multi-user confirmed by Chris**: three roles (Owner /
  Staff / Review), PIN sign-in via profile picker. NEW: multi-OFFICE
  direction — a company has locations; a super user sees all, local
  users only what they're given. v1 stores per-user `locations` but
  enforces nothing; cross-location sync waits for the BAA cloud.

- 2026-08-22 — **A held photo is resolved by a human, in place**: the banner
  offers "It was just taken — add it to this visit"; adoption files it AND
  teaches the camera's clock offset (the wrong-clock bootstrap).
  [[earlier-photo-guard]]
- 2026-08-22 — **Green means evidence.** For push transports the pill is
  green only on a live camera link or activity <60 s; amber waiting /
  disconnected otherwise; 5 s drop watcher + alert. [[camera-presence]]
- 2026-08-22 — **Update checks are automatic (6 AM daily + boot); installs
  stay one human click** (auto-install offered, not yet chosen). The
  bottom-left status chip is the whole update UI. [[in-app-updates]]
- 2026-08-21 — **The app ships knowing its own relay** (built-in
  provisioning; env/saved override). Nobody ever pastes a relay URL or
  token; the browser gate FAILS if the form appears when a relay is known.
- 2026-08-21 — **No left sidebar** (Chris floated it): a handful of screens
  on front-desk machines and iPads — one top-right menu + corner status
  chip. Revisit when real new destinations exist. [[design-doctrine]]
- 2026-08-21 — **Flow rules are doctrine**: no screen without a path Home;
  nothing destructive on first click; never auto-navigate away from the
  user; no floating layer over controls; a banner offers the next step,
  never just states a wall. Each anchored to a same-day field lesson.
  [[design-doctrine]]
- 2026-08-21 — **One FTP port, hot-add logins** (Chris asked about multiple
  listeners): the login identifies the camera; auth checks a LIVE account
  list, so cameras add/remove with zero interruption. [[ftp-push-transfer]]
- 2026-08-21 — **Camera login = room; one shared patient library.** Adding
  a camera = naming it; rooms decide which visit a photo joins, never who
  can see a patient. [[2026-09-multi-room]]
- 2026-08-21 — **Three-tier connectivity**: local LAN (default) · Med Photo
  Box (travel router) · Cloud Relay (Railway, test photos only until
  FTPS+BAA). Frame.io ruled out (no BAA). [[three-tier-connectivity]]
- 2026-08-21 — **Renamed CamLink → Med Photo** everywhere in-product
  ("I don't want to see camlink anymore"); repo renames pending.
- 2026-08-21 — **Mac app via installer + launchd + Chromium app-mode**;
  true Electron/Tauri packaging deferred until the first outside clinic
  onboards.
- 2026-08-21 — **FTP push is the second transport** (PhotoNodes approach):
  camera-initiated, vendor-agnostic, no discovery layer. Entry bodies
  (R10) stay on PTP/IP. [[ftp-push-transfer]]

- 2026-07-09 — **Vault lives on GitHub, checkpoints are manual.** Private
  repo `chrisbachmaxwell/CamLink-Vault`, local at `~/CamLink-Vault`, pushed
  with explicit `git push` (single sync system; Obsidian Git plugin optional
  later). SDK repo CLAUDE.md points every agent session at it.
- 2026-07-09 — **RAW handled, JPEG recommended.** CR3 files store fine; grid
  shows embedded-JPEG sidecars; clinics are advised JPEG Large/Fine.
- 2026-07-09 — **Support the R6 Mark III's 0xc1b6 event** by decoding the
  field hex dump rather than waiting for documentation. [[eos-event-records]]
- 2026-07-08 — **Events are layout-proof by design**: read only the object id
  from capture events, fetch truth via GetObjectInfo. This absorbed a brand-new
  camera generation with a 3-line change. [[eos-event-records]]
- 2026-07-08 — **Never disconnect-reconnect a Canon**: diagnostics hand their
  live session to the connection ([[session-handoff]]). Canon bodies treat
  check-then-redial as an error and restart their Wi-Fi AP.
- 2026-07-08 — **Degrade, don't fail** on SetRemoteMode 0x2002: physical
  shutter is the core clinic workflow; remote trigger is a nicety. Background
  retry (incl. 0x15) upgrades when possible. [[remote-shutter-degraded-mode]]
- 2026-07-07 — **The app diagnoses its own listening path** (self-test probes,
  port-contention detection, IP display) — field debugging with a
  non-technical operator requires the app to name the broken layer itself.
- 2026-07-07 — **UI never caches**: `no-store` on all static files + visible
  version number. A stale browser cache burned a full debugging round.
- 2026-07-06 — **User picks the connection type.** Chris: "remove all that
  information I should pick what type of connection I am making." Wizard is
  three tiles; CCAPI demoted to an Advanced link.
- 2026-07-06 — **Announce from boot, forever.** The camera searches BEFORE
  connecting and gives up if unanswered ("connection target not found").
  [[eos-utility-pairing]]
- 2026-07-05 — **PTP/IP is the primary path** ("the Tether Tools solution"):
  activation-free, works on every EOS body's "Remote control (EOS Utility)"
  mode. CCAPI (needs one-time USB activation) parked as Advanced.
  USB tether agreed as the follow-up transport. [[ptp-ip-protocol]]
- 2026-07 (project start) — **Adapter pattern, mock-first, monorepo**
  (original spec): consumer code never touches vendor SDKs; MockCameraAdapter
  ships before any vendor adapter; milestones M0–M6. [[adapter-pattern]]
