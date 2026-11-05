# Camera setup walkthrough 0.20.5 — 2026-11-05

## User direction and physical evidence
Chris initially asked the agent to operate Med Photo while he handles a
different Canon EOS R6 Mark III on a new network. Installed 0.20.4 created
one new camera entry in synthetic test mode; the older R6 II visit was
preserved. His camera photos show the purple Network function tab with
Transfer images to FTP server, followed by Communicating with Err45.
Canon defines Err45 as FTP login rejected. The actual cause and saved
camera profile are unverified; do not assume a mistyped password.

Chris then said: “before we continue with trying to connect medphoto I just
want our app to walk a user through connecting.” Physical work is paused.
No new R6 III delivery, power-cycle/two-Mac acceptance or camera ping is
claimed. Do not resume camera-side questions automatically. Pending credentials were available only in the signed-in app page before
restart and must not be exposed or silently rotated. After update, saved
profile review cannot redisplay the prior password; it offers an explicit
new camera password. No credential/profile recreation was performed.

## Implementation and sources
Nine guided tasks: open FTP, join Wi-Fi, protocol, server/port, passive/proxy,
camera login, folder/save, automatic transfer, JPEG/card/new-photo preparation.
Each task shows only its needed values and has Back, in-page resume and
“My camera looks different” help. Reported Canon Err45 and Err41 route to
login/server review; missing-photo help routes to automatic transfer.
Reviewing settings never creates another camera or rotates its login.

Exact Canon menu guides, checked 2026-11-05 (verify after: 2027-02):
- R6 III: https://cam.start.canon/en/C022/manual/html/UG-07_Network_0070.html
- Errors: https://cam.start.canon/en/C022/manual/html/UG-07_Network_0160.html
- R6 II: https://cam.start.canon/en/C012/manual/html/UG-07_Network_0070.html
- R5 II: https://cam.start.canon/en/C017/manual/html/UG-06_Network_0060.html
- Original R6: https://cam.start.canon/en/C004/manual/html/UG-06_Network_0070.html
- Original R5: https://cam.start.canon/en/C003/manual/html/UG-06_Network_0070.html

The combined R6/R6 II ID remains for saved records but is hidden for new
selection. Other Canon/family, Sony, Nikon and Fujifilm choices explicitly
use general guidance; complete exact-model/manual/accessory audit and
hardware proof remain open. Manufacturer-sourced instructions do not imply
physical compatibility acceptance for every offered camera.

The between-photo UI correction from local `2c40c15` is included: recent
completed receipt, current sign-in, neutral waiting and unavailable checks
are different signals. Normal FTP idle is not a failure. Delayed test help
is conditional on the user having taken a photo; only a new verified upload
from the exact selected camera completes the test. No ping feature added.

## Mistakes caught and patterns confirmed
- Generic Wi-Fi/Bluetooth instructions were wrong for R6 III: its FTP menu
  comes before Wi-Fi setup. The original UI gate passed incorrect wording;
  it now exercises the manufacturer's sequence, recovery, narrow layout,
  exact-camera proof and preserved credentials.
- The initial new gate failed an old Wi-Fi-first expectation; corrected the
  test to the intended FTP-first sequence and reran all required gates.
- R5 II vault menu wording and its claimed passive-mode fix were overstated.
  Corrected the manual path; the old transfer failure remains unproven.
- Native AX actions may focus without activating, and coordinate clicking
  can fail with no available window. This is an automation limitation, not
  proof of broken product buttons. Preserve pending setup during recovery.
- AWS CloudShell's 1-GB home filled during ZIP upload; the helper's concurrent
  upload was throttled. Temporarily moved the known 0.20.4 installer to /tmp,
  preserved the partial new file, retried sequentially, verified the immutable
  S3 object, and restored the old installer with its exact checksum. Existing
  release objects were never overwritten. Only non-PHI app binaries/helper
  were uploaded; no backend, IAM, credential or provider agreement changed.
- SDK branch writes now succeed on this new branch; the prior commit_refs
  issue did not block this delivery. Its original local commit is preserved.

## Code and verification
Owned SDK worktree: `.codex/worktrees/medphoto-visit-start/CamLink-SDK`.
Branch: `codex/r6iii-setup-guide-20261105`, base main `f13b35c`.
Feature: `5d2583ffe020412413e482f1a504222bae216956` (initial correction `872a4a1`).
PR: https://github.com/chrisbachmaxwell/CamLink-SDK/pull/21 — merged.
Main merge: `a78ec718733e8825c1b8d8984d273456dcce7ddd`.
Tree: `df194a21efc95625cdd58a4b37e222449226a6a3`, exact match to packaged source.

All six required gates pass: build, all workspace tests (492 pass, one existing
skip), ptp-simulator/FTP/multi-room smokes and browser UI gate. Node 20 and 22
CI passed before merge. Narrow/login/error/automatic-transfer/proof screenshots
were inspected. Their synthetic fixture version label is 0.20.1; it is not
installed-version proof. The 0.20.5 package passes ZIP/extraction/arm64/version/
deep-strict signature and DMG checks. Fresh-profile packaged startup is signed
out, hides clinical data, and serves the exact reviewed UI modules.

## Release evidence
Stage: `/Users/chrismaxwell/MedPhoto-Clinical-Stage-0.20.5`.
ZIP: 114110160 bytes, SHA-256
`8bda99e9dfd256ded98b7209da5a1496400485fcfce2c7c8f4545f679ad00d5d`.
DMG: 124178729 bytes, SHA-256
`867139b14aa247513123fe58d76f3577e3ebc7e7b3fc73ce081709c851cad739`.
Private immutable S3 upload verified. Local signed manifest publisher verifies
current and three prior public ZIPs. The release bundle carries only the
current DMG. Railway deployment `f3c1d3be-7d8b-4d63-8e83-df9b44e2e13a`
is SUCCESS. Public Ed25519 manifest signature, complete ZIP and no-store DMG
bytes/hash, and service health verified at 2026-11-05T14:04:16Z. No clinical
API/relay deployment occurred. Remote activation of the version chip initially failed even after Raise;
coordinate input reported no available window. Asked Chris to open the version
chip and Check for updates. The next inspection shows 0.20.5 in native UI
and plist; all six installed UI files match the reviewed source exactly.
The existing active visit still shows 11 photos and the R6 III entry remains.
The precise install/guard click sequence was not observed; no agent-ended
visit or forced replacement occurred. Installed camera check shows neutral
Waiting for first photo, model-specific automatic-transfer help, delayed
conditional guidance and reported-error recovery. Review settings explains
that the old password cannot be redisplayed after restart. No rotation occurred.
Installed proof: `installed-version-receipt.json` and
`installed-camera-check.png` in the stage directory.

## Remaining work
Physical R6 III setup remains paused. When resuming, use saved-camera recovery
if the old values were not entered; the app requires explicit password
replacement, not silent rotation. The all-model guide audit and physical
delivery acceptance remain separate work. No new camera connection is claimed.
