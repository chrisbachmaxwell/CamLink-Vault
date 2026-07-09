# Remote shutter & degraded mode (SetRemoteMode 0x2002)

## The behavior
Some bodies (field: [[canon-eos-r10]], persistently) answer
`SetRemoteMode (0x9114) → 0x2002 GeneralError` right after pairing —
gphoto2 has the same unresolved reports. Without remote mode the camera
refuses `RemoteRelease` (no app-triggered shutter) but **capture events
from the physical shutter still flow** once `SetEventMode` succeeds.

## Our strategy (eos-init.ts)
1. Settle 500 ms after session open (camera UI is still transitioning).
2. Retry SetRemoteMode(1) 5× @1 s on GeneralError/DeviceBusy.
3. Fall back to **SetRemoteMode(0x15)** — gphoto2 lore: EOS M family and
   some newer entry bodies over Wi-Fi accept only 0x15.
4. Try mode order swap (event mode first) — some firmware prefers it.
5. If event mode works but remote never does → **run degraded**:
   `canTriggerCapture = false`, UI says "use the physical shutter",
   everything else works. Throw ONLY if event mode is unattainable.
6. Post-connect background recovery: retry every 10 s (~3 min), alternating
   1 and 0x15; upgrade live when accepted
   (`[canon-ptp] remote shutter recovered` in the log).

## Why degrade instead of fail
The clinic workflow is photographer-with-camera-in-hand; the physical
shutter IS the product. The app button is a convenience. (Decision
2026-07-08, [[decisions]].)
