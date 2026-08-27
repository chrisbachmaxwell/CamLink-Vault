# roadmap — WHAT IS LEFT

Rewritten 2026-08-27 after the cloud-authoritative decision. Ordered by Chris's
priorities. Governing boundaries: [[hipaa-local-first]] and
[[cloud-authoritative-library]].

## Now (active)
1. **Cloud clinical data plane** — [[2026-08-cloud-clinical-library]]:
   PostgreSQL adapter/migrations, OIDC clinical API, private S3 originals/
   derivatives, authorized short-lived photo access and realtime events.
2. **Synthetic direct-camera ingest** — AWS Transfer Family FTPS → S3 → ingest
   workflow; R6 Mark II camera credential maps to one location/camera and files
   only into that camera's active visit (otherwise Unassigned).
3. **Downloaded app cloud mode** — ordinary sign-in + location picker; every
   computer sees the same library; no permanent local capture store.

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
