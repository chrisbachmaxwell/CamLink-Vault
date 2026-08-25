# 2026-08-25 — device-bound Hub access joined end to end

SDK commit `d290a80` was pushed to
`claude/camera-sdk-adapter-pattern-4pj5r8`.

## What changed

- Hub enrollment requests, challenges, and proofs now carry required TLS
  certificate and SPKI SHA-256 pins in their closed schemas and signed bytes.
- Control-plane schema v2 stores the proven Hub device ID, Ed25519 SPKI, and
  both TLS pins. A v1 store with no Hubs migrates atomically; a v1 store with
  Hubs fails with an explicit re-enrollment requirement because v1 has no
  authenticated TLS pins to migrate.
- Authorized native clients POST only their opaque device ID and public-key
  fingerprint to the location-scoped `hub-connections` endpoint.
- The control plane checks durable location membership and returns only active
  Hubs, each with a fresh signed Hub credential/TLS trust and a short-lived
  viewer grant bound to that desktop key.
- The restricted native HTTPS client calls one configured origin and endpoint,
  never follows redirects, bounds/cancels responses, enforces closed scope, and
  never sends the OIDC token to the Hub.
- Issuer key/lifetime/version configuration fails during service construction.
  Request bodies and server headers/requests have explicit deadlines; rejected
  incomplete bodies are disconnected.

## Review and verification

Terra agents implemented the TLS-pin signature chain and native HTTPS client.
The independent reviewer repeatedly exercised wrong location, revoked Hub,
pin substitution, stale material, response expansion, invalid issuer, body
stall, and response-cancellation cases. Findings were fixed and made regression
tests before push. The final remaining malformed-content-type keep-alive case
is covered by a raw socket regression in the control-plane suite.

- Full `npm run build`, `npm run typecheck`, and `npm test` — green.
- Hub identity 10 tests, clinic control plane 11, control-plane service 8,
  desktop connector 9 — green.
- PTP simulator, FTP, and multi-room smoke flows — green.
- Full browser-driven `ui-gate` — green.
- `git diff --check` — green.

## Remaining boundary

This still does not create a second-computer installable product. Native macOS
implementations are required for OIDC authorization-code/PKCE, Keychain-backed
device identity, mDNS, live TLS peer evidence, and the app window/daemon. The
clinic Hub must serve its real read routes through the HTTPS authorization
boundary. Signed updates still need an embedded production key, notarized
package verifier, atomic installer, and route migration off Git. Cross-location
patient/photo access still waits for the separately approved BAA-backed data
plane.
