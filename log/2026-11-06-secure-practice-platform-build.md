# 2026-11-06 — secure practice platform implementation

Chris said “build it all” after accepting physical R6 II FTPS speed and requiring
independent practice infrastructure. Production AWS/BAA setup remains deferred;
synthetic-only work proceeded in isolated worktrees, preserving legacy FTP.

## Implemented

- Dedicated CloudFormation generator: separate API/identity/database/bucket,
  KMS key, VPC, private management ALB, FTPS receiver, scoped secrets and DNS.
  Office-only /32 FTPS control/passive ingress. No public plain FTP listener.
- Hosted receiver authenticated-encryption spool, scoped receipt validation,
  bounded admission and fail-closed encrypted recovery; legacy mode unchanged.
- Offline practice root/leaf issuance, same-root leaf renewal, validated secret
  rotation preflight/explicit apply and app authenticated ROOT.CER download.
- Signed expiring desktop practice enrollment with scope/rollback checks and
  expiry recovery preserving the prior practice identity.
- Secure receiver library and runnable Canon pilot: encrypted queue, digest
  receipts, retry/deduplication, one-use pairing, RSA-bound credential renewal,
  camera revocation, heartbeat and separate app connection/delivery states.
- Mac Keychain/Linux Secret Service provider; protected-file test fallback.
  Existing identity plus missing vault key blocks creation of a replacement key.
- Exact Canon R8/R8 II official manual links and receiver instructions. The R8 II
  is a real documented model; corrected the prior “verify identity” uncertainty.

## Mistakes caught and boundaries

- Fixed ALB health check that would incorrectly require a management credential.
- Fixed expired desktop enrollment losing its scope/rollback comparison context.
- Serialized queue admission/downloads; sticky backpressure warnings; receipt
  mismatch cannot delete photos; retained encrypted crash records fail closed.
- Browser tests updated because receiver models are now supported by the pilot
  flow, and certificate-download controls make an otherwise empty panel visible.
  Explicit assertions still forbid exposing passwords on the certificate step.
- Pairing failures after camera creation now preserve the saved camera and
  explain recovery instead of inviting duplicate creation.
- No AWS launch, secret mutation, real photo upload or Mac install in this work.
  Existing installed version remains 0.20.7. No HIPAA readiness claim.
- Remaining: managed receiver installer/signed update integration, host access
  and key recovery proof, exact-model hardware/power/backlog drills, two deployed
  stacks' isolation, operational alarms/renewal scheduling and compliance review.

## Delivery evidence

SDK feature commits e0a479f and 018b0fb, PR30:
https://github.com/chrisbachmaxwell/CamLink-SDK/pull/30
All six local gates passed on the final source: full build, every workspace
test, PTP/FTP/multi-room smoke and full browser UI gate. Added browser proof
covers the FTPS certificate download and R8 II receiver pairing steps.
Generated template passed cfn-lint and structure tests. Offline certificate
initialization and same-root renewal passed. GitHub Node20/22 CI both passed on 018b0fb. SDK PR30 merged to main as
7767bad13de2e3195a023c7adda6313353532add. No deployment or desktop release.
Vault evidence is delivered through PR43.
