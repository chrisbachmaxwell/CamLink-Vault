# Design doctrine (Chris's directive, 2026-08-21)

Chris: "I want the app to be the best it can be… keep everything simple
like Apple. Always ask: do I really need this. The main goal is to be the
easiest software to store patient photos with instant connection from the
camera."

The full doctrine lives in the CODE repo at `docs/DESIGN.md` — that file
is law for every UI change; agents read it before touching the front end.
This page records the durable principles:

1. **The one sentence**: easiest software to store patient photos, with
   instant connection from the camera. Every feature is judged against it.
2. **One primary action per screen.** Home = "who is the patient?".
   Visit = "are the photos arriving?". Setup = "is the camera talking?".
3. **"Do I really need this?"** is asked about every element. Diagnostics
   and options exist but are folded; the happy path shows almost no text.
4. **Calm by default** — quiet when working; loud only when the user must
   act, and then one plain sentence with one action.
5. **The camera is ambient** — after setup, users forget it exists.
6. **Speed over ceremony** — three letters + Enter → shooting; undo beats
   "are you sure".
7. Hard boundaries: plain HTML/CSS/JS, no frameworks, nothing loaded from
   the network at runtime (HIPAA), all gates green including the browser
   UI gate.

Goal pages are written against this doctrine from now on: every UI goal's
"Done when" list must include "screen passes the one-primary-action test"
and "browser UI gate green".

## Camera setup refinement — 2026-09-05
Camera → Connect → Test photo. Add opens the model picker directly. Connection
instructions reveal Wi-Fi, server and login as separate tasks; names are
optional. Existing-camera inspection never rotates a password. Replacement is
explicit and confirmed. Back and Finish later preserve progress; only a new
completed upload from the selected camera passes verification. See the code
repo `docs/DESIGN.md` and [[log/2026-09-05-camera-setup-access-audit]].

2026-11-04 correction: cloud FTP can intentionally disconnect between photos.
Recent photo receipt, current sign-in, neutral waiting and unavailable status
are separate signals. Keep receipt time visible; never infer an unsent shot
from idle time. A new exact-camera photo is the delivery check; a ping only
tests reachability. The 0.20.5 walkthrough includes delayed-check help and Canon
FTP power-saving guidance. See [[log/2026-11-04-camera-between-photos]].

## Existing patient visits — 2026-09-05
An exact stable patient ID with an active visit offers **Open visit**, with
camera and photo-count context. Refresh the current projection before opening
or preparing a new visit. A same-patient conflict offers only Open; it must
not recommend ending/recreating that visit or overwrite its existing details.
Different stable IDs remain different patients even when their names match.
Explicit Open navigates to capture; background refresh preserves the page the
user chose. Changed/ended stale links explain what happened and never open a
replacement patient's visit. See [[log/2026-09-05-active-visit-recovery]].

## Start visit without paperwork (2026-11-04)
Start visit goes directly to capture when one camera is available; multiple
cameras ask only Which camera. Optional purpose, provider, procedure, body area
and photo phase belong under Visit details & notes during or after capture.
Never silently carry prior visit documentation into a new visit. Failures say
what to do next in plain language and never imply that blank optional fields
are the user's mistake. SDK PR 19 merged as `b86d56e`; arm64 0.20.3 is
published. See [[log/2026-11-04-visit-start-simplification]].

## Complete camera walkthrough — 2026-11-05
Chris paused the live setup to prioritize the app teaching the process.
One task per screen, values beside the action that needs them, Back and
in-page resume, model-specific manufacturer wording, automatic sending and
new-photo delivery proof are the standard. Provide “My camera looks different”
and reported-error recovery during setup and testing; preserve the profile
and credentials while reviewing a step. General family instructions must say
so. SDK PR 21 implements the sequence with five exact Canon manual guides;
Chris subsequently confirmed the R6 III guide worked perfectly, with four
photos visible in its active visit. Remaining model audits stay open. See
[[log/2026-11-05-r6iii-live-setup]].

## Recover the saved connection — 2026-11-05
Saved-profile Review settings must lead to actionable troubleshooting, not
back to an unchanged test prompt. A camera saved in Med Photo is not proof
that its physical login succeeded. Distinguish user-reported Err45 from
automatically observed evidence and explain that hiding a password does not
expire it. Preserve the camera and its photos; only explicit confirmed login
replacement invalidates its old login. Then guide editing the existing camera
profile. See [[log/2026-11-05-camera-login-recovery]].
