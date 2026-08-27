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
- SDK `a40171a` + `a718bef` — fix clean dependency order and scope Railway's
  build to SDK → FTP adapter → relay rather than the full desktop monorepo.
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

## Live synthetic deployment
- With Chris's explicit approval, the rotated relay control token was
  transferred directly from device Keychain into the AWS Lambda environment.
  It did not enter command output, source, commits, this vault or logs; the
  temporary transfer copies were deleted.
- CloudFormation stack `medphoto-synthetic-clinical-v2` reached
  `UPDATE_COMPLETE`; Lambda reported Active/Successful and confirmed the relay
  origin/host/port plus a configured token without revealing it.
- The first two Railway builds failed safely before replacing the live service:
  one exposed a clean-monorepo dependency-order problem and the next omitted
  SDK from the scoped relay build. Commits `a40171a` and `a718bef` fixed those
  gates. Exact deployment `4b758caf-35f9-4b8b-8a5a-763a64bf3841` then succeeded
  from `a718bef` with its `/data` volume and no error-level deployment logs.
- AWS `/v1/health` and authenticated relay `/v1/health` returned OK; the rotated
  primary FTP credential completed login/quit; and a temporary unique camera
  profile was configured and removed through the live management endpoint.
- Exact arm64 v0.19.0 was packaged and published after the backend proof. The
  ZIP SHA-256 is
  `a32fb9892f6057925c8760ea67031c4f0f2efae593662a8eeb65848879509405` and
  the DMG SHA-256 is
  `bf723e1b5d4ee6cc2763d87bcfd6ced1b0f08c0b34ba5a09bded66a5e2e57c86`.
  Archive/version/arm64/code-signature/native-updater gates and DMG verification
  passed. The live Ed25519 manifest verifies and an actual v0.18.16
  updater check reports v0.19.0 available. Release-service deployment
  `1eb9937d-d6b0-4d94-9400-f588dd87eb62` also returns the byte-exact verified
  DMG from the app's no-store latest-installer URL.
- Clean onboarding is conditional by design: an unclaimed clinic is guided
  through organization, location, first Owner and Camera now/later. The current
  synthetic AWS tenant is already claimed, so a new Mac pointed at it leads
  with username/password sign-in and joins the existing clinic.

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
