# Canon EOS R6 Mark III (test body #2)

2025-generation body. Completed the full CamLink pipeline 2026-07-09.
File prefix on Chris's unit: `F91A` (e.g. `F91A0431.CR3`).

## PTP pairing menu (not the FTP setup path)
MENU → **Wireless features** → **Connect to EOS Utility** →
**Add a device to connect to**. Same protocol underneath; only menus moved.
Applies to the R1 / R5 Mark II / R6 Mark III generation.
(verify after: 2027-01 — Canon may reshuffle again)

## FTP setup — manual checked and field menu corrected 2026-11-05
Chris is adding a different physical R6 III on a new network in installed
Med Photo 0.20.4. His camera photo shows the purple **Network function** tab
with **Transfer images to FTP server**. The app's generic
Wireless features → Wi-Fi/Bluetooth connection instruction is wrong for
this walkthrough. Start in FTP, add a device, configure online, then join
Wi-Fi. The authoritative source is the
[Canon C022 FTP guide](https://cam.start.canon/en/C022/manual/html/UG-07_Network_0070.html).
It covers server/protocol/port, passive mode, proxy, login, destination and
automatic transfer. Use the current app's provisioned values; never store
camera credentials in this vault. (Verify after: 2027-02.)

The second camera photo shows **Communicating** with **Err45**. That heading
is not successful connection proof. Canon's
[error guide](https://cam.start.canon/en/C022/manual/html/UG-07_Network_0160.html)
defines 45 as FTP login rejection and calls for checking the login and server
permissions. This may be an existing saved profile; its actual server/login
have not been compared. Do not conclude that Chris mistyped a password.
The initial profile screen was followed by a pause while the walkthrough
shipped. Chris subsequently redid setup in 0.20.5 and reported it worked
perfectly on 2026-11-05. The native app subsequently showed four photos in that camera’s active visit.
This supports delivery; no packet trace or power-cycle test was performed.
Preserve the working configuration.
SDK PR 21 adds the full C022-sourced nine-step guide and Err45/Err41 recovery;
see the linked log for release/installation evidence.
See [[log/2026-11-05-r6iii-live-setup]].

## Saved-profile login rejection — 2026-11-05
Chris's next camera photo shows the full Err45 text: Cannot login to FTP
server; error received from server. This supports server-response/login-
rejection evidence, not successful previous authentication, password expiry,
or proof that the selected server/login matches the new app profile.
Canon C022's FTP guide documents **Transfer images to FTP server → Edit/delete
device → select the saved connection → FTP server**. End the camera's current
Wi-Fi connection before editing; keep the saved profile and edit it. This is
camera-side FTP setup guidance, not a second PTP diagnostic session.
Sources above rechecked 2026-11-05 (verify after: 2027-02). The new recovery UI
is published as 0.20.6; see [[log/2026-11-05-camera-login-recovery]].


## User-confirmed field success — 2026-11-05
Chris subsequently reported: “I just added the camera re did the setup and the
insturctions were incredible! worked perfectly”. This is user-confirmed success
for the published 0.20.5 R6 III walkthrough after redoing setup. A subsequent read-only native app observation showed the R6 III active visit
with four photos. The agent did not rotate the working login.
The exact old-login failure remains unknown; do not label it expired. Preserve
the now-working camera configuration. Saved-profile recovery remains a useful
follow-up and does not require another physical setup test from Chris.

## Quirks (field-verified 2026-07-09)
- **Emits object-added event 0xc1b6** ("ObjectAddedEx3") — a record absent
  from libgphoto2 and all documentation. Decoded from our tracer's hex dump:
  oid@0, storage@4, format(u32)@8, u64 size@20, parent@28, unix timestamp@36,
  PTP-string filename@40. Full dump in [[raw/2026-07-09-field-evidence]].
  The oid@0 invariant held → 3-line fix. [[eos-event-records]]
- Arrived set to **RAW (CR3), ~40 MB/shot** → slow transfers, no browser
  preview. Handled via embedded-JPEG thumb sidecars; recommend JPEG
  Large/Fine for clinic use.
- Same startup chatter as the R10 (0xc1f6/0xc18a/0xc18b/0xc185).
- Remote shutter: worked via session flow; if 0x2002 appears post-connect
  the background retry (1 ↔ 0x15) handles it.
  (Confirm which SetRemoteMode value this body accepted — not yet recorded.)
