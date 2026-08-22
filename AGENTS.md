# Med Photo Vault — agent instructions (OpenAI / Codex / Cursor)

(CLAUDE.md and GROK.md are this file's mirrors — KEEP ALL THREE IN SYNC.)

You are inside the knowledge vault — the PROJECT BRAIN — for **Med Photo**
(formerly CamLink; renamed 2026-08-21): camera → app → patient-folder
platform for clinics. This file is the always-loaded tax: it stays short
and points at the vault; it never contains the vault. The code lives in
the `CamLink-SDK` repo (repo rename pending; product name is Med Photo).

## The four rules
1. **One lesson per file.** A page holds one entity, one concept, or one
   dated log entry. If a finding doesn't fit an existing page, make a new one.
2. **Update, don't duplicate.** Before writing, grep/search for an existing
   page on the topic and edit it. Two pages on one topic is rot.
3. **Delete what's wrong.** When the field contradicts a page, fix or delete
   the page immediately and note the correction in `log/` with today's date.
4. **Never touch `raw/`.** Raw material (terminal logs, transcripts, pasted
   evidence) is append-only ground truth. Summarize it into pages; never
   edit or delete it.

## How to read (pay-per-read — open only what the task needs)
- Start at `INDEX.md`; it has a **task router** — find your task type,
  open only the pages it lists. Never sweep whole folders into context.
- For broad questions ("what do we know about X across the vault"), spawn a
  subagent to read pages in its own context and return one paragraph.
- Current state lives in `entities/project-status.md` and
  `entities/roadmap.md` — read those two before starting ANY Med Photo work.

## How to write (this brain is SELF-BUILDING — feed it as you work)
- New knowledge → the matching page in `entities/` or `concepts/`, with a
  dated line: claim, source (terminal log / commit hash / doc link), date.
- Volatile claims (menus, firmware behavior, pricing, tool versions) carry
  an expiry: `(verify after: YYYY-MM)`.
- New work → a goal page in `goals/` following goals/README.md; work loops
  check boxes and append iteration-log lines as they go.
- Session summaries → `log/YYYY-MM-DD-<slug>.md`: decisions made, mistakes
  caught, patterns confirmed. Then update the wiki pages those touch.

## Session end (non-negotiable ritual)
Before finishing ANY working session — and immediately whenever Chris
says "wrap up" or "done" — without being asked:
1. Write `log/YYYY-MM-DD-<slug>.md`: decisions made, mistakes caught,
   patterns confirmed, commits pushed, what a human should test by hand.
2. Update `entities/project-status.md` and `entities/roadmap.md` to
   match reality.
3. `git push` this vault AND any code repo you changed.
Work that isn't pushed and logged doesn't exist. If a session is cut off
mid-task, the per-cycle pushes of the goal-loop protocol are the backstop
— but never rely on them when you can run the ritual.

## Sync warning
One sync system only. This vault is checkpointed with git — commit and push
per the ritual above; never mix with iCloud/Dropbox auto-sync on the same
folder. Cloud Claude sessions: attach `chrisbachmaxwell/camlink-vault` via
the add_repo tool to read/write this brain directly.
