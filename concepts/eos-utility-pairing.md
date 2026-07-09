# EOS Utility pairing = UPnP/SSDP discovery (the hard part)

The single most important non-obvious fact in the whole project:
**a Canon in "Remote control (EOS Utility)" mode will not talk to you until
it has DISCOVERED you via UPnP.** No announcement → the camera's screen
never lists your computer → "connection target not found." Source: CHDK
project's ptpip-canon-helpers + our field validation. (2026-07)

## The dance (implemented in `EosUtilityAnnouncer`)
1. Camera multicasts SSDP **M-SEARCH** for `upnp:rootdevice` to
   239.255.255.250:**1900**, about once per second, BEFORE any connection.
2. Computer answers 200 OK with `LOCATION: http://<ip>:<port>/desc.xml` and
   the magic header — the camera ignores anything that isn't
   `SERVER: Microsoft-Windows/10.0 UPnP/1.0 UPnP-Device-Host/1.0`.
3. Camera fetches desc.xml: UDN uuid must equal our PTP GUID
   ([[ptp-ip-protocol]]); friendlyName is what the camera screen shows
   ("CamLink Clinic").
4. User selects the computer, presses SET → camera opens port 15740.
5. The camera RE-VERIFIES the announcement on EVERY connection, not just
   the first → the announcer must run whenever the adapter is in use
   (we run it from process boot, forever).

## Announcer hardening (all field-driven)
- Binds UDP 1900 with reuseAddr + SO_REUSEPORT (Node ≥22.12) so port
  squatters like Spotify can't starve us ([[macos-networking-traps]]).
- Exclusive-bind probe at start records `portContended` for diagnostics.
- Multicast memberships re-enumerated every 15 s; on interface-set change
  (Mac hops onto the camera AP) re-joins in place without restarting or
  changing the GUID — injectable `listInterfaces` for the unit test
  (2026-07-09, [[2026-07-camera-reconnect]] cycle 1).
- Proactive NOTIFY ssdp:alive every 5 s per interface (belt & suspenders;
  CHDK notes cameras may ignore NOTIFY — the M-SEARCH answer is the one
  that must work).
- Self-test: sends itself a loopback probe and a multicast probe → splits
  "nothing heard" into which-layer-is-broken (socket / multicast / network).
- Own NOTIFY echoes are filtered from `packetsHeard` (they poisoned the
  "is the outside world reaching us" signal once).
