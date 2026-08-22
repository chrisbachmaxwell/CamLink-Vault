# 2026-08-21 — Session: FTP push adapter built and gated

Chris green-lit the PhotoNodes-style transport same-day ("build it — we
test with R6 III"). Shipped in one session (commit 05253d6).

## What shipped
- `@camlink/adapter-ftp-push`: embedded zero-dependency FTP server (camera
  dialect: USER/PASS, FEAT, TYPE, CWD/MKD, PASV/EPSV, STOR incl. the
  data-before-STOR race, LIST, rename tolerance) + FtpPushAdapter mapping
  uploads → photoCaptured. canTriggerCapture=false. Passes the full
  adapter certification suite.
- push-client (exported subpath) = the camera simulator: used by unit
  tests, the new `smoke.mjs ftp` gate, and CI.
- Clinic wizard: "Pro camera auto-send" tile; panel prints the exact
  values to type into the camera (IP / port 2121 / user / generated
  d-pad-friendly password, persisted forever); live listener status line
  including credential-mismatch detection; first pushed photo jumps to
  the proof screen. Test step now adapts to shutterless transports.
- Docs: HARDWARE-TESTING gained the R6 III FTP field procedure.
- Gates: 104 tests across 8 packages; smoke modes ptp-simulator /
  simulator / ftp all green; ftp smoke added to CI. Clinic app v0.3.0.

## Decisions
- Plain FTP first, FTPS as fast-follow (documented in-app and in the
  concept page); LAN-only + generated credentials meanwhile.
- Port 2121 (21 needs root); camera-friendly password alphabet (no
  0/O/1/l, lowercase only).
- Credentials persist across re-setups so a camera configured once stays
  valid forever.

## Waiting on Chris (field test, R6 III)
1. App → Pro camera auto-send → Start listening.
2. Camera → Wireless features → FTP transfer → same Wi-Fi (or camera AP)
   → plain FTP → type the panel's values → automatic transfer ON.
3. Take a photo → proof screen. Then run a patient session.
Record: does the R6 III accept plain FTP easily, does auto-transfer fire
per shot, transfer time for JPEG vs CR3, and anything the status line
failed to explain.

## Follow-ups (roadmap)
- FTPS (AUTH TLS + PROT P) with self-signed cert + camera "no cert
  verification" guidance — required before real-clinic use per
  hipaa-local-first.
- Rename-to-final-name handling if Sony field tests need it.
- Consider making FTP the recommended tile for supported bodies.
