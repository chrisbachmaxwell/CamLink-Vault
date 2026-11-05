# FTP push transfer (the PhotoNodes approach) — researched 2026-08-21

## 2026-11-05 opt-in FTPS implementation
Implemented explicit AUTH TLS with encrypted login/data, per-control TLS session
binding, credential revocation, and relay configuration. Canon FTPS profiles get
certificate-import and trust-error guidance; existing FTP instructions remain.
All physical Canon FTPS interoperability and endpoint/certificate provisioning
remain pending. No live relay change, AWS production setup, or desktop release.
See [[log/2026-11-05-canon-ftps-implementation]].


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

At SDK main `6eb0552`, `FtpPushAdapter` in packages/adapter-ftp-push embedded
a **plain FTP** server. Subsequent main `8bdefe1` adds opt-in explicit FTPS;
it remains undeployed and unverified with physical Canon cameras. The legacy
local clinic mode can start the adapter from saved setup and serve multiple
camera accounts. This component is not the completed production office
receiver. Source review at SDK main `6eb0552`,
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

## iPad foreground receiver feasibility — 2026-11-05
Chris clarified that staff already need Med Photo open during shooting to
choose the correct patient. A native iPad app could plausibly combine patient/
visit selection, a foreground camera FTP(S) receiver and HTTPS cloud upload.
Apple's Network framework supports incoming listeners on iPadOS; this is a
platform capability, not a tested or released Med Photo iPad receiver. A Safari
page alone does not supply that native FTP(S) receiving service. A future
iPad client could also select the patient while a direct FTPS camera sends
to the cloud, so the tablet need not carry the photo bytes.

Foreground availability fits this workflow: keep the capture screen visible,
prevent idle sleep only during active capture, obtain local-network permission
and verify camera reachability. Switching apps or locking the device can
suspend receiving. Background HTTPS upload support is distinct from running
an indefinitely available incoming FTP server. Do not promise automatic
desktop-style receiver startup or uninterrupted background service on iPad.

Patient selection must explicitly start/confirm a visit for the chosen camera;
merely browsing a patient page is not capture authorization. The cloud records
that camera's active visit independently of the viewing screen. A proposed
receiver must preserve queued-photo association across patient changes and
interruptions and route ambiguous backlog to review, never silently to the
next patient. This additional receiver behavior needs implementation and tests.
No current iPad receiver, local FTPS hardware proof or performance is claimed.

Official sources checked 2026-11-05 (verify after: 2026-12):
- https://developer.apple.com/documentation/network/nwlistener
- https://developer.apple.com/documentation/technotes/tn3151-choosing-the-right-networking-api
- https://developer.apple.com/documentation/uikit/uiapplication/isidletimerdisabled
- https://developer.apple.com/documentation/technotes/tn3179-understanding-local-network-privacy
See [[cloud-authoritative-library]] and
[[log/2026-11-05-ipad-receiver-feasibility]].

## Local receiver versus internet ports — 2026-11-05
Current documented synthetic route: camera initiates an outbound internet
connection to the hosted relay. An app used only to select visits/view photos
does not change that route. A local receiving app changes the camera's server
destination to the computer/iPad's LAN address; it then forwards through
outbound HTTPS (normally TCP 443). Both routes already use network ports.
Local receiving does not inherently require a different numeric port; the
destination and permitted network path are what change. Final port assignments
are receiver configuration, not yet selected for a production local app.

On an ordinary permitted LAN, IT may need no network change. On a restricted
office network, IT must allow the designated camera network to reach the
receiver's control/data ports and resolve relevant device isolation or routing
restrictions. The Mac application firewall and local-network privacy permission
are separate from network-appliance rules. Same Wi-Fi does not prove local
reachability. Do not disable security broadly or expose the receiver publicly.
An on-LAN camera-to-receiver route does not call for WAN port forwarding.

Passive FTP(S) has control and data connections, both initiated by the camera
in passive mode. Today's synthetic relay multiplexes them onto one public
endpoint; SDK main `8bdefe1` FTPS instead requires a control port plus a fixed
passive range (docs/FTPS-SETUP.md). Direct cloud FTPS can therefore still need
an outbound firewall allowance on restrictive networks. That is distinct from
opening inbound internet access into the office. No zero-IT guarantee for
either route. For least device-to-device dependency, keep camera-to-cloud
FTPS and use the app for patient selection/viewing.

Sources checked 2026-11-05 (verify after: 2026-12): SDK `8bdefe1`
docs/FTPS-SETUP.md; [[med-photo-relay]]; Apple Mac firewall guidance;
https://support.apple.com/guide/mac-help/block-connections-to-your-mac-with-a-firewall-mh34041/mac
and https://documentation.meraki.com/Wireless/Operate_and_Maintain/How_Tos/Firewall_and_Traffic_Shaping/Wireless_Client_Isolation.
See [[log/2026-11-05-receiver-network-ports]].
