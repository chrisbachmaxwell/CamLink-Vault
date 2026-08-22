# Goal: Multi-room — several cameras, each with its own patient visit

Status: BUILT 2026-08-21 (clinic app v0.6.1) — field verification with a
real second body still open (last unchecked box).

Design decision (Chris asked "should we have multiple listeners so we
can add cameras while one is being used?"): NO extra listeners — one
port, hot-add instead. The login already identifies the camera and one
port is one firewall rule; auth is checked at sign-in against a LIVE
account list, so cameras are added/removed with zero interruption to
rooms mid-transfer (proved by the multi-room smoke: camera added while
a visit was live with a photo already stored, and by an adapter test).

Status was: PROPOSED (Chris, 2026-08-21: "some places have multiple cameras
and each camera should have there own patient session… camera as the
definer"; same day: "when we add a camera should we name it… med spas
would name it by room or type of photo and then they should all have
access to the patient folders")

## The idea (camera identity = room)

The FTP-push design makes this natural: every camera **logs in** to our
FTP receiver with a user name. Give each camera its own user —
`room-1`, `room-2` — and the login IS the room. A photo that arrives as
`room-2` files into *room 2's* active visit, no matter what any other
room is doing. Same trick on the Cloud Relay (it already supports
multiple accounts, one FTP login + pull token each).

Today's app is one-camera: a single active visit, and every arriving
photo files into it. Two cameras pushing to the same login TODAY would
mix their photos into one visit — that's the thing this goal removes.

## Decisions locked by Chris (2026-08-21)

- **Adding a camera = naming it.** The add-camera flow asks one thing:
  "What should this camera be called?" — free text, with examples in
  the placeholder ("Exam Room 2", "Before/After station"). That name is
  the card label everywhere; the FTP user is derived from it
  (`exam-room-2`) and shown on the point-your-camera card. Rename must
  be possible later without touching the camera (login stays stable).
- **One shared patient library.** Cameras/rooms are NOT silos: every
  room searches the same patient list and files into the same
  per-patient folders. Emma photographed at the "Before/After station"
  today and in "Exam Room 2" next month lands in the one Emma folder.
  The camera name only decides WHICH active visit an arriving photo
  joins — never who can see a patient.

## Shape (keep Apple-simple)

- `Room` = { name (Chris: room or photo-type), ftp user+password,
  its own active visit or idle }.
- Front desk home shows one card per room ("Room 1 — Emma D., 4 photos"
  / "Room 2 — free"); clicking a room gives today's exact
  who-is-the-patient flow, scoped to that room. One room = today's UI
  unchanged (a solo clinic never sees the feature).
- Each room's page works on its own device (front desk iPad per room =
  Chris's "logins"); the URL carries the room.
- CameraFtpServer: accept a set of accounts (user → room) instead of one
  user; relay path: one relay account per room, app polls each.
- PTP/IP cameras (R10-class, no FTP) stay single-room for now — the
  wizard binds that camera to one chosen room.
- HIPAA unchanged: local/LAN first, per-patient folders, no PHI in logs.

## Done when (verified by:)

- [x] Two simulated cameras push as `room-1`/`room-2` and their photos
      land in two different patients' visit folders
      (verified by: new `smoke.mjs multi-room` mode, green 2026-08-21)
- [x] Shared library both ways: the same patient, visited from two
      different rooms (in sequence), ends up with both visits in the ONE
      patient folder; and both rooms' search finds patients created in
      the other room (verified by: same smoke mode, green 2026-08-21)
- [x] Browser gate drives two rooms at once: start visit in each, push a
      photo as each camera, correct tile appears on the correct room page
      (verified by: ui-gate extension, green 2026-08-21 — also asserts the
      OTHER room's photo never shows)
- [x] One-room clinics see today's UI unchanged
      (verified by: existing ui-gate flow still green, no room chrome)
- [ ] Field: R6 III as `room-1` + a second FTP body (or push-client as a
      stand-in) as `room-2` in the office (verified by: Chris's session,
      photos in the right patients' folders)
- [x] All gates green (now SIX: build, unit, smoke ×3, multi-room smoke,
      browser ui-gate); CLAUDE.md/AGENTS.md verify lists updated

## Stop clause

Stop and report instead of pushing on if: the session/storage model
needs more than one refactor commit to hold per-room visits, or the
relay needs multi-account provisioning UI (that drags in accounts/auth
— a separate goal). Ship the local two-room path first; relay
multi-room can trail.
