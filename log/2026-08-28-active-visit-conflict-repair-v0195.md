# Active-visit conflict repair and v0.19.5 release — 2026-08-28

Chris's v0.19.4 field screenshots exposed two contradictions at once: Start
visit returned `camera already has an active visit`, while Home showed no visit
in progress, and the same amber sentence remained on every screen.

## Cause and correction

- Dynamo's camera-active lock could outlive a missing or ended visit record.
  The create transaction trusted the lock, but the Home projection trusted the
  visit record, so both screens were internally consistent and mutually wrong.
- The cloud repository now reads the lock and visit consistently. It deletes
  only the exact stale lock, rereads if a concurrent visit replaced it, and the
  API retries the start transaction once after a successful repair.
- Real camera or patient conflicts return a closed, validated visit summary.
  The clinic facade uses that authoritative record to offer the real visit
  action instead of a dead generic sentence.
- Ordinary banners now have a close control, expire after seven seconds, and
  clear on screen changes. Actionable conflicts remain only in their relevant
  view.

## Delivery evidence

- Feature commit: `e603dc4dee1dd0d75ef5abbae09d71edcda05acf`
- Code PR: `chrisbachmaxwell/CamLink-SDK#7`
- Main merge: `7c0d11f31efbfb97a0f557b64df7d21b531e7497`
- GitHub Actions: Node 20 and Node 22 passed.
- Local gates: root build/tests, PTP simulator, FTP, multi-room and browser UI
  gate all passed.
- AWS: `medphoto-synthetic-clinical-v2` reached `UPDATE_COMPLETE`; deployed
  Lambda changed at 2026-08-28T17:05:39Z and `/v1/health` returned 200 with the
  synthetic-only environment marker.
- Release: signed arm64 v0.19.5 Railway manifest is live. Its immutable
  CloudFront ZIP is 114081847 bytes and SHA-256
  `2fa83cd6ca4c3d310bec1576a40961a276a4231d520672684005ccbbb61e2af7`.

No PHI, credentials, setup codes or raw provider responses were written here.
The app and backend remain synthetic-only. Next field proof: update both Macs,
start a visit, and confirm a real conflict opens/ends the active visit while a
stale lock repairs without leaving a persistent global banner.
