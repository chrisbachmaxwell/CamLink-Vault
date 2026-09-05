# 2026-09-05 — Patient handling and product polish assessment

## Request and scope
Chris wants richer patient information and more polished flows comparable to
RxPhoto. This session assessed the current product and prepared an interactive
concept. It did not implement patient-data collection or change installed or
hosted software. All example records were synthetic.

## Evidence and mistakes caught
- Read the vault entry/status/roadmap and routed clinic/design pages. The
  primary local vault contains unrelated edits and old guidance; fetched
  `origin/main` (`0f5d7ab`) supplies current cloud and PR-governance context.
  Preserved the primary checkout and used an isolated vault worktree.
- SDK checkout `9bc5ee7`, fetched main `02c27d8`; installed desktop plist
  v0.19.7. Installed and checkout `public/index.html` are byte-identical
  (SHA-256 `35398a88b7f0d8ccdbb54f9d4c2fac3d29d436aace9d1be278c5f5ef4c141951`).
  Installed `app.js` separately confirms patient Edit is hidden in cloud mode.
  No actual signed-in cloud account was inspected.
- `apps/clinic/src/patients.ts`: name, optional DOB and one note. Cloud domain
  `CloudPatient`: displayName and nullable dateOfBirth plus tenant/location/
  stable identity/creation fields, with no note field. Thus frontend-only
  additions cannot solve shared patient handling.
- Patient markup includes only identity/note and static Consent / Not recorded.
  Local synthetic browser walkthrough created a patient from Home, navigated
  Patients → Browse all → patient, and inspected the rendered screen.
- Assessment: clean/readable but sparse and generic; duplicated identity,
  emoji navigation and limited context contribute to an early-product feel.
  Not a timed usability study or an exhaustive authenticated RxPhoto audit.
- RxPhoto primary sources reviewed 2026-09-05:
  https://rxphoto.com/platform/forms-and-notes and
  https://rxphoto.com/platform/clinical-photography. They describe connected
  patient timelines, structured notes, forms/consent and repeatable capture.
  Marketing claims are not independent verification of product effectiveness.

## Proposed direction
- Persistent identity header and Overview / Photos & visits / Forms & consent /
  Details. Keep the existing Home / Patients / Cameras / Settings destinations.
- Richer shared patient identity and optional contact/chart identifiers;
  patient-level preferences separated from dated, authored visit notes.
- Visits carry purpose, provider, body area, baseline/follow-up and photo-view
  labels. Favor defaults and progressive disclosure for repeat visits.
- Distinct clinical-photo consent and marketing authorization with signed
  versioned artifacts, scope, dates, withdrawal and audit history. Do not infer
  consent from a badge or from treatment consent.
- Consistent iconography, spacing, typography, actions, errors, empty states
  and back-navigation across the entire patient journey.
- Preserve stable identities/historic visits and tenant/role controls; prove
  edit/reload/second-computer behavior before claiming completion. No full EHR
  replacement or external messaging/integration was authorized by this audit.

## Concept and validation
A task-owned conversation concept demonstrates record tabs, visit preparation,
capture handoff placeholders and baseline comparison structure. It is clearly
labeled fictional and has no patient-system or camera connection. Browser QA
caught the sandbox's blocked native form submissions; controls were changed
to explicit local button actions. Production build/test/camera gates were not
run because no application source was changed; concept checks do not replace
those gates for future implementation.

## Delivery
Vault-only branch `codex/patient-workspace-audit-20260905`; owned files are this
log plus entities/clinic-app.md, entities/project-status.md and
entities/roadmap.md. Push/open a documentation PR; no merge or deployment is
implied. SDK code was not changed, so there is no SDK commit or release.
Next user review: explore the patient workspace tabs and Start visit in the
conversation, then refine the field set and flow before production work.
