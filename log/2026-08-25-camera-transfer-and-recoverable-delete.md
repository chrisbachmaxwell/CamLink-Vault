# 2026-08-25 — camera transfer A/B + recoverable photo removal

No patient names, DOBs, folder names, serials, credentials, or photo bytes
are recorded here.

## Field observations
- Nikon Z8, Cloud Relay, JPEG: three queued photos took minutes. One upload
  was refused as truncated by the v0.17.1 complete-upload guard; completed
  relay-to-Mac pulls were immediate.
- Z8 FTP Err.32 occurred even though the saved per-camera relay credentials
  passed a direct authentication-only FTP check. Ending and restarting the
  camera's connection cleared that error, pointing to camera profile/session
  state rather than a rejected server registration.
- Canon R6 Mark II, same Mac/network/relay: 17 JPEGs arrived quickly with
  zero failed uploads and zero failed visit photos; seven arrived during a
  16-second observed window.
- Verdict: the relay is not generally slow. The open defect is specifically
  the Z8-to-relay/single-port FTP compatibility path. Do not blame Z8 local
  transfer hardware generally, and do not recommend the relay for Z8 clinic
  use until a command/data trace identifies the incompatibility.

## Product decision and implementation
- Chris asked for a quick way to remove a bad image while shooting.
- Chosen interaction: an always-visible, 44 px trash control on every
  completed live tile, plus **Remove photo** in the full-screen viewer.
  There is no confirmation dialog; speed doctrine says Undo beats ceremony.
- `POST /api/photo/delete` moves the original and optional RAW thumbnail
  sidecar into `captures/.trash/<visit>/`. The visit manifest retains a
  `deleted` tombstone and timestamp; active `CaptureSession` state changes
  too, so the next incoming photo cannot resurrect the removed one.
- `POST /api/photo/restore` reverses the move and tombstone. The UI batches
  rapid removals into one 10-second Undo action. No permanent-delete control
  was added. Review-only users receive 403 for both mutation paths.
- Shipped as Med Photo v0.18.0, SDK commit `4d6194d` on
  `claude/camera-sdk-adapter-pattern-4pj5r8`.

## Verification
- `npm run build` — green (all workspaces; app reports v0.18.0).
- Focused SDK/clinic tests — green, including tombstone counts, filesystem
  move/restore, traversal rejection, and review-role authorization.
- `node apps/clinic/test/smoke.mjs ptp-simulator` — green.
- `node apps/clinic/test/smoke.mjs ftp` — green.
- `node apps/clinic/test/smoke.mjs multi-room` — green.
- `node apps/clinic/test/ui-gate.mjs` — green. Browser proof removes from
  both the live tile and viewer, verifies the file moved into `.trash/`,
  then verifies Undo restored it without a duplicate.
- Full `npm test`: every product/new-feature test passed; the same three
  already-documented Mac environment failures remained: two UDP-1900
  announcer tests while Spotify and the already-running Med Photo process
  held the port, plus the reconnect test requiring absent `127.0.0.2`.

## Next
- Capture a bounded Z8 FTP command/data trace against the relay; test REST/
  resume and passive single-port demultiplexing hypotheses.
- Chris hands-on: remove one completed photo during a real visit, take more
  photos, then try Undo. Any hesitation becomes a simplicity-pass checkbox.
