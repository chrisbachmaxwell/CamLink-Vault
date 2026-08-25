# roadmap — WHAT IS LEFT

Rewritten 2026-08-22. Ordered by Chris's priorities. Governing
constraint: [[hipaa-local-first]].

## Now (active)
1. **Distributed app usable layer** — transport contracts (`920baa2`), the
   device-bound connection-material flow (`d290a80`), and self-contained Mac
   packaging (`74c5a76`) are green. Next wire real macOS OIDC/location
   selection, mDNS/TLS/keychain adapters, and the HTTPS authorization boundary
   in front of clinic Hub viewer routes. Then deploy the non-PHI Railway
   control plane with durable backing. Keep patient bytes at the Hub.
2. **R5 Mark II FTP dialect** — [[2026-08-r5ii-ftp-dialect]]: read the
   relay's FTP conversation trace, fix whatever the body speaks, prove
   "works for all FTP cameras" (Chris's words).
3. **Field-close multi-room** — a second body as `room-2` in the office
   ([[2026-09-multi-room]], last unchecked box).

## Next
4. **FTPS + BAA hosting + compliance sign-off** — the hard gate before
   ANY patient photo touches the relay (repo docs/CLOUD-RELAY-PLAN.md).
   Includes per-clinic relay accounts issued at install time (replaces
   the built-in shared prototype account; rotates the burned pull token
   and FTP password).
5. **Logins, roles, and the review seat** — [[2026-09-logins-and-roles]]
   (PROPOSED, design in [[multi-user-model]]; absorbs Phase C lockdown).
   Waiting on Chris's read of the proposal.
6. **Auto-install updates at 6 AM when no visit is active** — offered
   2026-08-22, awaiting Chris's go; small change on top of
   [[in-app-updates]].

## Later
7. **Distribution: public signed/notarized download + verified auto-update** —
   the self-contained Electron app and arm64/x64 internal-test ZIPs now exist
   (`74c5a76`), along with the signed-manifest/release-service/update-client
   foundations. Next: Developer ID sign/notarize, publish immutable artifacts,
   embed the production Ed25519 key/native verifier+installer, migrate Check
   for updates off Git, and verify the Railway release service. Waiting on
   Chris only when Apple Developer enrollment/invite becomes necessary
   ([[log/2026-08-25-mac-release-runbook]]).
8. **Med Photo Box** — GL.iNet Beryl AX travel-router kit for hostile
   clinic networks (repo docs/MED-PHOTO-BOX.md; hardware sourced).
9. **USB tether (Phase D)** — `@medphoto/adapter-usb`; design in repo
   docs/PTP-PLAN.md.
10. **Clinic lockdown (Phase C)** — [[2026-07-clinic-lockdown]]: PIN,
   audit log, no-cloud CI guard.
11. **Other FTP vendors** (Sony/Nikon/Fuji pro bodies) — adapter is
   vendor-agnostic by design; needs per-vendor field proof.

## Done recently (details in [[project-status]])
Multi-room · earlier-photo guard · honest presence · in-app updates ·
Mac app installer · home redesign + flow rules · cloud relay on Railway ·
FTP push transport · Med Photo rename (all 2026-08-21/22) · recoverable
live photo removal (v0.18.0, 2026-08-25; tile/viewer → local `.trash/` +
manifest tombstone + batch Undo). Hands-on feedback decides whether a
persistent trash browser is needed beyond Undo.

## 2026-08-25 transfer follow-up
- Trace and reproduce the Nikon Z8 against the relay's single-port FTP
  state machine before recommending that path for Z8 clinics. Same-day R6
  Mark II success rules out a generally slow relay, but does not yet identify
  whether the Z8 issue is resume/REST behavior, passive-data demux, Wi-Fi,
  or camera profile state.
