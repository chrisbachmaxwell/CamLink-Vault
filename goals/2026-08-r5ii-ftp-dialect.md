# Goal: R5 Mark II speaks FTP to Med Photo — and so does every FTP body

Status: IN PROGRESS (opened 2026-08-22). Chris: "I need this to work for
all ftp cameras."

Context: [[canon-eos-r5-mark-ii]] — logs in, transfers nothing. The FTP
conversation tracer is deployed to the relay ([[med-photo-relay]]).

## Done when (verified by:)
- [ ] Root cause identified from the relay's FTP trace (verified by: the
      trace lines quoted in this page's iteration log)
- [ ] Fix shipped if server-side; camera-setting documented in the app's
      instructions if camera-side (verified by: gates green, and the
      Camera setup / relay cards mention the setting when relevant)
- [ ] R5 Mark II delivers a photo end-to-end into a visit (verified by:
      Chris's session — the field box)
- [ ] Any new commands the R5 II sent are handled or explicitly answered
      (no bare "502 Command not implemented" left in its trace)
      (verified by: unit test per new command)

## Waiting on Chris
- On the R5 II: FTP connection settings → **Passive mode: Enable**;
  protocol = plain **FTP** (not FTPS/SFTP); auto-transfer ON. Take ONE
  photo. Tell the agent — it reads the trace from Railway logs.

## Stop clause
If the trace shows the body requires FTPS/SFTP with no plain-FTP option,
stop and fold this into the FTPS milestone ([[roadmap]] #3) instead of
building TLS ad-hoc.

## Iteration log
- 2026-08-22 — Goal opened; tracer deployed; PORT/EPRT now answered with
  the passive-mode fix in words; checklist sent to Chris.
