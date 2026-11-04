# 2026-11-04 — Start visits without optional paperwork

## Report and diagnosis
Chris could not start a visit: the patient entry point displayed five optional
metadata fields, then the raw error `request contains an unknown field` without
explaining any recovery. No patient name/photo or supplied screenshot is saved
in this vault. The screenshot establishes a failure, not the backend revision.

The installed 0.20.2 source submits every optional field, even when blank.
The clinic turns those blanks into null, and the cloud client forwards them.
An older API whose create route accepts only patientId/cameraId rejects those
extra keys. A synthetic regression reproduced the exact error before the fix.
Current main source and the retained 0.20.0 API artifact both accept visit
metadata, so a current deployed code mismatch remains an inference, not proven.
The public service health endpoint returns ok/synthetic-only but no revision;
initially no authenticated AWS session was available for deployed-code proof.
After Chris signed in, read-only inspection of `medphoto-synthetic-clinical`
confirmed Lambda CodeSha256 `NVAs7KSQHxz65qNHyahakR6LkGXpIP21oTRRB1RwMn0=`,
last modified 2026-09-05T18:45:16Z, update Successful, runtime nodejs22.x. This
matches the recorded 0.20.0 API artifact that accepts visit metadata. The exact
failing request/integration remains unproven; do not label the live API old.

## Decision and behavior
- Patient-page Start visit goes directly to capture when one camera is
  available. Two or more cameras ask only Which camera. Zero cameras explains
  that a camera must be added. Home's existing quick entry already skips the
  documentation form and is the immediate workaround for installed 0.20.2.
- Visit details remain optional and editable under Visit details & notes
  during/after capture. Do not silently inherit an earlier visit's context.
- Cloud creation omits null/empty/whitespace-only optional metadata. Nonempty
  submitted values are preserved; never retry by silently dropping them.
  PATCH nulls still clear saved values.
- Start failures preserve meaningful HTTP status and explain sign-in, access,
  missing patient/camera, app/service update, busy service or uncertain
  connection recovery. Raw upstream messages are not shown. An uncertain
  response does not claim that no visit was created.
- Existing-patient Open, exact stable identity, changed-visit protection,
  camera choice, reviewer restrictions and duplicate-submit guard remain.

## Validation
- `npm run build`: pass.
- `npm test`: 477 passed; one existing reconnect test skipped on this Mac.
- Required PTP-simulator, FTP and multi-room smoke commands: pass.
- Full browser UI gate: pass, including real local optional-metadata edits
  after capture begins, explicit multi-camera routing, compare/history,
  existing-visit races/preservation, direct single-camera start, repeated-click
  suppression, actionable error and successful retry. Desktop screenshots were
  inspected. A narrow fixture screenshot exposes the existing cramped test-mode
  header; the packaged desktop minimum width remains 960, not a mobile claim.
- Regression failed before the fix with the reported unknown-field message,
  then passed without a retry. Nonempty metadata rejection is not hidden.
- Arm64 packaging: ZIP safety/integrity, Finder extraction, deep/strict ad-hoc
  signature and mounted DMG checks pass. An isolated disposable-profile launch
  reports 0.20.3, signed-out auth, hidden clinical data and byte-identical served
  patient-workspace.js. No installed app or patient data was changed.

## Source and release boundary
Feature: `464c10b2648a9c472d38d1a2fcfe07a829854cf6`.
SDK PR: https://github.com/chrisbachmaxwell/CamLink-SDK/pull/19
Main base: `76fd261ff042f7e873e65b20052de5ed41e3bf36`.
PR 19 merged as `b86d56eefad098cf888ea5b53af885cd9a6fb770` after Node 20/22
GitHub CI passed; run `41926337959`. Main's tree matches the tested feature.
Chris explicitly designated the integration owner and authorized merge,
publication and updating this Mac.
Vault continuation: `codex/app-status-20261104`, PR 21 (same chat's earlier
status audit; historical audit note retained).

Published version: 0.20.3. Installed-version verification is pending; last
verified installed version was 0.20.2.
ZIP SHA-256: `8b042aa01943f98ddbe68e203544c62c66388eeedec3572c02e015c9c2a6afd1`.
DMG SHA-256: `62a3ccead082868c5c0421ce5027f0d8c5934808a0546138ecfcf0f182bcb625`.
Artifacts are in the isolated SDK worktree's `apps/desktop/release/`:
`/Users/chrismaxwell/.codex/worktrees/medphoto-visit-start/CamLink-SDK`.
The immutable ZIP was conditionally uploaded to the existing private release
bucket, then the offline publisher signed 0.20.3 and reverified retained
0.20.2/0.20.1/0.20.0 manifests and public ZIP bytes. The private key never left
the Mac. The existing Railway channel reached SUCCESS at deployment
`37e87537-3a70-4fe3-878a-05edee2e69ab`. Latest Ed25519 signature, complete
114103084-byte ZIP and 124174899-byte no-store DMG downloads match the hashes
above; health is ok. A disposable-profile check using the installed 0.20.2
NativeMacUpdater returns available 0.20.3. Backend/IAM/storage/provider
agreements are unchanged.

Durable release evidence:
- `/Users/chrismaxwell/MedPhoto-Clinical-Stage-0.20.3/` — package, deployment and
  public-release receipts; inspected upload helper and read-only API checker.
- `/Users/chrismaxwell/MedPhoto-Deploy-0.20.3-release/` — exact deployed bundle.
- `/Users/chrismaxwell/MedPhoto-Package-Audit/0.20.3-release/` — verified history
  to use as the next publisher's previous-release-directory.

Mistakes caught: including both full bootstrap installers exceeded Railway
CLI's upload size limit (413, no deployment); the final bundle keeps the current
bootstrap DMG, matching prior release practice, while all retained signed ZIP
versions remain available. CloudShell uploads need a filechooser listener before
Actions → Upload file and one upload at a time. The Railway connector needed
reauthentication; the already-authorized CLI account completed deployment.
Native app automation can read the window but coordinate clicks fail with
noWindowsAvailable; Chris was given the normal two-click update path, and
installation will be verified independently.

## Remaining final steps
Verify the authorized 0.20.3 installation, then prove a synthetic visit against
the actual service. If an error remains, verify the exact API integration/Lambda
revision before proposing a scoped backend change. Existing captures and visits
must remain intact; no automatic end/recreate workaround.
