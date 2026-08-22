# FTP push transfer (the PhotoNodes approach) — researched 2026-08-21

Chris's lead: PhotoNodes (studio-management software by 40 North Labs)
connects to cameras by running an FTP SERVER; cameras with built-in FTP
upload push each shot to it as taken. Verified below. Candidate for a
third Med Photo adapter. (verify after: 2027-02)

## Receipts
- Canon EOS R6 Mark III manual, "Transferring Images to an FTP Server"
  (cam.start.canon C022 UG-07): built-in, supports auto-transfer of each
  image as shot. → our test body supports it TODAY.
- Same feature documented for R6/R6 II/R5; R6 II users report SFTP working
  (dpreview thread). Sony documents FTP push across Alpha bodies; Nikon
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
- One-way: no remote shutter, no status, no thumbnails on demand.
- Camera-side setup = typing server IP/user/password into camera menus
  (clunky for staff; mitigate with an in-app setup card showing exactly
  what to type; some bodies import saved comm profiles).
- HIPAA: plain FTP is cleartext — REQUIRE FTPS/SFTP where the body
  supports it ([[hipaa-local-first]]); LAN-only server binding.
- Same LAN realities: router client isolation blocks camera→server too.

## Proposed shape (roadmap candidate: Phase D2, after USB tether or even
## before it — discuss with Chris)
`FtpPushAdapter` in packages/adapter-ftp-push: embedded FTPS server;
authenticated upload → photoCaptured event → existing session pipeline
untouched. discover() = "listening"; triggerCapture absent (degraded-mode
UI already handles that). Wizard tile: "Pro camera (auto-send)". Cert
suite must pass. Simulator: scripted FTP client pushing fixtures.
