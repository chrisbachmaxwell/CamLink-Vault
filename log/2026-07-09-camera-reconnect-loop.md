# 2026-07-09 — camera reconnect loop (worker)

Active goal [[2026-07-camera-reconnect]] (Status: IN PROGRESS — architect
flips DONE after re-review). Field defect from Chris's R6 III power-cycle
test; jumps Phase B.

## RCA verified against code
1. UI `reconnect()` polls `/api/connect` every 5 s — but Canon on its own AP
   only opens 15740 after SSDP is answered.
2. Announcer already refreshed membership every 15 s, but had no injectable
   lister / change detection — Mac hop onto camera AP was the field gap.
3. `cameraFound` is wizard-only (`if (configured …) return`) — configured
   reconnect must be server-side.

## Cycles (SDK branch `cursor/camera-reconnect-de7f`)
1. `abe0a12` — announcer `listInterfaces` + `refreshMemberships()` on
   interface-set change; unit test drives the hop; GUID unchanged.
2. `b6baf35` — server reconnect watch (2 s probe); integration test
   external PtpIpSimulator stop/restart within 30 s, no `/api/connect`.
3. `0707d63` — prefer recent SSDP-search IP; persist new host; test moves
   sim to 127.0.0.2 + injected M-SEARCH.
4. `33962aa` — mid-session power cycle → same visit folder + manifest.
5. `f07dbb6` — plain-language WAITING_FOR_CAMERA banner; vitest helpers.
6.  — hard-rule guard script; vault clinic-app + roadmap;
   all Done-when agent-verifiable boxes checked. Status stays IN PROGRESS.

## Scope guard held
No live-session handoff, pairing GUID persistence, or Canon adapter
event/tracer / GetObjectInfo changes. No Phase B. No new dependencies.
adapter-canon* diff limited to announcer + simulator bind-host + re-exports.

## Waiting on Chris
Real R6 III power-cycle pass (commands on the goal page).
