# Goal: Clinic lockdown (Phase C — HIPAA technical safeguards)

Status: PLANNED (after [[2026-07-patient-records]]) · Created: 2026-07-09
Grounding: [[hipaa-local-first]] — safeguards, not compliance claims.

## Why
Before real patient data: control who can open the app, keep PHI off the
open network, make loss/theft survivable, and leave an audit trail.

## Design sketch
- **Network posture**: server binds 127.0.0.1 by default (TODAY IT LISTENS
  ON ALL INTERFACES — fix). Optional `--lan` flag for front-desk-on-another-
  machine setups, which then REQUIRES the PIN. Camera traffic stays on the
  LAN by nature of PTP/IP.
- **Access**: simple front-desk PIN (argon2/scrypt-hashed locally) gating
  the UI; auto-lock after configurable idle minutes.
- **Audit log**: append-only local file — app opened/unlocked, visit
  started/ended, exports/deletions, with timestamps.
- **At rest**: document FileVault as the baseline; add an optional
  app-level encrypted store to the roadmap (do NOT hand-roll crypto in
  this goal — document + verify FileVault, wire the audit).
- **Backups**: docs page — LAN NAS via Time Machine/rsync, never cloud
  sync on the captures folder.
- **No-cloud guarantee**: automated test greps the clinic app for outbound
  hosts; CI fails if any non-LAN endpoint appears.

## Done when (agent-verifiable)
- [ ] Default bind is localhost; `--lan` documented and PIN-gated (tests)
- [ ] PIN setup/unlock/auto-lock implemented with tests (hashing, lockout
      after N failures)
- [ ] Audit log writes the listed events; tested; documented location
- [ ] No-cloud CI check in place and green
- [ ] `docs/CLINIC-DEPLOYMENT.md`: FileVault, backups, screen lock,
      retention pointers, "safeguards ≠ compliance" disclaimer
- [ ] All three gates green; pushed; vault pages updated

## Waiting on Chris
- [ ] Decide: front desk on the same machine, or second machine (→ --lan)?
- [ ] A compliance-savvy advisor reviews docs/CLINIC-DEPLOYMENT.md before
      any real clinic pilot

## Stop clause
Max 12 cycles, or 2 consecutive no-progress cycles → BLOCKED + log why.

## Iteration log
