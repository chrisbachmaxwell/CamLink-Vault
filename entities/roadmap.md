# roadmap — WHAT IS LEFT

Rewritten 2026-08-22. Ordered by Chris's priorities. Governing
constraint: [[hipaa-local-first]].

## Now (active)
1. **R5 Mark II FTP dialect** — [[2026-08-r5ii-ftp-dialect]]: read the
   relay's FTP conversation trace, fix whatever the body speaks, prove
   "works for all FTP cameras" (Chris's words).
2. **Field-close multi-room** — a second body as `room-2` in the office
   ([[2026-09-multi-room]], last unchecked box).
3. **Field-test same-LAN Hub + Viewer** — update two arm64 Macs to v0.18.14;
   enable **Settings -> Other computers** on the Hub; use a Review PIN in the
   second computer's browser; prove one synthetic visit/photo appears live.
   If unreachable, check Local Network permission and router client isolation.
   v0.18.12 fixes the first-Owner transition and puts working Sign out in the
   top-right profile menu. v0.18.13 allows the installed Mac to update from the
   signed-out profile picker and offers direct-installer recovery. v0.18.14
   explicitly returns the Hub and every open Viewer to the profile picker when
   sharing restarts the memory-only session; after the Owner/Review PIN, the
   same library must return.

## Next
4. **FTPS + BAA hosting + compliance sign-off** — the hard gate before
   ANY patient photo touches the relay (repo docs/CLOUD-RELAY-PLAN.md).
   Includes per-clinic relay accounts issued at install time (replaces
   the built-in shared prototype account; rotates the burned pull token
   and FTP password).
5. **Shared staff identity for downloaded Viewer apps** — current Owner/Staff/
   Review PINs live on one Hub and work for same-LAN browser Viewers. Connect
   the native multi-computer foundations to the control plane so a staff login
   can discover only enrolled Hubs for its organization/location, without
   copying local user files or creating another photo library.
6. **Auto-install updates at 6 AM when no visit is active** — offered
   2026-08-22, awaiting Chris's go; small change on top of
   [[in-app-updates]].

## Later
7. **Public Mac distribution** — the self-contained Electron app, offline
   Ed25519 publisher, Railway release service and verified native updater are
   live for arm64 internal tests (v0.18.10; three successful end-to-end
   self-updates). Immutable arm64 history now lives on a persistent Railway
   volume. The Finder/Archive Utility bootstrap path is archive-valid as of
   v0.18.8. Remaining: Developer ID signing/notarization so the first download
   opens without macOS Open Anyway, and host/test the Intel artifact. See
   [[log/2026-08-26-signed-mac-updater-live]] and
   [[log/2026-08-26-finder-safe-mac-release]].
   **Field gate:** the M1/Tahoe Mac still bounced after the full two-step Open
   Anyway flow on v0.18.9. v0.18.10 now offers a verified DMG with a Finder
   drag-to-Applications workflow and more deterministic foreground behavior.
   Independent quarantine testing reproduced a pre-JavaScript `_dyld_start`
   block with no server, renderer or window, so no further Electron startup
   change can honestly promise reliable unsigned first install. Field-test the
   DMG, but Developer ID signing/notarization is the required reliable fix.
8. **Med Photo Box** — GL.iNet Beryl AX travel-router kit for hostile
   clinic networks (repo docs/MED-PHOTO-BOX.md; hardware sourced).
9. **USB tether (Phase D)** — `@medphoto/adapter-usb`; design in repo
   docs/PTP-PLAN.md.
10. **Clinic lockdown (Phase C)** — [[2026-07-clinic-lockdown]]: PIN,
   audit log, no-cloud CI guard.
11. **Other FTP vendors** (Sony/Nikon/Fuji pro bodies) — adapter is
   vendor-agnostic by design; needs per-vendor field proof.

## Done recently (details in [[project-status]])
Multi-room · synthetic same-LAN Hub/browser Viewer (v0.18.11) · profile-first
sign-in and account menu (v0.18.12) · signed-out local update + installer
recovery (v0.18.13) · Hub-restart sign-in/library recovery (v0.18.14) · earlier-photo guard · honest presence · in-app updates ·
Mac app installer · Finder-first DMG + bounded Mac startup/renderer recovery (v0.18.10) · home redesign + flow rules · cloud relay on Railway ·
FTP push transport · Med Photo rename (all 2026-08-21/22) · recoverable
live photo removal (v0.18.0, 2026-08-25; tile/viewer → local `.trash/` +
manifest tombstone + batch Undo). Hands-on feedback decides whether a
persistent trash browser is needed beyond Undo. Self-contained arm64 Mac app
+ signed Railway updater (v0.18.10, 2026-08-26); Finder-safe first-install ZIP,
DMG bootstrap and startup recovery are live; initial public-download
notarization remains open.

## 2026-08-25 transfer follow-up
- Trace and reproduce the Nikon Z8 against the relay's single-port FTP
  state machine before recommending that path for Z8 clinics. Same-day R6
  Mark II success rules out a generally slow relay, but does not yet identify
  whether the Z8 issue is resume/REST behavior, passive-data demux, Wi-Fi,
  or camera profile state.
