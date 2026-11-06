# Dedicated practice deployments

Decision: Chris, 2026-11-06. Independent practices must not share clinical
servers/sites or storage. Shared source and non-clinical installer/update
hosting are fine; DNS aliases over one clinical server are insufficient.

Each practice needs separate API, Cognito pool/client, metadata table, private
photo bucket, least-privilege IAM role, FTPS receiver/service and encrypted queue,
management secret and stable hostname/certificate. Prefer separate production
AWS accounts per practice. This does not promise dedicated physical AWS hosts.
No practice gets platform-wide administration. Camera identity remains scoped
to practice/location/camera. Signed-in desktop enrollment must bind the correct
practice endpoint and identity issuer. Cross-practice records or credentials
must fail closed even if accidentally inserted into the wrong repository.

SDK source adds dedicated-deployment membership/ingest checks, FTPS-only
activation policy, explicit legacy synthetic FTP opt-in and adversarial tests.
The existing sandbox template creates separate clinical resources per stack;
this is not evidence that two isolated live practices were deployed. See SDK
`docs/DEDICATED-PRACTICE-DEPLOYMENTS.md` for configuration and acceptance.

Permanent FTPS receiver provisioning, authenticated certificate distribution,
trusted desktop practice enrollment, renewal, two-deployment isolation drills,
MFA/recovery, key policy, audit, backups/restore, independent security review
and incident response remain open. AWS production BAA/eligible-service setup
is deferred. Synthetic-only until the exact deployment passes all PHI gates.

R6 II FTPS field transfer succeeded; Chris accepts perceived speed as fast enough.
The temporary trial has automatic stop and short-lived trust; not permanent hosting.
Next compatibility path: [[2026-11-secure-office-relay]].
