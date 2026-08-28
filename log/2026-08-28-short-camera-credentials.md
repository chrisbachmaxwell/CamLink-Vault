# 2026-08-28 — short camera-entered credentials

## Decision
Keep every physical camera independently identifiable and revocable, but stop
making staff type machine-oriented strings into the camera keyboard.

## Delivered code
- SDK `c43b75c` changes newly staged camera FTP profiles to a 13-character
  username (`mp-` plus 10 random characters) and a 12-character random
  password.
- The alphabet omits `0`, `1`, `i`, `l`, and `o`. Random generation uses
  rejection sampling; the password retains roughly 60 bits of entropy for an
  online-authentication secret.
- The separate 43-character cloud-ingest credential remains random, internal
  and unchanged. Rotation, stolen-camera revocation, durable relay binding and
  direct AWS routing are unchanged.

## Evidence
- Clinical API typecheck and 37/37 tests passed.
- Relay 34/34, desktop-connect 9/9, control-plane 8/8, clinic 88 passed with one
  expected skip, and the isolated Canon degraded-mode test passed.
- PTP simulator, FTP and multi-room smokes passed; the complete browser UI gate
  passed on its clean rerun. Its first run reached the last relay workflow and
  hit a transient Playwright element-stability timeout.
- A full root test attempt showed the host clock jumping by minutes in unrelated
  timer tests even though wall time was seconds; each reported package passed
  normally in isolation.

## Deployment proof
- Chris privately restored the expired AWS IAM browser session; no credential
  was requested, read or recorded.
- The artifact was uploaded to the existing private synthetic artifact bucket.
  The reviewed CloudFormation change set contained only non-replacing changes
  to `ClinicalApiFunction` and `ApiIntegration`.
- Stack `medphoto-synthetic-clinical-v2` reached `UPDATE_COMPLETE`.
- Deployed Lambda SHA-256 was
  `PqBcraLlGawc+/Y/nZsMiNGFBasSQ4EHKsU+GxBC9h4=`, exactly matching the local
  tested ZIP.
- The live `/v1/health` response was HTTP 200 with
  `{"ok":true,"environment":"synthetic-only"}`.

No camera password, relay token, PHI, filename or provider response is recorded
here.
