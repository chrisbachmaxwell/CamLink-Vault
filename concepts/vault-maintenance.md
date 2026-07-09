# Vault maintenance loops

A vault that only grows when someone remembers to feed it dies in three
weeks. These loops run on schedule, not on memory. (Format per the
"keep it alive with loops" article, adapted to this project.)

## After every session (hook)
When a CamLink work session ends, the agent writes ONE dated note to
`log/YYYY-MM-DD-<slug>.md`: decisions made, mistakes caught, patterns
confirmed, commits pushed. Then updates [[project-status]] / [[roadmap]] /
any touched entity page. In Claude Code this is a Stop/SessionEnd hook; until
that's configured, end every session with: "update the vault per its CLAUDE.md."

## Nightly (cheap model)
Compile pass: read new `log/` and `raw/` material since last run, fold it
into the wiki pages. Routine work → routine tier (Haiku-class). Never the
premium model.

## Weekly (cheap model) — lint
Hunt contradictions, duplicate pages, dead links, expired
`(verify after: ...)` claims. Merge duplicates, delete falsehoods, list
anything needing human/field verification in the weekly note.

## Weekly (premium model) — synthesis
The ONE premium pass: read across the whole vault, write
`log/YYYY-Www-synthesis.md` — what changed this week, what's drifting,
what deserves attention next. This is where "we've validated 2 Canon bodies
but zero Windows machines" type insights surface.

## Research sweeps (when needed, not scheduled yet)
For questions like "what are tethering apps doing about USB-C on iPad":
fan out sub-questions → search practitioner layer + docs → every finding a
receipt (claim, link, date) → a SKEPTIC agent attacks each claim → survivors
land as dated pages with expiry. Fresh-context skeptics, never the
researcher reviewing itself.

## Sync rule
Git only. Commit at checkpoints. NEVER let iCloud/Dropbox sync the vault
folder an agent writes to — conflicted copies scramble the graph.
