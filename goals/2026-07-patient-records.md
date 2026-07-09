# Goal: Patient records & visits (Phase A — the product core)

Status: DONE · Created: 2026-07-09 · Owner: work loop
Constraint: LOCAL ONLY — no cloud, no external services ([[hipaa-local-first]]).

## Why
Today photos file under a typed name per session. An orthodontist needs:
find the patient in two keystrokes, start a VISIT, photos land in that
patient's history. Typos and duplicate names must not scatter records.

## Design sketch (loop may refine, not expand scope)
- Local patient index `captures/patients.json`: id (stable, generated),
  name, optional DOB, optional note, createdAt. No external DB.
- Folders become `captures/patients/<id>-<slugged-name>/visits/<ISO-date>/`
  (CaptureSession prefix mechanism already supports nesting).
- Existing loose session folders: one-time migration prompt or "unfiled"
  list — never silently move PHI.
- Front desk UI: search-as-you-type over patients; "New patient" inline;
  collision-safe (same name + different DOB = different record);
  "New visit" button on a patient → session flow as today.

## Done when (agent-verifiable)
- [x] Patient index module in the clinic app with tests (create, search,
      rename, collision behavior)
- [x] Visit folders nest under the patient as designed; manifest carries
      patientId + visitId
- [x] Wizard-free flow: typing a new name offers "create patient"; typing
      an existing one matches it (test via API)
- [x] Session history view groups by patient → visits
- [x] Migration/unfiled handling for pre-existing session folders, tested
- [x] Smoke test extended: two visits for one patient + one for a
      same-named patient with different DOB file into distinct folders
- [x] All three gates green; pushed
- [x] Vault updated: [[clinic-app]] page reflects the new model

## Waiting on Chris (not loopable)
- [ ] Real-office sanity pass: create 3 patients, 2 visits each, with the
      R6 III — does the front desk flow feel right?

## Stop clause
Max 12 cycles, or 2 consecutive cycles with no new checked box → set
Status: BLOCKED and write the blocker in the log.

## Iteration log
(loop appends: date · what changed · commit hash)
- 2026-07-09 · PatientIndex module (`apps/clinic/src/patients.ts`) + 9 vitest cases (create/search/rename/DOB collision/folder helpers); clinic workspace now runs `vitest` · `af4abc8`
- 2026-07-09 · CaptureSession `folder`/`patientId`/`visitId`; clinic `visits.ts` + server start-by-patientId → `patients/<id>-<slug>/visits/<ts>/`; manifest fields covered by tests · `dc6cdba`
- 2026-07-09 · `/api/patients` + `/api/patients/match`; front-desk find/create UI; patients-api HTTP tests · `70ef1ce`
- 2026-07-09 · History groups by patient→visits (nested + legacy); `/api/sessions` returns `{patients,sessions}` · `6c8a3d2`
- 2026-07-09 · Unfiled list + explicit `/api/unfiled/file` migration (never auto-move); UI picker · `781a505`
- 2026-07-09 · Smoke extended: 2 visits one patient + same-name/different DOB → distinct folders; history groups; legacy stays unfiled · `5071486`
- 2026-07-09 · Vault [[clinic-app]] / [[project-status]] / [[roadmap]] updated; Phase A agent items DONE (Chris R6 III sanity still Waiting) · (this commit)
