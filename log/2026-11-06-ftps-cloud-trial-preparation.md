# Direct-cloud FTPS trial preparation — 2026-11-06

Chris selected the saved Canon R6 Mark II and direct-to-cloud testing. Both app
and AWS authentication now work; the earlier preflight sign-in blocker is cleared.
No PHI allowed. Working Railway FTP and saved camera profile are preserved.

Owned code: infra/ftps-test. Feature bf0a1d8a82a32cb2e88cc470a249a6e0a187fab6,
SDK PR https://github.com/chrisbachmaxwell/CamLink-SDK/pull/26 open; not merged,
released or deployed at this checkpoint. Installed app stays 0.20.7.

Template: t3.small, encrypted 12 GiB gp3, IMDSv2, office IPv4 /32 ingress on
2121 and 50000–50009 only, no SSH/HTTP ingress. Narrow SSM instance-control
role (no clinical-data/parameter reads). Non-root service, private configuration,
four-hour-per-boot stop timer. Disk persists and incurs charges after stop;
bootstrap failure can prevent the timer, so verify it after launch. No Elastic IP.

Build, workspace tests, PTP/FTP/multi-room smokes and UI gate all passed.
Two infrastructure guards passed. Receiver loaded fixture TLS, installed one
synthetic binding and stopped gracefully locally. AWS validate-template passed
for exact uploaded SHA-256
2552ff5e4bd16775dbc03553d71467233d9c9aa9d7e713683a98bd21c6d7772c.
Read-only routing verified an active internet gateway. Existing unrelated AWS
instances were not modified. CloudShell refuses overwrite on upload; the
reviewed template used a unique filename and its hash was checked.

Pending: explicit launch confirmation (new network/IAM access and $2 trial
budget), card availability, server provisioning, secure single-camera binding
copy, short-lived CA-signed server certificate and public root card import,
trusted/negative TLS checks, actual Canon upload and matched timing trials.
No credentials/keys exported or created; no instance launched. Never publish
secrets in source, SSM commands, CloudShell history or vault. CA private key stays
off server; no trust bypass or Mac root-store installation. Different hosting
routes mean timing is a route comparison, not pure encryption overhead.

Physical acceptance is still open. Prepared infrastructure is not deployed
service, camera compatibility, latency proof or production HIPAA readiness.
