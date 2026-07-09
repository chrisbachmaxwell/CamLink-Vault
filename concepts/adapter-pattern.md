# Adapter pattern (the architecture rule)

The founding constraint of [[camlink-sdk]]: consuming apps talk to two
interfaces — `CameraAdapter` (discover/connect) and `CameraConnection`
(status/triggerCapture/download/events) — and never to a vendor SDK,
protocol, or HTTP API directly.

## Why it's the moat
- New camera support is additive: R6 Mark III's brand-new event dialect
  landed as a 3-line adapter change; zero app changes.
- The clinic app runs identically on mock, two simulators, CCAPI, and
  PTP/IP — which is what made CI + field debugging tractable.
- A future Nikon/Sony adapter, or the USB tether transport, slots in without
  touching consumers.

## Enforcement
- `packages/adapter-cert`: 9-check certification suite every adapter must
  pass (lifecycle, events, download integrity, error taxonomy…).
- Mock adapter shipped FIRST (original spec) so the interfaces hardened
  before any vendor quirks arrived.
- Errors are SDK-typed (`ConnectionError`, `CaptureError`, `TransferError`)
  — vendor error codes never leak upward.

## Transport sub-pattern
Inside the Canon PTP adapter the same trick repeats: `PtpTransport`
interface with `PtpIpTransport` (Wi-Fi) today and `PtpUsbTransport` (libusb)
planned — the adapter won't notice the wire change. [[roadmap]]
