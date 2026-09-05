# 2026-09-05 — Patient workspace implementation

## Request and scope
Chris approved the patient workspace direction with “lets do it”. This first
release adds shared patient editing, structured visits, authored visit notes,
and a cohesive patient UI. Signed forms, clinical-photo/marketing permissions,
photo-view protocols, and wider EHR functionality remain separate work.
All test records and photographs were synthetic. No real captures were read,
changed, migrated, or sent to a provider. The primary SDK and vault checkouts
were preserved; implementation used fresh-main isolated worktrees.

## Behavior
- Patient registration/editing supports full and preferred name, DOB, optional
  chart ID, email, phone and patient-level preference note. IDs and existing
  visit/photo folders survive edits. Search covers preferred name and chart ID.
- Name+DOB and chart-ID duplicate checks are normalized. Revision checks return
  a conflict rather than overwriting changes from another computer. Historical
  duplicates do not prevent unrelated corrections; there is no automatic merge.
- Visits carry purpose, provider, procedure, body area and baseline/follow-up/
  other phase. Notes are append-only, stamp the authenticated author/time, and
  use request IDs for safe retries. Notes are bounded at 25 per visit and 2,000
  characters each in this first implementation.
- Patient UI has Overview, Photos & visits, and Details, with a persistent
  identity header. Registration is available from Patients. Start visit opens
  a short preparation form; prior provider/procedure/body area are suggestions
  to review. Home retains its fast repeat-visit path. No placeholder implies
  signed consent exists.
- Polling preserves unfinished patient/visit edits and note drafts. Conflicts
  retain the draft and offer an explicit latest-record reload before retry.
  Reviewers remain read-only. Navigation uses consistent local SVG icons.

## Review findings fixed
- Empty-visit cleanup could erase a note saved concurrently with End visit.
  Keep the manifest and documentation; hide truly blank visits in history.
- Asynchronous preparation could attach two sessions to one camera. Reserve
  the camera while starting and release the reservation on every outcome.
- Timestamp-only local visits could collide within one second and overwrite
  a prior manifest. Actual local starts now reserve unique visit folders.
- One unreadable documentation sidecar could hide all patient photo history.
  Preserve the photo/manifest view and surface the individual document error.
- New browser assets require both public-shell and static-route allowlisting.
  The real-server browser gate caught this gap before packaging.
- DynamoDB metadata edits and visit completion preserve concurrently appended
  notes; failed audit/record transactions do not partially commit.

## Validation
- Full monorepo build and all workspace tests pass. Clinic: 99 passed, one
  existing macOS loopback portability skip. Cloud API: 53; domain: 13; client: 11.
- PTP simulator, FTP, multi-camera smoke and full front-desk browser gate pass.
- Independent synthetic HTTP gate proves rich edits/search, stale conflicts,
  notes/retries, author stamping, reviewer denials, concurrent starts, end/save
  races, and byte-identical old photos/manifests/notes after rapid revisits.
- UI harness verifies draft retention/reload/conflict behavior, visit preparation
  and registration. Separate browser-context and narrow-window details will be
  recorded with the final UI handoff.
- No physical camera/two-Mac installed-app proof is implied by these tests.

## Delivery evidence
- Cloud feature `e6b6dcd`, SDK PR12, merged `829d55e`.
- Clinic bridge feature `8bc8a5b` (PR head `7b7a955`), PR14, merged `302063a`.
- Independent HTTP gate feature `b17f3d1`, PR13, merged `fd43808`.
- UI/version feature `6fc979e`, PR15, merged `22a3770`.
- All four PRs passed Node 20 and Node 22 CI before sequential main merges.
  Final source main: `22a37708e49e0cc52a5be898f3ef15aad08cf508`.
- Exact frozen UI head reran eight browser scenarios: two independent owner/
  staff contexts edit together, stale-save conflict, explicit rebase preserving
  untouched remote fields, authored notes, note draft surviving remote append,
  read-only reviewer, and 390px layout without horizontal overflow. This used
  an in-memory synthetic API harness; actual services are tested separately.
- Actual server screenshots cover patient Overview, visit preparation, and
  Photos & visits, alongside the full camera/front-desk gate.
- Exact main produced arm64 0.20.0 ZIP and DMG; native package script verifies
  ZIP integrity, no AppleDouble entries, extracted-app ad-hoc code signature,
  and DMG. A fresh disposable-profile Electron launch independently showed
  version 0.20.0, cloud mode, sign-in and both new workspace assets returning 200.
  It did not install over `/Applications/Med Photo.app` or sign in clinically.
- NativeMacUpdater independently accepted the exact signed 0.20.0 arm64 ZIP
  in a disposable verification directory. No install/apply was attempted.
- The local Ed25519 manifest signature verifies with the tracked release public
  key. Prior signed release history is retained (0.19.9,0.19.7,0.19.6).
- AWS Console was signed out. Asked Chris to restore the existing Med Photo
  AWS session; no passwords or access keys were read, created or changed. No AWS deployment,
  package upload, Railway deployment, real patient use or installed-app update
  occurred. Live latest was rechecked and remains 0.19.9; synthetic API health
  is green but does not identify the deployed code.
- Staging caught a missing `/v1/packages/` prefix in the publisher invocation;
  it was corrected before any provider write. The normal publisher then
  stopped at the expected external-URL verification because the new ZIP has
  not been uploaded. The partial Railway directory must not be deployed.
- Blocker: existing AWS Console/CloudShell sign-in must be restored before the
  synthetic API update and immutable package upload. Resume with the following
  artifact receipt and steps. No compliance/provider-policy change is needed
  or authorized by this release work.

## Exact local artifacts
- Package audit/signatures/history and `release-receipt.json`:
  `/Users/chrismaxwell/MedPhoto-Package-Audit/0.20.0`.
- ZIP: `packages/Med-Photo-0.20.0-darwin-arm64.zip`,114098429 bytes,
  SHA256 `677b450de4b09a51f8fa143ed4f0739454e41e52aa7719932e4a23619ca571da`.
- DMG: `bootstrap/Med-Photo-0.20.0-darwin-arm64.dmg`,124085513 bytes,
  SHA256 `f383e6c8fba86399671efb1636b1c8d2181d7bc9e98ee15e03fcadd9bdec23d4`.
- API: `/Users/chrismaxwell/MedPhoto-Clinical-Stage-0.20.0/clinical-cloud-api.zip`,
  247978 bytes, SHA256
  `35502ceca4901f1cfae6a347c9a85a911e8b9065e920fdb5a13451075470327d`;
  Lambda CodeSha256 `NVAs7KSQHxz65qNHyahakR6LkGXpIP21oTRRB1RwMn0=`.
- Manifest issuedAt: `2026-09-05T17:42:37.847Z`.
- `/Users/chrismaxwell/MedPhoto-Deploy-0.20.0` contains only the partial runtime
  scaffold because external-byte verification stopped publication. Preserve it
  as incomplete. The earlier `...0.20.0-origin-check` is also incomplete.

## Resume deployment after AWS sign-in
Before writes, recheck the published latest is still 0.19.9 and each immutable
API/desktop object key is absent or contains the exact expected bytes. If a
newer release exists or any 0.20.0 object differs, stop and prepare a fresh
version using current verified history. Never overwrite an immutable object
or downgrade latest by replaying the pinned 0.19.9 history.

1. Verify the account and existing synthetic stack in AWS Console/CloudShell.
   Use region us-east-1 and `medphoto-synthetic-clinical`; no new identity, policy
   or production-PHI gate. Upload the exact API ZIP under an immutable digest
   key in the stack's existing LambdaCodeBucket. Prepare a code-only UPDATE
   change set with `--use-previous-template`, preserve every prior parameter
   except the approved LambdaCodeBucket/Key, and inspect that only
   ClinicalApiFunction code changes with no replacement. Execute, then prove
   deployed Lambda CodeSha256 equals the value above and health stays green.
2. Sign in to the synthetic clinical app and verify richer patient PATCH,
   visit metadata, authored note/retry and a second authorized client. Keep
   test values synthetic. A live health 200 alone is insufficient.
3. Discover the existing ReleaseBucketName from `medphoto-release-sandbox`.
   Upload the exact ZIP to
   `v1/packages/Med-Photo-0.20.0-darwin-arm64.zip` with immutable cache headers.
   Stream the public CloudFront URL and verify exact bytes/hash.
4. Rerun the normal publisher from the integration worktree with a fresh
   `MedPhoto-Deploy-0.20.0-verified` and
   `MedPhoto-Package-Audit/0.20.0-verified` directory, package base
   `https://dgh9gdn4fjlbh.cloudfront.net/v1/packages/`, previous history0.19.9,
   retain3, min-supported0.18.0, version 0.20.0, and the pinned issuedAt above.
   Use the existing offline signing key path; never output its contents. Let
   external verification pass normally, then add the exact DMG to bootstrap.
5. Preserve the existing startup command:
   `MEDPHOTO_RELEASE_DIRECTORY=./releases MEDPHOTO_BOOTSTRAP_DIRECTORY=./bootstrap node dist/index.js`.
   Deploy only the verified directory to the existing Railway service:

```sh
railway up /Users/chrismaxwell/MedPhoto-Deploy-0.20.0-verified --path-as-root \
  --project a2ff3fdf-7e0a-4875-9c79-1a254ec0f62b \
  --environment production --service e8426aad-1042-427d-a26c-573ee4b9c48a \
  --message "Med Photo internal-test 0.20.0 patient workspace"
```

6. Prove `/healthz`, signed latest 0.20.0, full immutable ZIP bytes/hash,
   no-store latest DMG bytes/hash and retained older URLs. Log exact AWS and
   Railway deployment identities. Only then describe the release as published.
   Two-Mac installation, real camera field behavior and production compliance
   remain distinct proof.
