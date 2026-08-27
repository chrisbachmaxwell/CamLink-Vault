# HIPAA boundary (local-first history, cloud-authoritative decision)

Chris's original 2026-07-09 directive made Med Photo local-first. On
2026-08-27 Chris explicitly changed the product direction: the cloud will be
the authoritative clinical library so every signed-in computer sees the same
patients, visits, and photos. **Not legal advice** — cloud hosting does not make
the product HIPAA compliant by itself. The practice still owns policies,
training, risk analysis, retention, and device safeguards; a compliance advisor
must review before any real-patient pilot.

## What counts as PHI here
Patient names, DOB, notes, and the photos themselves (faces/dentition are
biometric identifiers). The whole `captures/` tree is a PHI store — treat
it that way in every feature.

## Architecture stance now
The clinical cloud is the source of truth ([[cloud-authoritative-library]]).
Internet-capable cameras upload by FTPS; every app reads through the same
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
