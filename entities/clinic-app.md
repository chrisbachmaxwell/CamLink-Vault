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

## Patient page & visit compare (Phase B — 2026-07-10)
Goal: [[2026-07-visit-compare-ui]] (IN PROGRESS — architect re-review).
Branch: `cursor/visit-compare-6345` (tip `eba9194`).
- `GET /api/visit-photos?patientId=&visitId=` — photos + thumb/full URLs
  from manifest + `.thumb.jpg` sidecars (JPEG / RAW+sidecar / failed / empty).
- Patient page: click a history patient → timeline of visits with photo
  grids, on-disk `captures/…` path + Copy path control.
- Compare: pick two visits → side-by-side grids → A/B large view; arrow
  keys step pairs (`public/compare.js`).
- Click any photo (live session, visit grid, compare) → large view;
  JPEG full-res on demand; RAW uses sidecar only (never CR3 in `<img>`).
- History grouped patient → visits via `history-render.js`; live session
  banner separated from history (`hist-active-session`).
- Front-end logic in small ESM modules under `public/` (vitest + jsdom);
  no Playwright/Puppeteer. Smoke asserts visit-photos for both janeA visits.

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
  switching the camera to JPEG for clinic use. Phase B large view and
  compare obey the same rule (`photo-display.js` / `large-view.js`).
- Testable ESM modules: `reconnect-messages.js`, `photo-display.js`,
  `patient-page.js`, `compare.js`, `large-view.js`, `history-render.js`,
  `storage-path.js`, `nav.js` (jsdom ok; no browser-automation deps).
- Modes: `ptp` (real camera) | `ptp-simulator` | `simulator` (CCAPI sim) |
  `canon` (CCAPI real) | `mock`.
- Process guards for uncaughtException/unhandledRejection (a camera reset
  once crashed the whole app — never again).
- Clinic package vitest coverage includes patient index, visits, history,
  unfiled, visit-photos, patient-page/compare/large-view/nav, HTTP APIs.
  Smoke extends to multi-visit + same-name DOB + visit-photos compare payloads.
