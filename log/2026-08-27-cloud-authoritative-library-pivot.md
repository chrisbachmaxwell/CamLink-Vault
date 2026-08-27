# 2026-08-27 — cloud-authoritative library pivot

## Decision
Chris replaced the local Capture Hub / shared-library product direction with a
central clinical cloud: every downloaded app signs in and sees the same data;
internet-capable cameras rely on the internet ingest path. HIPAA was the reason
for revisiting storage, but the important correction is that HIPAA does not
require cloud-only storage and a BAA alone does not create compliance.

Recommended production-shaped path: R6 Mark II FTPS → AWS Transfer Family →
private S3 → ingest workflow → PostgreSQL clinical API → authorized apps. The
R6 Mark II officially supports FTPS and root-certificate import. Use only AWS
HIPAA-eligible services and keep all pre-BAA work synthetic.

## Implemented (SDK `f2ce0a1`)
- Added `docs/CLOUD-CLINICAL-DATA-PLANE.md` and superseded the end-user Hub flow.
- Removed Settings **Other computers / Share this library**, its API/IPC/state,
  and the packaged desktop LAN listener. On upgrade the app forces the legacy
  preference false; it does not touch `captures/`.
- Added `@medphoto/clinical-cloud-domain`: tenant/location scoping, read-only
  reviewer, camera registration, patient/visit lifecycle, camera-active-visit
  upload routing, Unassigned retention, upload idempotency bound to SHA-256,
  opaque object keys, closed PHI-free audit schema, strict stored referential
  integrity, and soft delete/restore.
- Added 9 adversarial synthetic tests and wired the package into root gates and
  lockfile.

## Verification
- root build, typecheck, every workspace test: green
- smoke `ptp-simulator`, `ftp`, `multi-room`: green
- browser `ui-gate`: green; explicitly proves sharing control absent
- `npm ci --dry-run --ignore-scripts`, `git diff --check`: green

## Safety / not done
- No existing library, patient record, photo, camera config, Railway service,
  AWS resource, or provider agreement changed.
- No release was published; v0.18.14 remains the installed/live test build.
- The new domain is foundation, not a working multi-computer cloud app yet.
- Next: PostgreSQL/S3 adapters + authenticated API, then synthetic AWS FTPS
  ingest, then desktop cloud mode, migration/purge, and only last the BAA/
  production compliance gate.
