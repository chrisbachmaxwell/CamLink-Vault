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
