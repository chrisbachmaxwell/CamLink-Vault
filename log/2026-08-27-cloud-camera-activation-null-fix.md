# 2026-08-27 — cloud camera activation null-marker fix

## Field report

The model-first camera flow reached AWS and the Railway relay, then displayed
`relay profile activation conflicted`. The same result repeated on v0.19.3.

## Cause

The durable DynamoDB relay-profile record intentionally stores
`activatedAt: null` and `revokedAt: null` while a profile is pending. The
activation transaction required `attribute_not_exists(activatedAt)`. DynamoDB
distinguishes a present null attribute from an absent attribute, so the
transaction deterministically cancelled even though no competing profile had
won.

## Fix and safety

- SDK `a5bc7b4` makes the transaction accept an absent or explicit-null
  activation marker and adds the equivalent revocation fence.
- A Dynamo-command regression asserts the exact condition and null value.
- The full monorepo build/workspace tests and required PTP simulator, FTP,
  multi-room and browser UI gates passed.
- The Lambda artifact was uploaded to the private synthetic code bucket. A
  reviewed change set modified only the Lambda and its API integration, with
  no replacement, and stack `medphoto-synthetic-clinical-v2` reached
  `UPDATE_COMPLETE`.
- The deployed Lambda reports Active/Successful and its code SHA matches the
  locally tested bundle; `/v1/health` returns 200.

The failed attempts had created six empty relay-profile drafts. Before cleanup,
the operation asserted that the current draft had no active pointer and no
dependent visit/photo/upload records. It then idempotently retired the six
relay logins and marked those camera/profile drafts revoked. Post-cleanup state
is zero active camera drafts, zero pending profiles and only the relay's primary
account login. No photo or visit was removed.

No raw FTP password, cloud ingest credential, relay control token, setup code,
patient data or provider response was placed in source, commits, this log or
the project brain.

## Next field step

On the existing camera setup screen, click **Continue** once. The new profile
should activate and display its unique camera-entered host, port, username,
password and folder. That one physical-camera result is still required before
closing the field loop.
