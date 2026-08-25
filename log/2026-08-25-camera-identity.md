# 2026-08-25 — Camera identity: v0.16.0 → v0.16.2, relay redeployed twice

Session goal: [[goals/2026-09-camera-identity]] (born and shipped today).
Decisions logged in [[entities/decisions]] (identity-over-dates,
per-camera relay sign-ins / registration = first sign-in).

## What shipped (all six gates green before every push)
- **v0.16.0** (5ca3b6f): identity over dates (the in-visit EXIF hold is
  gone — WHICH camera sent a photo is the fact to trust, never WHEN the
  camera claims it was taken; EXIF now only teaches clock offsets,
  shown as advice); serial binding on first photo + mismatch banner
  (never blocks a store); per-camera relay sign-ins (PUT /v1/cameras,
  X-Camera-User routing, per-login presence, idempotent app→relay
  sync); registration = first sign-in (new cameras "waiting", hidden
  from the picker; existing rooms grandfathered). Relay redeployed.
- **v0.16.1** (4a93b29): field defect within the hour — one live
  camera lit EVERY camera green: the default camera read the relay's
  account-level AGGREGATE presence. /v1/health now carries the primary
  login's own row + `primaryUser`; the app reads the primary's own row.
  Regression pinned in adapter + relay tests. Relay redeployed again.
- **v0.16.2**: Chris's field pass gaps — (1) photoBuffered had NO UI
  (photos on a visit-less camera saved but INVISIBLE → "photos aren't
  being added"); now a banner offers one-click adoption into the open
  visit. (2) Patient-page "Which camera?" ask now covers relay mode
  (was silently defaulting). (3) Ending a visit with photos lands on
  the patient's record; done card only for empty/name-only visits.

## Mistakes caught (write them down so they stay caught)
- The v0.16.0 build agent DIED SILENTLY ~2 h in with the tree complete
  and no completion report — the work sat idle until Chris nudged.
  Verified the finished tree independently (all gates + line review)
  before shipping. Lesson: a quiet agent is a stalled agent — check
  the tree, not the notification.
- The "compat aggregate" presence signal became a NEW reader's default
  and lied within hours of shipping. Lesson: aggregates exist for OLD
  readers only; every new reader gets the specific signal.
- The gate caught a real race I introduced: sessionEnded (broadcast)
  ran the new end-navigation and yanked pages mid-turnover. Navigation
  now belongs ONLY to the user's own End click (design doctrine:
  never auto-navigate away from the user).
- `pkill -f <script>` matched my own shell's command line and killed
  it. The port-cleanup rule ("kill by port, never pkill") exists for a
  reason; for processes, `pgrep -f "[b]racketed"` avoids self-match.

## Infrastructure notes
- The evening-long git transport outage ENDED mid-session: first push
  answered with a real "fetch first"; reconciled (v0.15.0 API commits
  had identical trees), rebased, pushed. All later pushes normal git.
- Vault remote renamed upstream: pushes answer "This repository moved →
  CamLink-Vault.git" but succeed via redirect. Consider updating the
  local remote URL next session.
- Railway relay deployed twice from the scratchpad worktree (token
  still valid — Chris should still rotate/delete it: it was pasted in
  chat once and is treated as burned).

## Open
- Chris's field pass: add the R6 III as its own camera (own relay
  sign-in), first photo binds its serial, photos file into ITS visit,
  ending lands on the patient record.
- R5 Mark II relay transfer (passive-mode suspect) unchanged.
- FTPS + BAA milestone unchanged (relay stays TEST PHOTOS ONLY).
