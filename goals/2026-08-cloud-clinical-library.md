# Goal: Cloud-authoritative clinical library

Status: IN PROGRESS · Created: 2026-08-27 · Owner: architect + Chris
Constraint: [[hipaa-local-first]] · Decision: [[cloud-authoritative-library]]

## Done when
- [x] Product architecture records cloud as source of truth and retires the
      packaged **Share this library** flow.
- [x] Packaged app always binds loopback and forces the legacy `shareOnLan`
      preference off without touching `captures/`.
- [x] Synthetic clinical domain enforces tenant/location scope, read-only
      reviewers, camera→active-visit routing, unassigned retention,
      idempotency/digest binding, opaque object keys, PHI-free audit facts, and
      recoverable deletion (`@medphoto/clinical-cloud-domain`, SDK `f2ce0a1`).
- [ ] Durable PostgreSQL clinical-store adapter and migrations.
- [ ] Clinical HTTPS API using OIDC subject + durable membership; strict
      per-location authorization and realtime events.
- [ ] Private S3 object adapter and short-lived authorized display access.
- [ ] Synthetic AWS sandbox: Transfer Family FTPS → S3 → ingest event → active
      visit / Unassigned queue; R6 Mark II profile proof.
- [ ] Desktop cloud mode: sign in, location picker, shared patient/visit/photo
      views; no permanent local library.
- [ ] Resumable digest-verified legacy migration; separate human-confirmed purge.
- [ ] Restore, retention, revocation, audit, and incident drills green.
- [ ] Production BAA + eligible-service review + compliance sign-off before PHI.

## Waiting on Chris
- [ ] AWS account/organization access for the synthetic sandbox when the code
      reaches infrastructure deployment. Do not provide long-lived access keys
      in chat; use an invited role or AWS SSO.

## Stop clause
Stop before any real patient record/photo, production cloud deployment, local
library purge, or provider agreement change unless Chris explicitly authorizes
that exact gate. Two no-progress cycles → record the blocker here.

## Iteration log
- 2026-08-27 · Cycle 1: architecture + synthetic clinical domain landed in SDK
  `f2ce0a1`; LAN sharing product surface removed and legacy preference disabled;
  existing captures untouched. Root build/typecheck/tests, PTP/FTP/multi-room
  smoke, UI gate, lockfile dry-run, and diff checks passed.
