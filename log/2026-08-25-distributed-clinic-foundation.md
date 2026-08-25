# 2026-08-25 — distributed clinic security foundation

## Decision

The multi-computer/multi-location product is split into three boundaries:

1. one local Capture Hub per location remains the only writer of camera files;
2. a narrow non-PHI control plane holds opaque organization/location/identity/Hub authorization records;
3. a future BAA-backed clinical data plane is required before photos or patient records leave a location.

The existing prototype relay is not that clinical data plane. Patient builds
now disable all external relay setup/probe/info paths unless the explicit
`MEDPHOTO_ALLOW_TEST_RELAY=1` synthetic-test capability is present. The prior
hard-coded shared relay token was removed.

## Shipped checkpoint

SDK commit `de29c19` (pushed to
`claude/camera-sdk-adapter-pattern-4pj5r8`) adds:

- strict non-PHI organization/clinic/location membership authorization;
- Ed25519 Hub identity, signed proof-bound single-use enrollment, replay and
  revocation-version contracts;
- privacy-safe local Hub discovery matching an authorized enrolled key;
- a fail-closed non-PHI HTTP service for verified OIDC subjects, location/Hub
  listing, enrollment-code issuance, proof redemption, and signed Hub device
  credentials;
- closed-schema/durable-store tests, cross-location denial, expiry/replay/race,
  body-limit, no-PHI response, and credential-verification coverage;
- camera-controlled filename containment, case-insensitive collision handling,
  `.thumb.jpg` reservation, no-clobber filesystem writes, legacy-manifest
  containment, and DOM-safe test-shot rendering;
- opaque-ID audit lines and filename/path-free runtime logging;
- hermetic announcer tests using an injected ephemeral SSDP port while
  production remains fixed to Canon's port 1900.

The independent reviewer first reproduced a mutable-return authorization
escalation and several enrollment/filename gaps. Those were fixed and added as
regressions before the checkpoint. Final independent focused review found no
remaining defect in this slice.

## Verification

- `npm run build` — green.
- `npm run typecheck` — green.
- `npm test` — green across every workspace while Spotify and the already
  running clinic app continued to hold UDP 1900.
- `node apps/clinic/test/smoke.mjs ptp-simulator` — green.
- `node apps/clinic/test/smoke.mjs ftp` — green.
- `node apps/clinic/test/smoke.mjs multi-room` — green.
- `node apps/clinic/test/ui-gate.mjs` — green.
- `node apps/clinic/test/hard-rule-guard.mjs` — green.

## What this does not yet promise

This is not yet a downloadable distributed desktop app. The actual Capture Hub
still needs enrolled-device HTTPS/TLS enforcement and the native app must wire
OIDC sign-in, control-plane membership, mDNS discovery, and public-key pinning.
Remote photo access/sync remains disabled until a provider, executed BAA,
encryption/key design, retention policy, and recovery drill are approved. The
Railway release service is live for non-PHI release delivery only; Check for
updates still needs the signed release client/installer integration.

