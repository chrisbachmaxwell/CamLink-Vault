# 2026-08-24 — Sign-in ships; the app may never lose a photo again

Clinic app **v0.12.0** pushed (SDK commit `268a311`; v0.11.x commits
`d776d12` auth foundation, `49664f3` camera-first language landed
earlier in the same working session).

## Field incident → decision
Chris onboarded a **Nikon Z8** through the new model-first connect flow
("everything worked great") — then started a visit and no photos came
over. The Railway FTP tracer proved the truth in one look:
`upload complete 4J6A6738.JPG (11270475 B)` — the photo REACHED the
relay and was piped to the app, which threw it away because no visit
was open on that camera. That specific shot is unrecoverable (it was
dropped before the fix); every future one is not.

**Decision (now in [[entities/decisions]]):** a photo that reaches us
can never vanish. No-visit arrivals are filed as a held
"Photo without a visit (<camera>)" session in Unfiled and a
`photoBuffered` event is broadcast (UI affordance for that event is a
later wave — the session itself already shows in Unfiled).

## Shipped
- Never-drop buffer (`captureUnassigned` in server.ts;
  `holdEarlierPhoto` grew a label param; wired for both the default
  connection and named-camera connections).
- Sign-in UI (agent wave 3, sonnet): Apple-TV profile picker → PIN
  pad, user chip, Menu → Sign out, Menu → People (adding the FIRST
  person turns access on and makes them Owner), review role gets a
  read-only home (start form hidden, history visible, trimmed menu)
  with server 403s behind it.
- Camera pill: shows the camera's NAME, click opens Camera setup
  ("the pill is a door"); hidden action for review role.
- Gates: ui-gate step 8 (bootstrap owner "Dr. Chris"/4321, wrong-PIN
  rejection, review "Front Desk"/2222 read-only + server 403);
  smoke multi-room filters "Photo without a visit" sessions out of its
  shared-library assertions. ALL SIX GATES GREEN before push.

## Mistakes caught
- The Z8 drop itself: `connectCamera`'s default-connection handler only
  broadcast `cameraPhoto` and let the photo die when no session was
  active. The relay tracer (built two days ago for the R5 II) is what
  made the diagnosis instant — keep tracers forever.
- Note: relay currently gives ALL cameras ONE shared login, so Z8 and
  R6 III share an identity on relay mode. Per-camera relay accounts
  arrive with the per-clinic accounts / FTPS+BAA milestone.

## Open
- Chris field tests: onboarding flow, sign-in (Menu → People), R5 II
  passive-ON retry (tracer live: `railway logs --service relay`),
  multi-room second body.
- `photoBuffered` UI affordance; per-camera relay logins; Railway token
  deletion by Chris.
