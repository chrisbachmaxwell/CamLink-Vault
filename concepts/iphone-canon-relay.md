# Canon USB through iPhone to cloud

Chris explicitly chose the cloud route on 2026-09-10, after requesting broad
Canon support, an iPhone connection, and no persistent patient data on phones.
That choice supersedes the earlier LAN-only direction for this feature. It
does not establish HIPAA compliance or authorize use of real patient data before
the existing production security and operational gates pass.

## Implemented source

SDK PR 18, branch `codex/iphone-cloud`, head `dc1defb`, adds the SwiftUI
Med Photo Camera app, Canon USB CameraAdapter using ImageCaptureCore, desktop
QR pairing, and the existing clinical AWS cloud ingest integration. Credentials
expire after eight hours; enrollment and pending-transfer state remain in RAM.
The phone polls only an opaque active-visit token, pins each capture to that
visit, hashes bounded 256 KiB camera reads and streams an S3 upload in the
foreground. Completion requires the expected byte count, digest and visit.
Idempotent retries reconcile already completed uploads without resending them.

No app photo-file writer, Photos-library save, disk queue, background upload,
URL cache or credential persistence is provided. Switching away pauses capture;
failed transfers retain camera originals. Replaced/expired enrollment prompts
re-pairing. Changed visits cannot silently receive an earlier capture. Existing
Canon sessions are retained rather than repeatedly closed and reopened.

App-level memory-only design is not proof of zero operating-system/framework
residue. Device storage audit remains required. Camera originals are never
automatically deleted. Only JPEG/CR2/CR3 are currently selected for transfer.
Broad Canon discovery is a validation target, not a claim that all Canon
models, firmware, cables or live-capture events work.

## Evidence and delivery boundaries

- Source PR: https://github.com/chrisbachmaxwell/CamLink-SDK/pull/18
- Native checks: eight synthetic coordinator/pairing checks; XCTest includes
  a real bounded streamed HTTP transfer. CI built and launched the unsigned
  iPhone simulator app; its initial screen was visually inspected.
- Desktop QR pairing was visually checked at desktop and 390px width using
  synthetic API fixtures. PTP, FTP, multi-room and browser UI gates passed.
- Cloud API tests: 55 passing, including credential expiry/replacement,
  changed-visit rejection, original-visit replay and completed-upload replay.
- Final PR CI determines exact-head build/test evidence. No main merge,
  AWS deployment, signed physical-device install or Canon field proof is
  implied by a branch push or simulator run.

This task has no configured AWS deployment credentials or Apple signing
identity; this Mac has Command Line Tools but no full Xcode. Cloud deployment
must include both the API artifact and the new gateway status route. A signed
physical iPhone build, camera/cable/model tests, storage-residue audit and the
cloud BAA/security/clinic operational gates are still required. Keep testing
synthetic-only until those gates are satisfied.

See SDK `docs/IPHONE-CANON-RELAY.md` and `native/MedPhotoCamera/README.md` for
implementation details, primary references and exact build/install commands.
See [[log/2026-09-10-iphone-canon-relay]].
