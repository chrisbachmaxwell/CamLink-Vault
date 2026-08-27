# 2026-08-27 — synthetic cloud library live

## Outcome
Med Photo now has a working synthetic-only cloud path rather than only a domain
model. The tagged AWS sandbox uses Cognito sign-in, an authenticated Lambda/API
Gateway boundary, DynamoDB metadata and private S3 originals. Railway remains
the separate non-PHI signed-manifest plane; a different private/versioned S3
release bucket serves immutable app bytes through read-only CloudFront.

The downloaded app configuration contains only the public API origin, region
and user-pool client id. Username/password credentials and refresh/access
tokens stay in process memory. Owners can add owner/staff/reviewer accounts;
reviewers can see the shared library and cannot mutate it.

## Reliability and routing fixes
- Upload grant creation freezes patient/visit association. Completion can no
  longer move a slow upload from patient A into a newly started patient B
  visit on the same camera.
- Each local camera entry persists an opaque cloud camera id. Camera display
  names are not used as identity across computers.
- Active and no-visit synthetic camera photos upload directly from memory to
  S3 and return only an opaque `cloud:` reference; no permanent photo file is
  written by the camera-host app.
- Signed-out update checks remain a desktop-shell capability and are not
  blocked by Cognito or the clinical API. [[in-app-updates]] now records the
  signed immutable package and rollback contract rather than obsolete Git/npm
  behavior.

## Evidence
- API adversarial suite: membership scope, reviewer block, rollback on failed
  account persistence, self-owner removal refusal, and patient-A/patient-B
  upload turnover all green.
- Two independent local app processes signed into the live AWS sandbox as
  Owner and Reviewer. The Owner created a synthetic visit and triggered one
  mock-camera photo; the Reviewer listed the visit, received one photo and
  downloaded the bytes. Reviewer delete returned 403.
- The camera-host test profile contained zero JPEG/PNG/RAW photo files after
  cloud confirmation.
- Browser proof showed the cloud username/password screen, Owner People page,
  reviewer patient library and the shared visit image.
- The exact v0.18.16 arm64 package passed archive/version/architecture/code-
  signature checks and a packaged-runtime cloud startup regression. Railway's
  live manifest signature verified, and a fresh CloudFront download matched
  its signed SHA-256. Update check remains available before clinical sign-in.

## Boundaries still open
Synthetic data only. No BAA, real patient record, production migration, local
purge or provider agreement changed. Transfer Family FTPS, R6 Mark II direct
camera proof, push realtime, multi-location, PostgreSQL production storage,
retention/restore/revocation drills, Apple notarization and every production
compliance gate remain open.

Code: SDK `9bcc526` on `claude/camera-sdk-adapter-pattern-4pj5r8`.
