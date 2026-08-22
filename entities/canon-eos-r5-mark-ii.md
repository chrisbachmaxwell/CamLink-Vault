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
R5 II FTP menu path: Network → Connect to FTP server → connection
settings. (verify after: 2026-10 — menu paths from field, not manual.)
