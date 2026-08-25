# 2026-08-25 — Mac release signing runbook

## Scope
- Continued the "Fix unassigned photo visibility" thread at the Mac release
  boundary. Unassigned-photo visibility and recoverable removal remain shipped
  in clinic app v0.18.0; this pass changed no clinical-data path.
- Audited SDK commits `33b2751`, `6092011`, and `11beff8`.

## Confirmed
- `@medphoto/release-manifest` verifies a closed Ed25519-signed, non-PHI
  metadata schema. It does not build an app, sign a manifest, download a
  package, or install an update.
- `@medphoto/release-service` serves health, latest manifests, and immutable
  package bytes from a local directory. It has no patient/photo/telemetry
  routes and needs no Apple credentials.
- The current Mac installer makes an app-mode launcher backed by the source
  checkout and local Node runtime; it is not yet a self-contained production
  package.
- The separate Railway release-service deployment could not be verified in
  this Cloud environment: Railway MCP discovery failed and the Railway CLI
  was unavailable. No deployment was attempted.

## Changes
- SDK feature branch `cursor/mac-release-runbook-e615`, commit `9cabcaa`, PR
  #5:
  - added `docs/MAC-RELEASE-RUNBOOK.md` with the least-privilege Apple team
    invite, CSR-only certificate handoff, Keychain notarization profile,
    Developer ID signing/notarization checks, manifest gate, and immutable
    publication order;
  - added release-service storage/deployment documentation and an app-local
    Railway config so a project rooted at `apps/release-service` does not start
    the repository's clinical relay;
  - fixed package HEAD requests that incorrectly returned 200 for a missing
    package without checking storage.
- Follow-up SDK commit `11c6359` refreshed the stale root lockfile entry after
  `11beff8` removed the release service's manifest dependency, and aligned both
  manifest examples with the implemented `/v1/packages/<filename>` route.
  Lockfile-only install, both release builds, and all 10 release tests passed.

## Safety decisions
- Never request, accept, export, or store an Apple private key, `.p12`,
  certificate, notarization credential, or encoded equivalent in the SDK,
  vault, PR, Railway, chat, or logs.
- Minimum invite starts at Developer + Certificates, Identifiers & Profiles.
  The operator creates the CSR/private key locally; Chris as Account Holder
  issues Developer ID Application and Installer certificates from the CSR.
- Apple signing/notarization stays on the signing Mac Keychain or a future CI
  secret store Chris controls. The release service receives public bytes only.
- The Ed25519 release-manifest key is separate from Apple's Developer ID key
  and also never belongs in the release service.

## Verification
- `npm run build` — pass after restoring workspace dependencies with
  lockfile-only `npm ci`.
- `npm test` — pass, including release manifest and release service.
- `smoke.mjs ptp-simulator` — pass.
- `smoke.mjs ftp` — pass.
- `smoke.mjs multi-room` — pass.
- `ui-gate.mjs` — pass after installing the lock-matched Playwright Chromium
  binary; first attempt stopped only because the browser binary was absent.

## Waiting on Chris
- The one human/account action: enroll or confirm the Med Photo business legal
  entity in the Apple Developer Program, remain Account Holder, then invite
  the release operator in App Store Connect as Developer with Certificates,
  Identifiers & Profiles access. Do not send any key or `.p12`.

## Still open
- Self-contained app/package builder.
- Approved manifest signer and app-embedded production public key.
- Signed-manifest updater integration.
- Controlled upload into persistent release storage.
- Read-only verification of the separate Railway project's deployment and
  empty `/healthz` state.
