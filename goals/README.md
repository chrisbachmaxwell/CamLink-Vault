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
1. [[2026-07-visit-compare-ui]] (Phase B — CURRENT)
2. [[2026-07-clinic-lockdown]] (Phase C)
3. USB tether (Phase D — needs a goal page when its turn comes; design in
   repo docs/PTP-PLAN.md)
Done: [[2026-07-patient-records]] (Phase A) ·
[[2026-07-camera-reconnect]] (reconnect defect) — both 2026-07-09.
