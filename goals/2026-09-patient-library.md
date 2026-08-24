# Goal: The patient library — search-first, real visits only, gallery

Status: IN PROGRESS (2026-08-24 — Chris's direction after using the new
drawer shell in the field; built the same day, v0.15.0).

Context (Chris, 2026-08-24, with screenshots of his live data):
- "I don't like the list of all the patients. I would rather search for
  one or click and see a list of all of the patients that I can narrow
  down into."
- "I also don't like the orphaned photos there. I think that was a
  mistake — our system should just work; the person taking photos
  should verify that they are being received to the correct patient.
  Remove that part."
- "It even shows sessions that were started without any photos — we
  should only keep sessions that actually have photos. A session
  shouldn't be able to be saved to the database unless photos were
  captured."
- "Long lists like this isn't great UI experience."
- "The organization should want to be able to download them, click into
  them and it opens a gallery so it can be larger etc. Make the UI
  incredible!"

## The design
1. **Search-first library.** The Patients page rests as a search field
   + "Browse all patients". The library lists PATIENT RECORDS (name,
   DOB, visit/photo counts) — never raw folders. System sessions
   ("Photo without a visit", "Earlier photo") and legacy name-only
   folders never appear as patients.
2. **Verification happens at capture time.** The live banners (held
   photo → "It was just taken", buffered photo alerts) are THE filing
   moment — the photographer confirms photos are landing on the right
   patient while shooting. The Unfiled section leaves the Patients
   page. HARD RULE UNCHANGED: no photo is ever deleted — orphaned
   files stay on disk under captures/ even though they no longer pose
   as patients. (If the field ever needs a recovery view, it goes in
   Settings, not the library.)
3. **Empty visits are never saved.** Ending a visit with zero photos
   discards the empty record — after verifying on disk the folder
   holds nothing but its manifest (the no-hard-delete rule is about
   photos; an empty visit has none). Legacy empty visits are hidden
   from every list, non-destructively (folders untouched).
4. **Gallery + download.** Click any photo (live grid or patient page)
   → full-screen viewer: arrows/keys, filename + taken time, Download
   (single photo), Download all (whole visit as a zip — store-only zip
   streamed by the app, no new dependencies). RAW files: no preview,
   still downloadable. Visit lists collapse past 6 ("Show all N").

## Done when (verified by:)
- [x] Patients page rests as search + Browse; typing narrows; no
      folder-orphans, no Unfiled section (verified by: ui-gate asserts
      hidden-at-rest, filter-to-row flow, #unfiled-block absent —
      2026-08-24)
- [x] Ending a 0-photo visit saves nothing; /api/sessions never lists
      0-photo visits (verified by: ui-gate ends an empty visit and
      asserts it is absent; done card says "nothing was saved" —
      2026-08-24)
- [x] Gallery opens from live grid and patient page, Esc returns,
      Download links wired (verified by: ui-gate — 2026-08-24)
- [x] Visit zip endpoint streams a valid zip (verified by: ui-gate
      fetches it and checks the PK header — 2026-08-24)
- [ ] All six gates green (✓ 2026-08-24); field: Chris browses, opens
      the gallery, downloads a visit (verified by: Chris's session)

## Stop clause
If discarding an empty visit could ever touch a folder containing ANY
file besides manifest.json, stop — keep the folder. The no-photo-loss
rule outranks tidiness.

## Iteration log
- 2026-08-24 — Direction from Chris; design set; build running
  (sonnet agent, spec in session); brain updated first per his ask.
- 2026-08-24 (later) — **v0.15.0 built and shipped.** All six gates
  independently verified green, including the five new assertions
  (live-grid gallery + Esc, empty-visit discard, search-first library
  with #unfiled-block absent, patient-page gallery + download hrefs,
  zip PK header). Stop clause honored in code: /api/session/end
  discards a folder ONLY after readdir shows nothing but
  manifest.json. Gate fixture fix along the way: the pushed-JPEG
  fixture was a 22-byte header with no scan data (undecodable → no
  <img> for the gallery step); replaced with a real 1×1 baseline
  JPEG. Shipped via the GitHub API route (git transport still down),
  every file blob-SHA-verified byte-exact against local dd2b9fd.
  Remaining: Chris's field pass (browse, gallery, visit download).
