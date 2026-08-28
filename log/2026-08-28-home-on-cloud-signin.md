# 2026-08-28 — Cloud sign-in lands on Home

## Field report and decision

A newly signed-in computer opened directly into whichever cloud visit was
already active. That silently opted the new computer into another person's
live screen.

Cloud sign-in now always lands on **Home**. Existing shared visits remain
visible under **In progress** with their patient, camera and photo count; the
person explicitly chooses **Open** before entering one. Local capture stations
retain their existing active-visit resume behavior.

The camera choice was also rechecked rather than changed:

- one available camera is selected automatically because there is no choice;
- two or more available cameras show **Which camera?** before the visit starts;
- the patient-page Start visit path also asks which camera when two or more are
  available.

## Code and verification

- SDK feature commit: `6d314bc`
- PR: `CamLink-SDK#11`
- `main` merge commit: `02c27d8`
- Desktop source version: **v0.19.9**
- Focused cloud boot regression proves the cloud branch reaches Home and cannot
  call `renderSession(mySession)` automatically.
- Root build and all workspace tests passed. PTP simulator, FTP, multi-room and
  full browser UI gates passed. The browser gate already proves both the Home
  camera chips and patient-page multi-camera question. GitHub CI passed on
  Node 20 and 22.

## Release boundary

The behavior is merged and pushed to code `main`. v0.19.9 has **not** been
packaged, signed, published, installed or field-proven. The currently
documented live signed release remains v0.19.7.
