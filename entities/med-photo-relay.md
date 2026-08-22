# med-photo-relay — the hosted Cloud Relay deployment

Live at `https://relay-production-3c84.up.railway.app` (Railway project
"Medphoto", service "relay") since 2026-08-21. **TEST PHOTOS ONLY** until
FTPS + BAA + compliance sign-off ([[hipaa-local-first]], repo
docs/CLOUD-RELAY-PLAN.md). (verify after: 2026-11)

## Shape
- `packages/relay` `RelayServer`: per-account `CameraFtpServer` ingest,
  bounded in-memory queue, **pipe-not-store** (delivery = deletion),
  bearer pull token (constant-time compare).
- Railway constraint → **single-port FTP**: one TCP proxy port
  (`metro.proxy.rlwy.net:24838`); PASV/EPSV advertise the external
  host:port; control vs data demuxed by first-bytes sniff (350 ms).
- HTTP API: `/v1/next` (long-poll pull; X-File-Name, X-Received-At,
  X-Camera-* presence headers), `/v1/health` (queueDepth + camera
  presence), `/v1/info` (camera-side FTP values INCLUDING password —
  pull-token-gated; a values card without the password strands setup,
  field lesson 2026-08-21).
- **FTP conversation tracer** (2026-08-22): every command/reply/
  connection event logged to Railway logs, passwords masked
  (`FTP_TRACE=0` disables) — the tool for new-camera dialects.
- Client: `packages/adapter-cloud-relay` `CloudRelayAdapter` long-polls;
  the clinic app ships with this relay BUILT IN (zero typing;
  provision.ts; env/saved values override).

## Operations
- Deploy: `railway up --detach --service relay` from a repo checkout
  (needs RAILWAY_TOKEN; Railway CLI ≥5.41). PORT env pinned 8080 (Railway
  once injected the FTP port → EADDRINUSE crash-loop, 2026-08-21).
  Docs: repo docs/DEPLOY-RAILWAY.md.
- Secrets: FTP_PASSWORD / PULL_TOKEN env on the service. The 2026-08
  prototype credentials were pasted in chat → treat as burned; rotate at
  the FTPS/per-clinic-accounts milestone. The Railway project token used
  2026-08-21/22 must be deleted by Chris.
- Restart drops queued (undelivered) photos — by design; cameras re-send.
