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
- [x] Synthetic clinical HTTPS API using Cognito subject + durable DynamoDB
      membership; strict per-location authorization. Realtime is a 3-second
      app projection refresh for this internal build; push events remain open.
- [x] Private S3 object adapter and short-lived authorized display access.
- [ ] Synthetic AWS sandbox: Transfer Family FTPS → S3 → ingest event → active
      visit / Unassigned queue; R6 Mark II profile proof.
- [x] Desktop cloud mode for the single synthetic location: username/password
      sign-in, Owner-managed reviewer accounts, shared patient/visit/photo
      views and no permanent local photo write. Multi-location picker remains
      open.
- [x] Exact cloud-enabled artifact keeps boot/manual update checks reachable
      before clinical sign-in; updater remains independent of AWS availability.
- [ ] Resumable digest-verified legacy migration; separate human-confirmed purge.
- [ ] Restore, retention, revocation, audit, and incident drills green.
- [ ] Production BAA + eligible-service review + compliance sign-off before PHI.

## Waiting on Chris
- [x] AWS console/CloudShell access supplied for the synthetic sandbox; no
      long-lived access key entered in source, chat, or the vault.

## Stop clause
Stop before any real patient record/photo, production cloud deployment, local
library purge, or provider agreement change unless Chris explicitly authorizes
that exact gate. Two no-progress cycles → record the blocker here.

## Iteration log
- 2026-08-27 · Cycle 1: architecture + synthetic clinical domain landed in SDK
  `f2ce0a1`; LAN sharing product surface removed and legacy preference disabled;
  existing captures untouched. Root build/typecheck/tests, PTP/FTP/multi-room
  smoke, UI gate, lockfile dry-run, and diff checks passed.
- 2026-08-27 · Cycle 2: deployed the tagged synthetic AWS stack (private
  KMS-backed/versioned S3, DynamoDB PITR, Cognito, Lambda + HTTP API), added
  Owner-managed reviewers, fixed upload-grant visit binding, and connected two
  independent app processes. One uploaded synthetic photo was visible and
  downloadable to the reviewer; reviewer mutation returned 403 and the camera
  host wrote zero local photo files. FTPS, multi-location, migration/purge,
  push realtime and every production compliance gate remain open.
- 2026-08-27 · Cycle 3: SDK `9bcc526`; exact v0.18.16 arm64 artifact started
  cloud mode from a fresh profile, rendered username/password sign-in and
  returned an authenticated-independent update check before sign-in. Railway's
  signed manifest pointed to the read-only CloudFront package, whose full
  download matched the signed SHA-256. The private/versioned S3 release bucket
  is separate from clinical storage and explicitly PHI-prohibited.
