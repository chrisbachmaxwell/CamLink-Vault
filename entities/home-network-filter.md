# Home network filter (unresolved blocker for Same-Wi-Fi mode)

Status: OPEN · discovered 2026-07-09 · blocks same-network camera use at
Chris's home; the office network is untested and may differ.

## Evidence (receipt)
`ping 192.168.16.1` from the Mac answered:
```
92 bytes from 10.128.128.128: Communication prohibited by filter
```
ICMP "administratively prohibited" from a middlebox at **10.128.128.128** —
a security appliance/feature is blocking device-to-device traffic on the LAN.
Meanwhile multicast M-SEARCH from the camera DID reach the Mac's interface
(tcpdump), so multicast floods but unicast between peers is dropped —
pairing/PTP can never complete on this network.

## Likely culprits
Router "advanced security" / parental-control suites: Xfinity xFi Advanced
Security, eero Secure, TP-Link HomeShield, Netgear Armor, Firewalla, or a
guest SSID with client isolation. Also possible: a VPN/antivirus network
extension on the Mac.

## To resolve (waiting on Chris)
1. ISP + router/Wi-Fi system brand?  2. Any VPN/antivirus/parental app?
Then: disable the device-isolation feature or whitelist the camera+Mac.

## Workaround in production use
Camera's own Wi-Fi mode bypasses the router entirely — this is how both
cameras were validated. USB tether ([[roadmap]] #1) will make this moot.
