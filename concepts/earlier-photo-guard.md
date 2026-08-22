# Earlier-photo guard — a camera's backlog never files into a fresh visit

Field incident 2026-08-21: a camera powered off with an unsent shot
flushed it AFTER a new patient's visit started; it filed into the wrong
chart. Arrival time lies (cameras queue while off); the truth is the
EXIF capture time inside the JPEG.

## Mechanism (clinic app + sdk, shipped v0.6.2–v0.9.2)
- `exifCaptureDate()` in the SDK: tiny defensive EXIF reader
  (DateTimeOriginal, fallback DateTime; garbage → null; epoch-era
  unset clocks rejected).
- `CaptureSession.photoGate` inspects each downloaded photo pre-store;
  'hold' drops it from the session and emits `photoHeld`. A THROWING
  gate stores — never lose a shot to a policy bug.
- App policy: per-room camera clock offset (arrival − EXIF) learned from
  live shots, persisted in med-photo.json. No offset known → only >10 min
  gaps held (a sloppy clock never blocks a real shot); offset known →
  90 s grace. No EXIF / RAW → always store.
- Held photos land in `captures/earlier-photos/<ts>/` with a manifest and
  surface in **Unfiled sessions** — a HUMAN files or leaves them.

## The wrong-clock bootstrap (field incident 2026-08-22)
Chris's R6 III clock is hours wrong → every FRESH photo looked pre-visit
→ held → and nothing could ever teach the offset (catch-22). Fix: the
held banner offers **"It was just taken — add it to this visit"** —
`CaptureSession.adopt()` files it (human ruling bypasses the gate) AND
the app learns the offset from that judgment (capture ≈ hold moment).
Proven in smoke: adopt one 2 h-stale-looking photo, the next photo from
the same wrong clock flows straight in.

## Invariants (tested)
- The visit manifest never contains a held photo; a held photo leaves no
  session trace and its filename frees up.
- smoke `multi-room` covers: cold 2 h hold, live store + learning, 5 min
  hold after learning, adoption + post-adoption flow-through.
