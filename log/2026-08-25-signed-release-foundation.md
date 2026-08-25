# 2026-08-25 — Signed release manifest foundation

Chris approved the product promise: every location keeps capturing offline;
authorised staff eventually share patient history across locations.

## Shipped now (non-PHI only)

- SDK commit `33b2751` adds `@medphoto/release-manifest`, a pure release
  metadata validator with no network, file, clinic, device, patient, visit,
  image, or capture-path access.
- Manifests are closed-schema and Ed25519-signed. The verifier rejects a
  wrong key type, unsigned/tampered metadata, malformed values, invalid
  calendar timestamps, bad hashes and version comparisons that could lose
  precision.
- `docs/DISTRIBUTED-CLINIC-ARCHITECTURE.md` records the enforced separation:
  Capture Hub per location, future clinical data plane, and non-PHI release
  service. Current Cloud Relay is not approved for patient data.

## Not shipped / explicit gate

No patient data leaves a location. Multi-location patient sharing is blocked
until a BAA-backed provider, retention policy, threat model, deployment
authority, and compliance review are approved. The current server also needs
the Clinic Lockdown safeguards before it is a shared-LAN Hub.

## Verification

- Clean install dry run, root build and root typecheck: green.
- Release-manifest unit tests: 7/7 green.
- Clinic smoke: ptp-simulator, ftp, multi-room: green.
- Browser UI gate: green.
- Whole-workspace `npm test` remains environment-red in the already documented
  UDP-1900 announcer tests and macOS `127.0.0.2` reconnect test; the new
  package and relevant clinic tests pass.
