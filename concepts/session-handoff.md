# Session handoff (never disconnect-reconnect a Canon)

## The failure (field, 2026-07-08, R10 on its own AP)
Wizard flow was: run diagnostics (open session, verify pairing/identity/
events), close it, then dial a fresh session for real use. The camera
treated that quick close-and-redial as a client error: flashed an error,
**restarted its Wi-Fi AP**, kicked the Mac off (password prompt), final
connect died ECONNRESET. 100% reproducible.

## The rule
One session per pairing ceremony. The connection that passed the checks
must BECOME the working connection.

## Implementation
- `runPtpIpDiagnostics(host, port, { keepOpen: true })` → on success the
  report carries `handoff`: the open transport + identity + remoteMode flag.
- `CanonPtpAdapterOptions.handoff` → `connect()` adopts it (skips
  OpenSession/GetDeviceInfo/SetRemoteMode — already done), `discover()`
  reports the camera without probing the busy port (cameras are
  one-client-at-a-time; probing an owned port can upset them).
- Clinic server stores the handoff between the doctor call and /api/setup,
  expires it after 5 min so an abandoned wizard can't hold the camera.

## Related traps
- ECONNRESET right after all-green checks = this bug (or the Mac hopped
  Wi-Fi — check [[macos-networking-traps]] auto-hop).
- The stale-handoff close itself can still trigger the camera-error-AP-restart
  behavior; acceptable because it only happens on abandoned wizards.
