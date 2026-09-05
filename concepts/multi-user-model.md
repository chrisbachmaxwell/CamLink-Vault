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
- **Owner** — camera setup, users + everything below
- **Staff** — start/end visits, adopt held photos + everything below
- **Review** — patients, visits, compare; library-first home; no camera
  or visit controls. Future features (notes, tags, flag-for-doctor,
  export) hang off this seat.
No per-patient ACLs in v1.

Software Update is intentionally outside this role hierarchy: every signed-in
role, and the signed-out desktop shell, may maintain the installed app through its private local desktop
capability. Ordinary browser/LAN sessions do not receive that capability.

## Login UX (cloud-authoritative app)
Every human account uses a normalized email plus password. Clean-clinic setup
creates the first Owner with an email; Owners add Staff/Review accounts by
email; password recovery sends a 6-digit code to the verified email. Passwords
are at least 8 characters and require uppercase, lowercase, a number and a
symbol. A v0.19.0 legacy synthetic username may sign in only to complete the
one-time same-membership email migration; it cannot open library/camera/People
APIs first. The header profile menu contains identity and sign-out.

The earlier local-only PIN picker remains engineering compatibility code for
explicit LAN fixtures, not the downloaded cloud product direction.

## Sign-in recovery and access audit — 2026-09-05
The local live feed is bound to its session token. Enabling the first local
account closes anonymous streams; sign-out and account removal close streams
for the affected sessions. Cloud access loss clears the local session and
returns 401; temporary identity-network failures retain the refresh token for
retry. Losing sign-in closes an open photo viewer, clears setup credentials
from page memory, and removes clinical navigation. Role restrictions remain
403, with owner-only setup and People controls hidden for staff/review.
The private desktop update capability grants no patient, visit or camera API
access. Verified with actual disposable-server HTTP requests, local session
revocation in a browser, cloud client tests and synthetic cloud UI fixtures.
This does not replace cross-device revocation/restore drills. See
[[log/2026-09-05-camera-setup-access-audit]].

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
- Three roles: yes. Cloud human sign-in is email/password; the earlier PIN
  confirmation applied to the retired local-only product direction.
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
