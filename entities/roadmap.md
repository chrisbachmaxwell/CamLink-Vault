# roadmap — WHAT IS LEFT

Rewritten 2026-08-27 after the cloud-authoritative decision. Ordered by Chris's
priorities. Governing boundaries: [[hipaa-local-first]] and
[[cloud-authoritative-library]].

## Now (active)
1. **Cloud clinical data plane** — [[2026-08-cloud-clinical-library]]:
   the synthetic Cognito/Lambda/DynamoDB/private-S3 path and two-computer app
   projection are live. Next: push realtime, multi-location selection, durable
   migration tooling, restore/revocation/retention drills and the planned
   production PostgreSQL adapter/migrations.
2. **Synthetic direct-camera ingest** — v0.19's Railway bridge now gives every
   camera unique, rotatable and independently revocable FTP + cloud-ingest
   credentials, durably spools before acknowledgement, and survives restart.
   New camera-entered profiles are shortened to a 13-character username and
   12-character unambiguous password; the long cloud credential stays hidden.
   The coordinated relay/AWS configuration is live and the management/rotated
   login probes pass. Next: prove two physical cameras plus theft revocation,
   then replace synthetic plain FTP with the production FTPS/TLS endpoint under
   the BAA gate. Each credential maps to one location/camera and files only into
   that camera's active visit (otherwise Unassigned).
3. **Downloaded app cloud mode** — v0.19.3 arm64 is live with clean-clinic
   onboarding, email/password sign-in and email-code recovery, single-location
   shared library, pre-sign-in updates and no permanent local photo write. Its
   camera setup is model-first and automatically provisions the per-camera
   relay values; staff never enter the relay control URL/token.
   The live AWS null-marker activation defect is fixed and failed empty drafts
   are retired. The short-credential Lambda deployment is pending a fresh AWS
   console sign-in. Immediate field steps after deploy: finish the one-time legacy
   Owner-to-email screen, then click Continue once in camera setup and confirm
   that the unique FTP values appear. Next: multi-location picker,
   device/session administration and exact two-Mac packaged field proof.

## Next
4. **Patient record & clinic organization** — make the shared library a
   usable patient record, not merely a place to start a visit. Patient list
   and patient page: edit the photo-workflow identity (legal/preferred name,
   DOB, external MRN/EHR id where available), show a clear visit timeline,
   consent status, provider/procedure/body-area labels and photos together;
   actions are Edit patient, Start visit, view/compare/filter photos, and
   later Add/view consent. Preserve audit history and recoverable deletion.
   Med Photo deliberately does **not** become the system of record for full
   medical history, medications, insurance, diagnoses, billing, scheduling or
   clinical charting—those remain in the practice's EHR.
5. **Consent forms & photo permissions** — versioned, signed clinical-photo
   acknowledgement plus a separately explicit marketing/publication release;
   patient-page indicator, durable signed artifact, withdrawal/revocation
   behavior, audit facts and role controls. Build/test only with synthetic
   records until the production compliance gate passes.
6. **Verified migration + purge** — upload existing libraries resumably,
   compare digest/counts, human approve, then offer a separately confirmed
   purge. Never delete a local library in an update.
7. **Production compliance gate** — execute AWS BAA; eligible-service/threat/
   retention/backup/restore/revocation/audit/incident review; advisor sign-off.
   No real PHI before this last gate.
8. **EHR integration (opt-in, adapter first)** — after the clinical cloud
   record and compliance gate: per-EHR patient/demographic lookup and daily
   schedule import to remove duplicate entry, then audited, idempotent export
   of an authorized photo/visit package to the chart. Never silently make an
   EHR the source of truth, import a full chart, or send photos without
   per-integration authorization and reconciliation proof.
9. **R5 Mark II FTP dialect** — [[2026-08-r5ii-ftp-dialect]]; later validate
   FTPS compatibility if this body remains in the supported cloud fleet.
10. **Field-close multi-camera** — [[2026-09-multi-room]] routing semantics now
   become cloud camera→active-visit field proof.
11. **Auto-install updates at 6 AM when no visit is active** — offered
   2026-08-22, awaiting Chris's go; small change on top of
   [[in-app-updates]].

## Later
12. **Public Mac distribution** — the self-contained Electron app, offline
   Ed25519 publisher, Railway release service and verified native updater are
   live for arm64 internal tests (current v0.19.2). Railway serves signed
   manifests plus the no-store latest bootstrap pointer; immutable ZIP/DMG
   bytes also live in a separate private, versioned S3 release bucket behind
   read-only CloudFront, avoiding Railway's
   package-upload ceiling. The Finder/Archive Utility bootstrap path is archive-valid as of
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
13. **Med Photo Box** — reassess; internet-direct FTPS may remove the need for
   travel-router hardware on isolated clinic networks (repo
   docs/MED-PHOTO-BOX.md; hardware sourced).
14. **USB tether (Phase D)** — `@medphoto/adapter-usb`; design in repo
   docs/PTP-PLAN.md.
15. **Other FTP vendors** (Sony/Nikon/Fuji pro bodies) — adapter is
   vendor-agnostic by design; needs per-vendor field proof.
16. **Capture protocols & baseline-assisted repeat capture** — clinic-defined
    photo sequences and optional prior-view reference for a follow-up shot.
    Defer until the patient record is useful and the core AWS/consent work is
    established; validate against real clinic workflow before claiming
    automatic alignment.

## Done recently (details in [[project-status]])
Multi-room · retired synthetic same-LAN Hub/browser proof (v0.18.11–v0.18.14) · profile-first
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
