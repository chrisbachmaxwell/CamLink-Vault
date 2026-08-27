# 2026-08-27 — Patient record organization shipped

## Decision implemented

Chris asked Med Photo to make selecting a patient reveal a useful, editable
patient record, rather than only offering **Start visit**. This is the first
small, clinic-reference implementation of the roadmap's patient-record and
clinic-organization work. It is intentionally not an EHR.

## Shipped in SDK `154c2b5`

- Patient page now shows **Patient information**: name, DOB and an optional
  short photo-workflow note, together with the existing visit timeline,
  thumbnails and Compare action.
- Staff/owners can edit those three fields in place; review users remain
  read-only both in the UI and server authorization.
- Stable patient ids, historic folders and visit relationships remain intact;
  changing a name never moves prior folders. The audit event uses only the
  opaque patient id.
- A quiet **Consent — Not recorded** state makes the missing permission
  visible without pretending to have a signed form. Consent, external/MRN
  identity and EHR integration remain separately designed cloud work.
- Browser gate now proves edit persistence after leaving/reopening, then a
  second actual FTP visit and two-visit Compare interaction.

## Verification

- `npm run build` — green
- `npm test` — completed after the full workspace build; focused clinic run:
  79 tests green, 1 platform-specific reconnect skip
- `node apps/clinic/test/smoke.mjs ptp-simulator` — green
- `node apps/clinic/test/smoke.mjs ftp` — green
- `node apps/clinic/test/smoke.mjs multi-room` — green
- `npm run test:ui -w @medphoto/clinic-app` — green

## Boundary

No real patient data, cloud resources, provider agreements, consent forms or
EHR connections were created. Current AWS/cloud work remains synthetic-only.
