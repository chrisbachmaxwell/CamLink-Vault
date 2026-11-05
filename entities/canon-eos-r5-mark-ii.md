# canon-eos-r5-mark-ii — OPEN INVESTIGATION (FTP transfer fails)

Chris's third body, first tried 2026-08-22 against the cloud relay.

## Symptom
- Logs in to the relay fine (presence flashed green "active") — so
  address, port, user, password all correct.
- Drops seconds later; **no image ever arrives**; camera UI claims
  "connected".

## Suspects (in order)
1. **Passive mode OFF** (camera default) — matches login-ok/transfer-dead
   exactly; active mode (PORT/EPRT) cannot work through NAT/relay. The
   server now answers PORT/EPRT with the fix in words: "turn PASSIVE
   mode ON in the camera FTP settings."
2. Protocol flavor: R5 II offers FTP / FTPS / SFTP — must be plain FTP
   (until the FTPS milestone).
3. An unknown command dialect — which is why the **FTP tracer** was
   built and deployed ([[med-photo-relay]]): next attempt is recorded
   command-by-command in Railway logs.

## Next actions (goal: [[2026-08-r5ii-ftp-dialect]])
Chris: passive ON, plain FTP, one shot. Then read
`railway logs --service relay` and fix whatever the trace shows.

## Manual-corrected guide — 2026-11-05
[Canon C017 FTP manual](https://cam.start.canon/en/C017/manual/html/UG-06_Network_0060.html)
uses **Transfer images to FTP server → Add a device to connect to → Configure
online**, then **New settings → Wi-Fi** and automatic IP configuration/save
with SET. The old Network → Connect to FTP server wording was not exact and
is superseded. SDK PR 21 adds this sequence and the remaining server/login/
folder/automatic-transfer/test steps. Follow the protocol provisioned by the
app; the current synthetic endpoint uses FTP. Passive mode must be enabled,
but the earlier field failure has not been proven fixed by changing it.
No new R5 II hardware attempt was made. (Verify after: 2027-02.)
See [[log/2026-11-05-r6iii-live-setup]].
