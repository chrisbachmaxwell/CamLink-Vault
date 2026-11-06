# FTPS cloud trial launched — 2026-11-06

Chris explicitly approved launch with a $2 trial budget, office-only inbound
access and four-hour stop; confirmed the R6 II card was connected and later
confirmed the certificate imported successfully. Production HIPAA setup deferred.

Code evidence: feature bf0a1d8, SDK PR 26 merged f651894026ee880dbaf4ff16ef76110fe32d5de9
following all six local gates, infrastructure guard tests, wrapper startup and
Node 20/22 CI. No desktop release; installed 0.20.7 unchanged.

AWS stack medphoto-ftps-trial-20261106 CREATE_COMPLETE, us-east-1.
Instance i-0ed907d9786741d7f; public test endpoint 3.87.221.191:2121,
DNS ec2-3-87-221-191.compute-1.amazonaws.com.
Security group sg-0b74fece1c0f55ecc: verified ONLY approved office public IPv4
/32 on TCP2121 and TCP50000–50009. No public SSH or HTTP. SSM agent online.
Bootstrap successful, receiver active, stop timer active for 2026-11-06
22:53:37 UTC (3:53 PM Mountain). Stop retains encrypted 12 GiB disk; storage
charges continue. Timer is not a billing hard cap. No unrelated resources touched.

Server generated its private key on EC2. Only public CSR returned to Mac,
verified then signed by short-lived local CA (root seven days, leaf two days).
CA private key never left Mac. Public ROOT.CER copied to mounted card,
byte-compared, card ejected; Chris confirmed camera import. No system trust change.
Only saved R6 II login/ingest binding was copied, preserving existing FTP and
other camera. Settings were owner-only locally, CMS-encrypted to server key
before CloudShell/SSM transfer; credentials never appeared in command history,
output, source or vault. Public bundle/certificate and encrypted settings hashes
verified remotely. Non-root receiver active with private key/config permissions.

Live tests from office: plaintext USER rejected; trusted FTPS login accepted;
PROT P accepted; PROT C rejected; untrusted root rejected; wrong hostname rejected.
TLS-session-reused protected data upload of labeled synthetic computer-generated
JPEG returned 226 in 0.64 seconds. Native Med Photo subsequently showed Photo
received and updated last-photo time on the selected R6 II record. This was a
server test, not physical Canon evidence or shutter-to-visible timing.

Chris has a private local Camera setup.txt under the private trial directory,
including existing camera login, test address, FTPS/passive/automatic-JPEG steps.
No secrets in this note. Waiting for separate saved camera connection and object
photo; then run individual/burst/idle timing versus unchanged FTP route. No PHI.

UX correction: Canon C012 explicitly requires FTPS root import from a card.
An earlier suggestion that public CA alone might remove the step was corrected.
Design must make initial per-camera import simple; do not bypass verification or
promise public-CA trust-store support without evidence. Updated R6 II entity.

Outstanding operational cleanup: after testing verify spool delivery, stop VM
when idle, retain failed data for review, then explicitly dispose of dedicated
trial resources/storage and temporary credential copy when authorized. Root/leaf
expire; do not present trial endpoint as permanent office setup. A future restart
may change IP and require certificate/address reprovisioning.
