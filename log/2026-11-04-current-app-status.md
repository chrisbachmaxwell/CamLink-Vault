# 2026-11-04 — Current app version and built-feature audit

Chris asked what has been built and the current app version. This session
audited source, the live public release metadata and the installed bundle;
it did not change application code, deploy, install, or access clinical data.

## Confirmed version and sources
- Fresh SDK `origin/main`: `76fd261ff042f7e873e65b20052de5ed41e3bf36`;
  `apps/desktop/package.json` and `apps/clinic/package.json` both say 0.20.2.
- Public arm64 latest manifest read on 2026-11-04: version 0.20.2,
  issuedAt 2026-09-05T20:05:33.000Z, SHA-256
  `1aa9477dfbd1cc87e4b85c8e718cb75b30c77eaa09ccd631206d3be51e1b5c87`.
  It agrees with [[log/2026-09-05-active-visit-recovery]]. No full artifact
  download or new cryptographic verification was performed in this audit.
- `/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString'
  '/Applications/Med Photo.app/Contents/Info.plist'` returned 0.20.2.
  Installed identity is checked; running processes and clinical behavior are not.
- Public source:
  https://med-photo-release-service-production.up.railway.app/v1/releases/darwin-arm64/latest.json

## Built and released
Current main/vault records describe a standalone Apple Silicon Mac app, shared
cloud patients/visits/photos, richer editable patient profiles, structured
visit details and authored notes, live photo refresh, compare/download/export,
recoverable removal/restoration, Owner/Staff/Review access, email sign-in and
recovery, per-camera provisioning/rotation/revocation, guided test-photo proof,
same-patient active-visit recovery and verified in-app updates. Local PTP/IP,
FTP, reconnect and multi-room capture remain engineering/transport modes;
the old end-user same-LAN Share this library direction was retired.

Separate pushed SDK branch `codex/iphone-cloud` at `dc1defb` contains a SwiftUI
iPhone companion, QR pairing, Canon USB discovery, foreground memory-only
cloud uploads and completed-upload reconciliation. Source inspected:
`docs/IPHONE-CANON-RELAY.md` and the native app tree on that branch. It is
not merged into main or part of the published 0.20.2 Mac release. The branch
records simulator/synthetic checks, not physical Canon/iPhone certification.
Device signing, deployment and phone storage-residue verification remain gates.

## Mistakes caught and decisions
- The primary SDK checkout is on the preserved legacy branch at `477dfd1`;
  its desktop 0.19.6 / clinic 0.18.6 numbers do not identify the current release.
- The primary vault is divergent and contains unknown local edits. Read fresh
  `origin/main` and used an isolated feature worktree; preserved all primary
  checkout files, commits and unknown artifacts.
- Corrected INDEX's 0.9.2 pointer and clinic-app's stale staged 0.20.0 / live
  0.19.9 header. Superseded older installed 0.20.0 observations without rewriting
  dated historical release logs. Updated status, roadmap and the active goal.
- Version identity is distinct from field proof, release is distinct from
  branch work, and the synthetic internal channel is not production approval.

## Validation and delivery
Documentation-only: reviewed the exact diff and ran `git diff --check`.
No new build/test/physical-camera pass is claimed. The previous complete gates
and Node 20/22 CI for the released source are recorded in the 0.20.2 release log.
Owned branch: `codex/app-status-20261104`; exact commit and PR are reported in
the session handoff. Vault main base: `597a247`. No application source commit,
merge, package or deployment was created. The legacy SDK source is already
pushed; a no-change push is checked for the session ritual. The vault update
is proposed through a PR; it is not merged by this audit agent.

## Remaining work
Exact current two-Mac/camera field proof; signed consent/forms; production
FTPS/TLS and clinical security/compliance gates; migration/restore/revocation
drills; public Mac signing/notarization; multi-location, USB and broader camera
validation. Continue the existing goal/roadmap; no unrelated loop was started.
Use synthetic records only. (Version observations verify after: 2026-11.)
