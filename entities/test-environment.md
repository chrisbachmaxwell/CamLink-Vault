# Test environment — Chris's setup

- MacBook Pro, macOS **26.5.1**, Node **v24.14.0**, zsh, runs the app from
  **Terminal.app** (`npm start -w @camlink/clinic-app`).
- Browser: Chrome. Spotify installed (see [[macos-networking-traps]]).
- Home network: `192.168.16.x` (Mac was .191, R10 got .110) with a
  device-to-device filter — see [[home-network-filter]]. A second subnet
  `192.168.15.x` exists (a device at 192.168.15.200 does SSDP searches);
  suggests a mesh/multi-AP setup. Router brand/ISP: **unknown — ask Chris**.
- Camera-hotspot network: camera at `192.168.1.2`, Mac gets `192.168.1.x`.
- macOS traps already fought and solved on this machine: Spotify on UDP 1900,
  Local Network permission for Terminal (fixed by reboot → popup → Allow),
  Wi-Fi auto-hop off no-internet networks (fix: Auto-Join OFF on home
  network during camera-hotspot sessions).
- Repo lives at `~/CamLink-SDK` (a.k.a. `/Users/chrismaxwell/CamLink-SDK`);
  vault at `~/CamLink-Vault`.
- Chris is non-technical: instructions must be exact commands + what to
  expect; the app should name problems itself (this shaped [[clinic-app]]'s
  diagnostics).

## Standard hands-on-test preamble (agents: copy this into every request)
Any "Waiting on Chris" test request MUST include this block verbatim
(plus test-specific steps and what he should expect to see). Rule added
2026-07-09 at Chris's request — see [[goals/README]].

```
cd ~/CamLink-SDK
git pull
npm install
npm run build
npm start -w @camlink/clinic-app
```

Then: open http://localhost:3333 in Chrome. Stop the app afterwards with
Ctrl+C in Terminal. Chris does NOT commit or push anything after testing —
he reports what he saw in plain words and the architect turns it into
goal-page items.
