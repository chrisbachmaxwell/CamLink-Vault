# Goal: Patient records & visits (Phase A — the product core)

Status: DONE (architect re-review 2026-07-09 — see below) · Created:
2026-07-09 · Owner: work loop
Constraint: LOCAL ONLY — no cloud, no external services ([[hipaa-local-first]]).

## Why
Today photos file under a typed name per session. An orthodontist needs:
find the patient in two keystrokes, start a VISIT, photos land in that
patient's history. Typos and duplicate names must not scatter records.

## Design sketch (loop may refine, not expand scope)
- Local patient index `captures/patients.json`: id (stable, generated),
  name, optional DOB, optional note, createdAt. No external DB.
- Folders become `captures/patients/<id>-<slugged-name>/visits/<ISO-date>/`.
  (Corrected 2026-07-09: `folderPrefix` could NOT express this — the loop
  rightly added an explicit `folder` + `patientId`/`visitId` to
  CaptureSessionOptions instead.)
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
- [x] All three gates green; pushed — RESOLVED 2026-07-09 (worker):
      architect note left for history — `npm test` had failed 2 of 3 full
      runs on `packages/adapter-mock/test/mock-adapter.test.ts:103`
      (order-dependent flake). Fixed in `db01c8d` (order-independent
      assertion). Proof: **10/10 consecutive `npm test` green**. Folder
      traversal rejected in `f4f8a1e`. Status stays IN PROGRESS pending
      architect re-review.
- [x] Vault updated: [[clinic-app]] page reflects the new model

## Architect review (2026-07-09 — verdict: NOT DONE, two fixes required)
Reviewed the actual diff `9309110..5071486`, ran all three gates myself
(3× full `npm test`, 20× isolated adapter-mock reruns, ptp-simulator
smoke). Adapter boundary intact; adapter packages untouched (empty diff);
no cloud calls; no PHI in logs; unfiled migration is explicit-only; no
hard-deletes (only an empty legacy parent dir is removed). Boxes 1–6 and
the vault box verified and hold: index (atomic writes, no-DOB collision
key), SDK folder/patientId/visitId extension + tests, create/match HTTP
tests, grouped history incl. legacy manifests, unfiled list/file with
traversal guard, extended smoke (ran green here).

Defects found (these are the worker's next cycles):
1. **REQUIRED — flaky test gate.**
   `packages/adapter-mock/test/mock-adapter.test.ts:103` asserts strict
   storage order across concurrent downloads. Apply the same fix as
   `packages/sdk/test/session.test.ts` (order-independent assertion) or
   make CaptureSession ordering deterministic — state which in the
   commit. Prove it: 10 consecutive green `npm test` runs, then re-check
   the gates box.
2. **REQUIRED — SDK `folder` option accepts path traversal.**
   Verified: `new CaptureSession({ …, folder: '../../outside/evil' })` is
   accepted, and `FileSystemStorageProvider.store` joins it to the root
   without containment checks → a public SDK API can write photos outside
   the storage root. Not reachable through the clinic server today (it
   builds the folder from sanitized parts), but third-party apps get this
   API. Reject absolute paths, `..` segments, and NUL in the
   CaptureSession constructor; add a test.
3. Minor: the unfiled test named "refuses path traversal and
   already-filed sessions" only tests traversal — add the already-filed
   assertion (`fileUnfiledIntoPatient` on a manifest with patientId must
   throw) or rename the test.

When 1–2 land and gates are proven green, the worker re-checks the gates
box and leaves Status: IN PROGRESS; the architect flips DONE and
re-promotes [[project-status]] / [[roadmap]] after re-review. (Worker
landed 1–3 on 2026-07-09 — see Iteration log.)

### Re-review (2026-07-09 late — verdict: DONE)
Verified the fixes diff `5071486..3b2b69a` and re-ran everything myself:
build green; **10/10 consecutive full `npm test` runs green** (independent
of the worker's tally); ptp-simulator smoke green. Traversal probes against
the built SDK: `../../…`, `/tmp/…`, `C:\…`, `a/../../b`, NUL all rejected;
nested visit paths accepted. All three fixes are exactly scoped; adapter
packages untouched. One cosmetic edge, non-blocking, noted on [[roadmap]]:
`assertSafeSessionFolder('.')` normalizes to `''` (session writes to the
storage root) instead of throwing — no containment breach, unreachable
from the clinic app. Status: DONE; summary promoted to [[project-status]].

## Waiting on Chris (not loopable)
- [ ] Real-office sanity pass: create 3 patients, 2 visits each, with the
      R6 III — does the front desk flow feel right?
      PARTIAL 2026-07-09: Chris created patients without DOB and started
      sessions with them later — works as intended. The full 3×2 pass is
      blocked by the power-cycle reconnect defect he found mid-test →
      [[2026-07-camera-reconnect]]. Re-run this pass after that goal.

      To run it:
      ```
      cd ~/CamLink-SDK
      git pull
      npm install
      npm run build
      npm start -w @camlink/clinic-app
      ```
      Open http://localhost:3333 in Chrome, connect the R6 III through
      the wizard (Camera's own Wi-Fi), then: type a name → Create patient
      (add DOB) → Start visit → shoot → End session. Repeat for 3
      patients, 2 visits each. Expect folders under
      `captures/patients/<id>-<name>/visits/<timestamp>/` and History
      grouped by patient. Also try two patients with the SAME name and
      different DOBs — they must stay separate. When done: Ctrl+C in
      Terminal, then tell the architect in plain words what felt wrong.

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
- 2026-07-09 · Architect fix 1: adapter-mock storage assertion order-independent (sort before compare; concurrent downloads stay intentional). Proof: 10/10 consecutive `npm test` green · `db01c8d`
- 2026-07-09 · Architect fix 2: CaptureSession rejects absolute/`..`/NUL `folder` via assertSafeSessionFolder; tests for each reject + nested accept · `f4f8a1e`
- 2026-07-09 · Architect minor 3: unfiled test now asserts already-filed (patientId present) throws · `3b2b69a`
- 2026-07-09 · Re-checked gates box (resolved note kept); Status remains IN PROGRESS for architect re-review · fixes `db01c8d` `f4f8a1e` `3b2b69a`
