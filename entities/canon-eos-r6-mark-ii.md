# Canon EOS R6 Mark II

2026-11-04: Chris reports the camera is on the network and wants an obvious
connection indicator and automatic photo arrival. Later the same day he
confirmed that photos arrive, but Connected lasts only about 5–7 seconds
after each shot. This is user-reported physical transfer evidence, not a
power-cycle or two-camera/two-Mac acceptance test.

Canon's [R6 Mark II FTP manual](https://cam.start.canon/en/C012/manual/html/UG-07_Network_0070.html)
describes automatic transfer under the FTP transfer settings reached from the
FTP image-transfer menu. Enable it, keep a card in the camera, and use JPEG
for the app's test preview. Joining Wi-Fi alone does not establish the saved
FTP server/login or enable automatic sending. These are manual-sourced facts,
not a confirmed diagnosis of Chris's settings. (Verify after: 2026-12.)

## Between shots and ping (2026-11-04)
The same official manual's **Using the Power Saving Function** section says
FTP power saving can log off both FTP and Wi-Fi while idle, reconnecting for
the next image. To retain Wi-Fi: **Transfer images to FTP server → FTP transfer
settings → Power saving → Disable**. This is a plausible explanation of the
5–7-second status, not confirmation of Chris's selected setting or that exact
timeout. The app's setup disclosure includes this path in the 0.20.5 walkthrough
merged in SDK PR 21; see [[log/2026-11-04-camera-between-photos]].

A local network ping is technically possible as a reachability diagnostic,
but this R6 II's ICMP replies in FTP mode/sleep have not been tested or verified
from Canon's manual. A reply would not prove FTP credentials, automatic transfer
or cloud photo completion. No reply is ambiguous (sleep/off/filtering), and a
hosted relay cannot directly ping a camera's private LAN address across ordinary
NAT. See [[camera-presence]] and [[macos-networking-traps]]. No ping feature was
added; do not claim Canon guarantees it. A targeted Canon-documentation search
on 2026-11-04 still did not establish R6 II ping support. This is uncertainty,
not evidence that Canon blocks ping. Chris was asked for the camera's own IP
under Confirm Wi-Fi settings so a bounded hardware test can resolve it; do
not substitute the FTP server address or assume a previous LAN address.
See [[log/2026-11-04-canon-ping-clarification]]. (Verify after: 2026-12.)

Earlier SDK PR 20 (`d050ea6`) added automatic-transfer help and exposed current
relay sign-in separately from photo receipt; see [[camera-presence]]. The
new exact R6 II catalog entry stays without `fieldProven`; the combined
entry remains for saved records but is hidden from new selection. After deployment, verify
with an object photo: a new photo arrives, power
on resumes transfers without re-creating
credentials. Firmware-specific failures require investigation rather than
unverified menu or protocol guesses.

2026-11-05: the complete C012-sourced setup sequence has an exact R6 II entry
and nine guided tasks, plus reported-error recovery. Source checked 2026-11-05
(verify after: 2027-02). The recent-receipt/online/waiting/unavailable fix from
`2c40c15` is included in SDK PR 21. Release evidence: [[log/2026-11-05-r6iii-live-setup]].
