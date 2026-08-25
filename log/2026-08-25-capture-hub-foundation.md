# 2026-08-25 — Capture Hub LAN foundation

## Decision

One computer owns the local `captures/` library and camera connections. Other
office computers view and operate that Hub over the LAN; they do not mount or
replicate the capture folder. Multi-location cloud synchronization remains a
later, separate security boundary.

## Shipped in the SDK

- Localhost-only HTTP listener by default.
- Explicit `--lan`, refused before the first local owner/PIN exists.
- Plain-language startup instructions and `docs/CLINIC-DEPLOYMENT.md`.
- Signed-out `/api/state` contains only non-PHI boot metadata; live SSE and all
  patient routes require a session.
- Public profile picker omits location and credential fields.
- scrypt PIN storage; compatible migration from legacy SHA-256 after a valid
  sign-in.
- Five attempts per source/profile followed by a one-minute lock; reservations
  happen synchronously so concurrent guesses do not bypass the cap.
- 64 KiB JSON body ceiling before login verification.

## Verification

- Repository build: green.
- Focused Capture Hub/auth/security tests: 19/19 green.
- PTP simulator, FTP and multi-room smoke gates: green.
- Browser UI gate: green, including auth roles and multi-camera flows.
- Independent attack test: 20 concurrent wrong PINs produced five 401s then
  fifteen 429s; a correct PIN remained blocked during the lock; signed-out
  state/events leaked no patient/session/camera credential data.
- Full `npm test`: all relevant suites green; only the already-documented
  macOS environment failures remained (UDP 1900 contention and unavailable
  `127.0.0.2` loopback alias).

## Boundary / next

This is a pre-pilot foundation, not a HIPAA compliance claim. Plain HTTP can be
observed on a LAN, so `--lan` must not carry real patient data until TLS/device
enrolment ships. Then add idle auto-lock and finish the Phase C audit,
no-cloud, FileVault and backup gates.
