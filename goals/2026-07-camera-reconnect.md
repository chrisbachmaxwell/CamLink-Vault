# Goal: Camera power-cycle reconnect (field defect — jumps the queue)

Status: IN PROGRESS · Created: 2026-07-09 (from Chris's hands-on R6 III test)
· Owner: work loop
Constraint: LOCAL ONLY ([[hipaa-local-first]]). Hard rules apply, esp.
session-handoff and announcer-from-boot ([[session-handoff]], AGENTS.md).

## Why (Chris, 2026-07-09, camera-hotspot mode)
Camera powered off → app says "camera disconnected" (correct). Camera
back on → Chris picks CamLink on the camera → camera broadcasts its AP →
Mac rejoins it → **nothing happens**, forever. His words: "it should be
really easy to reconnect and it isn't."

Terminal evidence: after rejoining the camera's AP there are NO
"announce: answered a device search" lines from the camera's subnet
(192.168.1.x) — only home-mesh chatter from 192.168.15.200. The four
unhandled-event lines (0xc1f6/0xc18a/0xc18b/0xc185) are documented
known-harmless chatter ([[eos-event-records]]) from power-off — not a lead.

## Root-cause analysis (architect; loop verifies, may refine)
Three mechanisms exist and the scenario falls between them:
1. UI `reconnect()` polls `/api/connect` every 5 s after `disconnected` —
   but a Canon on its own AP only opens PTP port 15740 AFTER its SSDP
   search is answered. If the announcer doesn't hear the search, the
   camera shows "connection target not found", never opens the port, and
   the poll loop fails forever.
2. The announcer joins multicast at boot on whatever interfaces exist
   THEN. When the Mac hops onto the camera's AP (a different interface
   state), membership is not re-established → the camera's M-SEARCH is
   never heard. (Matches known debt: "announcer port-contention detection
   is boot-time only".)
3. `cameraFound` auto-connect is wizard-only by design
   (`if (configured …) return` in app.js) — a configured-but-disconnected
   app deliberately ignores the one signal that says "camera is back".

## Design sketch (loop may refine, not expand scope)
- **Announcer network-change resilience**: re-enumerate interfaces and
  re-join the SSDP multicast group when the interface set changes (poll
  `os.networkInterfaces()` on the existing 60 s self-test cadence, or
  rebind on self-test failure). The announcer keeps running from boot and
  the GUID NEVER changes — this strengthens the hard rule, not bends it.
- **Server-side reconnect watcher** (must not depend on a browser tab
  being open): when configured (ptp mode) and disconnected, watch SSDP
  searches AND probe the saved host's port on an interval; when the port
  opens, re-run the connect path with the persisted GUID and broadcast
  the reconnected state. If a search comes from a DIFFERENT IP than the
  saved host (camera DHCP moved), try that IP too and persist it on
  success.
- **Plain-language waiting state** in the UI (Chris never reads logs):
  replace "Reconnect failed: no cameras found — retrying in 5 s…" with
  "Camera is off or not reachable — turn it on and choose CamLink
  Clinic on the camera. Reconnecting automatically." Flip to connected
  with no clicks when the server reconnects.
- **Session survival**: `connectCamera()` already re-attaches an active
  session (`session.attach(connection)`) — cover it with a test so photos
  taken after a mid-session power cycle land in the same visit folder.
- NOT in scope: the live-session handoff contract, pairing GUID
  persistence, Canon adapter event/tracer behavior, same-Wi-Fi mode
  testing (blocked on router), USB tether.

## Done when (agent-verifiable)
- [x] Announcer re-joins multicast when the interface set changes; unit
      test drives the interface-change path (injectable interface lister)
      and asserts re-join without GUID change or announcer restart
- [x] Server auto-reconnects without any browser tab: integration test
      starts the app against the ptp-simulator, kills the simulator
      (app broadcasts disconnected), restarts the simulator, asserts the
      app reconnects by itself within 30 s (SSE `camera` event + API
      state), no wizard/API nudge
- [x] Reconnect works when the camera comes back on a different address:
      test moves the simulator to a new port/host between cycles, a
      search event carries the new address, app reconnects and persists it
- [x] Mid-session power cycle: photos captured after reconnect file into
      the SAME active visit folder with manifest intact (test)
- [ ] UI shows the plain-language waiting state while disconnected and
      clears it on reconnect (logic/jsdom test, no new browser-automation
      deps)
- [ ] Hard-rule regression guard: diff over packages/adapter-canon* shows
      no changes to session-handoff, tracer, or GetObjectInfo behavior
      (announcer interface-refresh in adapter-canon-ptp is allowed and
      expected)
- [ ] All three gates green; pushed
- [ ] Vault updated: [[clinic-app]] reconnect behavior, [[roadmap]] debt
      line about boot-time-only announcer removed

## Waiting on Chris (not loopable)
- [ ] Real power-cycle pass with the R6 III on camera-hotspot mode.
      To run it:
      ```
      cd ~/CamLink-SDK
      git pull
      npm install
      npm run build
      npm start -w @camlink/clinic-app
      ```
      Open http://localhost:3333 in Chrome, connect the camera through
      the wizard as usual. Then, three drills:
      1. Turn the camera OFF, wait for "camera disconnected", turn it
         back ON, pick CamLink on the camera, rejoin its Wi-Fi on the
         Mac. Expect: app reconnects by itself within ~30 s of the Mac
         rejoining — no clicks.
      2. Same, but during an active visit: start a visit, power-cycle,
         reconnect, shoot 2 more photos. Expect: they appear in the SAME
         visit.
      3. If it ever sits longer than a minute, copy the LAST 10 Terminal
         lines and send them — especially whether any
         "announce: answered a device search from 192.168.1.x" line
         appeared after rejoining.

## Stop clause
Max 10 cycles, or 2 consecutive cycles with no new checked box → BLOCKED
+ log why. Scope guard: no changes to live-session handoff or pairing
GUID persistence; no same-Wi-Fi work; no new dependencies.

## Iteration log
(loop appends: date · what changed · commit hash)
- 2026-07-09 · cycle 1: verified RCA (UI reconnect polls `/api/connect`;
  `cameraFound` wizard-only; no server reconnect watcher). Announcer already
  refreshed membership every 15 s but had no injectable lister / change
  detection — added `listInterfaces` option, `refreshMemberships()` that
  re-joins on interface-set change without GUID change or restart, unit
  test drives the hop. Gates green. · abe0a12
- 2026-07-09 · cycle 2: server reconnect watch (2 s probe of saved host + SSDP-search IPs; reconnects + persists without browser tab). Integration test drives external PtpIpSimulator stop/restart. · b6baf35
- 2026-07-09 · cycle 3: different-address reconnect — watch prefers recent SSDP-search IP, persists new host on success; test moves sim to 127.0.0.2 + injected M-SEARCH. · 0707d63
- 2026-07-09 · cycle 4: mid-session power cycle — post-reconnect photos land in the same visit folder with intact manifest (session.attach on reconnect). · 33962aa
