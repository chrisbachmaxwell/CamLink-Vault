# Goal: The simplicity pass (continuous)

Status: IN PROGRESS · Created: 2026-08-21 · Owner: architect + Chris
Doctrine: [[design-doctrine]] / repo docs/DESIGN.md. This goal never
"finishes" — it re-opens whenever a screen fails the tests below.

## The three tests every screen must pass
1. **One-action test**: a first-time front-desk user can say what this
   screen wants from them in one sentence, without reading twice.
2. **Quiet test**: when everything works, the screen contains no status
   chatter, no diagnostics, no explanations.
3. **"Do I really need this?"**: every visible element has a job serving
   the one-sentence mission (easiest patient-photo storage, instant
   camera connection). Anything that can't answer gets folded or cut.

## Done when (this round — the 2026-08-21 redesign)
- [x] Home = one centered patient question; Enter starts the visit
      (verified by: apps/clinic/test/ui-gate.mjs — doctrine-primary path)
- [x] Visit screen = name, count, grid, End visit only
      (verified by: ui-gate + screenshots in test/artifacts/)
- [x] Patient page + Compare shipped (Phase B core)
      (verified by: agent render pass; NEEDS a ui-gate extension — see below)
- [x] Wizard reworded to doctrine, diagnostics preserved & folded
      (verified by: smoke x3 unchanged, manual render pass)
- [x] ui-gate extended to cover patient page + Compare (open a patient,
      edit/save/reopen its photo-workflow information, enter Compare, switch
      visits, close) (verified by: ui-gate.mjs, 2026-08-27)
- [ ] Chris's hands-on pass: run a visit start-to-end and name anything
      that made him think twice → new checkboxes here

## Waiting on Chris
- [ ] Judge the redesign against "simple like Apple" with real eyes; every
      complaint becomes a checkbox (rule C in roles/architect.md)

## Stop clause
Per round: max 6 cycles or 2 no-progress cycles → BLOCKED with reasons.

## Iteration log
- 2026-08-28 · Cloud active-visit dead end fixed (`aae5b44`): Home now
  refreshes authoritative camera/visit state across computers, a fresh
  conflict immediately populates **In progress**, and the warning offers a
  direct door to the exact visit plus End-and-start. Focused cloud UI tests,
  root build/tests, PTP/FTP/multi-room smokes and the browser UI gate passed.
- 2026-08-27 · Patient-record organization shipped in the clinic reference
  app (`154c2b5`): a patient page now shows/edit-saves name, DOB and a short
  photo-workflow note; consent is visibly "Not recorded" until its separate
  signed-permission model exists. Review stays read-only. Browser gate proves
  edit persistence plus two real visits in Compare; build, tests, smoke x3
  and UI gate green.
- 2026-08-21 · Full redesign shipped (commit 5b24ac9): home/visit/patient/
  compare/wizard per doctrine; browser UI gate added (commit 7285d06) and
  hardened to the Enter-first flow after catching an obscured-button issue
  in review; 104 tests + smoke x3 + ui-gate green.
