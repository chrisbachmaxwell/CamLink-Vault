# 2026-08-27 — RxPhoto and ImageAssist product research

## Scope

Public-product research only; no patient data, accounts, trials, or vendor
systems accessed. Sources reviewed: RxPhoto platform/clinical-photography
pages and ImageAssist product/integrations pages, plus ImageAssist's 2024
peer-reviewed product paper.

## What the market validates

- Repeatable capture is a primary job, not cosmetic polish. RxPhoto uses
  procedure capture sequences and ghost overlays; ImageAssist uses procedure
  guides plus alignment feedback. Both position instant comparison as the
  consultation payoff.
- The patient record needs a visible, durable link between photos, visit
  context and permissions. Both products pair capture with consent, access
  controls and auditability; ImageAssist distinguishes clinical and marketing
  consent.
- EHR schedule/patient lookup removes duplicate identity entry. ImageAssist
  claims patient and schedule sync, then chart export. This is a later,
  explicitly-integrated workflow—not a reason to duplicate a cloud product.

## Med Photo implications

1. Add a local-only **Capture Protocol** layer after the current security
   gates: a clinic-defined sequence such as front/right/left/intraoral; each
   arriving camera image is assigned to the next required view, with a quiet
   missing-view reminder only when the visit ends. This preserves camera-first
   capture and the one-action visit screen.
2. Make **baseline-assisted repeat capture** the next comparison enhancement:
   when a staff member chooses a protocol view, show the previous visit's
   photo as an optional translucent reference on the workstation (or a paired
   iPad companion only after a local-device security design). Do not promise
   automatic alignment until it is measured on real clinic imagery.
3. Extend the existing patient/visit manifest with non-PHI operational
   metadata: protocol-view label, camera/model, capture timestamp and an
   immutable content digest already present. This makes compare and export
   more trustworthy without image alteration.
4. Phase C should retain its priority: access control, auto-lock and audit
   trail are prerequisites. Then add a locally stored signed clinical-photo
   acknowledgement and a separately explicit marketing-release state. Never
   expose or sync an image based merely on a generic treatment consent.
5. Treat EHR work as an adapter/export boundary: initially a clinician- or
   IT-triggered export package with deterministic filename, digest, visit
   metadata and audit entry; later, an opt-in per-EHR adapter. No automatic
   cloud synchronization or remote patient portal is implied.

## Explicit non-adoptions

- ImageAssist's cloud storage, browser portal and Canva path conflict with the
  local/LAN-only PHI stance unless Chris and a compliance advisor explicitly
  open a separate BAA-reviewed project.
- Background removal/editing should not alter the diagnostic original. Any
  future derivative must be opt-in, visibly labeled, locally generated and
  preserve the original plus provenance.
- Marketing galleries, SMS/email forms, patient portals and cross-location
  synchronization are out of scope for Med Photo today.

## Suggested validation before implementation

Interview an orthodontic clinic and a plastic-surgery/med-spa clinic using a
five-patient mock protocol. Measure: time from patient selection to first
shot, protocol-completion rate, reshoot count, and whether staff can retrieve
the matching prior view in under ten seconds. Capture no real PHI in the
exercise or research notes.
