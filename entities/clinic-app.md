# CamLink Clinic (reference app)

`apps/clinic` in [[camlink-sdk]] · local web app · `npm start -w @camlink/clinic-app`
→ http://localhost:3333 · v0.2.0 (version shows in header + boot log)

Built ONLY on public `@camlink/*` APIs — it dogfoods exactly what third-party
developers get. Governing constraint: [[hipaa-local-first]].

## Front-desk workflow (the product promise)
Find or create a patient (search-as-you-type; optional DOB for name
collisions) → Start visit → every photo files into
`captures/patients/<id>-<slug>/visits/<ISO-timestamp>/` with
`manifest.json` carrying `patientId` + `visitId` + SHA-256 → End session.
History groups by patient → visits. See [[2026-07-patient-records]].

## Patient records (Phase A — 2026-07-09)
- Local index: `captures/patients.json` (`id`, `name`, optional `dob`/`note`,
  `createdAt`). No cloud DB.
- APIs: `GET/POST /api/patients`, `GET /api/patients/match`,
  `POST /api/session` with `patientId` (preferred) or legacy `patientName`.
- Collision rule: same name + same DOB rejected; same name + different DOB
  = distinct records (distinct folders).
- Legacy flat folders (`captures/<slug>/<timestamp>/`) appear under
  **Unfiled sessions**; filing into a patient is an explicit
  `POST /api/unfiled/file` — never auto-moved.
- History: `GET /api/sessions` → `{ patients: [...visits], sessions: [...] }`.

## Connection wizard
- Three tiles: Same Wi-Fi network / Camera's own Wi-Fi / Practice mode
  (simulator). CCAPI hidden behind an "Advanced" link. (Chris explicitly
  asked: user picks the connection type; no auto-guessing walls of text.)
- 📻 status line self-diagnoses the listening path every 3 s: port squatters
  (Spotify), multicast delivery, firewall, Local Network permission, shows
  this computer's current IPs (see [[macos-networking-traps]]).
- Announcer self-test (loopback + multicast probes) tells WHICH layer is
  broken instead of guessing.
- `cameraFound` watcher: when a camera that searched for us opens its port,
  the app auto-fills the IP and auto-runs Check & pair → connect → test step.
- Connect retries for 2 min with plain-language "you're off the camera's
  network — rejoin EOS-XXXXXX" banners (macOS Wi-Fi hop survival).
- Test step: blue remote-shutter button AND physical-shutter detection
  (photo pops up with "your shutter press reached the app").

## Technical notes
- Plain JS/HTML/CSS front end, no build step. SSE for live events
  (`camera`, `pairing`, `cameraSearch`, `cameraFound`, `session`,
  `photoCaptured`, `cameraPhoto`, `photoError`, `sessionEnded`).
- Static files served `cache-control: no-store` (a browser once cached the
  old UI through three updates — never again).
- RAW (CR3) shots: camera's embedded JPEG preview saved as
  `<file>.thumb.jpg` sidecar; grid renders it; one-time banner advises
  switching the camera to JPEG for clinic use.
- Modes: `ptp` (real camera) | `ptp-simulator` | `simulator` (CCAPI sim) |
  `canon` (CCAPI real) | `mock`.
- Process guards for uncaughtException/unhandledRejection (a camera reset
  once crashed the whole app — never again).
- Clinic package now has vitest coverage (patient index, visits, history,
  unfiled, HTTP create/match). Smoke extends to multi-visit + same-name DOB.
