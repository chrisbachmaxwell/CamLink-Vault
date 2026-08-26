# 2026-08-26 — Mac bootstrap recovery and durable release storage

## Field report

The first Railway download on another Mac passed the user's Gatekeeper
**Open Anyway** step but appeared to bounce in the Dock without opening.
No patient data was involved.

## What the reproduction proved

- The exact live v0.18.6 arm64 ZIP matched its signed SHA-256, had the correct
  bundle ID/version/architecture, and passed deep/strict code-sign checks.
- A Safari-quarantined copy was rejected before the Med Photo process began.
  Clearing quarantine on the isolated test copy made the same bytes launch
  and reach a fresh local v0.18.6 state.
- The immediate internal-test bootstrap remains: put the app in
  `/Applications`, approve it explicitly, and if necessary clear quarantine
  on that exact bundle. This is not the public distribution solution;
  Developer ID signing/notarization remains the required gate.

## Shipped

SDK `b231454`, Med Photo v0.18.7:

- creates and shows a small **Starting Med Photo** window before starting the
  packaged clinic service, so the Dock no longer bounces with no explanation;
- races clinic readiness against an early child exit and keeps a visible
  **Med Photo could not start** recovery screen instead of quitting silently;
- writes updater restart health proof only after the real clinic page loads,
  preserving rollback if the renderer itself is broken;
- retains the existing context-isolated, sandboxed, no-Node renderer boundary;
  startup/recovery pages are script-free with a restrictive CSP.

An independent agent tested the exact final v0.18.7 ZIP, a clean Launch
Services profile, and a temporary copy with its bundled server deliberately
moved aside. The healthy copy reached v0.18.7; the broken copy stayed open
with the recovery window.

## Railway migration

Preserving two arm64 ZIPs in a single source upload crossed Railway's upload
gateway limit. Dropping old immutable package URLs was rejected as a shortcut.
A 50 GB Railway volume is now mounted at `/data`; the release service reads
`/data/releases`. It contains signed manifests and packages for both
v0.18.6 and v0.18.7. Live verification:

- `/healthz` 200;
- latest arm64 manifest v0.18.7 verifies with the embedded Ed25519 public key;
- streamed v0.18.7 package SHA-256 matches the signed manifest;
- the old v0.18.6 package URL still returns 200 with immutable cache headers;
- the installed v0.18.6 app reported one update and completed a live
  v0.18.6 → v0.18.7 self-update/restart with no active visit.

## Gates

- root build, typecheck and every workspace test green
- clinic tests: 71 passed / 1 expected skip; desktop: 17; release service: 10
- PTP simulator, FTP, multi-room and test-relay smokes green
- browser UI gate green
- final package archive, signature, version, architecture, fresh launch and
  forced-startup-failure checks green

## Still open

- Apple Developer ID signing + notarization for a normal first download
- final x64/Intel artifact publication and a real Intel-Mac gate
- the separate multi-computer shared-data/Capture Hub viewer promise
