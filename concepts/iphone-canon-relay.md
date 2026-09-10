# Canon USB through iPhone, no persistent patient data

Chris's 2026-09-10 instruction: target all Canon cameras, use iPhone, and
save nothing patient-related on phones. This replaces the earlier conversational
proposal to buffer pending photos on the phone. It does not authorize a cloud
deployment or certify HIPAA compliance.

## Design boundary

Camera card → bounded iPhone RAM → authorized receiver. Patient data must not
be written to Photos, Files, temporary downloads, caches, offline queues,
backups, diagnostic attachments, or logs. Data necessarily traverses RAM;
neither Swift object release nor Apple's chunk API proves zero OS residue.
Stop transfer when the receiver/authorization/foreground session disappears.
Keep original photos on the camera; never auto-delete them.

Receipt-verified transfer is necessary: immutable receiver-side visit binding,
exact byte count and digest, durable commit, replay prevention and reconciliation
after ambiguous completion. Do not retarget old card photos to a new visit.

## Current implementation

`native/MedPhotoKit` contains `MemoryOnlyCameraRelay`, an ImageCaptureCore
chunk-reader primitive, and a synthetic `RelayVerification` executable. Reads
are bounded to 256 KiB requests with acknowledgement backpressure, incremental
SHA-256, exact receipt validation, sanitized errors and cancellation checks.
There is no phone persistence API, camera-delete method or deployed receiver.
The Apple reader compiles against this Mac's SDK; iOS remains unbuilt.

This is a foundation, not a complete Canon adapter or installable app. Broad
Canon discovery/capability detection is planned; no Med Photo iPhone camera is
field validated. Honcho's Canon matrix provides candidates only (EOS R, DSLR,
EOS M and selected PowerShot). Never advertise every Canon as supported.

## Remaining gates

Full Xcode/iOS toolchain, signed foreground app, native Canon adapter and event
handling, secure authorized receiver, lifecycle/timeouts, card-based recovery,
hardware/firmware matrix, and device/framework storage-residue audit. Complete
security and clinic operational review before real patient data. HHS requires
technical, administrative and physical safeguards; no-phone-storage alone is
not compliance.

Current task follows supplied local/LAN-only instructions. The separately
recorded cloud-authoritative project remains unchanged; no third-party photo
traffic was enabled here.

Reproduce synthetic core checks:

```sh
cd /Users/chrismaxwell/CamLink-SDK
swift run --package-path native/MedPhotoKit RelayVerification
```

Expected: seven synthetic checks pass. `swift test` is blocked by missing
XCTest in Command Line Tools; `xcodebuild -version` confirms full Xcode is absent.
No install command is offered until a signed iPhone artifact actually exists.

Implementation specification and primary source links:
`docs/IPHONE-CANON-RELAY.md` in SDK. See [[log/2026-09-10-iphone-canon-relay]].
