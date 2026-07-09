# HIPAA & local-first (the constraint that shapes the product)

Chris's directive (2026-07-09): "HIPAA is a big deal so making it local and
staying on the local network is important." This page is the technical
translation. **Not legal advice** — the app ships safeguards; the practice
(a covered entity) still owns policies, training, and risk analysis. A
compliance advisor must review before any real-patient pilot.

## What counts as PHI here
Patient names, DOB, notes, and the photos themselves (faces/dentition are
biometric identifiers). The whole `captures/` tree is a PHI store — treat
it that way in every feature.

## Architecture stance (why we're well-positioned)
CamLink is local-first BY DESIGN: camera → computer over the LAN (PTP/IP)
→ local folders. No cloud component exists; nothing phones home. The moat
is keeping it provable: an automated no-cloud check belongs in CI
([[2026-07-clinic-lockdown]]).

## Technical safeguards ladder
1. Bind the app to localhost by default; LAN mode only behind auth.
2. Front-desk PIN + idle auto-lock (access control).
3. Append-only audit log (accountability).
4. Encryption at rest: FileVault baseline now; app-level encrypted store
   later (never hand-rolled crypto).
5. Backups to office NAS only; NEVER consumer cloud sync (iCloud/Dropbox
   on `captures/` is both a sync hazard and a BAA problem).
6. Deletion = move to local `.trash/` + audit entry (no silent hard-delete
   of PHI), retention per practice policy.

## Red lines for every future feature/agent
- No PHI in logs, commits, or the vault (camera serials fine; patient
  names/photos never).
- No third-party service touches `captures/` without a BAA decision by
  Chris + advisor.
- Remote access features (if ever) are a separate, explicit project — not
  a convenience add.
