# Decisions log

Dated, newest first. One line of context each; details live in linked pages.

- 2026-07-09 — **Vault lives on GitHub, checkpoints are manual.** Private
  repo `chrisbachmaxwell/CamLink-Vault`, local at `~/CamLink-Vault`, pushed
  with explicit `git push` (single sync system; Obsidian Git plugin optional
  later). SDK repo CLAUDE.md points every agent session at it.
- 2026-07-09 — **RAW handled, JPEG recommended.** CR3 files store fine; grid
  shows embedded-JPEG sidecars; clinics are advised JPEG Large/Fine.
- 2026-07-09 — **Support the R6 Mark III's 0xc1b6 event** by decoding the
  field hex dump rather than waiting for documentation. [[eos-event-records]]
- 2026-07-08 — **Events are layout-proof by design**: read only the object id
  from capture events, fetch truth via GetObjectInfo. This absorbed a brand-new
  camera generation with a 3-line change. [[eos-event-records]]
- 2026-07-08 — **Never disconnect-reconnect a Canon**: diagnostics hand their
  live session to the connection ([[session-handoff]]). Canon bodies treat
  check-then-redial as an error and restart their Wi-Fi AP.
- 2026-07-08 — **Degrade, don't fail** on SetRemoteMode 0x2002: physical
  shutter is the core clinic workflow; remote trigger is a nicety. Background
  retry (incl. 0x15) upgrades when possible. [[remote-shutter-degraded-mode]]
- 2026-07-07 — **The app diagnoses its own listening path** (self-test probes,
  port-contention detection, IP display) — field debugging with a
  non-technical operator requires the app to name the broken layer itself.
- 2026-07-07 — **UI never caches**: `no-store` on all static files + visible
  version number. A stale browser cache burned a full debugging round.
- 2026-07-06 — **User picks the connection type.** Chris: "remove all that
  information I should pick what type of connection I am making." Wizard is
  three tiles; CCAPI demoted to an Advanced link.
- 2026-07-06 — **Announce from boot, forever.** The camera searches BEFORE
  connecting and gives up if unanswered ("connection target not found").
  [[eos-utility-pairing]]
- 2026-07-05 — **PTP/IP is the primary path** ("the Tether Tools solution"):
  activation-free, works on every EOS body's "Remote control (EOS Utility)"
  mode. CCAPI (needs one-time USB activation) parked as Advanced.
  USB tether agreed as the follow-up transport. [[ptp-ip-protocol]]
- 2026-07 (project start) — **Adapter pattern, mock-first, monorepo**
  (original spec): consumer code never touches vendor SDKs; MockCameraAdapter
  ships before any vendor adapter; milestones M0–M6. [[adapter-pattern]]
