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

# Addendum: Chris's first reconnect drill — blocked (cause under diagnosis)

Chris attempted the camera-hotspot connection; camera reached "pairing
with the computer in progress — start EOS Utility". App never connected;
no "answered a device search" from 192.168.1.x ever appeared.

CORRECTION (same evening): my first read blamed the
[[macos-networking-traps]] auto-hop because the terminal kept answering
192.168.15.200 (home mesh). But the app's announce lines carry NO
timestamps — those answers may all predate the Wi-Fi switch. Chris
states Auto-Join was OFF and the Mac stayed on the camera's Wi-Fi.
Withdrawn as the conclusion; auto-hop remains just one hypothesis.
(Lesson for the app AND future logs: timestamps on announce lines would
have settled this instantly — added to the fix list.)

Open hypotheses, in structured-diagnosis order (commands sent to Chris):
1. Camera port 15740 closed until its SSDP search is answered, and the
   announcer — despite cycle-1's interface re-join — still doesn't hear
   M-SEARCH on the camera AP on REAL macOS (unit test used injected
   interfaces; field macOS multicast delivery is the untested layer).
2. macOS Local Network permission reset (blocks both SSDP and TCP probes
   silently; "No route to host" signature).
3. Saved host in camlink-clinic.json differs from the camera's current
   address, and no SSDP search is heard to supply the fresh IP (ties
   back to 1).
Evidence requested: `ipconfig getifaddr en0`, `ping -c 3 192.168.1.2`,
`nc -vz -G 3 192.168.1.2 15740`, saved-config host value, and whether
any 192.168.1.x announce line appears while on the camera's Wi-Fi.

Product take-away queued on [[roadmap]]: the reconnect waiting banner
should self-diagnose the wrong-network case ("this computer is on
<home network>; the camera is broadcasting EOS-XXXX — rejoin it") by
reusing the wizard's 📻 interface checks. The app must name this trap
itself instead of an architect reading SSDP lines.
