# med-photo-relay — the hosted Cloud Relay deployment

Live at `https://relay-production-3c84.up.railway.app` (Railway project
"Medphoto", service "relay") since 2026-08-21. **SYNTHETIC TEST PHOTOS ONLY**
until FTPS + AWS BAA + compliance sign-off ([[hipaa-local-first]], repo
docs/CLOUD-RELAY-PLAN.md). (verify after: 2026-11)

## Current shape
- `packages/relay` `RelayServer` accepts camera FTP uploads and durably spools
  each accepted object on the mounted `/data` volume before returning FTP
  success. File bytes and strict profile bindings survive restart/deploy.
- Each camera receives a unique FTP username/password plus a separate long,
  write-only cloud-ingest credential. The camera-entered values can be rotated
  or revoked independently if a camera is lost; the internal ingest credential
  is never displayed or typed into the camera.
- Camera-facing credentials generated after SDK `c43b75c` use a 13-character
  username (`mp-` plus 10 random characters) and a 12-character random
  password. The alphabet omits `0`, `1`, `i`, `l`, and `o`; the independent
  43-character cloud credential remains unchanged.
- The relay sends durable jobs directly to the authenticated AWS clinical
  ingest API. Exact retries are idempotent; one revoked/held camera cannot
  block another camera's queue. Completed jobs are removed only after AWS
  confirms metadata completion.
- Railway's TCP constraint still uses one externally advertised FTP endpoint;
  control and passive data connections are demultiplexed on the service.
- Profile create/rotate/remove changes are failure-atomic: the binding envelope
  is fsynced before runtime accounts change. Rotation activates the new profile
  before idempotently retiring the old login.
- FTP trace is disabled by default. Explicit diagnostic trace emits only fixed,
  redacted event categories—never filenames, paths, account names, credentials,
  or IP addresses.

## Operations
- Deploy from the SDK checkout with the reviewed Railway service configuration;
  keep the `/data` volume attached. See repo `docs/DEPLOY-RAILWAY.md`.
- The AWS control plane provisions camera profiles through the relay's
  authenticated management boundary. Staff and the downloaded app never receive
  the relay control token.
- Do not place relay tokens, camera credentials, filenames, patient data, or
  provider responses in source, chat, logs, commits, or this vault.
- Current transport is plain FTP and therefore remains synthetic-only. The
  production gate is FTPS/TLS plus BAA, managed-secret, restore/revocation and
  incident-response proof.
