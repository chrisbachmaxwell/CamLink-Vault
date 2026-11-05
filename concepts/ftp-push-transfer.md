# FTP push transfer (the PhotoNodes approach) — researched 2026-08-21

Chris's lead: PhotoNodes (studio-management software by 40 North Labs)
connects to cameras by running an FTP SERVER; cameras with built-in FTP
upload push each shot to it as taken. Verified below. Candidate for a
third Med Photo adapter. (verify after: 2027-02)

## Receipts
- Canon EOS R6 Mark III manual, "Transferring Images to an FTP Server"
  (cam.start.canon C022 UG-07): built-in, supports auto-transfer of each
  image as shot. → our test body supports it TODAY.
- Same feature documented for R6/R6 II/R5. FTPS is verified from Canon
  manuals in the 2026-11-05 capability audit; do not infer SFTP from FTPS. Sony documents FTP push across Alpha bodies; Nikon
  and Fuji equivalents exist. FTP is the one cross-vendor transfer path.
- EOS R10: NO FTP section in its manual — entry bodies lack the feature
  (historically it even required WFT accessories on pro DSLRs).
- PhotoNodes itself: photonodes.com / 40 North Labs; event-photography
  kiosk workflows built on camera-FTP push (Seeed reTerminal writeup).

## Why it's attractive (vs our PTP/IP war stories)
- CAMERA INITIATES the connection → no SSDP announcer, no pairing screen,
  no session-handoff fragility, no event-record dialects. The photo
  arrives as a file; the entire discovery layer we debugged for days
  simply doesn't exist in this path.
- Vendor-agnostic: one FTP(S) receiver = Canon + Nikon + Sony + Fuji pro
  bodies, no per-vendor protocol work.
- Camera firmware handles retry/queueing of transfers.

## Why it can't replace PTP/IP
- Entry bodies (R10, R50…) have no FTP — budget clinic setups still need
  the EOS Utility path.
- One-way: no remote shutter, camera-side unsent-photo count, or thumbnails on
  demand. The receiver can observe authenticated connections and received
  transfers, but normal power-saving disconnects are not failures. Canon's
  R6 II manual explicitly documents this; see [[canon-eos-r6-mark-ii]] and
  [[camera-presence]] (2026-11-04 field correction).
- Camera-side setup = typing server IP/user/password into camera menus
  (clunky for staff; mitigate with an in-app setup card showing exactly
  what to type; some bodies import saved comm profiles).
- Plain FTP has no transfer encryption. Production internet uploads must use
  an approved encrypted protocol. A local-only exception requires documented
  risk review and enforced network/receiver safeguards, not a blanket statement
  that all FTP violates HIPAA or an unchecked assumption of a secure office.
  See [[hipaa-local-first]] and SDK docs/CAMERA-TRANSFER-SECURITY.md.
- Same LAN realities: router client isolation blocks camera→server too.

## Implemented local component and desktop receiver feasibility — 2026-11-05

`FtpPushAdapter` in packages/adapter-ftp-push already embeds a **plain FTP**
server, not an implemented FTPS server. The legacy local clinic mode can start
it from saved setup and serve multiple camera accounts. This component is not
the proposed production receiver. SDK main `6eb0552`,
apps/clinic/src/server.ts, explicitly disables legacy local capture startup
and setup endpoints in the downloaded app's cloud mode. The desktop shell
currently quits on window close and stops its clinic child; it has no login
startup or sleep-management implementation in apps/desktop/src/main.mjs.

Chris asked whether the installed app could itself supply an office receiver.
Yes, as a future engineering option: enroll a designated computer, start a
background receiving service, accept approved cameras on the permitted LAN,
then forward through authenticated HTTPS into the cloud-authoritative library.
A separate hardware box is not intrinsically required. Multiple computers may
view the library; each camera still needs an explicit receiver destination.
Starting another computer does not automatically retarget the camera or provide
failover. Stable addressing and scoped camera/device credentials are required.

Implementation needs a deliberate login/background-service lifecycle, clear
receiver status, restart recovery, local-network/firewall checks, an encrypted
bounded queue with confirmed-cloud-receipt handling, and server-enforced
practice/location/camera routing. A locked screen can coexist with a background
service; a sleeping/off computer cannot receive. Login startup is different
from a system service available before login. Client isolation can prevent
camera-to-computer traffic even when both use the same Wi-Fi.

Electron documents login services and preventing app suspension while allowing
the display to turn off. These are platform capabilities, not implemented Med
Photo features or hardware proof. Sources checked 2026-11-05 (verify after:
2026-12): https://www.electronjs.org/docs/latest/api/app#appsetloginitemsettingssettings-macos-windows
and https://www.electronjs.org/docs/latest/api/power-save-blocker.
Security acceptance stays in SDK docs/CAMERA-TRANSFER-SECURITY.md and
[[hipaa-local-first]]. This feasibility discussion does not supersede the
existing direct-FTPS-first priority or authorize installation/deployment.
See [[log/2026-11-05-desktop-receiver-feasibility]].
