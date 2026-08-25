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
- [ ] A live shot with an hours-wrong EXIF clock files straight into
      the visit — no hold banner (ui-gate)
- [ ] First stored photo binds the body serial to the camera entry;
      a later photo with a different serial shows the mismatch banner
      AND still stores (ui-gate)
- [ ] Relay mode: two cameras with their own logins → photos route to
      each camera's own visit; camera picker works over relay
      (gate/smoke against the in-repo relay)
- [ ] A newly added camera is hidden from the start-visit picker and
      marked "waiting for first sign-in" until its login connects
      (ui-gate)
- [ ] Old relay (no camera-registration endpoint) keeps today's
      shared-login behavior — no errors (test)
- [ ] All six gates green; relay redeployed to Railway; field: R6 III
      at home files into its own visit under its own name (Chris)

## Stop clause
Never block or drop a photo over identity: every mismatch is a
warning, storing continues. If per-camera relay sync would strand a
currently-working camera login mid-session, keep the legacy login
valid alongside.

## Iteration log
- 2026-08-25 — Direction from Chris (three messages, quoted above);
  design set; brain updated before build per his standing rule.
