# CamLink Vault — agent instructions

You are inside the knowledge vault for the CamLink project (camera → app →
patient-folder platform for clinics). This file is the always-loaded tax:
it stays short and points at the vault; it never contains the vault.

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

## How to read (pay-per-read — the expensive room holds decisions)
- Start at `INDEX.md`, follow links, open only the pages the trail points at.
- Never sweep whole folders into context.
- For broad questions ("what do we know about X across the vault"), spawn a
  subagent to read pages in its own context and return one paragraph.
- Current state lives in `entities/project-status.md` and
  `entities/roadmap.md` — read those two before starting ANY CamLink work.

## How to write
- New knowledge → the matching page in `entities/` or `concepts/`, with a
  dated line: claim, source (terminal log / commit hash / doc link), date.
- Volatile claims (menus, firmware behavior, pricing, tool versions) carry
  an expiry: `(verify after: YYYY-MM)`.
- Session summaries → `log/YYYY-MM-DD-<slug>.md`: decisions made, mistakes
  caught, patterns confirmed. Then update the wiki pages those touch.
- After meaningful work on the CamLink repo, update
  `entities/project-status.md` and `entities/roadmap.md` in the same session.

## Sync warning
One sync system only. This vault is checkpointed with git — commit when told,
never mix with iCloud/Dropbox auto-sync on the same folder.
