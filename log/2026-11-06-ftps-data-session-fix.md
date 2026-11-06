# FTPS data-session compatibility fix — 2026-11-06

Chris confirms settings correct, including Canon's five-digit 02121 port field,
but Err 41 persists. At 19:44:18 UTC the sanitized receiver log shows control
open,220,504,234,USER/331,PASS/230,PBSZ/200,PROT/200,PWD/257,EPSV/229,TYPE/200,
LIST/150 then closure one second later. This proves reachability/TLS/login and
narrows failure to data/listing; do not blame password or repeat basic settings.
No pre-fix data TLS detail existed, so exact physical cause remains conditional.

SDK PR 27 diagnostics merged d4bc5595d46fb28e2924acc789b03f455dbef911 after CI.
Owned new code paths: FTP adapter server/tests and trial diagnostics.
Feature 85f8b0de96ce6898075f384a802b08437848bfda / PR 28 open, CI pending.
Node documents explicit newSession/resumeSession handlers for session-ID reuse:
https://nodejs.org/api/tls.html#session-identifiers
Server only supported per-control ticket keys. A ticket-disabled TLS 1.2
listing regression failed on old code; bounded per-control session-ID cache
makes it pass. Cache clears on control close and never enrolls fresh data
sessions. Mandatory resumption remains; cross-control IDs and fresh channels
are rejected. Graceful protected listing sends TLS EOF before cleanup;
legacy plain FTP behavior preserved. Fixed allowlisted data-channel events
expose only open/TLS-failed/session-rejected/session-accepted, no secrets.

All six local gates pass. Fifteen focused FTPS tests pass, including listing
then upload with TLS1.2 IDs, TLS1.2 tickets and TLS1.3 tickets, foreign/fresh
session rejection, trust/downgrade/revocation checks. Three infra/privacy tests
pass. Code feature pushed; no desktop release or production relay mutation.

Test receiver bundle replaced through approved SSM path with verified hash,
previous bundle retained for rollback. Service and automatic stop remain active.
Live Python client from office completed trusted encrypted LIST and got 226
with tickets enabled and disabled, requiring control/data session reuse. No
new photos uploaded for those probes. User asked to retry unchanged saved FTPS
connection. Do not call this Canon success until that retry is observed.

Existing endpoint, certificate, credentials, firewall and four-hour stop timer
unchanged. Only synthetic trial; no PHI. Stop still 22:53:37 UTC / 3:53 PM
Mountain Nov6, with retained encrypted storage cost after stop.
