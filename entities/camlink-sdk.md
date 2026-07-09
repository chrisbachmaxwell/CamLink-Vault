# CamLink SDK (the product)

Repo: `chrisbachmaxwell/CamLink-SDK` · branch `claude/camera-sdk-adapter-pattern-4pj5r8` (default)
Owner: Chris Maxwell (non-technical founder). Built with Claude Code, July 2026.

## What it is
A TypeScript monorepo delivering camera connectivity as a platform: apps talk
to `@camlink/sdk`; vendor protocols hide behind the [[adapter-pattern]].
Photos taken on a connected camera stream into the consuming app and file
into per-patient session folders.

## Monorepo map (2026-07-09)
- `packages/sdk` — core: `CamLinkClient`, `CameraAdapter`/`CameraConnection`
  interfaces, `CaptureSession` (patient folders `[prefix/]<patient>/<timestamp>/`,
  download retry queue w/ exponential backoff, `retryFailed()`, manifest.json
  with SHA-256, multi-camera filename dedup), storage providers (fs + memory).
- `packages/ptp` — PTP/IP protocol: codec (LE reader/writer, fragmentation-safe
  packet assembler), `PtpIpTransport` (two-socket init handshake, serialized
  transactions), constants (see [[eos-event-records]]).
- `packages/adapter-canon-ptp` — the flagship adapter: [[eos-utility-pairing]]
  announcer, diagnostics w/ [[session-handoff]], LAN scanner, full simulator.
- `packages/adapter-canon` — CCAPI adapter + simulator (see [[canon-ccapi]], parked).
- `packages/adapter-mock` — dev adapter, ships first per original spec.
- `packages/adapter-cert` — certification suite (9 checks) any adapter must pass.
- `packages/cli` — `camlink doctor|certify|shoot|find|simulate`
  (`--protocol ptp|ccapi`; GUID persisted in `~/.camlink.json`).
- `apps/clinic` — see [[clinic-app]].
- `examples/clinic-capture` — minimal SDK consumer.
- `native/CamLinkKit`, `native/camlink-android` — scaffolds only (M2 pending).
- `docs/` — ARCHITECTURE, ROADMAP, HARDWARE-TESTING (the field bible), PTP-PLAN
  (USB tether design).
- CI: GitHub Actions — build + 67 tests + clinic-app smoke (ptp-simulator & ccapi-simulator).

## Key invariants
- Consumer code NEVER imports a vendor SDK/protocol — only `CameraAdapter`.
- One GUID per install, persisted forever (camera pairing binds to it):
  clinic app → `captures/camlink-clinic.json`; CLI → `~/.camlink.json`.
- The UPnP announcer runs from process boot, always (see [[eos-utility-pairing]]).
- Diagnostics hand their live session to the connection ([[session-handoff]]).

## Hardware validated (2026-07-08/09)
[[canon-eos-r10]] and [[canon-eos-r6-mark-iii]] — full pipeline: wizard pairing
→ capture events → download → patient folder, on the camera's own Wi-Fi.
