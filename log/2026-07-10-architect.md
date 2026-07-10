# 2026-07-10 — architect check-in: no new work; stale branches identified

Chris asked for status. Pulled both repos: SDK mainline still at `1732eac`
(reconnect merge), vault main at `3f920ff` (UX feedback translation).
**Phase B ([[2026-07-visit-compare-ui]]) has not started — no worker ran.**

## Stale branches (do NOT merge, do not chase)
Repo sweep found two leftover branches from earlier agent sessions:
- SDK `claude/connection-type-detection-ui-p8uvk1` — dated 2026-07-04,
  branched pre-vault (base `34dfd53`). An unscheduled "wireless vs
  tethered" header-chip experiment + an early fix for the same flaky
  order assertion mainline later fixed properly (`db01c8d`). No goal
  page ever covered it. If the chip idea is ever wanted, it needs a goal
  page and a fresh implementation on current mainline.
- SDK+vault `claude/staged-vault-update-exxodq` — 2026-07-09 19:20, a
  parallel session applying the staged vault update + flaky-test fixes.
  Everything in it happened independently on mainline the same day
  (vault apply `eba94bb`, flake fixes `db01c8d`); vault side rewrites
  pages in a pre-Phase-A shape. Fully superseded.

Left both branches in place (deleting remote branches is Chris's call);
this note exists so no future agent mistakes them for pending work.

## Open items (unchanged)
- Worker: Phase B loop not yet started — prompt already drafted for Chris.
- Chris: reconnect R6 III drills ([[2026-07-camera-reconnect]]) and the
  Phase A real-office pass ([[2026-07-patient-records]]) both still open.

---

# Addendum: Chris's first reconnect drill — blocked at the network layer

Chris attempted the camera-hotspot connection; camera reached "pairing
with the computer in progress — start EOS Utility". App never connected.
Terminal evidence: reconnect watch running, but the ONLY SSDP searches
answered were from 192.168.15.200 (home mesh) — meaning the Mac was on
the HOME network while the camera waited on its own AP. Classic
[[macos-networking-traps]] auto-hop: macOS drops the internet-less camera
AP and rejoins home Wi-Fi within seconds. Not (yet) evidence against the
reconnect fix — the Mac wasn't on the camera's network for it to act.
Gave Chris: `ipconfig getifaddr en0` to see which network he's really
on, Auto-Join OFF on the home network during camera sessions, then
re-drill. If it still fails WITH the Mac verifiably on 192.168.1.x, that
becomes a real defect against [[2026-07-camera-reconnect]].

Product take-away queued on [[roadmap]]: the reconnect waiting banner
should self-diagnose the wrong-network case ("this computer is on
<home network>; the camera is broadcasting EOS-XXXX — rejoin it") by
reusing the wizard's 📻 interface checks. The app must name this trap
itself instead of an architect reading SSDP lines.
