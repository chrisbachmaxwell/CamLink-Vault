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
- [ ] Users store (name, role, PIN hash) + login sessions; every API
      permission-checked by role (verified by: unit tests per role ×
      endpoint class)
- [ ] Profile-picker sign-in + signed-in chip + Menu sign-out
      (verified by: ui-gate signs in as Staff and as Review)
- [ ] Review role: library-first home; NO visit/camera controls render
      (verified by: ui-gate asserts absence)
- [ ] Un-pinned device asks "In which room?" once when starting a visit
      with 2+ rooms; pinned devices never asked (verified by: ui-gate)
- [ ] Append-only local audit log for visit start/end, patient views,
      held-photo adoption, camera changes — no PHI beyond local ids;
      never pushed anywhere (verified by: unit test + grep gate)
- [ ] All existing gates stay green; single-user installs see ONE
      optional owner profile, zero new friction until a second user is
      added (verified by: existing ui-gate path unchanged pre-login)
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
