# Goal: Logins, roles, and the review seat

Status: IN PROGRESS (2026-08-22 — Chris confirmed same day; foundation
being built by agents: server auth layer + camera-first language). Absorbs [[2026-07-clinic-lockdown]]
(Phase C: PIN, audit) as its foundation layer.

Context: Chris (2026-08-22): capture is one job; many team members
review. "Multiple logins and access controls… it would be bad if
someone logs in and creates a patient session and all of a sudden
photos are being saved to there patient." Answer: the room rule —
a login never receives photos, a room does ([[multi-user-model]]).
Constraint: simple, beautiful, Apple-esque ([[design-doctrine]]).

## Done when (verified by:)
- [x] Users store (name, role, PIN hash) + login sessions; every API
      permission-checked by role (verified by: unit tests per role ×
      endpoint class — users-api.test.ts, 10 tests)
- [x] Profile-picker sign-in + signed-in chip + Menu sign-out
      (verified by: ui-gate step 8 signs in as Owner and as Review)
- [x] Review role: library-first home; NO visit/camera controls render
      (verified by: ui-gate asserts start form hidden, menu trimmed,
      camera pill not clickable, server returns 403)
- [ ] Un-pinned device asks "In which room?" once when starting a visit
      with 2+ rooms; pinned devices never asked (verified by: ui-gate)
- [x] Append-only local audit log for visit start/end, patient views,
      held-photo adoption, camera changes — no PHI beyond local ids;
      never pushed anywhere (verified by: unit test + grep gate)
- [x] All existing gates stay green; single-user installs see ONE
      optional owner profile, zero new friction until a second user is
      added (verified by: solo mode sacred — 0 users = no auth
      anywhere; ui-gate pre-login path unchanged)
- [ ] Field: Chris + one teammate use capture and review seats at once
      (verified by: Chris's session)

## Stop clause
If role checks force breaking API changes for existing single-user
installs, stop and redesign for backward compatibility — a solo clinic
must never be forced through login setup.

## Iteration log
- 2026-08-22 — Proposed; design captured; waiting on Chris.
- 2026-08-22 (later) — Chris confirmed (3 roles, PIN); "room" language
  killed; camera chosen at visit start; multi-office direction added.
  Agents building: auth foundation (server) + camera-first UI.
- 2026-08-24 — Sign-in UI SHIPPED in v0.12.0: Apple-TV profile picker
  → PIN pad, People page (Menu → People; adding the first person turns
  access on and makes them Owner), user chip, sign-out, review role
  read-only home. Server auth (UserStore, cookie sessions, role
  matrix, audit.log) shipped v0.11.x. Remaining unchecked: "In which
  room?" prompt is now the "Which camera?" chips (shipped, camera-first
  wave) and the FIELD test — Chris + teammate, two seats at once.
  Multi-office `locations[]` stored but UNENFORCED (needs BAA cloud).
