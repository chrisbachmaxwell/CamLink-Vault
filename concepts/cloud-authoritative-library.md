# Cloud-authoritative clinical library

Decision: 2026-08-27 (Chris). Supersedes the end-user Capture Hub / **Share this
library** product direction.

## Promise
Every authorized Med Photo app signs in and sees the same organization/location
patients, visits, and photos. No office Mac is the permanent source of truth.

## Recommended data path
Canon R6 Mark II → FTPS → AWS Transfer Family → private S3 → ingest workflow →
PostgreSQL clinical metadata/API → authenticated apps + realtime events.

The R6 Mark II supports FTPS, including imported root certificates. Each camera
credential resolves server-side to one opaque organization/location/camera id.
An upload goes only to that camera's active visit; without a matching visit it
is retained in an explicit Unassigned queue.

Camera setup is also evidence-based: creating credentials is not a connection.
The app asks for a test photo and claims verification only after the cloud API
has checksum-verified and completed a newer upload for that exact camera. The
opaque received-photo id may be used to show the synthetic proof image after
the same authorization checks as every other cloud photo.

## Per-camera identity and theft response
The server address may be shared, but every physical camera must have its own
random FTP/FTPS username and password plus a separate write-only cloud ingest
credential. The credential, never the camera's display name, binds uploads to
one organization/location/camera. A per-camera DNS alias is optional later; it
is not the security boundary.

Owners can create replacement setup values or disable a camera. Rotation is
staged: provision the new relay login, atomically switch the cloud credential,
then retire the previous relay login with an idempotent retry. Disabling a
stolen camera revokes only its login and cloud credential. Other cameras and
previously stored photos remain available. A camera may retain the old values
in its menu, but those values must receive no authority after revocation.

The current Railway implementation proves this workflow only with synthetic
photos over plain FTP. Production requires FTPS/TLS, an executed BAA, managed
secret protection, revocation drills and the remaining compliance gates.

## Storage rule
Final S3 object keys contain opaque ids only. Patient names, DOBs, original
filenames, signed URLs, and image bytes never enter logs/audit. Buckets are
private and access is short-lived after server-side authorization.

## Local rule
The app may use a bounded encrypted upload/cache area, never a permanent second
library. It removes a queued copy only after immutable cloud digest + metadata
confirmation. Existing captures are migrated explicitly and remain untouched
until a human approves a verified purge. Camera cards remain a capture/retry
buffer governed by clinic device/retention policy.

## Compliance boundary
Use AWS HIPAA-eligible services from the first synthetic sandbox so production
does not require an architecture rewrite. No real PHI until the production AWS
account has an executed BAA and the eligible-service, threat, backup/restore,
retention, audit, access-revocation, and incident-response gates pass. Railway
and the current prototype relay remain synthetic/non-PHI only.

## Release/update separation
Railway remains the non-PHI signed-manifest plane only. Large immutable ZIP
and DMG bytes live in a separate private, versioned S3 release bucket behind
read-only CloudFront; neither surface receives clinical records or photo
bytes. The package URL and SHA-256 are signed by the offline Ed25519 key. AWS
clinical storage remains a separate PHI-prohibited synthetic data plane. The
installed shell can check and apply a verified update before sign-in, so
Cognito or clinical-API availability cannot strand a computer on an old build.

Repo specification: `docs/CLOUD-CLINICAL-DATA-PLANE.md`.
