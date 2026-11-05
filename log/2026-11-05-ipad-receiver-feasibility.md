# iPad receiver and patient selection — 2026-11-05

Chris asks whether an iPad could receive too, explaining that staff already
need the app open while shooting to pick the correct patient. Answer: yes as
a plausible native-app design, not as an already built/validated capability.

Apple's NWListener supports iPadOS incoming connections. Apple documents that
apps are suspended shortly after backgrounding, while background URLSession
HTTP transfers are a separate mechanism. UIKit can suppress idle sleep while
the active capture display needs to remain visible; reset that state when
capture ends. Local-network permission and actual LAN reachability need real
device tests. An open Safari page alone is not a native camera FTP(S) receiver.

Proposed workflow: sign in, choose patient and camera, explicitly start the
visit, confirm receiver readiness, shoot with the app foregrounded, confirm
transfer completion and end the visit. Switching apps or locking may interrupt
receiving; no persistent background receiver or boot-start promise. Protect
temporary bytes, retry safely and retain the originating visit across queued
uploads. Ambiguous delayed photos require review rather than automatically
filing into the next patient. This is future acceptance behavior, not current
tested code. A direct-cloud camera route can instead use the iPad only for
patient/visit selection and viewing; the cloud active-camera visit exists
independently of which screen is open.

## Evidence and current-state correction
- Read fresh vault main `d5dd9bb` and SDK main `8bdefe1`.
- SDK docs/CLOUD-CLINICAL-DATA-PLANE.md and cloud domain define explicit
  patient/camera visit start, scoped ingest and Unassigned when no active visit.
- Since the earlier desktop review, SDK PR 25 merged opt-in FTPS. Updated the
  concept page to preserve the earlier `6eb0552` snapshot without incorrectly
  describing the new source as FTP-only. FTPS is not deployed or hardware-proven.
- Main native/MedPhotoKit is an SDK scaffold; no released native iPad receiving
  workflow was established. Separate iPhone work is not assumed to prove iPad.
- Official Apple pages checked 2026-11-05 (verify after: 2026-12):
  https://developer.apple.com/documentation/network/nwlistener
  https://developer.apple.com/documentation/technotes/tn3151-choosing-the-right-networking-api
  https://developer.apple.com/documentation/uikit/uiapplication/isidletimerdisabled
  https://developer.apple.com/documentation/technotes/tn3179-understanding-local-network-privacy

## Delivery
Continue vault branch `codex/desktop-receiver-feasibility-20261105`, PR 34.
Merged fresh origin/main into this feature branch without conflicts; primary
checkouts and unknown work preserved. Owned changes: this log,
concepts/ftp-push-transfer.md, entities/project-status.md, entities/roadmap.md.
Documentation diff reviewed and whitespace checked. No SDK source changes,
runtime tests, implementation, release, deployment, settings or camera changes.
No manual test is requested of Chris for this feasibility discussion. Existing
direct-FTPS-first priority and production gates remain unchanged. Push/PR is
documentation delivery, not integration or a working iPad feature.
