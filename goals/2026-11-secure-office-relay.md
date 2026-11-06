# Goal: Secure office relay for cameras without FTP/FTPS

Status: SYNTHETIC IMPLEMENTATION BUILT; hardware and production acceptance OPEN. Requested Chris 2026-11-06.
Constraints: [[hipaa-local-first]], [[dedicated-practice-deployments]].

## Done when
- [x] Exact-model official Canon manuals verified for EOS R8 and EOS R8 Mark II.
      Both document Connect to EOS Utility; physical receiver interoperability
      remains unproven. See source links in SDK docs/SECURE-OFFICE-RELAY.md.
- [ ] Choose tested Wi-Fi/PTP or USB adapter per model, behind CameraAdapter;
      preserve Canon session handoff/pairing. Publish exact setup and recovery.
- [ ] Owner-authorized, expiring one-use pairing; device-bound upload-only identity,
      protected keys, revocation and no platform-wide secret.
- [ ] Outbound HTTPS to the practice's dedicated endpoint, no inbound WAN ports;
      local FTP only with reviewed scoped/expiring network exception.
- [ ] Bounded encrypted durable queue with crash/power/full-disk recovery; no PHI
      in logs, thumbnails, backups or phone persistence. No permanent local library.
- [ ] Stable capture id and digest-verified authoritative cloud receipt before
      deleting queued copy; retry and deduplication preserve sole copies.
- [ ] Two-practice attacks, wrong endpoint/device, revocation, certificate expiry,
      offline/backlog and reconnect hardware tests pass.
- [ ] Receiver heartbeat, camera state and last photo receipt distinguished in UI;
      actionable failures and signed OS/software updates.
- [ ] Supported desktop/appliance (evaluate Raspberry Pi) physically validated;
      no hardware purchase or general support promise from this plan alone.

## Loop / stop
Follow [[goals/README]]. Synthetic objects only. Stop before production AWS,
real PHI, new paid hardware/services or destructive queue migration without
explicit scope. Do not bypass camera certificate checks or internet FTP policy.
SDK implementation contract: `docs/SECURE-OFFICE-RELAY.md`.

## Implementation checkpoint, 2026-11-06

- Runnable Canon CameraAdapter receiver with persistent GUID/boot announcement,
  no live-session diagnostic reconnect, retry after actual session loss, bounded
  encrypted queue, receipt scope/digest/size validation and stable capture IDs.
- Owner pairing: 10-minute one-use code; RSA device key; encrypted 24-hour ingest
  credential; proof-of-key renewal; disabled cameras rejected. Pairing requests
  audited without code/credential values. Interrupted renewal can require re-pair.
- OS key provider: macOS Keychain and Linux Secret Service; missing key with an
  existing identity fails closed. Protected-file fallback is synthetic-only.
- API heartbeat and app states separate receiver availability, camera connection
  and last verified photo; stale/authorization/storage failures are explicit.
- Queue crash lock needs supervised recovery, and retained receipt metadata is
  bounded by the queue cap. No silent pruning, camera-original deletion or
  platform-wide device secret. Backups/indexing/OS-vault controls need host proof.
- Signed managed office receiver installer/update integration and exact-device
  hardware acceptance remain OPEN. Do not sell this pilot as an appliance.
- No paid service launched, real PHI used, installed app updated, or production
  HIPAA readiness claimed. Evidence: [[log/2026-11-06-secure-practice-platform-build]].
