# Canon Err 41 field investigation — 2026-11-06

Chris reports Cannot connect to FTP server, code Err 41, after importing the
trial root. Office public IP unchanged, trial server reachable at 2121 and
trusted TLS login from Mac passes. Receiver and four-hour stop timer active.
Original receiver journal contained no connection-stage evidence, so cannot
attribute the failed attempt to network, password, certificate or protocol.

Owned SDK paths infra/ftps-test. Feature 277d1210b8520dea29f3dea0b71e5004050ff5f7,
PR https://github.com/chrisbachmaxwell/CamLink-SDK/pull/27 open, CI pending.
All six required local gates pass; three infra/privacy tests pass. Diagnostic
logs allowlisted command verbs, numeric reply codes and fixed connection events
only; no arguments, credentials, filenames or addresses. Unknown text drops.

Diagnostic bundle deployed only to approved temporary EC2 receiver via SSM,
hash verified, prior bundle retained for rollback, service restarted successfully.
Stop timer stays active; no firewall, certificate, credential, desktop or working
FTP change. Post-change trusted TLS login/PROT passes. Journal proves operator
probe reached 220,234,USER/331,PASS/230,PBSZ/200,PROT/200,QUIT/221 then closure.
That is operator evidence, not a camera retry. No new photo upload in this step.

Asked Chris to verify FTPS, 3.87.221.191, port 2121 and passive enabled, then retry
once. Canon C012 explicitly suggests passive Enable for Err 41; this is a
troubleshooting step, not a diagnosed cause. No trust verification bypass.
Source https://cam.start.canon/en/C012/manual/html/UG-07_Network_0070.html

Pending physical retry/setting confirmation. Keep no-production/no-PHI boundary.
The existing stop timer remains 22:53:37 UTC / 3:53 PM Mountain Nov 6; retained
encrypted disk incurs storage cost. Do not restart trial later without checking
address, certificate and prior launch budget constraints.
