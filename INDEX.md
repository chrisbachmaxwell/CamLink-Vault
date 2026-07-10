# CamLink Vault — INDEX

The map of everything known about the CamLink project. Agents: start here,
follow links, open only what the trail points at. Never sweep whole folders.

## What CamLink is
One sentence: a camera-connectivity platform — cameras connect over Wi-Fi
(USB planned), and as the photographer shoots, photos file themselves into
per-patient folders in apps built on the SDK. First market: clinics
(orthodontists, plastic surgeons, med spas, dermatologists).

- [[camlink-sdk]] — the product: architecture, repo layout, current status
- [[clinic-app]] — the reference app clinics actually use
- [[project-status]] — WHAT IS DONE (read this first for state)
- [[roadmap]] — WHAT IS LEFT (read this first for next steps)
- [[decisions]] — dated log of every decision that shaped the build

## Hardware validated
- [[canon-eos-r10]] — entry body; quirks: SetRemoteMode 0x2002, degraded mode
- [[canon-eos-r6-mark-iii]] — 2025 body; new menus, new event record 0xc1b6, CR3

## Protocol knowledge (the moat — none of this is in official docs)
- [[ptp-ip-protocol]] — the activation-free transport CamLink speaks
- [[eos-utility-pairing]] — the UPnP/SSDP discovery dance (the hard part)
- [[eos-event-records]] — the four object-added dialects + the invariant
- [[session-handoff]] — why you must NEVER disconnect-reconnect a Canon
- [[remote-shutter-degraded-mode]] — 0x2002, the 0x15 fallback, recovery loop
- [[canon-ccapi]] — the parked alternative (needs one-time activation)
- [[adapter-pattern]] — the architecture rule that makes new cameras cheap

## Environment traps (cost days; check BEFORE debugging "camera not found")
- [[macos-networking-traps]] — Spotify on UDP 1900, Local Network permission,
  firewall, Wi-Fi auto-hop. THE checklist for silent discovery failures.
- [[home-network-filter]] — Chris's router blocks device-to-device traffic
- [[test-environment]] — Chris's MacBook: macOS 26.5.1, Node 24, Terminal

## Goals (active work loops)
- [[goals/README]] — loop protocol (Done when / Waiting on Chris / Stop)
- [[2026-07-patient-records]] — Phase A: local patient index & visits (DONE)
- [[2026-07-camera-reconnect]] — power-cycle reconnect field defect (DONE;
  Chris's R6 III drills open)
- [[2026-07-visit-compare-ui]] — Phase B: patient page & visit compare (CURRENT)
- [[2026-07-wizard-simplify]] — one-prompt-at-a-time wizard UX (after B)
- [[2026-07-clinic-lockdown]] — Phase C: localhost, PIN, audit, no-cloud CI
- Constraint for all product work: [[hipaa-local-first]]

## Chronicle
- [[log/2026-07-09-backfill]] — the full field-debugging saga, ordered, with
  every dead end and what each one taught us
- [[log/2026-07-09-vault-created]] — vault published and wired into SDK
- [[log/2026-07-09-patient-records-loop]] — Phase A patient records & visits
- [[log/2026-07-09-camera-reconnect-loop]] — power-cycle reconnect field
  defect loop (cycles 1–6); Status IN PROGRESS pending architect + Chris
- [[log/2026-07-09-architect]] — Phase A review (NOT DONE: flaky gate +
  traversal defect) then re-review (fixes verified → DONE; Phase B
  pre-flighted)
- [[log/2026-07-09-architect-fixes]] — worker's fix session for the three
  architect-required items
- [[log/2026-07-10-architect]] — check-in: Phase B not started; two stale
  branches identified (do not merge)
- [[log/2026-07-09-architect-fixes]] — worker landed the three required
  fixes; awaiting architect re-review

## Operations
- [[vault-maintenance]] — the loops that keep this vault alive
- [[agent-onboarding]] — paste-ready instructions for future agents/projects

## Rules (also in CLAUDE.md)
1. One lesson per file. 2. Update, don't duplicate. 3. Delete what's wrong.
4. Never touch `raw/`.
