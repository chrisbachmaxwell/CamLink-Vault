# 2026-11-04 — Current camera connection, separate from photo receipt

> Correction established 2026-11-04: the deployment/inspection below targeted
> `medphoto-synthetic-clinical`, while the installed app's API routes to
> `medphoto-synthetic-clinical-v2-api`. Health and unauthenticated checks did
> not establish the serving code. That v2 API remained on August code until
> the later correction documented in [[log/2026-11-04-serving-api-target-repair]].
> The desktop package/publication evidence below remains valid. Installed
> version is now verified as 0.20.4, superseding earlier checks below.

## Decision and findings
Chris wants to turn on the networked camera and shoot, with a clear connected
indicator. Adding instructions alone did not meet that request. Inspection
found the cloud projection always set live connection false while dashboard
and camera cards used historical upload confirmation for green.

## Implemented
SDK feature `d050ea676f7d66fea519db25f1da73480b3aea86`, PR
https://github.com/chrisbachmaxwell/CamLink-SDK/pull/20, adds bounded read-only
relay status using existing control access. Only a scoped active profile's
exact login contributes evidence. Home/Cameras/test screens show current
connection and last photo independently; evidence expires and errors turn
unknown without hiding the library. Saved checks open directly; no password
rotation. Canon R6 II optional help cites the official manual and is not
hardware proof. 0.20.4 includes the merged 0.20.3 visit-start repair.

## Verification and mistakes caught
Full build; 481 workspace tests pass, one existing skip; PTP, FTP and multi-room
smokes; full browser gate. The first concurrent multi-room run collided with
FTP port 2121; the isolated rerun passed. Those smoke modes share a fixed FTP
port and must run sequentially even when HTTP ports differ. Browser coverage
includes live/off/expired/unknown states, two-camera isolation, newer photo
proof, disconnect after receipt, no silent rotation and previous visit gates.
Mac arm64 ZIP/DMG build and deep strict code-sign verification pass. A disposable
packaged profile starts signed out as 0.20.4 and serves the exact reviewed UI.
No patient data or credentials were included in artifacts or this log.

## Delivery evidence
- Feature: `d050ea6`; PR 20 merged to main `f13b35c3e716e9ce9f9ad6347c13e4f25912bd6e`.
- Node 20/22 CI run `41930996747` passed; fetched main tree matches the packaged feature tree.
- Local package: `/Users/chrismaxwell/MedPhoto-Clinical-Stage-0.20.4/`.
- ZIP SHA-256: `fa7b16a76e044cf03a22bcef03794697338a7688bde0e6c202e79bb2e2dfc74f`.
- DMG SHA-256: `83186f05708d96fe4ef753143f9290388dc6ad8a78637c47ce77a32b33188c32`.
- API SHA-256: `cdf7e016c025e2c5929e3889539a71c18047ac3fe52cf62c0e02f30b8930d372`.
- Synthetic API: change set `camera-presence-0204-20261104` reached `UPDATE_COMPLETE`; Lambda digest matches the tested bundle and synthetic health is OK. Only function Code and its dependent integration URI changed, with no replacement.
- Publication: Railway deployment `96cac965-0473-4fa1-a38a-82bf00858deb` is SUCCESS. Public 0.20.4 manifest Ed25519 signature, full ZIP and full no-store DMG bytes match the tested artifacts; health OK (verified 2026-11-04T23:18:56Z).
- Upload staging initially filled CloudShell storage. Only this session's partial 0.20.4 ZIP and the previous session's durable-backed 0.20.3 ZIP copy were removed; both complete release artifacts remain on the Mac, and 0.20.3 remains in the immutable release bucket. Retry and checksum verification succeeded.
- Installed version: read-only plist and native UI still 0.20.2. Native AX can read controls but activation has no effect, keyboard focus does not move, and coordinate input fails with noWindowsAvailable. Chris has a pending request to click the version badge and Update ready. No manual replacement or bypass of the updater's active-visit guard was performed.
- Live physical-camera test: not established.

## Next field check
After the service/app update, turn the R6 II on, photograph an object, and
verify current connection plus a new receipt. Power off must clear current
connection while retaining the receipt; power on should resume transfer with
the existing saved setup. A live sign-in is not proof automatic transfer is
on. Do not mark the camera field-proven until this works on the real body.
