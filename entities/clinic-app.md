# Med Photo clinic app

`apps/clinic` in [[camlink-sdk]] · packaged by `apps/desktop` · clinic runtime
**v0.18.6** inside desktop source **v0.19.8** as of 2026-08-28. The currently
published signed desktop release remains **v0.19.7**; v0.19.8 is merged but not
yet packaged or published. The product is cloud-authoritative in packaged
mode; the local capture paths below remain supported engineering/transport
modes.

developers get. Governing constraint: [[hipaa-local-first]].
Built on public `@medphoto/*` APIs. Governing constraints:
[[hipaa-local-first]] and [[cloud-authoritative-library]].

## Cloud active visits (2026-08-28)
- The cloud is the source of truth for camera-to-visit assignments. Home's
  **In progress** section must show every active visit, including one started
  from another computer; entering Home and the three-second shared-library
  cycle both refresh camera/visit state (`aae5b44`).
- A start conflict is never a text-only wall. The clinic server resolves the
  requested camera's active visit (or the requested patient's visit on another
  camera), returns its current summary, and the browser immediately offers
  **Go to visit** and **End it & start**. Clicking Go to visit refetches cloud
  state before rendering so an already-ended visit cannot appear live.
- A camera-active lock is not sufficient proof by itself. The cloud API reads
  the locked visit consistently; if that visit is missing or ended, it deletes
  only the exact stale lock and retries once. If another visit wins during the
  repair, the reread returns that real visit rather than deleting it.
- A live visit viewed on two signed-in computers closes on both when either
  computer ends it. The non-clicking computer detects the ended transition in
  its tenant-scoped three-second projection and leaves the stale live screen
  (`1ab5602`; desktop source v0.19.8, release pending).
- Notifications are contextual, not global residue. Ordinary notices have a
  close control, expire after seven seconds, and clear on navigation. A real
  active-visit conflict stays only on the screen where the action is relevant.

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

## Power-cycle reconnect (2026-07-09 — [[2026-07-camera-reconnect]])
- **Server-side reconnect watch** (no browser tab required): when configured
  for PTP and the camera drops, the server probes the saved host every 2 s
  (and prefers a recent SSDP-search IP if the camera's DHCP address moved).
  On success it re-runs connect with the persisted GUID, broadcasts the
  reconnected state, and persists any new host.
- **Announcer interface re-join**: multicast memberships re-enumerated every
  15 s; on interface-set change (Mac hops onto the camera AP) re-joins in
  place without restarting or changing the pairing GUID.
- **UI waiting state**: while disconnected, banner reads
  "Camera is off or not reachable — turn it on and choose CamLink Clinic
  on the camera. Reconnecting automatically." Clears on reconnect; never
  dumps raw "no cameras found" errors.
- **Session survival**: an active visit stays open across the power cycle;
  `connectCamera()` re-attaches via `session.attach(connection)` so photos
  after reconnect land in the same visit folder.
- `cameraFound` remains wizard-only by design — configured reconnect is
  the server's job, not the browser's.

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
