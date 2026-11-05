# Visit comparison — 2026-11-05

## Evidence and boundary
Chris reported “no photos” in visit comparison, then confirmed it was working
again and requested a gallery view. Native read-only inspection showed populated
visit thumbnail strips. Remote Compare activation failed; the exact transient
live request error was not observed. Do not claim lost photos or a diagnosed
provider outage. No clinical data was modified or uploaded by this work.

Source: fetchVisitPhotos converted every failed request into an empty array;
comparison also rendered empty while loading, with no retry. The cloud visit
history order was not guaranteed chronological, but default comparison assumed
it was newest-first. A synthetic browser regression failed on the original
code for missing error recovery; it passes on the corrected UI in isolation.

## Work
SDK branch codex/visit-comparison-20261105 from fresh main 0b89555. Own comparison
photo-loading UI/HTML, narrowly scoped server photo-list error handling, new
browser regression and UI gate integration, version metadata and DESIGN.
Candidate 0.20.7 adds loading/error/empty separation, list and image retry,
request-generation guards, auth-loss cleanup, chronological history and newest
populated defaults. Server preserves sign-in errors instead of disguising all
cloud failures as missing visits. Patient thumbnail failures also offer retry.
Chris clarified that gallery means a full-screen comparison, not a single-photo
viewer. Both sides remain large and visible, each with independent controls.
Click either photo or Full screen to expand; Back/Esc preserves selections.
Keyboard focus stays inside the expanded view. No camera configuration or credential change.

## Validation
Initial fixture failed because Photos & visits was not selected; corrected its
navigation before establishing the original error-recovery failure. Image-failure
fixture now uses a distinct synthetic URL to avoid browser image-memory reuse.
Full build, workspace tests and all three smokes passed. First full UI run found
a narrow viewport assertion racing the sidebar transition; the test now waits
for the same settled width as the existing camera gate. Final build, 494 passing workspace tests (one existing skip), all three smokes
and UI gate passed. Node 20/22 CI passed. Fresh-profile packaged startup
confirmed 0.20.7, signed out with clinical data hidden and source UI matches.

An initial single-gallery implementation was replaced before commit after Chris
clarified the desired two-sided gallery. Final browser coverage checks screen
usage, independent controls, retained positions, keyboard entry/exit and focus,
narrow side-by-side layout and sign-in-loss cleanup.

## Integration and package
Feature `d222957d31b6757b2abf5753c610bb414f9616d4`, SDK PR 23 merged to main
`2e536da60c9c4cb6966d5c1bc0b6d60a4aafdaea`. Merge tree matches package tree
`48d774ca8e343bd2b09f46b45e1c6944cb6cc46d` exactly.
ZIP SHA-256 `f605e1657d9585f573fc1f29b94764f0b53515cecd9be6ce400c53a1bd54826d`,
114113399 bytes; DMG SHA-256
`195006ed7a0f6905c5a1f9a863d95ff55607da6b5b84a60058dba661f49016f8`,
124182853 bytes. Stage `/Users/chrismaxwell/MedPhoto-Clinical-Stage-0.20.7`.
Immutable package uploaded with checksum verification. CloudShell home quota
required temporarily moving the known 0.20.4 ZIP to /tmp; restored to its
original home path and verified its unchanged hash after upload. No deletion.
Railway release deployment `59398372-2236-45b2-995d-06da46dee591` SUCCESS.
Public signature, complete ZIP, no-store DMG and health verified at
2026-11-05T15:21:17Z. Only release service deployed, no clinical API change. Native Mac still shows 0.20.5. Version-button
remote click did not activate the updater. No forced replacement or ended visit.

Human check: open Compare visits, choose Full screen or either photo, browse
each side independently and return with Back/Esc. Updater opening was requested
from Chris because remote version-button activation did not work.
