# 2026-09-01 — 15-minute visit inactivity and reopen recovery

## Decision
Chris chose a 15-minute cloud visit inactivity boundary instead of a 45-minute
pause. Recovery is **Reopen visit**, not Pause. The final minute warns and
offers **Keep visit open**. At expiry the patient screen locks behind sign-in.
A photo arriving afterward remains in **Needs assignment** until a person
explicitly adds it after reopening or leaves it waiting.

## Source implementation
- Code commit `9bc5ee7` was pushed to
  `claude/camera-sdk-adapter-pattern-4pj5r8`.
- Cloud visit records now carry backward-compatible activity/end/reopen fields.
  Tenant-scoped visit reads and camera upload grants lazily and authoritatively
  expire stale visits at 15 minutes, releasing patient/camera active locks.
- Keep-open, same-visit reopen, and waiting-photo assignment use authenticated
  role-gated routes. Reopen refuses to displace an active visit. Dynamo
  transactions fence patient/camera locks and recheck that the target visit is
  active during assignment.
- The browser warns in the final minute, locks the visible patient surface at
  expiry, handles expired cloud authentication as 401, and offers Reopen after
  sign-in. It stores only an opaque dismissed visit id locally.
- Photos received between the prior end and reopen are offered only when they
  came from the same camera; Add is explicit and Leave preserves Needs
  assignment. Manual accidental endings use the same guarded reopen operation.
- Audit actions distinguish `visit.auto-ended`, `visit.kept-open`,
  `visit.reopened`, and `photo.assigned`; audit payloads remain opaque-id only.

## Verification
- `npm run build` — passed; packaged clinic runtime rebuilt.
- `npm test` — passed across every workspace.
- `node apps/clinic/test/smoke.mjs ptp-simulator` — passed.
- `node apps/clinic/test/smoke.mjs ftp` — passed.
- `node apps/clinic/test/smoke.mjs multi-room` — passed.
- `node apps/clinic/test/ui-gate.mjs` — passed.
- Focused API, Dynamo, domain, client, and exact countdown-boundary tests
  passed; `node --check` for both browser modules and `git diff --check`
  passed.
- One parallel smoke rerun produced expected FTP port 2121 contention between
  two test processes; both contending gates passed when rerun sequentially.

## Evidence boundary and follow-up
This is source proof only. The commit is not on code `main`; no synthetic AWS
deployment, signed desktop package, release-manifest change, installed-app
update, or two-Mac field proof was performed. Next: integrate through the
normal code PR path, deploy the matching synthetic API, package/release the
matching desktop source, then verify warning → auto-end → sign-in → reopen →
waiting-photo choice on two Macs.
