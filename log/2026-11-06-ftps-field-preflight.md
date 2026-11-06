# 2026-11-06 — FTPS connection and latency trial preflight

Chris asked to try connecting with FTPS and see whether it lags.

- SDK main remains 8bdefe1 (FTPS PR 25 merged). No source edits this session.
- Native app screenshot confirms installed 0.20.7, synthetic-only, signed out.
- No removable card mounted; camera model/availability not yet confirmed.
- Separate FTPS endpoint and certificate remain unprovisioned.
- Railway connector requires reauthentication; existing CLI login works.
  Do not ask for connector reauthentication when CLI can perform the work.
- Current hosted relay has the historical single-port FTP route. Railway CLI
  docs say one TCP proxy per service instance; actual installed CLI predates
  the tcp-proxy subcommand. Any alternative multi-service forwarding needs
  separate design/proof; do not switch the working receiver experimentally.
- Asked Chris for camera/card readiness, Med Photo sign-in, and whether to
  begin with a local FTPS compatibility/overhead trial or provision the direct
  cloud test. No answers received at logging time.
- No certificate, listener, infrastructure, credential, app version or camera
  profile changed. No photos taken or timing measured. Existing FTP preserved.

## Measurement contract
Use photos of an object, fixed JPEG size/settings/network, and keep original
FTP profile. Compare first shot, several individual shots, short burst, and
post-idle reconnect. Record shutter-to-visible separately from server receipt/
cloud ingestion. A local receiver trial cannot prove direct-cloud latency.
Do not use an unsynchronized camera EXIF clock as the timing source. Confirm
actual TLS/control/data and certificate verification before calling it FTPS.

Sources rechecked:
- https://docs.railway.com/cli/tcp-proxy
- https://cam.start.canon/en/C022/manual/html/UG-07_Network_0070.html

No SDK changes or release; vault-only preflight record.
