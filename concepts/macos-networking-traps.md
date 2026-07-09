# macOS networking traps (the checklist)

Every one of these silently broke camera discovery on Chris's Mac and cost
real debugging time. When discovery is dead ("nothing heard"), check IN
THIS ORDER — the clinic app's 📻 status line automates most of it.

## 1. Another app owns the discovery port (UDP 1900)
Spotify, casting/streaming, smart-home apps bind UDP 1900 for SSDP. With
plain reuseAddr on macOS, only ONE sharing socket receives each datagram —
the squatter eats the camera's M-SEARCH. Diagnose:
`sudo lsof -nP -iUDP:1900` (every claimant shows). Fix: fully quit the app
(Cmd+Q); our announcer also binds SO_REUSEPORT on Node ≥22.12 which usually
coexists. (2026-07-09, field)

## 2. macOS "Local Network" privacy permission (macOS 15+, incl. 26)
Per-app permission; without it macOS silently drops LAN traffic. Terminal
never got the one-time popup on macOS 26.5.1 → everything blocked with NO
error. Signature: tcpdump sees the packets, firewall is off, app hears
nothing; outbound ICMP (ping) still works (kernel-exempt) — so ping is NOT
a valid probe for this. Fix: System Settings → Privacy & Security → Local
Network → enable Terminal/iTerm; **if the app isn't listed, REBOOT** (re-arms
the stuck prompt), then trigger LAN traffic → popup → Allow → fully restart
the terminal app. (2026-07-09, field — the reboot was what fixed Chris's Mac)

## 3. Application Firewall
System Settings → Network → Firewall — blocks inbound to node. Was OFF in
our saga (red herring #2), but check with:
`/usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate`

## 4. Wi-Fi auto-hop off no-internet networks
macOS silently leaves the camera's hotspot (no internet) for a remembered
network — mid-handshake. Signature: all checks green, then
ECONNRESET/ECONNREFUSED; Wi-Fi menu shows the home network again.
Fix: System Settings → Wi-Fi → home network → Details → **Auto-Join OFF**
during camera-hotspot sessions. The app also retries for 2 min and names
the problem ("no 192.168.1.x address — rejoin EOS-XXXXXX").

## 5. The network itself filters peers
See [[home-network-filter]] — "Communication prohibited by filter" from a
middlebox = router security feature; not fixable on the Mac.

## Meta-lesson
tcpdump sees raw packets BEFORE app-level filters (TCC), so "tcpdump sees
it but the app doesn't" localizes the block to the Mac, not the network.
