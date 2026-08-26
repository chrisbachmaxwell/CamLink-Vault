# Same-LAN multicomputer test — v0.18.11

Date: 2026-08-26

## Decision

The first end-user multicomputer proof keeps the local-first topology: one
packaged Mac is the **Capture Hub**, owns every camera and the only capture
store, and other computers are browser Viewers. It does not replicate
`captures/` between computers and does not start camera adapters on Viewers.

This slice is explicitly synthetic-test-only authenticated HTTP. It proves the
workflow while native discovery, pinned TLS, device enrollment and the final
viewer-only desktop mode remain gated.

## Shipped

- SDK commit `911d466` adds **Settings -> Other computers -> Share this
  library** for a locally signed-in Owner.
- The packaged Hub persists a closed boolean setting and restarts on stable
  LAN port 3555. It advertises only private IPv4 addresses.
- Signed-out state never includes Hub-sharing details. Remote viewers can sign
  in and use the same library/live event stream, but receive 403 if they try to
  change sharing.
- A stable-port conflict fails visibly before the restart. The setting file is
  atomically written with owner-only permissions.
- The browser UI clearly labels the route as synthetic-data-only and recommends
  a Review user for viewing.
- Self-contained arm64 v0.18.11 was packaged, exact-launch tested, signed with
  the existing offline Ed25519 release key, and published to the Railway
  internal-test updater. Live package SHA-256:
  `a6edecc3989583684e12ff4748eebdf260a9c9e65484033fd7c23dbe93d2a9bd`.
  Versions 0.18.6 through 0.18.9 remain available.

## Evidence

- Full SDK `npm run build`, `npm run typecheck` and `npm test` passed.
- PTP simulator, FTP, multi-room, relay and browser UI gates passed.
- Dynamic packaged-host proof persisted sharing, relaunched with `--lan`,
  listened on `*:3555`, advertised the real private-network URL, accepted a
  second independently signed-in session, and refused the remote sharing
  mutation.
- Exact arm64 ZIP/DMG: version 0.18.11, arm64, clean archive, deep/strict
  code-sign structure, updater verifier pass and fresh-profile launch pass.
- Railway live manifest signature verified; the full streamed package matched
  the signed SHA-256; the final lightweight service deployment passed health.

## Mistakes caught

- The complete 560 MB immutable-history source bundle exceeded Railway's upload
  boundary and returned 413. Nothing changed live. The already-established
  persistent-volume transfer was used instead, then the small read-only runtime
  was restored. Historical releases were rechecked after the transfer.

## Remaining

- Use only synthetic patients/photos in this browser-viewer path.
- Complete pinned TLS, device enrollment/revocation and native Hub discovery
  before allowing patient data on LAN.
- Connect the downloaded app's viewer-only mode so staff do not need to paste a
  Hub URL into Safari/Chrome.
- Developer ID signing/notarization remains the reliable first-install gate.
