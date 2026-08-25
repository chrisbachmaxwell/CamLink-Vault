# Goal: Camera identity — sign-ins, serials, never dates

Status: IN PROGRESS (2026-08-25 — Chris's direction after taking the
R6 Mark III home; it connected to the relay wearing the z8's name and
its wrong clock got a live shot held out of the visit).

Context (Chris, 2026-08-25):
- "Is there a way to have a signature of each camera, a unique
  identifier, so the app knows it isn't the z8?"
- "I started a session with the R6 III connected as the z8 and it
  isn't adding [the photo] to the session… I don't want the user to
  have to pick — it should just automatically work… they should just
  pick the camera to start and the system would know that the photos
  being received from that camera obviously go to the session. Not
  relying on dates but just the pictures being received as they are
  shot."
- "Build both the fingerprint banner and the per-camera relay
  sign-ins. We should not register a new camera until it is signed
  in, and as part of the connection, when you take the first photo it
  should save the serial number to that camera so it always
  identifies the photos with that camera."

## The design (v0.16.0)
1. **Identity over dates.** A photo pushed by the visit's camera while
   the visit is live files into the visit, PERIOD. The earlier-photo
   EXIF gate no longer holds in-visit photos (reverses part of
   2026-08-22 "EXIF capture-time gate"; revisit condition — a real
   backlog flood mis-filing — would be answered with a bulk-arrival
   heuristic, never a date gate). EXIF time still feeds the learned
   per-camera clock offset; a badly-off clock becomes ADVICE on the
   Cameras page ("set this camera's clock"), never a block. The
   no-visit-open buffer (never-drop) is unchanged.
2. **Per-camera relay sign-ins.** The relay's one FTP listener accepts
   MULTIPLE logins (same mechanism as local mode: the login IS the
   camera). The app registers each camera's login with the relay
   (token-gated PUT, idempotent full-list sync — re-synced on boot and
   on every camera change, so a relay restart loses nothing). Files
   come back tagged with the login that sent them and route to that
   camera's visit; presence is per login. The old shared login keeps
   working (legacy cameras → first camera), and an old relay without
   the endpoint keeps today's behavior (feature-detected).
3. **No camera is registered until it signs in.** A new camera entry
   shows its sign-in values but presents as "waiting for its first
   sign-in" everywhere (picker hides it) until that login actually
   connects; the first sign-in confirms the registration.
4. **The serial is the signature.** Photos carry maker, model and the
   body's serial number in EXIF. The first photo a camera entry stores
   BINDS that serial to the entry (persisted). From then on a photo
   whose serial disagrees raises a clear warning banner naming both
   cameras — the photo still files (never lose a photo). With no
   serial in the file, a conservative make/model check backstops it
   (warn only on clearly-different bodies).

## Done when (verified by:)
- [x] A live shot with an hours-wrong EXIF clock files straight into
      the visit — no hold banner (ui-gate)
- [x] First stored photo binds the body serial to the camera entry;
      a later photo with a different serial shows the mismatch banner
      AND still stores (ui-gate)
- [x] Relay mode: two cameras with their own logins → photos route to
      each camera's own visit; camera picker works over relay
      (gate/smoke against the in-repo relay)
- [x] A newly added camera is hidden from the start-visit picker and
      marked "waiting for first sign-in" until its login connects
      (ui-gate)
- [x] Old relay (no camera-registration endpoint) keeps today's
      shared-login behavior — no errors (test)
- [ ] All six gates green (✓) and relay redeployed (✓, 2026-08-25); field: R6 III
      at home files into its own visit under its own name (Chris)

## Stop clause
Never block or drop a photo over identity: every mismatch is a
warning, storing continues. If per-camera relay sync would strand a
currently-working camera login mid-session, keep the legacy login
valid alongside.

## Iteration log
- 2026-08-25 — Direction from Chris (three messages, quoted above);
  design set; brain updated before build per his standing rule.
- 2026-08-25 — **v0.16.0 built, verified, SHIPPED** (commit 5ca3b6f,
  pushed over real git — the transport outage ended mid-session; the
  v0.15.0 API-route commits reconciled cleanly, trees identical). The
  build agent died silently ~2 h in with the tree complete; verified
  its work independently: all six gates green including the four new
  assertions (6-h-old EXIF stores with no hold banner; serial …1111
  binds then …2222 raises the mismatch banner AND stores; unconfirmed
  camera hidden from picker until first upload; relay two-login strict
  routing with per-camera value cards). Relay redeployed to Railway
  same session. Client model check shipped stricter than spec: warns
  only when the photo's model positively matches a DIFFERENT catalog
  entry. Remaining: Chris's field pass with the R6 III + z8.
- 2026-08-25 (later) — **Field defect, same night: one live camera lit
  every camera green.** Chris added "z8 display" (own login); only that
  login was live, but "z8 rental" showed on too — the default camera
  read the relay's account-level AGGREGATE presence (any login live →
  connected), a compat compromise the v0.16.0 code even documented.
  v0.16.1: /v1/health's cameras map now includes the PRIMARY login's
  own row plus `primaryUser`; the app reads the primary's own row when
  present (old relays fall back to the aggregate, where it is honest —
  single shared login). Regression pinned in adapter test (only cam-b
  speaks → primary row stays dark) + relay test (primary in map).
  Lesson: never let a "compat aggregate" be any NEW reader's default.
  All six gates green; relay redeployed; SDK pushed (4a93b29).
- 2026-08-25 (v0.16.2) — Chris's first field pass surfaced three gaps,
  all fixed same session: (1) photoBuffered had NO UI — a photo shot
  on a camera with no visit open was saved but INVISIBLE, which read
  as "photos aren't being added"; now a banner offers one-click
  adoption into the open visit (or says where the photo went). (2)
  The patient-page "Which camera?" ask still skipped relay mode — it
  silently used the default camera; now it asks whenever
  relayPerCamera is live (confirmed cameras only). (3) Ending a visit
  with photos now lands on the PATIENT'S record (Chris: "I want to go
  back to that patient's page"); done card stays for empty/name-only
  visits. Race caught by the gate: the sessionEnded broadcast also
  ran the new navigation and yanked pages mid-turnover — navigation
  now belongs ONLY to the user's own End click (doctrine: never
  auto-navigate away from the user). All six gates green; pushed.
- 2026-08-25 (v0.17.0 direction) — **Backlog floods get ONE warning
  with stop instructions** (Chris, watching his Z8 drain 30 queued
  NEFs, 38 min remaining: "should our app detect old photos when they
  happen and have the warnings saying old photos are being uploaded
  and then give instructions to stop it"). The reserved revisit
  condition fired. Design: the app CANNOT control the camera (FTP
  push is one-way by design — that's why it works on every brand), so
  the answer is detection + one honest banner: per camera, arrivals
  whose own capture time (clock-offset-corrected) is well in the past
  count into a burst; the banner aggregates ("uploading older photos —
  N so far, M RAW; kept safe") and carries the camera's OWN stop steps
  (catalog `backlogAdvice`; Nikon: Options → Auto send OFF →
  "Deselect all?" clears the queue). Per-file buffered/RAW banners go
  quiet while a burst is active — one flood, one banner. FILING IS
  UNCHANGED: identity over dates stands; burst photos still store
  (into the open visit, or the safe buffer). Also fixes a latent bug
  the detector exposed: offset learning now resists backlog poisoning
  (a flood of old files must not redefine the camera's clock).
