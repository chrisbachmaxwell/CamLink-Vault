# Goal: Patient page & visit compare (Phase B — the payoff)

Status: PLANNED (dependencies DONE — ready to start) · Created: 2026-07-09
Constraint: LOCAL ONLY ([[hipaa-local-first]]).

## Why
The moment that sells CamLink to an orthodontist: open a patient, see every
visit on a timeline, put month-0 next to month-6. Progress photos ARE the
ortho use case.

Field feedback folded in (Chris, 2026-07-09, real R6 III session):
1. "I'm not able to click and have them open up" — photos in the session
   grid are not clickable; no large view exists outside compare.
2. "I'm not sure where all these photos are actually being stored" — the
   app never shows the on-disk location (captures/patients/<id>/visits/…).
3. "Once I start a new session I can see all the sessions below it — big
   cluster, sessions stacked on each other" — history renders as a flat
   stack even though /api/sessions already returns patient groups.

## Design sketch
- Patient page: header (name/DOB/note), visit timeline (date + photo count
  + thumbnails), click a visit → its grid (reuse session grid components).
- Compare mode: pick two visits → side-by-side grids; click a photo in
  each → large A/B view. Keyboard arrows step through pairs.
- RAW shots use existing `.thumb.jpg` sidecars; full-res JPEG loads on
  demand (40 MB CR3s must never load into an <img>).
- No editing, no annotations yet (roadmap later — keep scope tight).

## Architect pre-flight (2026-07-09)
- Verification reality check: the front end is plain no-build JS
  (`apps/clinic/public/app.js`, ~900 lines) and the repo has NO browser
  test tooling. Do not install Playwright/Puppeteer for this goal.
  Instead: put compare/timeline logic (visit pairing, A/B stepping,
  photo-list shaping) in plain modules unit-testable under vitest (jsdom
  as a devDependency is acceptable if DOM assertions are needed); keep
  DOM glue thin; prove server-side behavior via API tests + smoke.
- Data plumbing that exists: `/api/sessions` already returns
  `{patients: [...visits], sessions}`; `/files/` serves stored photos
  with a traversal guard; RAW thumbnails exist as `.thumb.jpg` sidecars.
  Missing: an endpoint listing a single visit's photos (+thumb URLs) from
  its manifest — that's in scope.
- 40 MB CR3 rule stands: grids and A/B view load sidecar thumbs; full-res
  only ever loads for JPEGs, on demand.

## Done when (agent-verifiable)
- [ ] Visit-photos endpoint: given patientId+visitId, returns the visit's
      photos with thumb/full URLs from manifest + sidecars (API tests
      against disk fixtures, incl. RAW-with-sidecar and failed photos)
- [ ] Patient page renders patients → visits → photos from disk state
      (unit tests on the render/shaping modules against fixtures)
- [ ] Compare mode: two visits side-by-side with A/B large view; pairing
      + keyboard stepping logic covered by unit tests (jsdom ok — no new
      browser automation deps)
- [ ] Handles visits with zero/failed photos gracefully (tests)
- [ ] Any photo, anywhere it renders (live session grid, visit grid,
      compare), opens a large view on click: JPEG loads full-res on
      demand; RAW opens its sidecar thumb with the existing JPEG
      advisory; Esc/click closes (logic/jsdom tests) — Chris feedback #1
- [ ] History is grouped, not stacked: the below-session list renders
      patient → collapsible visits using the groups /api/sessions already
      returns; the active session is visually separated from history
      (render-module tests against fixtures) — Chris feedback #3
- [ ] The visit view shows WHERE photos live: the on-disk folder path
      (relative under captures/) with a copy-path control, so the front
      desk can find files in Finder (DOM/logic test) — Chris feedback #2
- [ ] Navigation: search → patient page in 1 click; patient page →
      compare in ≤2 more (asserted in a DOM/unit test of the nav flow,
      not by eyeballing)
- [ ] Smoke extended: after the existing patient-records checks, fetch
      the visit-photos endpoint for both of janeA's visits and assert
      compare-able payloads (photo lists non-empty, thumbs resolve)
- [ ] All three gates green; pushed
- [ ] Vault [[clinic-app]] page updated

## Waiting on Chris
- [ ] Show a real orthodontist (or front-desk person) and write their
      3 biggest complaints into [[roadmap]]

## Stop clause
Max 10 cycles, or 2 consecutive no-progress cycles → BLOCKED + log why.
Scope guard: no editing/annotations, no export, no printing, no new
browser-automation dependencies — roadmap items, not this goal.

## Iteration log
