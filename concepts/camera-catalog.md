# The camera catalog — per-model onboarding knowledge (2026-08-22)

Onboarding is MODEL-FIRST (Chris, 2026-08-22): the user picks their
camera model; the app already knows how to connect it. The catalog is
where that knowledge lives — one entry per model, encoding which
transport suits the body and that body's OWN menu path and traps.
Screen behavior: repo docs/DESIGN.md, "Connect a camera" ·
[[design-doctrine]].

## Where it lives
`apps/clinic/public/camera-catalog.js` in the code repo — plain JS
export, no build step, served to the browser. `catalogEntry(id)` looks
one up.

## Entry shape (verify after: 2027-02)
- `id` · `label` — stable slug + the dropdown text.
- `transport` — `'ftp'` (camera auto-sends; flow names the camera = its
  room, shows values), `'ptp'` (EOS Utility pairing wizard), `'choose'`
  (fall back to the transport chooser).
- `warning` — optional; rendered highlighted BEFORE the steps
  (e.g. the R5 II passive-mode trap).
- `note` — optional one-liner (e.g. "this body has no FTP").
- `steps` — that model's menu path, imperative, one action each, shown
  AFTER the values card.
- `testHelp` — optional model-specific help, collapsed below live connection status.
- `fieldProven` — true only when a real body ran the steps end-to-end.

## The rule
A field lesson about a body updates its catalog entry AND its vault
hardware page IN THE SAME SESSION — the catalog is what clinics see,
the hardware page is why. One model = one entry; update the day the
lesson lands (rule 2: update, don't duplicate).

2026-11-05 requirement: every model offered as supported needs complete,
manufacturer-sourced instructions in the order its screens appear. Include
network mode, server values, login/folder, automatic transfer, JPEG test and
error recovery. Record the manual and verification date; validate combined
families individually. Manual verification and successful hardware transfer
are distinct evidence. The current broad brand/family entries have not all
passed this audit. Do not claim that this catalog already meets the requirement.

The 0.20.5 guide implementation is merged in SDK PR 21 (`5d2583f` →
`a78ec71`); see [[log/2026-11-05-r6iii-live-setup]] for publication state.
`camera-setup-guide.js` builds nine tasks: open FTP, Wi-Fi, protocol,
server/port, passive/proxy, login, folder/save, automatic transfer and JPEG
test preparation. `walkthrough`, `ftpMenu`, `manualUrl`,
`autoTransferAdvice`, `jpegAdvice` and `powerSavingAdvice` carry model-specific
knowledge. `legacy` hides a combined entry from new choices while preserving
saved profile IDs. In-page progress never persists passwords in browser storage.

## Current entries (2026-11-05; verify after: 2027-02)
- Exact Canon FTP guides: R6 III (C022), R6 II (C012), R5 II (C017),
  original R6 (C004), original R5 (C003). Their catalog entries link the
  manufacturer's manual, checked 2026-11-05. Manual accuracy does not close
  hardware acceptance. Chris confirmed the R6 III 0.20.5 walkthrough worked
  on 2026-11-05, and the native app subsequently showed four photos in its
  active visit. R5 II transfer failure remains open.
- Legacy combined R6 / R6 II remains resolvable for saved records, hidden
  from new selection; no migration or credential rotation is performed.
- R5 / R5 C, Canon other, Sony Alpha, Nikon Z and Fujifilm X/GFX remain
  explicitly general family guides. Exact menu/accessory and per-model
  hardware audits remain open. Do not imply universal brand support.
- R10 remains PTP with prior hardware proof; R50 / R100 remains an unproven
  PTP family; Not sure / another camera opens transport choice.

Reported Canon Err45 routes to login and Err41 to server settings. The user
selects the observed error; the app does not infer it from quiet status.
Only a new completed photo from the exact selected camera passes the test.
Historical `fieldProven` flags do not prove the new guide's end-to-end usability.

2026-11-05 follow-up: `savedConnectionAdvice` carries the manufacturer-sourced
R6 III saved-profile edit route. Explicit login replacement uses that route
and retains the camera ID; general families use their manual without invented
menu labels. See [[log/2026-11-05-camera-login-recovery]].
