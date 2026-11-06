# Dedicated practice FTPS and secure relay follow-on — 2026-11-06

## Decisions and evidence
- Chris accepts R6 II FTPS perceived latency: "Appears almost immediately" and
  "fast enough". Benchmarking is not a blocker. Reliability/security tests remain.
- Each practice gets separate clinical API/identity/storage and FTPS receiver,
  not merely a separate hostname on the shared relay. Prefer separate AWS
  accounts for eventual production; no claim of dedicated physical AWS hardware.
- Keep legacy synthetic FTP instructions. Future local FTP exceptions require
  reviewed network safeguards, not a checkbox claiming compliance.
- Record secure office relay as next work for cameras without FTP/FTPS. Verify
  EOS R8 and the exact reported "R8II" model before claiming protocol support.
- Corrected stale physical-test-pending/PR28-CI-pending and shared-server text.
  Labeled the old local-default/pipe-only architecture historical.

## Code and validation
SDK PR28 feature 85f8b0d merged 132bb21 after both Node20/22 CI jobs passed.
The tested receiver is already deployed to the temporary synthetic trial.
SDK feature fe94642 / PR29 adds dedicated deployment membership/ingest checks,
FTPS-only activation with failed-downgrade cleanup and explicit legacy FTP opt-in.
Seven focused adversarial tests and all six required local gates pass. PR29
Node20 CI passed; Node22 browser/dependency step is still running at this
checkpoint. Do not merge until both pass. No secrets, patient records or images retained.

## Boundaries and remaining work
No new AWS infrastructure, PHI authorization or desktop release. Installed app
remains 0.20.7. Trial still has its previously configured 22:53 UTC Nov6 stop;
encrypted disk persists after stop and incurs storage charges. No new live
state claim or automatic-stop verification was made in this session.
Permanent receiver provisioning, stable hostname/certificate delivery/renewal,
trusted practice enrollment, two-live-practice tests, MFA/key/audit/restore and
production compliance acceptance remain open. Do not call this finished secure
hosting. Implementation contract and next goal are linked from status/roadmap.
