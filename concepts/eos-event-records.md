# EOS event records (capture notifications)

How a Canon tells us a photo exists: we poll `GetEvent` (0x9116) every
300 ms; the response is a blob of records `u32 size | u32 type | payload`.

## The four object-added dialects (all field-encountered)
| Type | Code | Seen on | Layout notes |
|---|---|---|---|
| ObjectAddedEx | 0xc181 | classic bodies | libgphoto2-validated: oid@+8, storage@+0xc, parent@+0x10, format **u16**@+0x14, size u32@+0x1c, name cstring@+0x20 |
| ObjectAddedEx64 | 0xc1a7 | newer R-series | 64-bit size variant |
| RequestObjectTransfer(64) | 0xc186 / 0xc1a8 | save-to-host configs | camera asks host to fetch |
| **ObjectAddedEx3** | **0xc1b6** | **R6 Mark III (2025 gen)** | decoded by US from a field hex dump (2026-07-09): oid@0, storage@4, format u32@8, u64 size@20, parent@28, unix time@36, PTP-string name@40 — in NO public documentation |

## THE INVARIANT (why CamLink absorbs new cameras cheaply)
**The object id is at payload offset 0 in every variant.** The adapter reads
ONLY that, then asks `GetObjectInfo` for authoritative name/format/size.
Never hand-decode event payloads for metadata — that's how the first R10
attempt silently dropped every photo (our layout was wrong AND the doc-based
code for it was wrong in two ways).

## The tracer (keep forever)
Unknown event types are hex-logged once per type per connection:
`[canon-ptp] unhandled EOS event 0x____ (NB) payload: <hex>`.
This one log line cracked both cameras. When a user says "camera did X and
nothing happened," ask for these lines FIRST.

## Known chatter (harmless, do not chase)
0xc18a AvailListChanged · 0xc18b CameraStatusChanged · 0xc185
StorageInfoChanged · 0xc1f6 (unknown, 12 B, both bodies, benign) ·
0xc189 PropValueChanged (we parse battery 0xd111).
