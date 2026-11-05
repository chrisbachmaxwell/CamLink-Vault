# Saved-camera login recovery — 2026-11-05

## User evidence and meaning
Chris supplied a full Canon R6 III Err45 screen and the 0.20.5 saved-camera
review. The camera says it cannot log in and received an error from the FTP
server. Canon's C022 error guide agrees: inspect login name/password and
server account permissions. A server responded; successful previous sign-in,
password expiry or a match to the new Med Photo profile is not established.
The old password cannot be redisplayed after app restart; this is a display
boundary, not an expiry event. No current password was read or changed.

Sources checked 2026-11-05 (verify after: 2027-02):
- https://cam.start.canon/en/C022/manual/html/UG-07_Network_0160.html
- https://cam.start.canon/en/C022/manual/html/UG-07_Network_0070.html
- SDK apps/clinical-cloud-api/src/types.ts CameraRelayProfileRecord: no TTL.
- SDK packages/adapter-ftp-push/src/ftp-server.ts passwordFor/PASS: compares
  current configured account; no time-based expiry. App access-token expiry
  and camera-controller leases are separate contracts.

## Decisions and implementation
Owned source branch codex/camera-login-recovery-20261105 from fresh main
`a78ec71`, in the existing isolated agent worktree. Saved-camera review opens
troubleshooting directly, explains the password lifetime and asks for the
observed camera message. Err45 shows the saved-profile edit path, comparison,
replacement only when necessary, and server-account escalation if exact new
values still fail. Error selection cannot rotate credentials or claim observed
success. Replacement is explicit/confirmed and retains the same camera ID;
its guide edits the existing FTP profile instead of adding another camera.
The R6 III edit route is documented by Canon. Other models retain general
manual-directed editing until individually audited.

Scope: UI/catalog/tests/design and 0.20.6 package metadata; no clinical API,
relay, account or credential deployment. The agent does not change the live camera setup.

## Mistakes caught
The prior 0.20.5 gate checked new-camera errors and rotation separately but
missed error recovery after page reload. The new browser case specifically
loads without cached secrets, selects Err45, rejects the old dead-end button,
checks narrow layout, cancels replacement, simulates failure, and verifies
successful replacement preserves the camera ID and uses saved-profile editing.
An initial edit command ran from the primary cwd and failed before writing;
it was rerun in the owned worktree. No shared source was modified.

## Verification and delivery
All six required local gates pass: build, 494 workspace tests plus one existing
skip, PTP/FTP/multi-room smokes and browser UI gate. Desktop and narrow recovery
screens were visually inspected. SDK feature `3a8f53501d09925fbd436ab82350a4505c757601`
is merged through PR 22 as `0b895558368e58e2ec95a01d43e537a68da006f5` after
Node 20/22 CI. Package tree `c27e8bac92e7affd735c8b3d26fe8f0596612a3a` equals
the merged main tree. Fresh-profile packaged startup verifies 0.20.6, signed-
out clinical data hiding, and all six UI modules matching the reviewed source.

Release-only Railway deployment `8b26598f-3228-4140-b3e4-b234333364ca` is
SUCCESS. Public manifest signature, full ZIP and no-store DMG verify. ZIP:
114111648 bytes, SHA-256
`5784a751a1b796c20e7a03eb68c345d13981e345e97df546b76287247219d4cf`.
DMG: 124176711 bytes, SHA-256
`ee034e94ddec694e8896d86036297b8feb3f4842e0c56fd990a5a07ce721d921`.
Receipts/scripts are in `/Users/chrismaxwell/MedPhoto-Clinical-Stage-0.20.6`;
audit history is `/Users/chrismaxwell/MedPhoto-Package-Audit/0.20.6-release`.
No clinical API or relay deployment and no live credentials changed.

CloudShell home lacked space; temporarily moved the known 0.20.4 ZIP to /tmp,
uploaded the new verified package, published its immutable private-S3 object,
then moved the new ZIP to /tmp and restored the old ZIP with matching hash.
No files deleted. GitHub connector disconnected, so CLI created and merged
the PR with a pinned head after green CI/fresh-main checks.

## User-confirmed field success — 2026-11-05
Chris subsequently reported: “I just added the camera re did the setup and the
insturctions were incredible! worked perfectly”. This is user-confirmed success
for the published 0.20.5 R6 III walkthrough after redoing setup. A subsequent read-only native app observation showed the R6 III active visit
with four photos. The agent did not rotate the working login.
The exact old-login failure remains unknown; do not label it expired. Preserve
the now-working camera configuration. Saved-profile recovery remains a useful
follow-up and does not require another physical setup test from Chris.

The app remains 0.20.5 with an active visit. Do not end that visit or force a
bundle replacement to install 0.20.6. Make the release available through the
normal updater after the visit is complete. No patient identity, filenames or
image contents were recorded in the vault.
