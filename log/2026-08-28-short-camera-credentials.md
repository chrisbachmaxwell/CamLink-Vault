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

## Deployment boundary
The tested Lambda bundle is ready, but the AWS console session expired and now
shows the private IAM sign-in form. No credential was requested or recorded.
Deploy the existing synthetic stack only after Chris completes that login, then
verify the deployed Lambda digest and health endpoint before field retry.

No camera password, relay token, PHI, filename or provider response is recorded
here.
