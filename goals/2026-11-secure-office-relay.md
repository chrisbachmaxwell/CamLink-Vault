# Goal: Secure office relay for cameras without FTP/FTPS

Status: PLANNED NEXT after dedicated FTPS rollout. Requested Chris 2026-11-06.
Constraints: [[hipaa-local-first]], [[dedicated-practice-deployments]].

## Done when
- [ ] Exact-model Canon manual/SDK evidence for EOS R8 and clarification of the
      reported "R8II" model; Wi-Fi alone does not prove a usable upload protocol.
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
