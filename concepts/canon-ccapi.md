# Canon CCAPI (the parked alternative)

Canon's official HTTP API (port 8080): documented, stable, JSON. Fully
implemented in `packages/adapter-canon` + simulator + diagnostics, but
**demoted to "Advanced"** in the clinic wizard because:

- Requires **one-time activation per camera body**: free Canon developer
  account → download "CCAPI Activation Tool" → USB cable → activate.
  ~5 minutes, permanent, but far too much friction for a clinic — and the
  camera menu doesn't even show "Camera Control API" until it's done
  (Chris's R10 only showed "Remote control (EOS Utility)" out of the box,
  which is what triggered the pivot to [[ptp-ip-protocol]], 2026-07-05).
- One remote app at a time: Canon Camera Connect / EOS Utility must be
  closed or the camera refuses.

Full activation walkthrough lives in the clinic app's Advanced section and
`docs/HARDWARE-TESTING.md`. Keep the adapter: it's the fallback if a body
ever misbehaves on PTP/IP, and its HTTP shape is easier to debug.

Open decision ([[roadmap]]): keep in wizard as Advanced vs. remove.
