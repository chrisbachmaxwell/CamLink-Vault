# 2026-08-27 — cloud camera revocation foundation

## Decision
Each physical camera gets an independent, random connection profile. A shared
relay host is acceptable; unique username/password and write-only cloud ingest
credential are the authorization and revocation boundary. An Owner can rotate
or disable one stolen camera without interrupting another camera or deleting
photos already stored in the clinical library.

## Delivered source
- SDK `220f584` — cloud-first onboarding, camera registry, direct relay path,
  durable capture direction and Owner camera controls.
- SDK `d846eef` — failure-safe rotation and relay profile persistence ordering.
- Cloud mode does not start the legacy local camera bridge. Existing local
  captures remain untouched; no migration or purge was authorized.
- New profile values are returned once. Clinical records retain hashes; the
  synthetic relay keeps the active binding in an owner-only integrity-checked
  durable envelope so it can recover after a Railway restart.
- FTP success is sent only after the direct job has been atomically written and
  fsynced. Restart restores the queue, and a revoked/held Camera A does not
  block Camera B.
- Rotation provisions the new relay login first, switches the cloud credential
  atomically, then retires the old relay username. A temporary retirement
  failure returns 202 with `retirementPending`; the same activation is an
  idempotent cleanup retry. Disabling a camera removes its relay login and
  cloud credential independently.
- Relay management changes are failure-atomic: a disk failure cannot expose a
  ghost login after a failed PUT or remove a working login after a failed
  DELETE. Symlink, tamper and unsafe-permission envelopes fail closed.
- FTP trace is off by default. Explicit test tracing emits fixed categories,
  not dialogue, filenames, paths, usernames or IP addresses.

## Verification
- Full root build and all workspace tests passed before the final focused
  hardening; clinic reported 85 passed + one expected skip and desktop 25.
- Required PTP simulator, FTP and multi-room smokes passed. Full UI gate passed.
- Final focused gates: relay 34/34, clinical API 17/17, clinical client 8/8,
  cloud domain 10/10; typechecks and diff checks green.
- Independent probes proved restart without re-provisioning, two-camera
  isolation after revoking A, idempotent DELETE, failure-atomic PUT/DELETE, old
  credential rejection after rotation, and the retirement saga:
  first activation 200; rotation 202 pending; retry 200; the correct old relay
  username retired.

## Deployment boundary
The Railway relay volume is attached at `/data` and coordinated variables are
staged, not active. The rotated synthetic relay control token is held outside
source/vault and has not been transmitted to AWS. No v0.19 app or new relay was
deployed in this session.

The current hosted relay is plain FTP and **synthetic photos only**. This work
does not claim HIPAA readiness. Production remains gated on FTPS/TLS, AWS BAA,
eligible-service and threat review, managed secrets, backup/restore/retention/
revocation drills and compliance sign-off.

## Mistake caught
A provider diagnostic exposed the previous synthetic relay pull token and
primary FTP password at the tool boundary. Both were rotated immediately;
replacements were stored only in device Keychain/provider state and are not in
source, commits, this vault or logs. The pending provider configuration must be
deployed only as one coordinated AWS/relay change.
