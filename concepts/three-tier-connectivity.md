# Decision: three-tier connectivity strategy (Chris, 2026-08-21)

Copy into CamLink-Vault/concepts/ and add to entities/decisions.md.

Field driver: office field test on a Cisco **Meraki** network — camera
could not reach the app (Error 41). Meraki NAT-mode SSIDs isolate
clients BY DESIGN; the home network's mystery `10.128.128.128`
"prohibited by filter" (July) was the same product family. Clinic
networks will present this wall routinely.

## The three tiers (all ship; local stays the default)
1. **Local** (default, HIPAA gold standard): same-Wi-Fi or camera
   access-point mode; photos never leave the building. SHIPPED.
2. **Med Photo Box**: preconfigured travel router = instant private
   camera↔computer network, zero IT involvement, repeatable installs.
   Spec: repo docs/MED-PHOTO-BOX.md.
3. **Med Photo Cloud Relay** (outbound-only, for zero-hardware clinics):
   camera →FTPS→ relay →TLS pull→ clinic computer. PIPE, NOT A STORE —
   delivery deletes. Prototype in packages/relay +
   packages/adapter-cloud-relay; plan in docs/CLOUD-RELAY-PLAN.md.
   **HARD GATE: no patient photo touches tier 3 until BAA-backed hosting
   + compliance-advisor sign-off** (hipaa-local-first red line). Frame.io
   ruled out for PHI (no BAA); fine to consider for non-medical markets.

## Meraki playbook (for the vault's clinic-network notes)
Dashboard → Wireless → Access control → SSID: Client IP assignment =
**Bridge mode** (never "NAT mode: Meraki DHCP"); Firewall & traffic
shaping: "Wireless clients accessing LAN" = **Allow**, "Layer 2 LAN
isolation" = **Disabled**. Best practice: dedicated "MedPhoto" SSID with
those settings. Never WAN port-forwarding. The app now ships a printable
/it-guide page with this recipe and live values.

## Field lessons this session (fold into ftp-push-transfer page)
- Camera IP must be **Auto** — the only address a human types is the
  computer's. (Field: camera was manually given the SERVER's IP →
  guaranteed Error 41. The app instructions must say this.)
- Multi-homed Macs (Ethernet + Wi-Fi) show several server addresses —
  the camera can only reach the one on ITS network; panel lists all,
  humans pick wrong. Product fix candidate: highlight/auto-detect.
- Passive-mode data connections use ephemeral ports → firewall rules
  must allow all TCP camera→computer, or we ship a fixed PASV port
  range (product fix queued).
