# 2026-08-28 — cloud active visit is visible and actionable

## Field report
An open cloud app repeatedly showed `camera already has an active visit`, but
the amber banner had no action and Home did not show the visit under **In
progress**. The user therefore could not open the exact visit to end it.

No patient names, photos, credentials or provider payloads are recorded here.

## Cause
- The cloud correctly rejected a second visit, but the clinic server collapsed
  the conflict to its text message and discarded the active-visit context that
  the existing local flow already knew how to render.
- The three-second cloud refresh updated patient history/photos only. It did
  not refresh the camera projection, so a visit started by another computer
  could remain absent from Home without a local `roomsChanged` SSE event.

## Decision and implementation
- Cloud camera/visit state remains authoritative. On a start conflict the
  clinic resolves the fresh active visit for the requested camera, falling
  back to the requested patient's visit on another camera, and returns the
  complete UI-safe summary.
- The browser immediately applies that summary to Home and uses the existing
  visit-turnover component: **Go to visit** or **End it & start**.
- Opening Home refreshes camera/visit state immediately. The three-second
  cloud library refresh now updates history and rooms together.
- No new dependency, protocol path, patient logging or capture storage was
  introduced.

## Proof
- SDK commit: `aae5b44` on
  `claude/camera-sdk-adapter-pattern-4pj5r8`, pushed to origin.
- Focused clinic cloud/setup tests: 11 passed.
- Root `npm run build`: passed.
- Root `npm test`: passed.
- `smoke.mjs ptp-simulator`: passed.
- `smoke.mjs ftp`: passed.
- `smoke.mjs multi-room`: passed.
- `ui-gate.mjs`: passed, including the named conflict doorway and Home
  **In progress** browser paths.

## Shared-worktree boundary
Separate unstaged clinical-cloud API changes were present by commit time. They
were preserved and excluded from `aae5b44`; the gates ran with them present.
