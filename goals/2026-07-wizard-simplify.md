# Goal: Wizard simplification — one step at a time (Chris's UX feedback)

Status: PLANNED (queued after [[2026-07-visit-compare-ui]]) · Created:
2026-07-09 · Owner: work loop
Constraint: UI/flow only — do NOT touch pairing, diagnostics, announcer,
or adapter logic (hard rules; the plumbing works and is field-proven).

## Why (Chris, 2026-07-09)
"When you click into the camera's Wi-Fi it has all this text… it really
needs to be a lot more simple and not so much troubleshooting
information. Tell me what to do and click start and then give me the
next prompt — not just lay it all out from the get-go. And as it
connects all these green things pop up and then they stay there."

Earlier directive still stands (recorded on [[clinic-app]]): user picks
the connection type; no auto-guessing walls of text. This goal extends
it: after picking, the flow must be progressive, not a dump.

## Current state (verified in code, 2026-07-09)
- `apps/clinic/public/index.html`: the hotspot path (`ptp-steps-shared` /
  `ptp-steps-hotspot`) shows multi-item numbered lists with menu paths,
  model variants, and bold warnings ALL at once, plus a "Having trouble?"
  details block visible on the same screen.
- The doctor run (`ptp-doctor-steps`) appends a persistent ✅/❌ row per
  check; on success the green rows stay on screen instead of collapsing.

## Design sketch (loop may refine, not expand scope)
- Progressive disclosure: exactly ONE instruction on screen at a time,
  each with a single primary button ("Start" → "Next" → …). Camera-menu
  variants (classic vs 2025 menus) become a single toggle or an
  auto-advancing hint, not parallel text.
- Diagnostics run exactly as today, but render as one status line
  ("Checking the connection…") that collapses to ONE success row
  ("✅ Camera connected") when all checks pass. The full per-check list
  appears ONLY when a check fails (which check + fix hint, as today) or
  behind a "Show details" link.
- Troubleshooting content ("Having trouble?", firewall/permission notes)
  moves behind an explicit link/expander shown only after a failure or a
  timeout — never on the happy path.
- Step-flow state (which instruction, when to advance, what the doctor
  summary shows) lives in a plain testable module like
  reconnect-messages.js — the pattern that worked for the reconnect
  banner. DOM glue stays thin.
- NOT in scope: any change to runPtpIpDiagnostics, announcer, pairing,
  handoff, retry logic, or the wizard's tile-choice screen.

## Done when (agent-verifiable)
- [ ] Step-flow module with unit tests: given the hotspot path, exposes
      one instruction at a time, advances on user action or on camera
      events (search heard / port open / connected), never shows two
      instruction blocks at once
- [ ] Happy path shows at most ONE line of diagnostic status while
      checking, and exactly one success confirmation after — no
      persistent per-check green rows (render-module/jsdom test)
- [ ] Failure path still names WHICH layer broke with its fix hint —
      existing doctor detail preserved behind "Show details"; test
      renders a failing doctor report and asserts the detail appears
- [ ] Troubleshooting content absent from the happy-path DOM until a
      failure/timeout or explicit expand (test)
- [ ] Instruction copy budget: each step ≤ 2 short sentences, no
      firewall/permission/protocol jargon on the happy path (asserted in
      a copy test, like the reconnect banner test)
- [ ] No plumbing diffs: guard-style check that packages/** and the
      server's /api/setup, /api/setup/check handlers are unchanged
      (UI + public/ modules only, plus test files)
- [ ] All three gates green; pushed
- [ ] Vault [[clinic-app]] wizard section updated

## Waiting on Chris (not loopable)
- [ ] Fresh-eyes walkthrough: with the camera OFF, click "Change camera"
      → Camera's own Wi-Fi and follow the prompts with the R6 III.
      To run it:
      ```
      cd ~/CamLink-SDK
      git pull
      npm install
      npm run build
      npm start -w @camlink/clinic-app
      ```
      Open http://localhost:3333 in Chrome. Verdict wanted in one
      sentence per screen: "clear" or what confused you.

## Stop clause
Max 8 cycles, or 2 consecutive no-progress cycles → BLOCKED + log why.
Scope guard: no plumbing changes, no new dependencies, no redesign of
the tile-choice screen or the test-photo step beyond copy.

## Iteration log
(loop appends: date · what changed · commit hash)
