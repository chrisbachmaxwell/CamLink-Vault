# Med Photo Vault — INDEX

The map of everything known about **Med Photo** (formerly CamLink;
renamed 2026-08-21). Agents: start here, follow links, open only what
the trail points at. Never sweep whole folders.

## What Med Photo is
One sentence: the easiest software to store patient photos — a camera uploads
as the photographer shoots, and every authorized computer sees the same
cloud-authoritative patient/visit library. FTPS internet ingest is the primary
R6 Mark II direction; local adapters remain for camera protocols that need
them. First market: clinics (orthodontists, plastic surgeons, med spas,
dermatologists).

## Task router — open ONLY what your task needs
| Your task touches… | Read first | Then |
| --- | --- | --- |
| Anything (always) | [[project-status]], [[roadmap]] | the row below |
| A camera not connecting/transferring | [[macos-networking-traps]], [[camera-presence]] | the camera's entity page; [[home-network-filter]] |
| Adding/onboarding a camera | [[camera-catalog]] | the camera's entity page |
| The FTP/auto-send path | [[ftp-push-transfer]] | [[2026-09-multi-room]], repo docs/HARDWARE-TESTING.md |
| The Cloud Relay | [[med-photo-relay]] | [[three-tier-connectivity]], [[hipaa-local-first]] |
| PTP/IP (EOS Utility mode) | [[ptp-ip-protocol]] | [[eos-utility-pairing]], [[eos-event-records]], [[session-handoff]] |
| UI / screens / flows | [[design-doctrine]] | repo docs/DESIGN.md (they mirror) |
| Photos filing to wrong/missing patients | [[earlier-photo-guard]] | — |
| Updates / install / Mac app | [[in-app-updates]] | repo apps/clinic/scripts/install-mac-app.mjs |
| Picking up work | [[goals/README]] | the CURRENT goal it names |
| Compliance / patient data / cloud library | [[hipaa-local-first]] | [[cloud-authoritative-library]], repo docs/CLOUD-CLINICAL-DATA-PLANE.md |
| Logins / roles / review seat | [[multi-user-model]] | [[2026-09-logins-and-roles]] |
| Multiple agents / branches / merging | [[multi-agent-delivery]] | [[agent-onboarding]], repo docs/MULTI-AGENT-WORKFLOW.md |

## The product
- [[camlink-sdk]] — architecture, repo layout (repo rename pending)
- [[clinic-app]] — the reference app clinics actually use
- [[project-status]] — WHAT IS DONE (v0.9.2 as of 2026-08-22)
- [[roadmap]] — WHAT IS LEFT, in priority order
- [[decisions]] — dated log of every decision that shaped the build
- [[med-photo-relay]] — the live synthetic-only hosted relay (Railway)
- [[cloud-authoritative-library]] — the 2026-08-27 source-of-truth decision

## Hardware validated
- [[canon-eos-r10]] — entry body (PTP/IP; no FTP support)
- [[canon-eos-r6-mark-iii]] — proven on PTP/IP, LAN FTP, and relay;
  clock currently hours wrong (see [[earlier-photo-guard]])
- [[canon-eos-r5-mark-ii]] — OPEN: logs in, won't transfer
  ([[2026-08-r5ii-ftp-dialect]])

## Protocol & transport knowledge (the moat)
- [[adapter-pattern]] — the rule that makes new cameras cheap
- [[ptp-ip-protocol]] · [[eos-utility-pairing]] · [[eos-event-records]] ·
  [[session-handoff]] · [[remote-shutter-degraded-mode]] · [[canon-ccapi]]
- [[ftp-push-transfer]] — the camera-initiated transport (PhotoNodes
  approach): multi-login, hot-add, presence, tracer
- [[three-tier-connectivity]] — LAN · Med Photo Box · Cloud Relay
- [[camera-presence]] — green means evidence
- [[earlier-photo-guard]] — EXIF gate, clock learning, adoption
- [[in-app-updates]] — the corner chip

## Product doctrine
- [[design-doctrine]] — Apple-simple; screen map; the flow rules
- [[hipaa-local-first]] — the BAA/PHI/migration red lines
- [[cloud-authoritative-library]] — every app sees one central library

## Environment traps (check BEFORE debugging code)
- [[macos-networking-traps]] — Spotify on UDP 1900, Local Network
  permission, firewall, Wi-Fi auto-hop
- [[home-network-filter]] — Chris's router + the office **Meraki**
  (NAT-mode SSID isolation) block device-to-device traffic
- [[test-environment]] — Chris's MacBook: macOS 26.5.1, Node, Terminal

## Goals (active work loops — protocol in [[goals/README]])
- CURRENT (active loop): [[2026-08-cloud-clinical-library]] — FTPS/S3/
  PostgreSQL cloud library + multi-computer app
- [[2026-08-camera-onboarding]] — model-first connect flow
- [[2026-08-r5ii-ftp-dialect]] — BLOCKED on Chris's passive-ON retry;
  resumes the moment his trace lands
- [[2026-09-multi-room]] — BUILT; field second-body box open
- [[2026-08-simplicity-pass]] — largely shipped via the 2026-08-21 flow
  overhaul; check boxes against [[project-status]]
- [[2026-09-logins-and-roles]] — PROPOSED: multi-user design awaiting
  Chris (absorbs clinic-lockdown)
- [[2026-07-clinic-lockdown]] — Phase C, queued (being absorbed above)
- DONE: [[2026-07-patient-records]] · [[2026-07-camera-reconnect]] ·
  [[2026-07-visit-compare-ui]] (shipped inside the 2026-08 redesign) ·
  [[2026-07-wizard-simplify]] (superseded by [[design-doctrine]])

## Chronicle (newest first)
- [[log/2026-09-01-visit-inactivity-reopen]] — source implementation for
  15-minute cloud visit auto-end, one-minute warning, patient-screen lock,
  same-visit reopen, and explicit recovery of photos received while ended
- [[log/2026-08-27-cloud-authoritative-library-pivot]] — retires end-user
  local library sharing; adds the synthetic cloud clinical domain and safe
  migration boundary
- [[log/2026-08-26-same-lan-multicomputer-v01811]] — v0.18.11 adds an
  owner-controlled same-LAN Capture Hub and authenticated browser Viewers for
  synthetic multicomputer workflow testing; one Hub retains the only library
- [[log/2026-08-26-mac-dmg-bootstrap-v01810]] — v0.18.10 adds a verified
  Finder DMG, separate Railway bootstrap route, and records the pre-JavaScript
  Gatekeeper boundary on the affected M1/Tahoe first-install path
- [[log/2026-08-26-mac-startup-recovery-v0189]] — v0.18.9 bounds Mac
  window startup, retries renderer failures, and makes silent Dock bouncing
  terminate in a visible native recovery path
- [[log/2026-08-26-finder-safe-mac-release]] — v0.18.8 removes AppleDouble
  ZIP entries, proves Finder-style extraction, and replaces the live download
- [[log/2026-08-26-mac-bootstrap-recovery]] — other-Mac quarantine
  reproduction; visible v0.18.7 startup recovery; durable Railway releases
- [[log/2026-08-21-med-photo-field-day]] — THE marathon: rename, FTP,
  relay, multi-room, guard, presence, Mac app, updates, R5 II opened
- [[log/2026-08-21-ftp-adapter-built]] — FTP research + build detail
- July logs: [[log/2026-07-10-architect]] · [[log/2026-07-09-architect]] ·
  [[log/2026-07-09-architect-fixes]] · [[log/2026-07-09-patient-records-loop]] ·
  [[log/2026-07-09-camera-reconnect-loop]] · [[log/2026-07-09-backfill]] ·
  [[log/2026-07-09-vault-created]]

## Operations
- [[vault-maintenance]] — the loops that keep this brain alive
- [[agent-onboarding]] — paste-ready instructions for future agents
- [[multi-agent-delivery]] — isolated worktrees, path ownership, PRs and one
  integration owner; `main` is the only merge truth
- Agent entry files: `CLAUDE.md` (Claude) · `AGENTS.md` (OpenAI/Codex/
  Cursor) · `GROK.md` (Grok) — mirrors, KEEP IN SYNC

## Rules (also in the agent entry files)
1. One lesson per file. 2. Update, don't duplicate. 3. Delete what's
wrong. 4. Never touch `raw/`. 5. Session end = log + status/roadmap +
feature PRs (the ritual). 6. Only the integration owner merges to `main`.
