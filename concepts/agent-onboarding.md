# Agent onboarding — how future agents use this vault

## Point any project at the vault (the three lines)
Add to that project's `CLAUDE.md` (adjust the path to where this vault lives):

```markdown
## knowledge
- before starting, read INDEX.md, entities/project-status.md and
  entities/roadmap.md from ~/CamLink-Vault, then follow links relevant to the task
- ground every claim about CamLink, its cameras, protocols or environment in a
  vault page; when the field contradicts a page, fix the page in the same session
```

## Session-start ritual (any CamLink coding session)
1. Read vault `INDEX.md` → [[project-status]] → [[roadmap]].
2. If the task touches cameras/networking, also read the specific pages:
   [[eos-utility-pairing]], [[eos-event-records]], [[macos-networking-traps]].
3. Repo ground truth: `chrisbachmaxwell/CamLink-SDK`, branch
   `claude/camera-sdk-adapter-pattern-4pj5r8`. Build `npm run build`,
   test `npm test`, smoke `node apps/clinic/test/smoke.mjs ptp-simulator`.
   All three must be green before pushing.

## Session-end ritual
1. Write `log/YYYY-MM-DD-<slug>.md` (decisions, mistakes caught, patterns
   confirmed, commits).
2. Update [[project-status]] and [[roadmap]].
3. Fix/delete any vault page today's work contradicted (rule 3).

## Working with Chris
Non-technical founder. Give exact terminal commands with expected output;
prefer making the APP explain problems over asking him to interpret logs.
When he reports "it didn't work," the highest-value asks are: a screenshot,
and the `[canon-ptp]` lines from the terminal.

## Field-debugging doctrine (proven July 2026)
1. Instrument first (the unhandled-event tracer cracked two cameras).
2. Change one variable per test round.
3. tcpdump-sees-it vs app-hears-it localizes Mac-side vs network-side.
4. Every fix ships with a simulator test so it can't regress.
5. Write what you learned into this vault — the R6 III took hours instead
   of days BECAUSE the R10 lessons were already encoded in the design.
