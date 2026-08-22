# In-app updates — the corner chip

Chris (2026-08-21/22): no Terminal for starting OR updating; checks must
be automatic. Shipped v0.8.0–v0.9.1.

## How it works (dev-repo form of auto-update)
- Check = `git fetch` + commits-behind count. Automatic shortly after
  boot and at **6:00 AM local daily**; offline mornings stay silent.
- The **bottom-left status chip** is the whole UI ("like claude and
  codex" — Chris): quiet `Med Photo · vX.Y.Z` at rest (click = check),
  blue **"Update ready — click to install"** when behind, live progress
  while applying. Menu → Check for updates is the second door.
- Apply = pull → npm install → build, refused while any visit is active;
  under launchd (MEDPHOTO_SUPERVISED=1 from the installer wrapper) the
  process exits non-zero and launchd relaunches the new build; the page
  reloads itself onto the new version.

## Field failures survived (both reproduced, both tested)
- **spawn npm ENOENT**: launchd starts the server with a bare PATH; the
  updater builds its own PATH starting from the running node binary's
  dir (npm lives beside node).
- **package-lock.json rewritten by a different npm** blocked `git pull`
  forever: the repo's lockfile is canonical — restored before pull and
  after install, every update starts and ends with a clean tree.

Auto-INSTALL (6 AM, only when idle) deliberately not enabled — offered,
awaiting Chris. Electron auto-update replaces all of this at
distribution time ([[roadmap]]).
