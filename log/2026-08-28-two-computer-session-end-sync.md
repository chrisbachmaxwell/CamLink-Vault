# 2026-08-28 — Two-computer session-end synchronization

## Field report

Two signed-in computers were both viewing the same active cloud visit. When
one computer ended the visit, that computer closed its live screen but the
other computer kept showing the ended visit as active.

## Cause and decision

The computer that sent `POST /api/session/end` closed from its direct API
response. Other computers already refreshed the signed-in cloud camera/visit
projection every three seconds, but the visit-screen reconciliation handled
only the `still active` case. It updated photos and counts but did nothing when
the authoritative projection no longer contained an active visit.

The signed-in cloud projection remains the cross-computer source of truth. A
computer displaying a visit now does both halves of reconciliation:

- if the visit is still active, render its newest summary;
- if the same displayed visit is no longer active, close the stale live view.

No patient-bearing visit summary was added to the process-global SSE broadcast.
That avoids leaking one cloud tenant's visit data to another tenant; each app
continues to fetch only its own authenticated projection.

## Code and verification

- SDK feature commit: `dc80e66`
- PR: `CamLink-SDK#10`
- `main` merge commit: `1ab5602`
- Desktop source version: **v0.19.8**
- Regression coverage: cloud UI synchronization test now requires the ended-
  elsewhere path to call `renderEnded` for the exact visible camera visit.
- Fresh-current-main verification: root build green; all workspace tests green
  (Node local); PTP simulator, FTP and multi-room smokes green; browser UI gate
  green; GitHub CI green on Node 20 and 22.

## Release boundary

The fix is merged and pushed to code `main`. v0.19.8 has **not** been packaged,
signed, published, installed on the two field Macs or field-proven yet. The
currently documented live signed release remains v0.19.7. Do not describe this
code merge as a live app update.
