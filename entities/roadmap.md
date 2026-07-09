# Roadmap — WHAT IS LEFT

Last updated: 2026-07-09 (Chris's field test found a reconnect defect —
it jumps the queue ahead of Phase B). Ordered by what makes the app a
usable orthodontist product fastest. Governing constraint:
[[hipaa-local-first]] — local only, LAN only.

## The phases (each has/gets a goal page in goals/)
- ✅ **A. Patient records & visits** → [[2026-07-patient-records]] — DONE
  2026-07-09 (architect re-review). Still open there: Chris's real-office
  R6 III sanity pass (partial 2026-07-09: patient create w/o DOB +
  later session confirmed working; rest blocked on reconnect).
- 🔥 **R. Camera power-cycle reconnect** → [[2026-07-camera-reconnect]] —
  field defect from Chris's test: camera off/on on its own AP never
  reconnects (announcer deaf after Wi-Fi hop + wizard-only cameraFound).
  **← next loop priority. Core product promise; jumps Phase B.**
- **B. Patient page & visit compare** → [[2026-07-visit-compare-ui]] —
  timeline per patient, side-by-side progress comparison (the ortho
  payoff). Starts after R.
- **C. Clinic lockdown** → [[2026-07-clinic-lockdown]] — localhost bind,
  PIN + auto-lock, audit log, FileVault/backup docs, no-cloud CI check.
- **D. USB tether transport (P4a)** — design in repo docs/PTP-PLAN.md;
  reliability king for offices. Needs a goal page when its turn comes.

## Also queued
- Fix Chris's home/office network filter ([[home-network-filter]]) — need
  router brand/ISP from Chris
- Package the clinic app for staff (double-click app, no Terminal) — folds
  naturally after Phase C
- Vault ops: schedule [[vault-maintenance]] loops; wikilink→markdown-link
  conversion for GitHub browsing
- M6 npm publish pipeline · M2 native kits · CCAPI keep-or-remove decision
- Adapter certification doc for third-party authors
- Windows validation pass
- Wizard test step: warn when the test file is RAW
- Retake/delete UI in sessions (clinic feedback anticipated) — soft-delete
  to `.trash/` per [[hipaa-local-first]]

## Hardware matrix to grow
Validated: EOS R10, EOS R6 Mark III. Next: R50/R8, R5 Mark II, a PowerShot,
an older menu-gen-1 body; Nikon/Sony = new adapters.
Open data point: which SetRemoteMode value the R6 III accepted.

## Known debt
- `assertSafeSessionFolder('.')` normalizes to `''` → session writes to
  the storage root instead of throwing (architect probe 2026-07-09).
  Cosmetic — no containment breach, unreachable from the clinic app; fold
  into the next SDK-touching goal.
- Same-Wi-Fi flow untested end-to-end (blocked on router fix)
- Announcer port-contention detection is boot-time only — now part of
  [[2026-07-camera-reconnect]] (interface re-join)
- Keep the unhandled-event tracer forever ([[eos-event-records]])
- Server binds all interfaces today — moves to localhost-default in Phase C
- Legacy typed-name `POST /api/session { patientName }` still works (smoke
  uses it) but new UI prefers `patientId`; consider deprecating after Phase B
