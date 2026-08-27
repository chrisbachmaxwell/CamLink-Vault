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

Repo specification: `docs/CLOUD-CLINICAL-DATA-PLANE.md`.
