# roadmap — WHAT IS LEFT

## 2026-11-06 direct-cloud FTPS trial live (synthetic only)
Chris approved the temporary $2 trial and connected the card. SDK PR 26 merged
as `f651894` after six local gates and Node 20/22 CI. Separate AWS receiver is
running; live firewall allows only the office IPv4 /32 on 2121 and 50000–50009.
SSM management is online; four-hour automatic stop verified for 22:53 UTC
(3:53 PM Mountain) Nov 6. Encrypted disk persists and has ongoing storage cost.
The selected saved R6 II binding alone was copied securely without rotating
working FTP. Server key stays on EC2; CA key stays on Mac. Public root was copied
to the card, verified and ejected; Chris confirmed camera import.
Trusted login/session-bound protected upload passed; plaintext login, PROT C,
untrusted root and wrong hostname were rejected. One small computer-generated
JPEG completed FTP in 0.64s and Med Photo showed Photo received for the saved
R6 II. This is NOT physical Canon or shutter-to-display latency proof.
Waiting for Chris to add the separate FTPS connection using private local
instructions and take an object photo. Desktop stays 0.20.7; no production
HIPAA deployment or general office rollout. See [[log/2026-11-06-ftps-cloud-trial-live]].

## 2026-11-05 opt-in FTPS implementation
SDK PR 25 merged as 8bdefe1 after all six local gates and Node 20/22 CI.
Implemented explicit AUTH TLS with encrypted login/data, per-control TLS session
binding, credential revocation, and relay configuration. Canon FTPS profiles get
certificate-import and trust-error guidance; existing FTP instructions remain.
All physical Canon FTPS interoperability and endpoint/certificate provisioning
remain pending. No live relay change, AWS production setup, or desktop release.
See [[log/2026-11-05-canon-ftps-implementation]].


Rewritten 2026-08-27 after the cloud-authoritative decision. Ordered by Chris's
priorities. Governing boundaries: [[hipaa-local-first]] and
[[cloud-authoritative-library]].

## 2026-11-05 priority: direct FTPS first, office box later
Chris explicitly prioritizes direct FTPS now and defers the local receiver box
for offices with other cameras. Raspberry Pi 5 is a plausible engineering
candidate based on Gigabit Ethernet/USB 3 and Linux, not validated Med Photo
hardware. Future appliance review includes SSD/encrypted spool, key protection,
automatic updates, scoped credentials, restart/power-loss and multi-camera load
tests. No purchase, appliance build or production AWS setup authorized here.
See [[log/2026-11-05-canon-ftps-foundation]].

## 2026-11-05 receiver/performance clarification
The office receiver remains planned; current synthetic ingress uses the hosted
relay. FTPS performance on the actual Canon bodies is unmeasured. Add matched
first-shot, steady, idle-reconnect and burst/time-to-display benchmarks before
promising latency. See [[log/2026-11-05-canon-ftps-foundation]].

## 2026-11-05 Canon FTPS foundation and local receiver direction
Chris authorized starting security preparation without production AWS setup.
Nine Canon still-camera models have source-backed FTPS capability records;
actual Med Photo FTPS remains unvalidated. Local FTP is not automatically a
HIPAA violation; a secure-network checkbox cannot establish safety. Design
specifies encrypted direct transfer or a reviewed local receiver with HTTPS
forwarding, enforced scope and revocation. Production routes remain disabled;
no AWS/provider configuration or real PHI use authorized. Validation/integration
status: SDK PR 24 merged as `6eb0552` after all six gates and Node 20/22 CI.
Installed release remains 0.20.7; see [[log/2026-11-05-canon-ftps-foundation]].

## 2026-11-05 security readiness review
Chris reaffirmed independent-practice isolation as a non-negotiable product
requirement. Read-only source review and 70 passing API/domain tests confirm
implemented scope/role checks, not production security certification. Current
camera ingress is synthetic-only plain FTP; AWS BAA/eligible-service evidence,
production FTPS, stronger authentication, live two-practice adversarial proof,
independent security review and recovery/audit/revocation drills remain gates.
No real PHI is authorized. See [[hipaa-local-first]] and
[[log/2026-11-05-security-readiness-review]].

## 2026-11-05 visit comparison recovery and gallery follow-up
Chris reported comparison incorrectly said visits had no photos, then confirmed
it was working again and requested a gallery view. The installed patient page
showed populated visits; the agent did not reproduce the exact live failure.
Source and a synthetic cloud browser case confirm photo-list failures were
converted to empty arrays and shown as “No photos in this visit”. Version 0.20.7
keeps loading, errors and real empty lists distinct, provides list/
preview retry, ignores stale selections and defaults to the newest populated
visits. Chris clarified that the gallery must keep both photos large, side
by side. The expanded comparison retains independent visit/photo controls,
keyboard focus and Back/Esc selection preservation. No live records/photos changed.
All six gates and Node 20/22 CI passed; SDK PR 23 merged as `2e536da`.
Release 0.20.7 is published and publicly verified (manifest signature, ZIP,
DMG and health). Installed Mac verified at 0.20.7 after Chris updated; app.js, index.html and
styles.css match the tested release byte for byte.
See [[log/2026-11-05-visit-comparison]].

## 2026-11-05 saved-camera recovery 0.20.6 published; R6 III field success
Chris redid setup with the installed 0.20.5 R6 III walkthrough and reported
that it worked perfectly. A subsequent native UI observation showed four
photos in that camera’s active visit. Preserve this working configuration.
The earlier Err45 established login rejection, not password expiry; its exact
saved server/login mismatch was not diagnosed.

SDK PR [22](https://github.com/chrisbachmaxwell/CamLink-SDK/pull/22), feature
`3a8f535` → main `0b89555`, adds direct saved-profile troubleshooting, a
no-expiry explanation, the Canon saved-connection edit route, and explicit
same-camera login replacement. Selection/review never rotates credentials.
All six local gates pass (494 tests plus one skip), as does Node 20/22 CI.
Package startup and exact merged-tree equivalence pass. Release-service
deployment `8b26598f-3228-4140-b3e4-b234333364ca` is SUCCESS; public Ed25519
signature and complete ZIP/no-store DMG bytes verify as **0.20.6**.

At the 0.20.6 release checkpoint the Mac remained **0.20.5**. Installation
was deferred while its visit was active (superseded by verified 0.20.7 above); no visit was ended, camera credentials
changed, or bundle forcibly replaced. No clinical API or relay deployment.
See [[log/2026-11-05-camera-login-recovery]].

## 2026-11-05 camera walkthrough 0.20.5 published and installed
Chris paused physical setup to prioritize an app that walks the user through
connecting. SDK PR [21](https://github.com/chrisbachmaxwell/CamLink-SDK/pull/21)
(feature `5d2583f`, main merge `a78ec71`) adds nine small setup steps, Back and
in-page resume, values at the relevant step, automatic transfer, and recovery
for reported camera errors. Canon R6 III, R6 II, R5 II, original R6 and R5 use
manufacturer-sourced menu instructions. Other families are explicitly general;
the complete all-model manual audit and hardware proof remain open.

The earlier between-photo candidate (`2c40c15`) is included: recent receipt,
current sign-in, neutral waiting and unavailable checks are separate. Normal
FTP idle no longer claims a disconnection. No ping feature or hardware ping
proof is claimed. All six local gates pass (492 tests plus one existing skip),
as does Node 20/22 CI. The 0.20.5 arm64 ZIP/DMG and fresh-profile packaged
startup are verified; merged tree matches the package source. Public 0.20.5 is verified through Railway deployment
`f3c1d3be-7d8b-4d63-8e83-df9b44e2e13a` (SUCCESS): manifest signature and
complete ZIP/no-store DMG bytes match. Installed Mac is verified as 0.20.5 by plist and native UI, and all six
installed UI files match the reviewed source. The existing visit still shows
11 photos and the saved R6 III entry remains. Physical setup is paused. Saved
passwords cannot be redisplayed after restart; review offers an explicit new
camera password, which was not invoked. See [[log/2026-11-05-r6iii-live-setup]].

## 2026-11-04 serving API corrected; registration verified
The installed Mac is **0.20.4** (plist and native UI). New-patient creation
reproduced `request contains an unknown field`. API Gateway inspection found
that the desktop origin routes to **medphoto-synthetic-clinical-v2-api**, still
running August code; September and the earlier November update had targeted
the separate stack without `-v2`. Public health checks did not catch this.
The already-tested 0.20.4 API artifact is now deployed to the correct v2 stack
with a reviewed code-only change set, no replacements, and matching Lambda
hash. Retrying the preserved synthetic form in the installed app succeeds.
The camera screen now reports current Not connected plus the last received
photo, matching the relay reading. Chris later confirmed photo arrival and
brief connections between shots; power-cycle/two-Mac acceptance remains open. See [[log/2026-11-04-serving-api-target-repair]].

## 2026-11-04 live camera status released
SDK PR 20 (`d050ea6` → main `f13b35c`) released **0.20.4** with current per-camera cloud sign-in
status, last photo received, automatic status refresh, stale/outage handling,
and direct opening of saved camera checks. It retains the 0.20.3 visit-start
repair. All required local gates pass: 481 tests plus one existing skip,
PTP/FTP/multi-room smokes and browser gate. Mac packaging/startup and strict signature checks pass. Node 20/22 CI passed.
The initial API update reached the sibling stack, not the app API; corrected
in the serving-target repair above. Railway deployment
`96cac965-0473-4fa1-a38a-82bf00858deb` is SUCCESS. Public manifest signature and
complete ZIP/no-store DMG bytes match the tested artifacts. Installed Mac
is now verified as 0.20.4. Chris subsequently reported photo arrival with 5–7-second connections; see the correction above.
See [[log/2026-11-04-live-camera-status]].

## 2026-11-04 verification checkpoint
The public and installed arm64 release is 0.20.4. Synthetic registration is
verified on this Mac after the serving-target correction; the second Mac and
the paired physical-camera/shared-patient workflow are not verified by this
read-only check. Continue the field checks below without treating a version
check as workflow proof. Separate iPhone companion source on SDK
`codex/iphone-cloud` (`dc1defb`) still needs integration/release review, device
signing, backend deployment and physical-camera/storage-residue verification
before it can be called a released camera path. See
[[log/2026-11-04-current-app-status]]. (Verify after: 2026-11.)

## Immediate visit-start repair (2026-11-04)
SDK PR 19 (`464c10b` → main `b86d56e`, published 0.20.3) removes the optional-documentation gate,
keeps explicit camera choice, omits blank metadata and replaces raw start
errors with recovery instructions. Required local tests and package/startup
checks and Node 20/22 CI pass. Publication is verified; next is installed-app
verification and a synthetic live start on the exact service. The initial AWS inspection read the wrong sibling stack. The later serving-API
audit confirms the app actually reached August code; that v2 API is now updated
to the tested 0.20.4 artifact. No visit was ended or replaced during this repair.
See [[log/2026-11-04-visit-start-simplification]].

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
3. **Downloaded app cloud mode** — v0.20.6 arm64 is live with clean-clinic
   onboarding, email/password sign-in and email-code recovery, single-location
   shared library, pre-sign-in updates and no permanent local photo write. Its
   camera setup is model-first and automatically provisions the per-camera
   relay values; staff never enter the relay control URL/token. Its guided
   setup now reveals only the values needed for the current step, then asks for
   one test photo and waits for that exact camera's verified cloud completion
   before claiming the camera works. Version 0.20.1 separates Wi-Fi/server/login,
   preserves saved credentials on inspection, and closes stale UI/live feeds
   after sign-in loss. Software Update before sign-in remains intentional.
   Local/CI/package/public-release proof is green; see
   [[log/2026-09-05-camera-setup-access-audit]].
   Version 0.20.2 offers Open for the same patient's active visit, preserves
   its photos/details, and handles stale links and start races. Source, local
   gates, CI, package and public update checks pass; see
   [[log/2026-09-05-active-visit-recovery]].
   The live AWS null-marker activation defect is fixed and failed empty drafts
   are retired. The short-credential Lambda is live. Immediate field steps:
   confirm v0.20.2 on both Macs (this Mac is verified at 0.20.2 on 2026-11-04;
   affected v0.19.5/v0.19.6 installs need one
   direct-DMG recovery), confirm
   a stale camera lock no longer blocks a
   visit, Home shows a real visit started on the other Mac, and its contextual
   conflict notice opens the same patient's visit without ending/recreating it;
   turnover remains explicit for a different patient. Then complete the
   guided values → test-photo proof on the physical R6 Mark II. Next:
   multi-location picker, device/session administration and exact two-Mac
   packaged field proof.
   v0.19.6 is live: the already-running three-second cloud projection refresh
   also re-renders the active visit currently on screen. Merge, full tests,
   signed manifest, immutable ZIP and direct DMG are proven; exact physical-
   camera field proof remains open.
   v0.19.7 removes the clean-Mac `lipo`/developer-tools dependency and makes
   desktop Software Update available to every clinical role while retaining
   the private loopback capability boundary. Exact ZIP/DMG/live-manifest proof
   is green; one field Mac must use the DMG once because its pre-v0.19.7
   verifier cannot repair itself.
   Live v0.19.9 includes the v0.19.8 session-end reconciliation: when either
   Mac ends a cloud visit, the other Mac's authenticated three-second
   projection closes the same stale live visit screen. It also makes a new
   cloud sign-in land on Home and show shared visits under In progress instead
   of silently opening one. Camera choice is automatic for one camera and
   explicit for two or more. Signed ZIP/manifest/direct-DMG proof is green;
   field-prove these exact behaviors on the two Macs.

## Next
4. **Patient workspace 0.20.0 — published; field verification next.**
   Main `22a3770` includes rich shared profiles, authored visit notes, structured
   metadata, patient tabs and visit preparation. Local gates/Node 20/22 CI and
   fresh-profile packaged startup pass. The exact synthetic API is deployed;
   signed latest 0.20.0, public ZIP and no-store DMG are verified. The packaged
   updater reported 0.20.0 available at that publication check. Chris's local
   installed app is now verified as 0.20.2 (2026-11-04); use 0.20.2 for the next field pass.
   Verify authenticated patient edits, visit details, notes and conflict recovery
   against the live API on two downloaded Mac builds together. Signed consent
   and guided photo protocols remain future work. Evidence and exact artifacts:
   [[log/2026-09-05-patient-workspace-publication]].

**Patient record & clinic organization direction** — make the shared library a
   usable patient record, not merely a place to start a visit. Patient list
   and patient page: edit the photo-workflow identity (legal/preferred name,
   DOB, external MRN/EHR id where available), show a clear visit timeline,
   consent status, provider/procedure/body-area labels and photos together;
   actions are Edit patient, Start visit, view/compare/filter photos, and
   later Add/view consent. Preserve audit history and recoverable deletion.
   Med Photo deliberately does **not** become the system of record for full
   medical history, medications, insurance, diagnoses, billing, scheduling or
   clinical charting—those remain in the practice's EHR.
   **2026-09-05 user priority:** richer patient handling and a cohesive visual
   redesign, using RxPhoto as a workflow reference. Start with shared editable
   identity, preferred name, optional external chart ID/contact details, and
   explicit duplicate handling. Model visit purpose, provider, body area,
   baseline/follow-up and authored visit notes separately from patient-level
   information. Then implement a consistent patient workspace and a short
   prepare → capture → review → complete flow with remembered defaults.
   Verify editing/reload/second-computer synchronization and role restrictions,
   preserve old visits/IDs, and visually inspect empty, populated, loading,
   error and narrow-window states. The original conversation concept was
   illustrative; the first patient workspace slice is now published for
   synthetic testing. See
   [[log/2026-09-05-patient-workspace-audit]].
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
   live for arm64 internal tests (current v0.20.2). Railway serves signed
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
13. **GitHub server-side branch protection** — GitHub Pro is now active, so
   the private-repository plan blocker is gone. CamLink-SDK `main` still
   returns **Branch not protected**. After explicit GitHub-settings approval,
   protect `main` in both code and Vault repositories and verify required PR,
   CI, current-branch, no-force-push and no-delete rules. Local hooks and the
   integration-owner contract remain active meanwhile.
14. **Med Photo Box** — reassess; internet-direct FTPS may remove the need for
   travel-router hardware on isolated clinic networks (repo
   docs/MED-PHOTO-BOX.md; hardware sourced).
15. **USB tether (Phase D)** — `@medphoto/adapter-usb`; design in repo
   docs/PTP-PLAN.md.
16. **Other FTP vendors** (Sony/Nikon/Fuji pro bodies) — adapter is
   vendor-agnostic by design; needs per-vendor field proof.
17. **Capture protocols & baseline-assisted repeat capture** — clinic-defined
    photo sequences and optional prior-view reference for a follow-up shot.
    Defer until the patient record is useful and the core AWS/consent work is
    established; validate against real clinic workflow before claiming
    automatic alignment.

## Done recently (details in [[project-status]])
Canonical `main` + isolated multi-agent PR workflow (2026-08-28) ·
Cloud active-visit synchronization + stale-lock repair + contextual visit
conflicts (`aae5b44`, `7c0d11f`) · two-computer visit-end source fix
(`1ab5602`, release pending) · cloud sign-in lands on Home (`02c27d8`,
release pending) ·
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
