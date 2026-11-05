# HIPAA boundary (local-first history, cloud-authoritative decision)

Chris's original 2026-07-09 directive made Med Photo local-first. On
2026-08-27 Chris explicitly changed the product direction: the cloud will be
the authoritative clinical library so every signed-in computer sees the same
authorized practice/location patients, visits, and photos. **Not legal advice** — cloud hosting does not make
the product HIPAA compliant by itself. The practice still owns policies,
training, risk analysis, retention, and device safeguards; a compliance advisor
must review before any real-patient pilot.

## What counts as PHI here
Patient names, DOB, notes, and the photos themselves (faces/dentition are
biometric identifiers). The whole `captures/` tree is a PHI store — treat
it that way in every feature.

## Architecture stance now
The clinical cloud is the source of truth ([[cloud-authoritative-library]]).
The production design requires internet-capable cameras to upload by FTPS;
the current synthetic relay still uses plain FTP. Every app reads through the same
authenticated, location-scoped API. A local adapter may keep a short-lived
encrypted upload queue for cameras that cannot reach the cloud, but no Mac is
the permanent shared library server.

Until an executed BAA, eligible-service review, security/recovery evidence, and
compliance sign-off exist, this path is **synthetic data only**. Railway remains
release/non-PHI prototype hosting. The current plain-FTP relay is never a
patient-photo store.

## Technical safeguards ladder
1. OIDC identity plus server-side organization, location, and role checks on
   every API request and event stream.
2. FTPS/HTTPS in transit; private object storage and managed encryption at rest.
3. Opaque object keys and PHI-free operational logs/audit facts.
4. No public bucket/object URLs; access is short-lived and authorized.
5. Verified, resumable upload/migration before any local purge. Upload-started
   is never permission to erase the only copy.
6. Soft deletion, retention policy, backups, and rehearsed restore/incident
   response. Never hand-roll encryption.

## Red lines for every future feature/agent
- No PHI in logs, commits, or the vault (camera serials fine; patient
  names/photos never).
- No real PHI touches any cloud environment until the BAA/provider/deployment
  gate is complete. Synthetic tests must remain unmistakable.
- Existing local libraries are preserved until an explicit digest-verified
  migration and separately approved purge. No app update silently deletes one.

## Practice isolation and production acceptance — 2026-11-05
Chris reaffirmed: each independent medical practice must see only its own
information. An organization is the practice boundary; locations belong to that
organization. Human users receive individual accounts and explicitly granted
roles. No practice owner gains access to another practice by being an owner.
Derive authority from verified identity and server-held membership, never from
a client-supplied practice selector. Missing or ambiguous scope must deny access.
Apply the same boundary to reads/writes, originals/thumbnails, exports, search,
background ingest, events, caches, backups and support/admin access. Test with
at least two independent synthetic practices and hostile identifier swapping.
No blanket platform support access; any future exceptional access needs an
explicit, time-limited, audited design.

Source review at SDK main `2e536da` confirms scoped membership/repository reads,
role checks and camera credential scope. Seventy focused API/domain tests pass.
This is not a live infrastructure audit or penetration test. Current onboarding
is a configured synthetic organization/location, not a completed many-practice
production onboarding system. The AWS template declares private KMS-encrypted,
versioned S3 and DynamoDB point-in-time recovery; runtime settings were not
reverified in this review. MFA is not declared in the sandbox UserPool template.
Photo content authorization issues a 60-second S3 presigned bearer URL; someone
possessing that URL can use it until expiry. Immediate link revocation and
per-view audit completeness are not established (content handler itself does
not append a view audit). Resolve the production access model and test it.

Before real PHI: verify executed BAAs for the actual AWS account and applicable
practice/provider chain; eligible services and regions; replace plain FTP/relay;
require and verify stronger authentication/MFA and user/device revocation;
independent threat/isolation/penetration review; encrypted device/cache/card
policy; audited access and alerts; least-privilege administration; proven backup,
restore, retention/deletion and incident procedures. Separate production from
test and sign off the exact serving endpoints/configuration. AWS infrastructure
eligibility never certifies our application, and no system is guaranteed
breach-proof. No PHI pilot authorization was given by this review request.

Sources checked 2026-11-05 (verify after: 2026-12):
- https://aws.amazon.com/compliance/hipaa-compliance/
- https://www.hhs.gov/hipaa/for-professionals/special-topics/health-information-technology/cloud-computing/index.html
See [[log/2026-11-05-security-readiness-review]].
