# The camera catalog — per-model onboarding knowledge (2026-08-22)

Onboarding is MODEL-FIRST (Chris, 2026-08-22): the user picks their
camera model; the app already knows how to connect it. The catalog is
where that knowledge lives — one entry per model, encoding which
transport suits the body and that body's OWN menu path and traps.
Screen behavior: repo docs/DESIGN.md, "Connect a camera" ·
[[design-doctrine]].

## Where it lives
`apps/clinic/public/camera-catalog.js` in the code repo — plain JS
export, no build step, served to the browser. `catalogEntry(id)` looks
one up.

## Entry shape (verify after: 2027-02)
- `id` · `label` — stable slug + the dropdown text.
- `transport` — `'ftp'` (camera auto-sends; flow names the camera = its
  room, shows values), `'ptp'` (EOS Utility pairing wizard), `'choose'`
  (fall back to the transport chooser).
- `warning` — optional; rendered highlighted BEFORE the steps
  (e.g. the R5 II passive-mode trap).
- `note` — optional one-liner (e.g. "this body has no FTP").
- `steps` — that model's menu path, imperative, one action each, shown
  AFTER the values card.
- `fieldProven` — true only when a real body ran the steps end-to-end.

## The rule
A field lesson about a body updates its catalog entry AND its vault
hardware page IN THE SAME SESSION — the catalog is what clinics see,
the hardware page is why. One model = one entry; update the day the
lesson lands (rule 2: update, don't duplicate).

## Current entries (as of 2026-08-22)
- Canon EOS R6 Mark III — ftp — FIELD-PROVEN ([[canon-eos-r6-mark-iii]])
- Canon EOS R5 Mark II — ftp — warning: ships with Passive mode OFF,
  transfers silently fail until ON (field lesson 2026-08-22,
  [[canon-eos-r5-mark-ii]], [[2026-08-r5ii-ftp-dialect]])
- Canon EOS R5 / R5 C — ftp — from manuals, not field-proven
- Canon EOS R6 / R6 Mark II — ftp — not field-proven
- Canon EOS R10 — ptp (no FTP on entry bodies) — FIELD-PROVEN
  ([[canon-eos-r10]])
- Canon EOS R50 / R100 — ptp — not field-proven
- Canon — other model — ftp with generic steps
- Sony Alpha (a7/a9/a1 with FTP) — ftp — not field-proven
- Nikon Z (Z6 III / Z8 / Z9) — ftp — not field-proven
- Fujifilm X / GFX (with FTP) — ftp — not field-proven
- Not sure / another camera — choose (the old transport-tile wizard)
