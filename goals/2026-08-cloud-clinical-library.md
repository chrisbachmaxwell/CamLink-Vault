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
- [ ] Synthetic direct camera sandbox: the durable Railway bridge and AWS API
      contracts are live with unique per-camera credentials, staged rotation
      and independent theft revocation. Two-camera/R6 Mark II field proof, then
      FTPS/TLS replacement remain open.
- [x] Guided physical-camera setup with truthful proof: enter the provisioned
      values, take a test photo, and claim verified only after that exact
      camera's checksum-verified completed cloud upload.
- [x] Desktop cloud mode for the single synthetic location: email/password
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
- 2026-09-01 · SDK `9bc5ee7` implements the selected 15-minute cloud visit
  inactivity boundary with a one-minute warning and **Keep visit open** reset.
  Expiry is enforced at tenant-scoped visit reads and camera upload grants, so
  a later photo remains unassigned even if the browser is closed or offline;
  the visible patient screen also signs out at its deadline. Staff can reopen
  the same automatically or manually ended visit when its patient/camera locks
  are free, then explicitly add eligible same-camera photos received while it
  was ended or leave them in Needs assignment. Lifecycle operations are
  audited without PHI, and Dynamo assignment/reopen writes are transactionally
  fenced. Root build/tests, all required PTP/FTP/multi-room/UI gates, focused
  boundary/API/domain/client/Dynamo tests, JS syntax and diff checks passed.
  Commit is pushed to the legacy feature branch only; `main` integration,
  synthetic AWS deployment, desktop package/sign/release and two-Mac field
  proof remain open.
- 2026-08-28 · Follow-up: a field report showed a new cloud login silently
  opening the current shared visit. SDK `6d314bc` merged through PR 11 as
  `02c27d8`; cloud sign-in now lands on Home and leaves each shared visit under
  In progress until the user chooses Open. One camera remains automatic; two
  or more show Which camera on Home and the patient page. Root build/tests,
  PTP/FTP/multi-room smokes, browser UI gate and Node 20/22 CI passed. Exact
  arm64 v0.19.9 is now live through the signed Railway manifest, immutable
  CloudFront ZIP and no-store direct DMG. The full public bytes match the
  locally verified SHA-256 values recorded in
  [[log/2026-08-28-home-on-login-v0199-release]]. Exact two-Mac field proof
  remains open.
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
- 2026-08-27 · Cycle 4: SDK `220f584` + `d846eef` + `a40171a` + `a718bef`;
  fresh cloud clinic setup,
  direct camera registry, unique per-camera relay and cloud credentials,
  owner-only rotation/revocation, durable pre-ack relay spool, restart recovery,
  failure-atomic binding changes and cross-camera scheduling landed. Full root
  build/workspaces, PTP/FTP/multi-room smokes and UI gate passed; final focused
  gates were relay 34, API 17, client 8, domain 10, clinic 85 + one expected
  skip, desktop 25. Independent failure injection and a pending-retirement retry
  saga passed. The approved rotated control token was transferred directly into
  AWS without entering source/vault/logs. CloudFormation reached
  `UPDATE_COMPLETE`; Railway deployment `4b758caf-35f9-4b8b-8a5a-763a64bf3841`
  succeeded with the `/data` volume. Both health endpoints, rotated primary FTP
  authentication and a live unique-profile create/remove probe passed. The
  At the end of this backend cycle, the v0.19 Mac app remained unpublished.
  Synthetic relay transport is still plain FTP and must not carry PHI.
- 2026-08-27 · Cycle 5: packaged and published exact arm64 v0.19.0. ZIP
  SHA-256 `a32fb9892f6057925c8760ea67031c4f0f2efae593662a8eeb65848879509405`
  passed archive, version, architecture, code-signature and native-updater
  verification; DMG SHA-256
  `bf723e1b5d4ee6cc2763d87bcfd6ced1b0f08c0b34ba5a09bded66a5e2e57c86`
  passed `hdiutil verify`. The signed Railway manifest is live and an actual
  v0.18.16 client check reports v0.19.0 available. Final release-service
  deployment `1eb9937d-d6b0-4d94-9400-f588dd87eb62` serves the no-store latest
  arm64 DMG with the exact verified hash. The app guides only an unclaimed
  clinic through organization/location/first-Owner and Camera now/later;
  existing clinics correctly start at username/password sign-in. Developer ID
  signing/notarization remains the first-install Gatekeeper gate.
- 2026-08-27 · Cycle 6: SDK `27d1ce1` made clinic setup, People and sign-in
  email-first, added non-enumerating email-code password recovery and a
  mandatory same-membership migration for legacy usernames. SDK `6f6dd70`
  lowered the password minimum from 12 to 8 everywhere while retaining upper,
  lower, number and symbol checks. Cognito reports `MinimumLength: 8`; the
  reviewed change set modified Lambda/API/IAM/UserPool with no replacements
  and reached `UPDATE_COMPLETE`. Exact arm64 v0.19.2 is live through the signed
  Railway manifest, immutable CloudFront ZIP and no-store DMG pointer. Full
  workspace tests, PTP/FTP/multi-room smokes and the UI gate passed.
- 2026-08-27 · Cycle 7: field screenshots caught Settings routing a cloud
  clinic into the retired manual relay address/token page. SDK `df96174` guards
  both Settings and a stale relay-tile click, returning cloud installs to the
  model-first flow that provisions unique camera credentials automatically.
  Exact arm64 v0.19.3 is live through signed Railway deployment
  `c374dc68-9306-4d54-bd1d-a938398b5345`; full workspace tests, required
  PTP/FTP/multi-room smokes and browser UI gate passed.
- 2026-08-27 · Cycle 8: field setup exposed a DynamoDB condition mismatch:
  staging persisted nullable activation/revocation markers, but activation
  required the marker to be absent. SDK `a5bc7b4` accepts either absent or null
  pending markers and fences revocation; a new Dynamo-command regression plus
  all workspace tests and required PTP/FTP/multi-room/UI gates passed. The
  reviewed Lambda/API-integration-only change set reached `UPDATE_COMPLETE`,
  deployed SHA matched the local bundle, and API health returned 200. Six
  failed empty profile drafts and their relay logins were retired after a
  zero-dependent-record assertion. Current synthetic state has zero active or
  pending camera drafts; one clean physical-camera retry remains the field
  proof. No secret or PHI entered source, output notes, or the vault.
- 2026-08-28 · Cycle 9: SDK `c43b75c` shortens only the camera-entered relay
  values to a 13-character username and 12-character unambiguous password.
  The 43-character cloud-ingest credential remains hidden and unchanged, and
  profiles remain unique, rotatable and independently revocable. API, relay,
  clinic, isolated Canon timer regression, PTP/FTP/multi-room smokes and the
  complete browser UI gate passed. One root run showed the known host-clock
  jump in unrelated timed tests; every affected package passed in isolation.
  After Chris privately restored the AWS session, the reviewed Lambda/API-only
  change set reached `UPDATE_COMPLETE`; deployed digest matched the tested
  bundle and the live synthetic health endpoint returned 200.
- 2026-08-28 · Cycle 10: SDK `f9531c8` and live arm64 v0.19.4 add the guided
  values → test-photo → verified sequence. Cloud completion stores durable
  per-camera upload evidence; an older photo cannot satisfy a newly opened
  setup test; the received synthetic image is shown as proof and otherwise
  retained in Unassigned. The disable notice now expires after five seconds.
  Full workspace build/tests, PTP/FTP/multi-room smokes and the browser UI gate
  passed. The reviewed AWS update reached `UPDATE_COMPLETE`. The signed live
  manifest, streamed CloudFront ZIP, no-store DMG and exact native updater all
  verified as v0.19.4. Physical R6 Mark II and two-camera field proof remain.
- 2026-08-28 · Cycle 11: field screenshots proved a split-brain case where a
  stale Dynamo camera lock rejected Start visit while Home showed no active
  visit, and the resulting generic amber message followed the user across all
  screens. SDK `7c0d11f` repairs only an exact stale lock, preserves a
  concurrent replacement, retries once, and returns a validated active-visit
  summary for real conflicts. Notices are now dismissible, timed and scoped to
  their originating view. PR 7 and Node 20/22 CI passed, as did the full local
  build/tests, PTP/FTP/multi-room smokes and UI gate. AWS reached
  `UPDATE_COMPLETE` with live health 200. Signed arm64 v0.19.5 is live through
  Railway and immutable CloudFront package SHA-256
  `2fa83cd6ca4c3d310bec1576a40961a276a4231d520672684005ccbbb61e2af7`.
  Two-Mac field confirmation remains open.
- 2026-08-28 · Cycle 12: a clean second Mac proved the pre-v0.19.7 native
  verifier invoked the `lipo` Xcode shim, prompting for Command Line Tools and
  safely rejecting the update. SDK `d416ab8` merged through PR 9 as main `9941b0f`;
  v0.19.7 reads the exact no-follow Mach-O header instead. Software Update is
  now visible and usable by Owner, Staff and Review only through the packaged
  app's private loopback capability; browser/LAN role restrictions remain.
  Full root build/tests, required PTP/FTP/multi-room/UI gates and Node 20/22 CI
  passed. The exact signed live ZIP and no-store DMG streamed with the hashes
  recorded in [[log/2026-08-28-clean-mac-updater-v0197]]. An affected
  v0.19.5/v0.19.6 Mac needs one direct-DMG recovery; future updates from
  v0.19.7 do not require developer tools.
