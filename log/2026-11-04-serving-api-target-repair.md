# 2026-11-04 — Correct the serving API; test patient creation and camera status

## Findings and decisions
Chris reported new-patient failure and that a working camera did not show as
connected. Native testing on installed 0.20.4 reproduced exactly `request
contains an unknown field` using a clearly synthetic record with optional
fields left blank. No missing required information caused the failure.

The app origin `https://7telztga3g.execute-api.us-east-1.amazonaws.com` has six
routes through integration `dfzi9yg`, all targeting
`medphoto-synthetic-clinical-v2-api`. That function's code dated 2026-08-28,
SHA-256 `9545f625db42b1b52e93022f1317afeb69011df947d3211b79a32632c088a0bd`.
The similarly named stack without `-v2` had received the September/earlier
November updates, but was not the installed app's API. This explains rejected
patient fields and absent connection metadata. Prior health/401 probes and
hashes of the wrong function were inadequate deployment proof. Corrected the
owning pages and annotated the affected historical logs rather than erasing
what was actually done.

## Authorized repair
The existing synthetic sandbox only; no production/PHI expansion, new identity,
permissions, credential replacement, storage migration or data deletion.
Chris's existing merge/publish/update authorization continues in this chat.
Applied the already merged and tested 0.20.4 API artifact from SDK `f13b35c`:
SHA-256 `cdf7e016c025e2c5929e3889539a71c18047ac3fe52cf62c0e02f30b8930d372`,
248653 bytes. The immutable S3 object was downloaded and fully hashed before
preparing the update. Previous template and every other parameter were kept.

Stack `medphoto-synthetic-clinical-v2`, change set
`serving-api-0204-20261104`: only `ClinicalApiFunction.Code` and its dependent
`ApiIntegration.IntegrationUri`, both Modify/no replacement. After execution,
stack UPDATE_COMPLETE, Lambda Successful, exact base64 digest
`zffgFsAl4sWSnjiJU5pxwYBHrD/lLPYsDgLzC4kw03I=` and healthy API confirmed.
The original v2 artifact remains available for rollback. The desktop remains
0.20.4; no new installer or version bump was necessary.

## Verification
- Same native registration draft retried after correction: success, patient
  page opened, preferred name retained, zero photos and no visits. Only the
  clearly synthetic record was created. Existing active visit preserved.
- Camera screen changed from Status unavailable to Not connected with last
  completed photo shown separately; the relay independently reported zero
  current camera connections. Chris was asked to leave the camera on and take
  a synthetic photo for physical connection/receipt proof; this is pending.
- Build and all workspace tests pass: 485 passed, one existing skip. PTP,
  FTP, multi-room and browser gates pass; FTP smokes ran sequentially.
- New `infra/aws/clinical-sandbox/verify-target.mjs` checks app origin, stack
  output, physical resources, every clinical integration, successful function
  update and optional exact artifact digest. Four regressions cover sibling
  stack, split routes, old code and in-progress updates. Live negative check
  rejects the wrong sibling stack before touching unrelated resources; the live
  positive check verifies all six routes to the v2 function and the expected hash.
- Native proof and sanitized diagnostics are local only under
  `/Users/chrismaxwell/MedPhoto-Clinical-Diagnostics-20261104/`.

## Delivery state
Owned SDK paths: `infra/aws/clinical-sandbox/README.md`,
`infra/aws/clinical-sandbox/verify-target.mjs`, and
`apps/clinical-cloud-api/test/deployment-target.test.ts`.
Feature commit `c11386ecfb12e09de5ff9ebc93de1f21cd5f1932` on
`codex/patient-registration-status-20261104`. Full local gates passed.
GitHub accepted the commit object but repeatedly rejected creating its branch
ref (`fatal error in commit_refs`; REST `Reference update failed`). PR and
merge of the verifier are pending this remote failure. The actual runtime
repair uses the previously merged 0.20.4 code and is already live.
Vault branch/PR and final physical result will be recorded in this session's
handoff. Second-Mac shared workflow and broader clinical release gates remain
open.
