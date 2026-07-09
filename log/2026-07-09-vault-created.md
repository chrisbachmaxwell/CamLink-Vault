# 2026-07-09 — Session: vault created, published, and wired in

## Decisions made
- Knowledge vault created per the "keep it alive with loops" format:
  raw/ (append-only), entities/, concepts/, log/, INDEX.md, CLAUDE.md with
  the four rules. Backfilled the entire project history ([[2026-07-09-backfill]]).
- Vault published to a **private GitHub repo**:
  `github.com/chrisbachmaxwell/CamLink-Vault` (branch `main`), living at
  `~/CamLink-Vault` on Chris's Mac. Checkpointing is **manual git push**
  by design (single sync system; optional Obsidian "Git" community plugin
  can automate the ritual later).
- CamLink-SDK repo gained a `CLAUDE.md` (commit f0de6b6) with the three
  knowledge lines pointing at this vault + the hard rules + the three
  build/verify gates.
- Cloud-session access plan: Claude GitHub App → add CamLink-Vault under
  Repository access; select BOTH repos in the claude.ai/code repository
  selector when starting sessions. (An already-running session cannot gain
  access — scope is fixed at session start.)

## Patterns confirmed
- The backfill validated the vault premise immediately: the R6 Mark III
  took hours instead of days BECAUSE R10 lessons were encoded in the
  design (oid@0 invariant, tracer, layout-proof events).

## Mistakes caught
- None this session; earlier sessions' mistakes are recorded in
  [[2026-07-09-backfill]] ("Mistakes worth remembering").

## Repo commits this session (CamLink-SDK)
- `1a5c521` newest-menu-generation instructions (R1/R5 II/R6 III)
- `a75b72a` R6 III 0xc1b6 event support + RAW thumbnail previews
- `6cabf7b` session grid RAW sidecar previews + JPEG advisory banner
- `f0de6b6` CLAUDE.md (vault-grounded agent instructions)

## Still open (carried on [[roadmap]])
- Router brand/ISP behind [[home-network-filter]] — ask Chris
- Which SetRemoteMode value the R6 III accepted — check next R6 III run
- Schedule the maintenance loops (nightly compile, weekly lint + synthesis)
