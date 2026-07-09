# Canon EOS R10 (test body #1)

Chris's entry-level body. Serial 326e47b7ca4abe977532cda0151f7576,
firmware 3-1.0.1. First camera to complete the full CamLink pipeline
(2026-07-08, camera's own Wi-Fi).

## Menu path (older/current menu generation)
menu → Wi-Fi/Bluetooth connection → **Remote control (EOS Utility)** →
Connect. Its own network appears as `EOS-B30C88` (also seen as
`EOSR10_B30C88-476_Canon0A` in macOS Wi-Fi dialogs); PTP name `EOSR10_B30C88`.
Camera IP on its own AP: `192.168.1.2`. IPv4 Auto, IPv6 Disable.

## Quirks (all field-verified)
- **Refuses SetRemoteMode** (1 AND 0x15) → 0x2002 GeneralError, persistently.
  Runs in degraded mode: no remote shutter button; physical shutter events
  flow fine. Background retry never succeeded on this body.
  (verify after firmware update)
- Pairing screen: "EOS-B30C88 pairing (connection) with the computer in
  progress. Start EOS Utility on the computer." = camera is SEARCHING via
  SSDP; it lists computers only after discovery ([[eos-utility-pairing]]).
- Its PTP port (15740) answers with RST (ECONNREFUSED) until the user
  selects the computer and presses SET — a failed "reach check" here is
  normal, not an error.
- A quick disconnect-reconnect makes it error out and restart its AP
  ([[session-handoff]] exists because of this body).
- Startup event chatter observed: 0xc1f6, 0xc18a (AvailListChanged),
  0xc18b (CameraStatusChanged), 0xc185 (StorageInfoChanged) — all harmless.
