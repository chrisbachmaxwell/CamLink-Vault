# Patient workspace 0.20.0 publication — 2026-09-05

## Decision and scope
Chris said "I'm in amazon" after the implementation handoff identified AWS
sign-in as the publication blocker. The existing in-app AWS Console and
CloudShell session were authenticated, so the previously authorized synthetic
API update, immutable software upload and Railway publication continued.
No new AWS credentials, provider identities, policies, agreements or real
clinical records were created or changed. The code remains the exact tested
SDK main `22a37708e49e0cc52a5be898f3ef15aad08cf508`; no code change or rebuild
was necessary. Prior implementation gates and merged PRs are recorded in
[[log/2026-09-05-patient-workspace-implementation]].

## AWS deployment
- Rechecked current public latest 0.19.9 before writes and publication. Exact
  versioned S3 keys were absent; conditional `If-None-Match: *` writes and
  SHA-256 checks prevented an immutable-key overwrite.
- Existing stack: `medphoto-synthetic-clinical`, account `276840047587`, region
  `us-east-1`. Tags confirmed `synthetic-only` and `PHI=prohibited`.
- The reviewed CloudFormation change set
  `patient-workspace-0200-20260905` changed `ClinicalApiFunction.Code` and its
  dependent `ApiIntegration.IntegrationUri` reference. Both were `Modify`
  with no replacement; the integration change was a dynamic reference to
  `ClinicalApiFunction.Arn`. Previous template, other parameter values,
  capabilities, identities and storage settings were preserved.
- CloudFormation reached `UPDATE_COMPLETE`; Lambda reported `Successful` and
  CodeSha256 `NVAs7KSQHxz65qNHyahakR6LkGXpIP21oTRRB1RwMn0=`.
- API ZIP: 247978 bytes, SHA-256
  `35502ceca4901f1cfae6a347c9a85a911e8b9065e920fdb5a13451075470327d`.
  Stored in `medphoto-synthetic-artifacts-276840047587-us-east-1` under
  `clinical-api/35502ceca4901f1cfae6a347c9a85a911e8b9065e920fdb5a13451075470327d.zip`.
- Previous API key retained for rollback:
  `clinical-api/dbad396f29c8aecb51520d7d4e0b0cf4f1d86d881d475b1628d7a8181d4a2c0b.zip`.
- Live `/v1/health` returned HTTP 200, `ok=true`, `environment=synthetic-only`.
  Unauthenticated patient PATCH, visit PATCH and authored-note POST probes
  returned 401. These prove the live authentication boundary, not signed-in
  persistence or role behavior; those remain field verification.

## Published release
- Private release bucket:
  `medphoto-release-sandbox-releasebucket-adjnssrjna0i`.
  Key: `v1/packages/Med-Photo-0.20.0-darwin-arm64.zip`.
  Cache-Control: `public,max-age=31536000,immutable`.
- Exact arm64 ZIP: 114098429 bytes, SHA-256
  `677b450de4b09a51f8fa143ed4f0739454e41e52aa7719932e4a23619ca571da`.
- Exact arm64 DMG: 124085513 bytes, SHA-256
  `f383e6c8fba86399671efb1636b1c8d2181d7bc9e98ee15e03fcadd9bdec23d4`.
- Publisher revalidated the prior audit directory and full public downloads
  of 0.20.0 plus retained 0.19.9, 0.19.7 and 0.19.6 packages. It reproduced
  the prepared signed manifest with issuedAt `2026-09-05T17:42:37.847Z`,
  minSupportedVersion 0.18.0 and the exact CloudFront `/v1/packages/` origin.
- Reviewed deployment source:
  `/Users/chrismaxwell/MedPhoto-Deploy-0.20.0-verified`.
  It contains only the built release service, signed manifests and direct
  bootstrap DMG. The startup command explicitly preserves both directories:
  `MEDPHOTO_RELEASE_DIRECTORY=./releases MEDPHOTO_BOOTSTRAP_DIRECTORY=./bootstrap node dist/index.js`.
- Railway deployment `76143415-6703-4d5f-ad05-d8433b23b903`: `SUCCESS`.
  Image digest:
  `sha256:aff9115dca672b6c1b9c754d58a16e34988ed5eb8f1d77dfdbd10a15b1653114`.
  Previous deployment: `6b26cfd3-9af6-49b1-b737-5e677b1fdd47`.
- Release `/healthz` returned HTTP 200 and plain text `ok`. Public latest
  0.20.0 passed Ed25519 verification against the embedded public key and
  matched the exact publisher stage. Full latest DMG download matched its
  byte count/hash and returned `Cache-Control: no-store`; immutable DMG HEAD
  returned 200. The exact packaged NativeMacUpdater, using a disposable
  profile with currentVersion 0.19.9, reported 0.20.0 available.
- No installation was performed. A fresh read of the installed
  `/Applications/Med Photo.app` metadata still reports 0.19.7.

## Receipts and future release input
- Next release must use the verified audit directory as its previous history:
  `/Users/chrismaxwell/MedPhoto-Package-Audit/0.20.0-verified`.
  It includes package history, matching signed manifests, exact bootstrap and
  `public-release-receipt.json`.
- AWS receipt and reviewed deployment helper:
  `/Users/chrismaxwell/MedPhoto-Clinical-Stage-0.20.0/aws-deployment-receipt.json`
  and `deploy0200reviewed.py` in that same directory.
- Earlier partial deploy directories `MedPhoto-Deploy-0.20.0` and
  `MedPhoto-Deploy-0.20.0-origin-check` remain incomplete and must never be
  deployed. The offline private signing key never left the build Mac.

## Mistakes caught and patterns confirmed
- CloudShell's Actions > Upload file opens the browser file chooser directly;
  attach the chooser listener before clicking. The browser-mediated transfer
  used only prepared software and a scoped helper, not credentials or records.
- Long CloudShell terminal typing times out; short chunks worked. Uploading a
  reviewed helper avoided typing large commands or secrets into the terminal.
- The first execution guard intentionally stopped when it saw two resource
  entries rather than one. Inspection proved the extra entry was only the
  expected dynamic integration URI dependency. The guard was narrowed to
  those exact resources/properties before execution; no update occurred on
  the failed attempt.
- The first public health verifier assumed JSON, but the release service
  correctly returns plain text `ok`. The verifier was corrected, and all
  release checks then completed.
- Railway CLI upload completion is not deployment success. Status was checked
  separately, followed by public-byte and native-updater proof.

## Integration and remaining field work
SDK PRs 12/14/13/15 were already merged to `main` `22a3770`, and the owned
SDK branch was already pushed. This session preserves the unrelated primary
SDK/vault checkouts and updates only the isolated publication vault branch.
The vault change is reviewed through its own PR to main; the merge result is
recorded in the session handoff and GitHub history.

On both Macs, open Med Photo and use Software Update to install 0.20.0, or use
the direct arm64 DMG. Sign in through existing authorized accounts. With only
synthetic records, verify profile edits reload and appear on the other Mac,
visit metadata and authored notes persist, concurrent edits preserve the local
draft and offer recovery, and Review remains read-only. Authenticated live API
workflow, exact physical two-Mac installation/camera proof, signed consent,
guided photo protocols and production compliance remain open. Publication of
this first slice is not full RxPhoto parity or a production-PHI approval.
