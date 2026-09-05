# 2026-09-05 — Existing patient visit recovery (0.20.2)

## Field report and decision
A user-supplied screen showed Start visit on the record of a patient whose
camera already reported an active visit. The conflict then suggested ending
and recreating that same patient's visit. The screenshot proves an active
projection was reported; it does not establish who originally opened it.
No patient identifiers, screenshots of real records or clinical data are
retained here. An optional question about first-ever visit versus first visit
after updating had no answer at implementation time.

Match the stable patient ID, offer Open visit with camera/photo context, and
refresh before opening or preparing. Same-patient races offer only Open;
different IDs retain the explicit turnover choice. Preserve existing visit
folder, photos and metadata. Explicit opening now navigates to capture;
background refresh still preserves patient/compare navigation. Guard stale
links against replacement visits and duplicate Home submissions. Local 409
responses now include the stable patient/visit IDs and folder.

## Verification and mistakes caught
The synthetic 48-photo regression failed before the fix (Start instead of
Open). The first fix exposed a second defect: renderSession intentionally
preserved the patient page even for an explicit Open action. Explicit
navigation fixes that without changing ambient polling. The full local UI
check initially failed because the new regression left its patient search
filter filled; clearing it through the UI restored the pre-existing test's
initial state. Screenshot capture disables transition animation.

Root build, all workspace tests, PTP/FTP/multi-room smokes and the full browser
UI gate pass. The real local-server check preserves folder/photo count and
asserts stable conflict IDs. Synthetic cloud cases cover 48-photo and original
metadata preservation, same-name/different-ID records, remote-end and start
races, changed-visit links, offline recovery and reviewer restrictions. The
exact arm64 package passes archive/version/architecture/ad-hoc code-signature
and DMG verification. Disposable-profile packaged startup shows sign-in,
hidden clinical navigation and the independent update control.

## Integration and publication
Feature commit: `9b84771f2e57502771e585643e9f63e6b92bdf1f`.
SDK PR: https://github.com/chrisbachmaxwell/CamLink-SDK/pull/17
SDK main merge: `76fd261ff042f7e873e65b20052de5ed41e3bf36`; its tree
`54347c0c2e51b1e8fa98916e30d7cd0aeff9078d` exactly matches the packaged
feature commit. Node 20 and 22 CI both pass.

Arm64 ZIP: 114102806 bytes, SHA-256
`1aa9477dfbd1cc87e4b85c8e718cb75b30c77eaa09ccd631206d3be51e1b5c87`.
Arm64 DMG: 124590576 bytes, SHA-256
`c208d9ec0afdb94196497960d08c544627261af928da0385164f608d8436ab89`.
Packaged app.js, patient-workspace.js and index.html match the tested source
byte-for-byte. The external package publisher verified every retained ZIP and
manifest, including full public downloads, before signing the new snapshot.
Only the immutable software ZIP was uploaded to the existing release bucket.

Railway deployment `d0190dec-5e74-442e-80a7-8da370e88114` is SUCCESS, image
`sha256:8f6e9e5019368e28ae8a6eb6d8d76456acb72ce93d61a37e0e98064357c9963b`.
The public signed 0.20.2 manifest exactly matches the stage, health is 200/ok,
and the full latest DMG download matches the above bytes/hash with no-store.
The immutable DMG route returns 200. The exact packaged updater reports
0.20.2 available from a disposable 0.20.1 profile. Chris's installed bundle
remains read-only verified as 0.20.0; no install was performed.

Public update: https://med-photo-release-service-production.up.railway.app/v1/releases/darwin-arm64/latest.json
Direct recovery: https://med-photo-release-service-production.up.railway.app/v1/bootstrap/Med-Photo-0.20.2-darwin-arm64.dmg

Exact local evidence (outside git):
- `/Users/chrismaxwell/MedPhoto-Clinical-Stage-0.20.2`: package/startup/public
  receipts, synthetic startup screenshot, direct DMG and upload verifier.
- `/Users/chrismaxwell/MedPhoto-Package-Audit/0.20.2-release`: next publisher's
  prior history; only manifests and packages, retaining 0.20.1/0.20.0/0.19.9.
- `/Users/chrismaxwell/MedPhoto-Deploy-0.20.2-release`: exact Railway source
  bundle, signed manifests and separate bootstrap directory.
- SDK worktree `codex-same-patient-visit-recovery-20260905`; synthetic patient
  screenshot `apps/clinic/test/artifacts/24-patient-open-visit.png`.

CloudShell had insufficient staging space. Removed only the earlier
agent-created 0.20.1 upload tar after verifying its retained local copy, then
uploaded the 0.20.2 software ZIP and small verifier/receipt individually. After
public-byte verification, removed only the current temporary CloudShell ZIP;
immutable S3 and local audit copies remain. No unrelated files were removed.

## Boundary and next field check
No live patient/visit was read, ended, deleted or edited. No clinical API,
Cognito/IAM settings, capture store or installed app was changed. The larger
inactivity/reopen proposal remains separate and is not present on main; this
release does not silently expire existing visits. Physical two-Mac proof is
still required: the same synthetic patient should offer Open on both Macs,
open the same visit and preserve its photo count and details.
