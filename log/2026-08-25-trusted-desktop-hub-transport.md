# 2026-08-25 — trusted desktop and Hub transport checkpoint

## Shipped checkpoint

SDK commit `920baa2` was pushed to
`claude/camera-sdk-adapter-pattern-4pj5r8`. It adds the security-critical
contracts between the earlier non-PHI control plane and a future packaged
native Mac app:

- strict issuer/audience/JWKS OIDC verification with bounded fetch/cache,
  rotation, time, algorithm, RSA strength, and unknown-key behavior;
- native Ed25519 client identity, signed short-lived viewer/operator grants,
  canonical request signatures, fresh revocation floors, and durable replay;
- Hub TLS trust bound to both live certificate and SPKI fingerprints;
- an HTTPS-only Hub request boundary with exact method/path/query/body binding,
  role checks, bounded headers/bodies, and header/request/body deadlines;
- native orchestration for verified token → authorized location/Hub list →
  privacy-safe mDNS match → live pinned TLS → signed Hub request, while never
  sending the OIDC token to the Hub;
- a signed release client with bounded no-identity downloads, active-visit
  deferral, immutable exact-inode staging, hash/platform-signature rechecks,
  and atomic installer/health/rollback interfaces;
- a clinic-facing release bridge that returns only fixed display-safe states;
- a strict one-Bearer-token adapter for the control-plane HTTP service.

## Mistakes caught before push

Independent adversarial review reproduced three stop-ship races:

1. a signature verifier could unlink and replace a downloaded package pathname
   after a valid inode was checked;
2. a malformed signed-request header could bypass body deadlines and hold a Hub
   socket open;
3. a native dependency ignoring `AbortSignal` could hang the desktop connector
   forever.

The code now keeps the verified update inode open through publication and
compares the published inode/hash, destroys incomplete rejected Hub bodies,
and races native calls against an actual rejecting deadline. The reviewer
re-ran direct reproductions: replacement rejected with `SHA256_MISMATCH`, the
malformed stalled TLS request was destroyed in milliseconds, and the ignored
abort rejected at its configured deadline.

## Verification

- `npm run build` — green.
- `npm run typecheck` — green.
- `npm test` — green across all workspaces (the Linux-only 127.0.0.2
  address-move scenario is explicitly skipped on macOS because it requires a
  privileged loopback alias; ordinary and mid-visit reconnect tests pass).
- `node apps/clinic/test/smoke.mjs ptp-simulator` — green.
- `node apps/clinic/test/smoke.mjs ftp` — green.
- `node apps/clinic/test/smoke.mjs multi-room` — green.
- `node apps/clinic/test/ui-gate.mjs` — green.
- Independent focused retest — release client 14/14, Hub boundary 9/9,
  desktop connector 5/5, builds/typechecks/diff check green.

## Exact remaining boundary

This does not yet make another-computer installation usable. The desktop
orchestrator still needs native macOS implementations for OIDC login, mDNS,
live TLS evidence, and secure key storage. The control plane must atomically
register current Hub TLS pins and issue scope/device-bound short-lived grants.
The clinic server must expose its actual routes through the new HTTPS boundary.
Check for updates still uses the legacy Git path until a production public key,
notarized package verifier, atomic native installer, and signed Railway release
artifacts exist. Cross-location patient/photo access remains disabled until the
separate BAA-backed clinical data plane is selected and approved.
