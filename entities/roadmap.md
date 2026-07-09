# Roadmap — WHAT IS LEFT

Last updated: 2026-07-09 (evening). Ordered by what unblocks clinics fastest.

## Next up (agreed with Chris)
1. **USB tether transport (P4a)** — "easiest for offices so staff doesn't
   have issues." Design exists in repo `docs/PTP-PLAN.md`: same PTP layer,
   `PtpTransport` interface already abstracts the wire; add a libusb-based
   `PtpUsbTransport` + auto-detect on plug-in. No Wi-Fi, no pairing dance,
   no [[macos-networking-traps]] — biggest reliability win available.
2. **Fix Chris's office/home network** for Same-Wi-Fi mode: identify router
   brand and disable client isolation / "advanced security"
   (see [[home-network-filter]]). Open question to Chris: ISP + router model,
   any VPN/antivirus on the Mac.
3. **Vault operations**: grant the Claude GitHub App access to
   CamLink-Vault and select both repos when starting cloud sessions;
   schedule the [[vault-maintenance]] loops (nightly compile, weekly lint,
   weekly synthesis). Until scheduled, end sessions with "update the vault."

## Product build-out
- Retake/delete UI in sessions (clinic feedback anticipated)
- Patient-name autocomplete + collision handling (two "Jane Doe"s)
- Package the clinic app for staff (Electron or menu-bar app; no Terminal)
- Multi-camera per app instance (SDK supports adapters[]; UI assumes one)
- PHI: encrypt-at-rest recipe + BAA guidance page (before real patient data!)
- Windows validation pass (all field testing so far is macOS)
- Wizard test step: warn when the test file is RAW (advisory currently
  fires on first session shot)

## Platform
- M6: npm publish pipeline for @camlink/* (versioning, changelogs, provenance)
- M2: native kits — CamLinkKit (Swift), camlink-android (Kotlin)
- CCAPI activation walkthrough exists in-app; decide whether CCAPI stays
  advanced-only or gets removed from the wizard entirely
- Adapter certification: publish "CamLink Certified" doc for third-party
  adapter authors

## Hardware matrix to grow
Validated: EOS R10, EOS R6 Mark III. Next candidates: R50/R8 (entry),
R5 Mark II (pro), one PowerShot, one older body (menu gen 1), Nikon/Sony
(new adapters — the pattern proves itself when a second vendor lands).
Open data point: which SetRemoteMode value (1 or 0x15) the R6 III accepted.

## Known debt
- `home-network` same-Wi-Fi flow untested end-to-end (blocked on router fix)
- Announcer port-contention detection is boot-time only (Spotify started
  AFTER the app won't be flagged)
- EOS event knowledge is field-derived; keep the unhandled-event tracer in
  place permanently (it cracked both cameras) — see [[eos-event-records]]
