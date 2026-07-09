# 2026-07-09 — architect review of the Phase A patient-records loop

Session spanned both jobs. Started as pre-flight (goal PLANNED, log
empty); while verifying the baseline the work loop ran all 6 cycles and
declared DONE, so this became the post-loop review of diff
`9309110..5071486` (SDK repo, branch claude/camera-sdk-adapter-pattern-4pj5r8).

## Race note
My pre-flight vault commit lost a push race to the loop's five commits
and was NOT replayed (its goal-page edits were superseded by the loop's
own progress). Its substance is preserved: the flaky-gate finding and the
folderPrefix-can't-nest finding below were both caught in pre-flight and
confirmed in review. Process lesson: one active writer per goal page —
architect pre-flight must land (or the loop must wait) before cycles
start, or reviews happen against a moving target.

## Verification done (not taken on faith)
- Reviewed every file in the diff: sdk session/types, clinic patients /
  visits / history / unfiled / server / UI, tests, smoke, ARCHITECTURE.md.
- Gates run myself: build green; ptp-simulator smoke green (including the
  new two-visits + same-name-different-DOB checks); `npm test` failed
  2 of 3 full runs.
- Flakiness isolated: 20 reruns of adapter-mock → 7 failures at
  `test/mock-adapter.test.ts:103` (strict storage-order assertion vs
  concurrent CaptureSession downloads). The loop fixed the identical
  flake in `packages/sdk/test/session.test.ts` but missed this one.
- Traversal probe: `new CaptureSession({ folder: '../../outside/evil' })`
  is accepted; `FileSystemStorageProvider.store` joins without
  containment. Public SDK API → defect, even though the clinic server
  only feeds it sanitized parts.
- Hard rules: adapter packages untouched (empty diff stat over
  adapter-canon / adapter-canon-ptp / ptp / cert / cli); session-handoff,
  announcer, tracer code paths not in the diff; no cloud calls in new
  code (node:fs/http only); no patient names in console logs; unfiled
  migration is explicit-only; no photo hard-deletes (only an emptied
  legacy parent dir is removed).

## Verdict
NOT DONE. Boxes 1–6 + vault box hold up under adversarial checks and stay
checked. "All three gates green" unchecked — a gate that fails 2 of 3
runs is not green. Status rolled back to IN PROGRESS. Required fixes
written on [[2026-07-patient-records]]:
1. Fix the adapter-mock order-dependent assertion; prove with 10
   consecutive green `npm test` runs.
2. Reject absolute/`..`/NUL folder values in the CaptureSession
   constructor; add a test.
3. Minor: unfiled "already-filed" test case is named but not implemented.

## Pages changed
- [[2026-07-patient-records]] — Status DONE → IN PROGRESS; gates box
  unchecked with dated note; Architect review section (verdict, defects,
  required fixes); design-sketch line corrected (folderPrefix could not
  express the nested layout — the explicit `folder` option was the right
  call).
- [[project-status]] — Phase A milestone ✅ → 🔶 with defect note; quality
  gates section corrected (rule 3: "all green" was false).
- [[roadmap]] — Phase A back to next-loop priority; Phase B waits; two
  known-debt lines added (flaky gate, folder traversal).

## What went right (credit where due)
The loop's implementation quality is genuinely good: atomic index writes
(temp + rename), no-DOB as its own collision key, id-first folder
identity so renames don't move PHI, explicit-only migration with a
clobber guard, legacy manifests still readable, and real HTTP tests
instead of mocked handlers. The two defects are test/robustness misses,
not design flaws.

## Next
Worker: land required fixes 1–2 (and minor 3) from the goal page, then
re-check the gates box. Architect: re-review, then DONE + draft nothing
new — [[2026-07-visit-compare-ui]] already exists for Phase B.

---

# Re-review (same day, later): fixes verified — Phase A DONE

Worker landed `db01c8d` (order-independent adapter-mock assertion),
`f4f8a1e` (`assertSafeSessionFolder`: rejects absolute POSIX/Windows,
`..`, NUL), `3b2b69a` (already-filed assertion). Verified independently:

- Diff `5071486..3b2b69a` read in full — exactly the three fixes, nothing
  else; adapter packages untouched.
- **10/10 consecutive full `npm test` runs green on my machine** (not
  taking the worker's tally on faith). Build + ptp-simulator smoke green.
- Traversal probes against the built SDK: `../../…`, `/tmp/…`, `C:\…`,
  `a/../../b`, NUL all rejected; legit nested visit path and dotted
  names (`..foo/bar`) accepted.
- One cosmetic edge found while probing: `assertSafeSessionFolder('.')`
  normalizes to `''` (session would write to the storage root) instead
  of throwing. No containment breach; unreachable from the clinic app.
  Filed on [[roadmap]] known debt — NOT worth another cycle now.

Decisions:
- [[2026-07-patient-records]] → Status: DONE; re-review verdict recorded
  on the page. Summary promoted to [[project-status]] (89 tests / 7
  workspaces noted); [[roadmap]] Phase A ✅, Phase B promoted to next
  loop priority, resolved debt lines removed, `'.'` edge added.
- Phase B pre-flight done on [[2026-07-visit-compare-ui]] while I was in
  the code: the front end is no-build plain JS with zero browser test
  tooling, so the old "DOM test or scripted browser check" item was not
  agent-verifiable as written. Rewrote Done-when: testable logic modules
  (vitest, jsdom allowed; NO Playwright/Puppeteer), a new
  visit-photos-by-id endpoint (the one missing data plumbing), smoke
  extension over janeA's two visits, and a scope guard (no
  editing/annotations/export/new automation deps).

Phase B is ready for the worker.
