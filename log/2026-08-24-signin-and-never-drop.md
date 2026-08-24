# 2026-08-24 — Sign-in ships; the app may never lose a photo again

Clinic app **v0.12.0** pushed (SDK commit `268a311`; v0.11.x commits
`d776d12` auth foundation, `49664f3` camera-first language landed
earlier in the same working session).

## Field incident → decision
Chris onboarded a **Nikon Z8** through the new model-first connect flow
("everything worked great") — then started a visit and no photos came
over. The Railway FTP tracer proved the truth in one look:
`upload complete 4J6A6738.JPG (11270475 B)` — the photo REACHED the
relay and was piped to the app, which threw it away because no visit
was open on that camera. That specific shot is unrecoverable (it was
dropped before the fix); every future one is not.

**Decision (now in [[entities/decisions]]):** a photo that reaches us
can never vanish. No-visit arrivals are filed as a held
"Photo without a visit (<camera>)" session in Unfiled and a
`photoBuffered` event is broadcast (UI affordance for that event is a
later wave — the session itself already shows in Unfiled).

## Shipped
- Never-drop buffer (`captureUnassigned` in server.ts;
  `holdEarlierPhoto` grew a label param; wired for both the default
  connection and named-camera connections).
- Sign-in UI (agent wave 3, sonnet): Apple-TV profile picker → PIN
  pad, user chip, Menu → Sign out, Menu → People (adding the FIRST
  person turns access on and makes them Owner), review role gets a
  read-only home (start form hidden, history visible, trimmed menu)
  with server 403s behind it.
- Camera pill: shows the camera's NAME, click opens Camera setup
  ("the pill is a door"); hidden action for review role.
- Gates: ui-gate step 8 (bootstrap owner "Dr. Chris"/4321, wrong-PIN
  rejection, review "Front Desk"/2222 read-only + server 403);
  smoke multi-room filters "Photo without a visit" sessions out of its
  shared-library assertions. ALL SIX GATES GREEN before push.

## Mistakes caught
- The Z8 drop itself: `connectCamera`'s default-connection handler only
  broadcast `cameraPhoto` and let the photo die when no session was
  active. The relay tracer (built two days ago for the R5 II) is what
  made the diagnosis instant — keep tracers forever.
- Note: relay currently gives ALL cameras ONE shared login, so Z8 and
  R6 III share an identity on relay mode. Per-camera relay accounts
  arrive with the per-clinic accounts / FTPS+BAA milestone.

## Open
- Chris field tests: onboarding flow, sign-in (Menu → People), R5 II
  passive-ON retry (tracer live: `railway logs --service relay`),
  multi-room second body.
- `photoBuffered` UI affordance; per-camera relay logins; Railway token
  deletion by Chris.

## Addendum (same day): Z8 trace verdict + v0.13.0
- **Z8 "no photos" SOLVED BY TRACE, camera-side**: relay trace shows the
  Z8 connect → login → PWD → PASV → NLST (directory listing) → QUIT,
  over and over — **it never sends STOR**. The camera checks in but has
  nothing queued to send: Nikon's FTP **Auto send is OFF** (or
  send-marking off). App/relay are fine; queueDepth 0, lastSeen live.
  Fix is on the camera: Network menu → Connect to FTP server →
  Options → **Auto send ON** (+ send JPEG if RAW+JPEG). No re-add
  needed. NOTE: yesterday's `4J6A6738.JPG` is a Canon-style name —
  that upload was almost certainly the R5 II, not the Z8.
- **"Room 1" on the pill**: his default camera was literally still
  NAMED "Room 1" (pre-rename default) and relay mode had NO rename UI.
  v0.13.0: default is now "Camera 1" (persisted "Room 1" migrates),
  and relay-mode Camera setup lists every camera with status light +
  Rename/Remove.
- **v0.13.0 shipped** (all six gates green): home **In progress** zone
  (every live visit: patient, camera, count, since; Open/End with
  confirm; live-updating; hidden for review) and the update-blocked
  banner now names the active visits with one-click
  "End <patient>'s visit & update" actions (409 carries activeVisits).
  Doctrine reaffirmed: a banner offers the next step, never a wall.

## Addendum 2: Z8 DELIVERS; RAW warning with per-model instructions (v0.13.1)
- Auto-send ON worked: `DSC_0016.NEF` stored into the visit — the Z8
  pipeline is FIELD-PROVEN end to end (camera → relay → app → visit).
- New complaint: "saved ✓ (no preview)" — the Z8 sent RAW. Chris: "I
  only want to send jpegs" + "there should be a warning in the app with
  instructions… it should know the type of camera."
- v0.13.1: RAW detection covers all mainstream extensions (was
  CR2/CR3-only — the NEF slipped past silently); the banner names the
  camera and gives the MODEL'S OWN menu path to switch to JPEG
  (camera-catalog `jpegAdvice` per FTP entry, generic fallback);
  onboarding steps for every FTP model now include "set image quality
  to JPEG". Gate-enforced: a .NEF push must produce the model-specific
  banner. DECIDED: no RAW preview extraction — clinics shoot JPEG;
  RAW is stored safely but steered away from.

## Addendum 3: drawer shipped (v0.14.0); patient library direction (v0.15.0)
- v0.14.0 left-drawer shell + dashboard home shipped (see decisions +
  docs/DESIGN.md screen map). Delivered via GitHub API file commits —
  workspace git transport to GitHub down all evening; every file
  blob-SHA-verified against the gate-tested local commit.
- Chris field feedback on the Patients area → goal
  [[goals/2026-09-patient-library]]: search-first library of PATIENT
  RECORDS (no folder orphans, Unfiled section removed — capture-time
  banners are the filing moment; photos on disk still never deleted),
  0-photo visits never saved and hidden from listings, full-screen
  gallery + per-photo download + visit zip. v0.15.0 build running.

## Addendum 4: patient library v2 shipped (v0.15.0)
- Built by a background agent from an exhaustive spec, then verified
  independently: all six gates green, including five NEW assertions
  (search-first hidden-at-rest + no #unfiled-block, empty-visit
  discard + "nothing was saved" done card, gallery from live grid and
  patient page with Esc, download hrefs, visit-zip PK header).
- Stop clause held: the empty-visit discard path readdir-verifies the
  folder holds ONLY manifest.json before removing it; anything else
  present → folder kept, visit kept.
- Mistake caught: the gate's pushed-JPEG fixture was a 22-byte
  header-only file — undecodable, so the browser never rendered an
  <img> to click for the gallery step. Replaced with a real 1×1
  baseline JPEG (same bytes adapter-mock uses).
- Shipped via the GitHub API route again (git transport still down):
  server.ts pushed and blob-SHA-verified in-session (remote commit
  9db84a4), remaining five files (app.js, index.html, styles.css,
  ui-gate.mjs, package.json LAST) pushed by a delegated agent under
  the same byte-exact protocol — local commit dd2b9fd is the truth.
- Vault: project-status rewritten to v0.15.0 (drawer, JPEG steering,
  library v2 bullets; Unfiled wording corrected in older bullets),
  goal page Done-when boxes checked (field pass with Chris still
  open), decisions already logged earlier today.
