# 2026-08-21/22 — the Med Photo field marathon

The single biggest session of the project: CamLink became Med Photo,
gained two transports, three connectivity tiers, multi-room, a safety
guard, honest presence, a Mac app, and self-updates — all driven by
Chris field-testing live and reporting friction in real time. Clinic app
v0.4.x → **v0.9.2**. Branch `claude/camera-sdk-adapter-pattern-4pj5r8`.

## Shipped (each with gates green before push)
1. **Rename** CamLink → Med Photo (packages `@medphoto/*`, config
   migration, UI). [[decisions]]
2. **FTP push transport** after PhotoNodes research — embedded zero-dep
   FTP server; R6 III field-proven. [[ftp-push-transfer]]
3. **Meraki office network** identified blocking local FTP →
   **three-tier connectivity**; Cloud Relay deployed to Railway
   (single-port demux). [[three-tier-connectivity]], [[med-photo-relay]]
4. **Relay UX**: password in the values card (it was withheld —
   stranded setup), zero-typing built-in provisioning, "use a different
   relay" as the advanced path.
5. **Multi-room**: login = room, named at add-time, hot-add on the live
   listener (no idle requirement), shared patient library, room strip,
   per-room pages. [[2026-09-multi-room]]
6. **Earlier-photo guard** + adoption bootstrap for wrong camera clocks
   (Chris's R6 III clock is hours off). [[earlier-photo-guard]]
7. **App flow overhaul** from Chris's screenshots: header menu, brand =
   Home, wizard escape hatches, NON-destructive Change camera (the old
   one wiped config on click — also wiped his relay setup), home
   redesign (Start a visit / Today / Patients — built by two subagents
   against a written map), Camera setup page, room-turnover banner with
   real actions. Flow rules now doctrine. [[design-doctrine]]
8. **Honest presence** + disconnect watcher + alerts. [[camera-presence]]
9. **Mac app installer** (icon, Spotlight, launchd, app-mode window) and
   **in-app updates** (corner chip, 6 AM checks); survived two field
   failures (bare launchd PATH; rewritten lockfile). [[in-app-updates]]
10. **FTP conversation tracer** for new-camera debugging; PORT/EPRT
    answered with the passive-mode fix in words.

## Mistakes caught (fed back into doctrine/tests)
- Suggestions dropdown covered the form's buttons (only Enter worked) →
  in-flow suggestions + strict click-path gate.
- "Change camera" wiped the saved setup instantly → nothing destructive
  on first click.
- App window has no browser Back → every screen needs a path Home.
- Green pill with the camera off → green means evidence.
- Guard held a live photo (wrong clock) and could never learn → human
  adoption teaches the offset.
- Gate races (async renders read too early) — wait for content, not
  visibility.
- pkill -f patterns matching our own shell — twice. Use port-based kills.

## Open at session end
- R5 Mark II FTP dialect ([[2026-08-r5ii-ftp-dialect]]) — ACTIVE, tracer
  deployed, awaiting Chris's passive-ON retry.
- Multi-room second-body field test; R6 III clock set; Railway project
  token deletion (Chris).

## For hands-on testing (Chris)
Everything lands via the corner chip now. The current loop: R5 II
passive ON → one shot → report; camera off/on to see presence flip.
