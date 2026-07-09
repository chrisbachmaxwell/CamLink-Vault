# Goal: Patient page & visit compare (Phase B — the payoff)

Status: PLANNED (blocked on [[2026-07-patient-records]]) · Created: 2026-07-09
Constraint: LOCAL ONLY ([[hipaa-local-first]]).

## Why
The moment that sells CamLink to an orthodontist: open a patient, see every
visit on a timeline, put month-0 next to month-6. Progress photos ARE the
ortho use case.

## Design sketch
- Patient page: header (name/DOB/note), visit timeline (date + photo count
  + thumbnails), click a visit → its grid (reuse session grid components).
- Compare mode: pick two visits → side-by-side grids; click a photo in
  each → large A/B view. Keyboard arrows step through pairs.
- RAW shots use existing `.thumb.jpg` sidecars; full-res JPEG loads on
  demand (40 MB CR3s must never load into an <img>).
- No editing, no annotations yet (roadmap later — keep scope tight).

## Done when (agent-verifiable)
- [ ] Patient page renders patients → visits → photos from disk state
      (test against fixtures)
- [ ] Compare mode: two visits side-by-side with A/B large view (DOM test
      or scripted browser check)
- [ ] Handles visits with zero/failed photos gracefully (tests)
- [ ] Search → patient page → compare reachable in ≤3 clicks from app open
- [ ] All three gates green; pushed
- [ ] Vault [[clinic-app]] page updated

## Waiting on Chris
- [ ] Show a real orthodontist (or front-desk person) and write their
      3 biggest complaints into [[roadmap]]

## Stop clause
Max 10 cycles, or 2 consecutive no-progress cycles → BLOCKED + log why.

## Iteration log
