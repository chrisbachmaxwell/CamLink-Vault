# project-status — WHAT IS DONE

Rewritten 2026-08-22 after the 2026-08-21/22 field marathon (see
[[log/2026-08-21-med-photo-field-day]]; July history in earlier logs).
Clinic app **v0.19.7** (2026-08-28, see
[[log/2026-08-28-clean-mac-updater-v0197]]). Code integration branch:
`main` (GitHub default since 2026-08-28).

## 2026-08-28 development governance
- `main` was created from the exact then-current default commit `f9531c8` and
  made the GitHub default branch. The legacy
  `claude/camera-sdk-adapter-pattern-4pj5r8` branch remains intact so active
  work is not deleted, but it is no longer an integration target.
- Mandatory multi-agent workflow: one task/owner/worktree/branch/PR, declared
  path ownership, one integration owner, serialized merges, fresh-main and
  gate verification, exact-file staging, and separate merge/release/deploy
  evidence. Code PR 6 merged these rules to `main` as `c0affc0`. Local hooks
  block direct `main` and non-fast-forward pushes; helper scripts create clean
  task worktrees. Chris confirmed the account is now on GitHub Pro, removing
  the private-repository plan blocker. A read-only API check still reports
  CamLink-SDK `main` as unprotected; enabling and verifying protection remains
  a separately authorized GitHub-settings action. PR discipline plus the local
  guard is the present enforcement boundary.

## 2026-08-28 clean-Mac updater and role-independent maintenance
- Field evidence from a second Mac showed v0.19.6 invoking Apple's `lipo`
  shim during update verification. A clean Mac without Xcode Command Line
  Tools therefore prompted to install developer tools and safely rejected the
  update. SDK feature `d416ab8` merged through PR 9 as main commit `9941b0f`.
  v0.19.7 now reads the arm64/x86_64 CPU type directly from the exact
  no-follow 64-bit Mach-O executable header; the packaged updater no longer
  invokes `lipo`.
- Software Update is maintenance of the installed Mac, not a clinical role.
  Owner, Staff and Review now see and may use it inside the packaged desktop
  app through the private HttpOnly loopback capability. The same role-gated
  update requests from an ordinary browser or LAN peer still return 403.
- Root build/tests, PTP/FTP/multi-room smokes and the browser UI gate passed;
  Node 20/22 PR CI passed. The exact 114082711-byte arm64 ZIP passed archive,
  version, built-in architecture, deep/strict code-signature and native-updater
  verification without `lipo`. The live Ed25519 manifest names v0.19.7 and
  immutable CloudFront SHA-256
  `e269bca45c0dbcfd440b67c05424d2de5f3e4e841bdcea1f371e0f36d7d71e0f`.
  The no-store 124157235-byte direct DMG streamed as SHA-256
  `4593489df9f22190e40dfae569fa049b262ffcae47437b927f25b0df8399efe1`.
- A Mac still running v0.19.6 contains the broken verifier itself, so that Mac
  needs the direct DMG once. After v0.19.7 is installed, future signed updates
  no longer depend on Command Line Tools. Developer ID/notarization remains
  the separate first-download Open Anyway gate.

## 2026-08-28 active-visit conflict repair
- SDK feature commit `e603dc4` merged through PR 7 as main commit `7c0d11f`.
  A camera lock whose visit record was missing or ended could previously block
  every new visit while Home truthfully showed no active visit. Dynamo now
  repairs only the exact stale lock, rereads if a concurrent visit replaced it,
  and retries the start transaction once. Real conflicts carry a closed,
  validated active-visit summary so the app can open or end the actual visit.
- Persistent global amber banners were retired. Ordinary notices are
  dismissible, expire after seven seconds, and clear when the user changes
  screens. A real active-visit conflict remains only on the screen where it
  occurred and provides its visit action instead of following the user through
  Home, Patients, Cameras and Settings.
- Full build/tests, PTP simulator, FTP, multi-room and browser UI gates passed;
  GitHub CI passed on Node 20 and 22. AWS stack
  `medphoto-synthetic-clinical-v2` reached `UPDATE_COMPLETE`; synthetic health
  returned 200. Exact arm64 v0.19.5 is live through the signed Railway manifest
  and immutable CloudFront ZIP. The streamed package is 114081847 bytes with
  SHA-256 `2fa83cd6ca4c3d310bec1576a40961a276a4231d520672684005ccbbb61e2af7`.
  The remaining field proof is to update both Macs, reproduce the former
  start-visit path, and confirm either a new visit starts or the real active
  visit opens from the conflict action.
## 2026-08-28 guided camera verification
- SDK `f9531c8` and live arm64 app v0.19.4 replace the credential-dump camera
  setup with one contextual sequence: enter the five camera values, continue,
  then take a test photo. The app waits for a checksum-verified completed cloud
  upload from that exact camera, shows the received image, and only then says
  **Camera verified**. A preexisting upload cannot satisfy a newly rotated
  profile's test. If no visit is active, the synthetic test photo is retained
  honestly in Unassigned.
- Cloud camera state now persists `lastUploadAt` plus an opaque photo id in the
  same completion transaction as the upload/photo records. Dashboard, header,
  and camera card labels no longer turn green merely because credentials were
  issued. Existing camera profiles become verified on their next completed
  upload; no historical photo migration or backfill was performed.
- Camera-disable feedback is a five-second informational notice instead of a
  persistent amber banner. Full workspace build/tests, PTP/FTP/multi-room
  smokes and the browser UI gate passed. AWS stack
  `medphoto-synthetic-clinical-v2` reached `UPDATE_COMPLETE`; the deployed
  Lambda code matched the reviewed bundle and synthetic health remained 200.
- The signed v0.19.4 arm64 updater is live. Railway manifest deployment
  `ea5fcd5d-75b2-4452-8178-876acc43f998` names the immutable CloudFront ZIP;
  its streamed SHA-256 is
  `e3a96484976dc93496c5f9994c0c42e60e01daf5f5cad47dfa7d5ac538073a9d`.
  The no-store latest DMG streamed as
  `870349212f677d5307a1b12889fabf1e605b54e367d937430f45ce0a71021f41`.
  The exact native updater verifier passed. This is still synthetic-only, and
  unsigned first-install reliability still requires Developer ID signing and
  notarization.

## 2026-08-27 cloud-authoritative pivot
- SDK `aae5b44` (2026-08-28) makes cloud active visits authoritative on every
  open app. The three-second shared-library refresh now also refreshes camera
  and active-visit state, and Home refreshes that state whenever it is opened.
  If another computer already started a visit, the 409 response carries the
  exact active visit summary; Home immediately shows it under **In progress**
  and the banner offers working **Go to visit** and **End it & start** actions
  instead of the dead `camera already has an active visit` sentence. Root
  build/tests, PTP/FTP/multi-room smokes and the browser UI gate passed.
  Field screenshots at 09:23 preceded the v0.19.4 release at approximately
  09:53. A fresh audit proved `aae5b44` is an ancestor of code `main` and the
  v0.19.4 source, and the exact signed ZIP contains the Home refresh plus
  **Go to ...'s visit** and **End it & start...** actions. The focused test and
  clinic typecheck passed; those screenshots therefore show the older app, not
  an unmerged or unpublished fix.
- SDK `c43b75c` reduces the values a person must type into a physical camera:
  new profiles use a 13-character `mp-...` username and a 12-character random
  password whose alphabet omits `0`, `1`, `i`, `l`, and `o`. The separate
  43-character cloud-ingest credential remains internal, random and unchanged;
  per-camera rotation and theft revocation remain intact. API 37/37, relay
  34/34, clinic 88 with one expected skip, all required PTP/FTP/multi-room
  smokes and the browser UI gate passed. The reviewed change set modified only
  the Lambda and API integration without replacement; CloudFormation reached
  `UPDATE_COMPLETE`, deployed code SHA-256 matched the tested bundle
  (`PqBcraLlGawc+/Y/nZsMiNGFBasSQ4EHKsU+GxBC9h4=`), and the live synthetic
  health endpoint returned `{"ok":true,"environment":"synthetic-only"}`.
- SDK `a5bc7b4` fixes the first live cloud camera profile activation. DynamoDB
  stores staged `activatedAt`/`revokedAt` markers explicitly as null, while the
  original transaction incorrectly required `activatedAt` to be absent; every
  otherwise-valid profile therefore returned `relay profile activation
  conflicted`. The transaction now accepts absent or null pending markers and
  also fences revocation. The reviewed Lambda-only/API-integration change set
  reached `UPDATE_COMPLETE`, the deployed Lambda SHA matches the tested bundle,
  and the synthetic API health check returns 200. Six failed empty profile
  drafts and their relay logins were retired only after proving they referenced
  zero visits/photos; the clinic now has zero active/pending camera drafts and
  is ready for one clean field retry. No setup password, ingest credential or
  relay control token was written to source, logs or the vault.
- SDK `df96174` and live app v0.19.3 remove the last accidental path from a
  cloud clinic into the legacy manual relay-address/access-token form.
  Settings **Change how the camera connects** now opens the model-first camera
  flow, which creates one unique server-side FTP profile and shows only the
  camera-entered host, port, username, password and folder. A stale cloud page
  already on the old Internet Relay tile is also redirected safely.
- SDK `6f6dd70` and live app v0.19.2 make every new human account email-first.
  Clean-clinic setup asks for the Owner's email; People creates email accounts;
  email-code password recovery is available before sign-in; legacy synthetic
  usernames are gated from the library until the same membership is migrated
  to email. Passwords now require 8 rather than 12 characters while retaining
  uppercase, lowercase, number and symbol checks. The AWS Cognito policy and
  packaged validation agree at 8; CloudFormation reached `UPDATE_COMPLETE`
  without replacing the UserPool, database or clinical photo bucket.
  Operational field follow-up confirmed the pre-email synthetic Owner remains
  enabled and `CONFIRMED`; its password was administratively reset without
  changing the membership or storing the credential, so the mandatory
  same-membership email upgrade can now be completed in the app.
- SDK `220f584` + `d846eef` establish the v0.19 cloud-first camera path;
  `a40171a` + `a718bef` make the clean Railway relay build dependency-scoped
  and deterministic. A
  fresh clinic now onboards an organization, location and first Owner; cloud
  mode never starts a legacy local camera bridge. Each physical camera receives
  a unique relay username/password plus a separate write-only cloud ingest
  credential. Owners can rotate those values or disable one stolen camera
  without changing another camera or its previously stored photos.
- Camera profile replacement is a staged, failure-safe saga: relay acceptance
  precedes the atomic cloud credential switch, and the old relay username is
  then retired idempotently. If that last cleanup is temporarily unavailable,
  the API returns an explicit pending-retirement state and retries without
  losing the new one-time setup values. The old cloud credential is already
  unusable at that point.
- The synthetic Railway relay now fsyncs a durable spool before returning FTP
  success, restores accepted jobs and dynamic camera bindings after restart,
  keeps a revoked camera's held job from blocking other cameras, and applies
  profile changes only after its binding envelope is durably committed. FTP
  dialogue/path/user/IP logging is disabled by default and redacted when
  explicitly enabled. This remains **plain FTP for synthetic photos only**;
  FTPS/TLS, BAA, managed secret storage and production drills remain gates.
- The coordinated synthetic backend is live. AWS stack
  `medphoto-synthetic-clinical-v2` reached `UPDATE_COMPLETE` with active Lambda
  relay control, and Railway deployment `4b758caf-35f9-4b8b-8a5a-763a64bf3841`
  succeeded from `a718bef` with its `/data` volume. Authenticated relay health,
  AWS health, rotated primary FTP authentication, and a temporary unique camera
  profile create/remove proof all passed. The exact arm64 v0.19.0 app is now
  packaged and published: a signed manifest/update check reports it available,
  the CloudFront ZIP matches the signed SHA-256, and Railway's no-store direct
  installer returns the byte-exact verified DMG. A genuinely unclaimed clinic
  receives organization/location/first-Owner setup plus Camera now/later; this
  already-claimed synthetic tenant correctly leads with username/password
  sign-in instead of repeating clinic creation.
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
- The tagged synthetic AWS clinical stack is now live: private
  KMS-backed/versioned S3, DynamoDB PITR, Cognito, Lambda and an authenticated
  HTTPS API. It is explicitly PHI-prohibited until the production compliance
  gate.
- Desktop cloud mode adds username/password sign-in, Owner-managed
  owner/staff/reviewer accounts, cloud patients/visits/photos, recoverable
  delete/restore, visit ZIPs and a 3-second shared-library refresh. Cloud
  camera bindings are opaque and persisted; display names are never identity.
- Two independent app processes proved the core path: owner capture uploaded
  one synthetic photo, reviewer saw and downloaded it, reviewer mutation was
  denied, and the camera host wrote zero local photo files. The cloud-enabled
  desktop release is v0.18.16. No BAA or existing local capture changed; FTPS,
  multi-location, migration/purge and production controls remain open. See
  [[log/2026-08-27-cloud-authoritative-library-live]].
- SDK `9bcc526` and v0.18.16 are published through the signed updater: Railway serves only the
  signed manifest and a private versioned S3 bucket serves the verified ZIP
  and DMG through read-only CloudFront. The live ZIP hash matched the manifest;
  the packaged cloud child, pre-sign-in updater and fresh profile all passed.

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
  v0.18.15 is live on the Railway release volume with the signed updater ZIP
  and stable first-install DMG independently streamed, signature-verified,
  and hash-verified. It carries the local patient-record organization work;
  this is not a cloud/AWS release.
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

For the v0.19 camera foundation, the full root build/workspace suite and all
three smokes + UI gate passed. Final focused gates passed with relay 34/34,
clinical API 17/17, clinical client 8/8, cloud domain 10/10, clinic 85 passed
with one expected skip, and desktop 25/25. Independent adversarial probes also
proved failure-atomic relay profile writes/deletes, restart recovery, two-camera
isolation, and a 202 pending-retirement retry completing as 200.

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

## 2026-08-28 live cloud-visit refresh release

- A field report proved direct-to-cloud photos were stored but the visible
  active visit stayed stale until it was reopened. Code PR 8 (`21eb8cd`)
  applies the existing three-second authoritative cloud projection to the
  visit currently on screen. The PR merged to SDK `main` at `de0a2d9` and
  shipped as v0.19.6. A fresh exact-merge build and all workspace tests passed;
  the packaged arm64 app passed ZIP, DMG, version, architecture and deep/strict
  signature checks. Railway serves the signed v0.19.6 manifest, CloudFront ZIP
  SHA-256 `1739a7b8c7ca4e775a89955d6f997443dd15f5711784cf4e0801a37df97aec98`,
  and direct-download DMG SHA-256
  `05ba39453ba7df0405536cbee62433e1a11c64962585418df496762f2399fbe1`.
  Live field proof that an open visit advances after a real camera upload is
  still required. See
  [[log/2026-08-28-cloud-live-visit-photo-refresh]].
