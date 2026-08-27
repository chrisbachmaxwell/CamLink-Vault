# 2026-08-27 — Addendum: RxPhoto/ImageAssist research under AWS direction

This addendum supersedes the local-only implementation framing in
`2026-08-27-rxphoto-imageassist-product-research.md`. The current product
decision is [[cloud-authoritative-library]]: AWS is to become the clinical
source of truth, while the desktop app keeps only a bounded encrypted
capture/upload cache.

## How the research maps to the active cloud goal

- **Capture protocols and baseline matching remain product features.** Attach
  protocol view labels, baseline/derived-photo relationships, camera identity,
  capture time and immutable digests to the cloud clinical metadata record.
  Originals remain immutable; an alignment or background-cleaned derivative
  must retain provenance and never replace the original.
- **Consent becomes an authorization fact in the clinical store.** Model
  clinical-capture acknowledgement separately from marketing/publication
  release, with versioned form, signer, timestamp, policy version and audit
  fact. An absent or withdrawn marketing release must deny gallery/export
  pathways even when clinical storage is allowed.
- **EHR integration is a later, opt-in adapter.** The appropriate first shape
  is an IT-authorized patient/schedule lookup and a deterministic chart export
  (for example, metadata plus a server-authorized object reference). It must
  preserve organization/location membership, opaque object keys, audit facts,
  idempotency and explicit reconciliation. Do not make an EHR the automatic
  source of truth without a per-integration decision.
- **Cloud galleries and mobile capture are separate projects.** The competing
  products validate demand, but they must wait for the active goal's private
  S3, OIDC/membership, short-lived display access, restore/retention/revocation
  drills, BAA and compliance sign-off. No marketing, Canva, portal, SMS/email
  consent or real-PHI path is authorized by this research.

## Revised sequencing

1. Finish the active synthetic AWS data-plane gates.
2. Add protocol metadata and a clinician-tested capture sequence without
   changing the fast camera-first happy path.
3. Add compare-assisted baseline reference as an optional workstation view;
   measure reshoots, protocol completion, and retrieval time before any
   automatic alignment claim.
4. Design consent and export only after the durable audit/access foundation,
   then test them with synthetic records and compliance review.
