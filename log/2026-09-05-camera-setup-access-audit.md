# Camera setup simplification and access-flow audit — 2026-09-05

Chris asked for simpler camera setup and a broader check after updating before
signing up. Software Update before sign-in is intentional desktop maintenance;
the audit preserves its private loopback capability and proves that capability
cannot open clinical APIs.

## Changes and mistakes caught
- Add camera opens the model picker directly; optional names default to model.
  Wi-Fi, server and login have separate tasks and folded full instructions.
  A saved camera can be inspected/tested without silently rotating its password.
  Password replacement is confirmed. Missing legacy model data does not create
  duplicate cameras; a successful creation no longer depends on another state
  read before setup can continue.
- Reproduced an anonymous live feed surviving first local signup. Bound feeds
  to session tokens and close them on signup, logout and account removal.
  The browser returns to sign-in immediately and closes its photo viewer. A second already-open anonymous window also leaves solo mode on first signup.
- Staff/review no longer see owner-only setup/People rows. Signed-out screens
  hide clinical navigation but retain Software Update. Sign-out failures remain
  visible instead of reloading as if completed. Password rules match validation.
- Revoked/expired cloud sign-in returns 401 and clears local access. A temporary
  refresh-network failure retains the token for recovery; ordinary role 403s
  do not sign the person out.
- Narrow-window test caught a non-wrapping badge; fixed layout and drawer resize.
  Screenshot checks wait for the drawer transition to finish. The old browser
  test expected an extra click after logout; immediate revocation correctly
  removed that stale control, so the test now asserts automatic recovery with
  a photo open.

## Verification and boundaries
Full build and all workspace tests pass (clinic 101 passed, one existing
platform-specific skip). The new actual-server HTTP audit proves anonymous
state sanitization, 14 clinical endpoint denials with and without the desktop
capability, owner-only actions, review write denials, and live-feed revocation.
PTP simulator, FTP, multi-room and browser gates pass; cloud setup browser
fixtures test supported/unsupported models, Back/cancel/reload, password-reset
failure, exact-camera new-upload proof, interrupted polling, roles and narrow
layout. Screenshots contain synthetic fixtures only.

No clinical AWS API deployment or provider policy/identity changes are needed.
The installed app was read-only verified as 0.20.0 during this session, updating
the earlier 0.19.7 observation. Physical camera, two-Mac installation and live
authenticated patient-flow proof remain open; synthetic-only/BAA limits remain.

A dependency audit also reports advisories in the Vitest/Vite development tree.
No Vitest UI/dev server is exposed by the packaged app. A tested developer-tool
upgrade is follow-up work; no blind major-version audit fix was applied here.

## Delivery evidence
- Feature commit: `c8f6bf9a39c6825cbaea83d9708f65bd0490370a`.
- SDK [PR 16](https://github.com/chrisbachmaxwell/CamLink-SDK/pull/16) MERGED;
  main `ea79005887bade446859b7c5c8a07961d8e7c77e`. Node 20/22 CI run
  `33987524831` passed. Package source tree and merged main tree both
  `a6bb4b0f196b8eb61b0d32287670ecceb1754e43`.
- ZIP: 114101810 bytes, SHA-256
  `b3db59c916207cea655b74b41ca12ca2535d193fba8da5aefd3abf368f6f82ac`.
  Conditional immutable S3 upload and checksum head pass; publisher downloaded
  this full ZIP plus retained 0.20.0/0.19.9/0.19.7 rollback packages successfully.
- DMG: 124178345 bytes, SHA-256
  `cf84700de956afc3d6c42bb7dcf459b18def4b6eb1f9c4e9673f41c3fd0939f0`.
  Archive containment, version, arm64, deep/strict ad-hoc code signature,
  standard unzip and DMG verification pass. Internal build is not notarized.
- Railway deployment `ebba862f-d6f8-4591-b18f-0c8b756c1132`: SUCCESS;
  image `sha256:51dbcb263f551c6f83b8ab6f61e40aaa0ca19f542de6bfe6c0b0487f501c8989`.
- Public release proof at 2026-09-05T19:42:24Z: health 200 `ok`, Ed25519 latest
  equals staged manifest; full latest DMG bytes/hash match with `no-store`;
  immutable DMG HEAD 200. Exact packaged updater `.check()` from version
  0.20.0 reports `{status: available, version: 0.20.1}`; no install/apply.
- Exact packaged app launched through Playwright Electron with a disposable
  profile and reached cloud sign-in, hidden clinical navigation and visible
  update control. Installed `/Applications/Med Photo.app` remains 0.20.0.
- Published deploy bundle: `/Users/chrismaxwell/MedPhoto-Deploy-0.20.1-release`.
  Valid next-run history: `/Users/chrismaxwell/MedPhoto-Package-Audit/0.20.1-release`
  (only manifests/packages). Public/package/startup receipts and DMG:
  `/Users/chrismaxwell/MedPhoto-Clinical-Stage-0.20.1`.

## Publication lessons
CloudShell staging reached its disk quota on extraction. Removed only the
redundant 0.20.0 tar generated by the earlier agent session (local copy remains),
then re-extracted and rechecked exact bytes before the conditional upload.
The strict history validator rejected the prior audit root's added bootstrap
and receipt. Copied only its unchanged manifests/packages to a fresh history
input, verified signatures and remote bytes, and produced fresh output dirs.
Do not use the incomplete `MedPhoto-Deploy-0.20.1-verified` or package-audit
`0.20.1-verified` directories as a release/history source. No existing remote
package or manifest was overwritten.

## Field follow-up
Open `open -a "Med Photo"`, choose Software Update and expect 0.20.1.
Use synthetic photos only. In Cameras, Add camera should go directly to model
selection, then Wi-Fi/server/login/test. Reopen a saved camera: Test camera
must preserve its login. Verify the physical camera's new photo completes the
test and appears on the second signed-in Mac. Confirm staff/reviewer controls
match their roles, and shared patient edits/notes remain synchronized.

