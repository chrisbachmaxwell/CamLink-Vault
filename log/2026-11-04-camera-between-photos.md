# Camera status between photos and Canon ping — 2026-11-04

## Decisions and field evidence
- Chris confirms R6 Mark II photos arrive; Connected appears for about 5–7
  seconds after a shot, then disappears until the next. Earlier claims that
  this session had no successful physical transfer are superseded by this
  user report. Power-cycle, two-camera and two-Mac acceptance are still open.
- Canon's R6 II manual explicitly documents FTP/Wi-Fi power-saving disconnects
  and automatic reconnection for the next transfer. The exact selected setting
  and firmware timeout here are unknown; this is a possible cause, not a
  diagnosed setting. Optional setting: Transfer images to FTP server → FTP
  transfer settings → Power saving → Disable.
- Source: https://cam.start.canon/en/C012/manual/html/UG-07_Network_0070.html
  (Using the Power Saving Function; checked 2026-11-04, verify after 2026-12).
- A local ping can test reachability if the camera replies. R6 II FTP/sleep
  ICMP behavior is unverified; no new ping code, discovery scan or second Canon
  session was introduced. Ping cannot prove automatic transfer or completed
  cloud delivery, and no reply cannot distinguish sleep/off/filtering.

## Implementation candidate
Owned SDK paths: apps/clinic/public/{app.js,cloud-camera-status.js,
camera-catalog.js,index.html,styles.css}, apps/clinic/src/server.ts (static
asset allowlist only), apps/clinic/test/{cloud-camera-status.test.ts,
camera-setup-gate.mjs}, docs/DESIGN.md. Owned vault paths are this log,
project-status/roadmap, canon-eos-r6-mark-ii, camera-presence, ftp-push-transfer,
in-app-updates, design-doctrine and the active cloud goal.

- Recent completed photo: Photo received, green, 60 seconds; socket closure
  does not erase it. After that: Camera online for current sign-in, otherwise
  neutral Waiting for next/first photo. Last received time stays visible.
- Failed/expired status checks remain amber Status unavailable. A historical
  photo cannot leave the camera green indefinitely. No start-visit gating.
- Check camera still requires a new exact-camera upload. At 30 seconds without
  proof, it says where to check for an error if a shot was taken, keeps waiting
  and accepts later recovery. It never invents an unsent shutter event.
- Canon help includes the verified power-saving path. Secrets, existing
  sessions, photos, credentials and cloud API schemas were not changed.

## Validation and delivery
All six required gates pass: build, 488 workspace tests (one existing skip),
PTP simulator, FTP, multi-room and browser UI gate. The browser test proves
normal post-photo socket closure, neutral old evidence, stale/outage handling,
exact-camera proof, delayed test/recovery, credential preservation and existing
patient-visit behavior. Screenshots were visually inspected.

Mistake caught and fixed: the first UI run found the new static status module
missing from the unauthenticated shell allowlist, blocking sign-in. Added it
to both asset maps; rebuilt, reran the HTTP access boundary audit and full
browser gate successfully. No data/API authorization was broadened.

SDK feature commit **2c40c15e2407ae8da1581d3644617ac7cf727f4a** is preserved on
local branch `codex/camera-between-photos-20261104`, based on main `f13b35c`.
The final git push failed `remote: fatal error in commit_refs`; connector
creation of the base branch independently failed HTTP 422 `Reference update
failed`. Read access and admin/push permissions work; the repository is not
archived/disabled. No SDK remote branch, PR, CI, merge or release exists for
this change. Stop repeated retries until repository writes recover.
Backup: `/Users/chrismaxwell/MedPhoto-Clinical-Diagnostics-20261104/camera-between-photos.patch`.
The earlier target-verifier commit `c11386e` remains separately preserved on
`codex/patient-registration-status-20261104`; it was not mixed into this work.
Published and installed app remains 0.20.4. No new backend deployment or
installed-app replacement occurred.

Vault feature/PR/merge evidence is recorded in this chat's handoff; no code
publication is implied by merging these notes.

## Remaining field check
Open the existing app: `open -a "Med Photo"`.
On the R6 II, optionally disable FTP Power saving using the path above, then
observe whether it stays online between object photos. This is an optional
hardware check; a working transfer must not be judged broken solely by a
power-saving disconnect. Ping would require the camera's current LAN address
and a separate hardware test before it is offered as a reliable diagnostic.
