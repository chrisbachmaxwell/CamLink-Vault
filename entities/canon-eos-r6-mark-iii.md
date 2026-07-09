# Canon EOS R6 Mark III (test body #2)

2025-generation body. Completed the full CamLink pipeline 2026-07-09.
File prefix on Chris's unit: `F91A` (e.g. `F91A0431.CR3`).

## Menu path (NEW menu generation — differs from R10!)
MENU → **Wireless features** → **Connect to EOS Utility** →
**Add a device to connect to**. Same protocol underneath; only menus moved.
Applies to the R1 / R5 Mark II / R6 Mark III generation.
(verify after: 2027-01 — Canon may reshuffle again)

## Quirks (field-verified 2026-07-09)
- **Emits object-added event 0xc1b6** ("ObjectAddedEx3") — a record absent
  from libgphoto2 and all documentation. Decoded from our tracer's hex dump:
  oid@0, storage@4, format(u32)@8, u64 size@20, parent@28, unix timestamp@36,
  PTP-string filename@40. Full dump in [[raw/2026-07-09-field-evidence]].
  The oid@0 invariant held → 3-line fix. [[eos-event-records]]
- Arrived set to **RAW (CR3), ~40 MB/shot** → slow transfers, no browser
  preview. Handled via embedded-JPEG thumb sidecars; recommend JPEG
  Large/Fine for clinic use.
- Same startup chatter as the R10 (0xc1f6/0xc18a/0xc18b/0xc185).
- Remote shutter: worked via session flow; if 0x2002 appears post-connect
  the background retry (1 ↔ 0x15) handles it.
  (Confirm which SetRemoteMode value this body accepted — not yet recorded.)
