# roadmap — WHAT IS LEFT

Rewritten 2026-08-22. Ordered by Chris's priorities. Governing
constraint: [[hipaa-local-first]].

## Now (active)
1. **R5 Mark II FTP dialect** — [[2026-08-r5ii-ftp-dialect]]: read the
   relay's FTP conversation trace, fix whatever the body speaks, prove
   "works for all FTP cameras" (Chris's words).
2. **Field-close multi-room** — a second body as `room-2` in the office
   ([[2026-09-multi-room]], last unchecked box).

## Next
3. **FTPS + BAA hosting + compliance sign-off** — the hard gate before
   ANY patient photo touches the relay (repo docs/CLOUD-RELAY-PLAN.md).
   Includes per-clinic relay accounts issued at install time (replaces
   the built-in shared prototype account; rotates the burned pull token
   and FTP password).
4. **Logins, roles, and the review seat** — [[2026-09-logins-and-roles]]
   (PROPOSED, design in [[multi-user-model]]; absorbs Phase C lockdown).
   Waiting on Chris's read of the proposal.
5. **Auto-install updates at 6 AM when no visit is active** — offered
   2026-08-22, awaiting Chris's go; small change on top of
   [[in-app-updates]].

## Later
6. **Public Mac distribution** — the self-contained Electron app, offline
   Ed25519 publisher, Railway release service and verified native updater are
   live for arm64 internal tests (v0.18.9; three successful end-to-end
   self-updates). Immutable arm64 history now lives on a persistent Railway
   volume. The Finder/Archive Utility bootstrap path is archive-valid as of
   v0.18.8. Remaining: Developer ID signing/notarization so the first download
   opens without macOS Open Anyway, and host/test the Intel artifact. See
   [[log/2026-08-26-signed-mac-updater-live]] and
   [[log/2026-08-26-finder-safe-mac-release]].
   **Field gate:** the M1/Tahoe Mac still bounced on v0.18.8 after Open Anyway,
   although an earlier unsigned ZIP opened on that same Mac. v0.18.9 closes a
   concrete desktop lifecycle gap: bounded navigation, fresh renderer retry,
   post-load renderer recovery, native error fallback, and final exit instead
   of indefinite Dock bouncing. Exact-artifact renderer-kill testing passed;
   retry v0.18.9 on that field Mac to confirm. Developer ID signing/notarization
   remains required for warning-free distribution, not for this recovery test.
7. **Med Photo Box** — GL.iNet Beryl AX travel-router kit for hostile
   clinic networks (repo docs/MED-PHOTO-BOX.md; hardware sourced).
8. **USB tether (Phase D)** — `@medphoto/adapter-usb`; design in repo
   docs/PTP-PLAN.md.
9. **Clinic lockdown (Phase C)** — [[2026-07-clinic-lockdown]]: PIN,
   audit log, no-cloud CI guard.
10. **Other FTP vendors** (Sony/Nikon/Fuji pro bodies) — adapter is
   vendor-agnostic by design; needs per-vendor field proof.

## Done recently (details in [[project-status]])
Multi-room · earlier-photo guard · honest presence · in-app updates ·
Mac app installer · bounded Mac startup/renderer recovery (v0.18.9) · home redesign + flow rules · cloud relay on Railway ·
FTP push transport · Med Photo rename (all 2026-08-21/22) · recoverable
live photo removal (v0.18.0, 2026-08-25; tile/viewer → local `.trash/` +
manifest tombstone + batch Undo). Hands-on feedback decides whether a
persistent trash browser is needed beyond Undo. Self-contained arm64 Mac app
+ signed Railway updater (v0.18.9, 2026-08-26); Finder-safe first-install ZIP
and startup recovery are live; initial public-download
notarization remains open.

## 2026-08-25 transfer follow-up
- Trace and reproduce the Nikon Z8 against the relay's single-port FTP
  state machine before recommending that path for Z8 clinics. Same-day R6
  Mark II success rules out a generally slow relay, but does not yet identify
  whether the Z8 issue is resume/REST behavior, passive-data demux, Wi-Fi,
  or camera profile state.
