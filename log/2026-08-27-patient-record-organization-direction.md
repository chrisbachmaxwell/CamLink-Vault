# 2026-08-27 — Patient record and clinic organization direction

Chris reviewed RxPhoto and ImageAssist research during the AWS buildout and
set the product direction:

- EHR integration belongs on the roadmap.
- Digital consent is a desired product capability.
- Capture protocols are valuable but later.
- The immediate product gap is patient organization: Med Photo cannot feel
  like only a `Start visit` action. Selecting a patient must reveal an
  understandable, editable patient record and useful actions.

Public research supports a patient-centered organization: RxPhoto presents a
single timeline combining visits, photos, forms and notes; ImageAssist markets
patient/date/procedure search, session history, photo albums and a visible
consent state. Neither vendor's public pages establish an exhaustive data
schema, so Med Photo will not copy unverified fields.

The roadmap now specifies a narrow patient-record layer: photo-workflow
identity, timeline, consent state, provider/procedure/body-area labels and
photo actions. Full medical history, diagnostics, medications, billing,
scheduling and charting remain EHR territory. Patient data, consent and EHR
work remain synthetic-only until the AWS production compliance gate passes.
