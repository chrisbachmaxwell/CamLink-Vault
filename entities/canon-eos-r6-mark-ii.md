# Canon EOS R6 Mark II

2026-11-04: Chris reports the camera is on the network and wants an obvious
connection indicator and automatic photo arrival. No successful physical
transfer or power-cycle reconnection was established in this session.

Canon's [R6 Mark II FTP manual](https://cam.start.canon/en/C012/manual/html/UG-07_Network_0070.html)
describes automatic transfer under the FTP transfer settings reached from the
FTP image-transfer menu. Enable it, keep a card in the camera, and use JPEG
for the app's test preview. Joining Wi-Fi alone does not establish the saved
FTP server/login or enable automatic sending. These are manual-sourced facts,
not a confirmed diagnosis of Chris's settings. (Verify after: 2026-12.)

SDK PR 20 (`d050ea6`) adds this help as optional disclosure and exposes current
relay sign-in separately from photo receipt; see [[camera-presence]]. The
combined catalog entry stays without `fieldProven`. After deployment, verify
with an object photo: connected evidence appears, a new photo arrives, power
off clears the indicator, and power on resumes transfers without re-creating
credentials. Firmware-specific failures require investigation rather than
unverified menu or protocol guesses.
