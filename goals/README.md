# goals/ — loopable goals

Each goal is ONE page a work loop maintains. Rules:
- **Done when** items must be agent-verifiable (tests, smoke runs, greppable
  facts) — anything needing Chris's hands goes under **Waiting on Chris**.
- Every **Waiting on Chris** item must carry exact paste-ready Terminal
  commands and what he should expect to see — start from the standard
  preamble in [[test-environment]]. Never ask Chris to test with prose
  alone. (His rule, 2026-07-09.)
- Every loop cycle: pull both repos → next unchecked item → implement with
  tests → all three gates green (build / npm test / ptp-simulator smoke) →
  push code → check the box + append one dated line to **Iteration log** →
  push vault.
- Obey the **Stop clause** literally. When stopping early, the last log line
  says exactly what's blocking.
- One active loop per repo at a time. Status field: PLANNED · IN PROGRESS ·
  BLOCKED · DONE.
- When a goal hits DONE: move its summary to [[project-status]], list any
  follow-ups in [[roadmap]], set Status: DONE. The page stays as history.

Current sequence (updated 2026-07-09 late):
1. [[2026-07-visit-compare-ui]] (Phase B — CURRENT; includes Chris's
   photo-click / grouped-history / storage-visibility feedback)
2. [[2026-07-wizard-simplify]] (W — Chris's wizard UX feedback)
3. [[2026-07-clinic-lockdown]] (Phase C)
4. USB tether (Phase D — needs a goal page when its turn comes; design in
   repo docs/PTP-PLAN.md)
Done: [[2026-07-patient-records]] (Phase A) ·
[[2026-07-camera-reconnect]] (reconnect defect) — both 2026-07-09.

Current sequence (updated 2026-08-22 — supersedes the list above):
1. [[2026-08-r5ii-ftp-dialect]] — CURRENT: R5 Mark II / all-FTP-cameras
2. [[2026-09-multi-room]] — BUILT; only the second-body field box open
3. [[2026-08-simplicity-pass]] — largely shipped in the 2026-08-21 flow
   overhaul; reconcile its boxes against [[project-status]]
4. [[2026-07-clinic-lockdown]] (Phase C)
Done since July: [[2026-07-visit-compare-ui]] (shipped inside the
2026-08 redesign) · [[2026-07-wizard-simplify]] (superseded by
[[design-doctrine]]'s wizard escape-hatches + zero-typing relay).
Gates are now SIX (build · unit · smoke ptp-simulator · smoke ftp ·
smoke multi-room · browser ui-gate) — "all three gates" above is stale.

Current sequence (updated 2026-08-27 — supersedes every list above):
1. [[2026-08-cloud-clinical-library]] — CURRENT: cloud data plane, FTPS ingest,
   downloaded-app cloud mode, verified migration, final BAA/compliance gate
2. [[2026-08-r5ii-ftp-dialect]] — keep field evidence; align with FTPS fleet
3. [[2026-09-multi-room]] — reinterpret remaining field box as cloud
   camera→active-visit routing
4. Public distribution + USB and other transports after the cloud workflow
Gates remain SIX, with package/service-specific adversarial tests added as each
cloud slice lands.
