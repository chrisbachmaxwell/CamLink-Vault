# Multi-user model — CONFIRMED by Chris 2026-08-22 (build underway)

Chris's second big ask (2026-08-22): two jobs — capture (camera +
patient selection) and review (many team members) — with multiple
logins and access control, without ever mis-filing a photo.

## The load-bearing rule (extends the multi-room decision)
**A login never receives photos — a room does.** Photos file by CAMERA
identity (FTP login = room) into that room's active visit. Reviewers
bind to no camera. The mis-filing scenario Chris fears is structurally
impossible under this rule; the only collision left is two people using
the SAME room, which the turnover banner already mediates.
UI enforcement: an un-pinned device asks ONE question when starting a
visit — "In which room?" (remembered per device); pinned capture
stations never see it.

## Roles (three, resist more)
- **Owner** — camera setup, users, updates + everything below
- **Staff** — start/end visits, adopt held photos + everything below
- **Review** — patients, visits, compare; library-first home; no camera
  or visit controls. Future features (notes, tags, flag-for-doctor,
  export) hang off this seat.
No per-patient ACLs in v1.

## Login UX (Apple-esque, clinic-real)
Profile picker on open (initials/faces, Apple-TV style) → 4–6 digit
PIN. No passwords/email on the LAN app. Header shows a quiet
signed-in chip; sign-out in the Menu. Fast user-switching is the
requirement (shared front-desk devices).

## What it buys besides permissions
The HIPAA audit trail ([[hipaa-local-first]]): who started/ended each
visit, viewed which patient, adopted which held photo, changed which
camera. This absorbs [[2026-07-clinic-lockdown]] (Phase C) — the two
goals merge.

## Build order (when Chris green-lights)
1. Users store + roles + PIN + append-only audit log (server; local
   only, audit never leaves the machine).
2. Profile picker + role-shaped home.
3. Device pinning as a real setting (supersedes the ?room= URL trick).
Concurrent multi-viewer already works (SSE broadcasts) — additive, not
a rebuild.

## Chris's confirmations + amendments (2026-08-22, same day)
- Three roles: yes. PIN sign-in: yes.
- Kill the word "room" everywhere user-facing — cameras are named
  cameras; starting a visit = CHOOSE THE CAMERA (selection chips in the
  Start-a-visit zone; last choice remembered per device; pinned devices
  skip it). Internal `room` ids/APIs unchanged (wire compat).
- Home should not jump straight to patient-typing — it leads with the
  camera choice, then the patient.
- Multi-OFFICE: company → locations; super user sees all; local users
  see only what they're granted. v1: `locations: []` stored on users,
  unenforced; real enforcement + cross-location visibility need the
  BAA cloud ([[roadmap]] FTPS milestone) — local-first stays the rule.
