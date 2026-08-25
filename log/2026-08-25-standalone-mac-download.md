# 2026-08-25 — standalone Mac download

## Decision

Use Electron for the first self-contained Mac application. The product is
already a Node camera service plus a proven browser UI, so Electron preserves
that code and the CameraAdapter boundary while bundling both Node and Chromium.
Tauri would add a Rust host while still requiring the Node service as a
sidecar. The earlier generated `.app` remains a development launcher only.

## Shipped

- SDK commit `74c5a76` on `claude/camera-sdk-adapter-pattern-4pj5r8`.
- New `@medphoto/desktop-app` workspace with an isolated BrowserWindow:
  sandboxed renderer, context isolation, no Node integration, popup denial,
  and exact loopback-origin navigation.
- esbuild produces a single bundled clinic service plus read-only public
  assets; Electron packages it without source-repo/runtime/browser
  dependencies.
- Captures/configuration are explicitly under the desktop user's macOS
  Application Support directory, never inside the replaceable `.app`.
- The host supplies a 256-bit one-time startup token and accepts the child
  only when `/api/state` returns the matching proof header. This closes the
  open-port reservation race found by the independent tester.
- Packager emits separate arm64 and x64 `.app`/ZIP artifacts with internal
  ad-hoc deep signatures. Version comes from the desktop package rather than
  duplicated literals.
- Packaged runtime disables the old Git/npm updater and explains that the next
  internal test build must be downloaded manually.

No patient data, credentials, keys, or artifact bytes were committed here or
to the vault.

## Verification

- Root build and typecheck passed, including the desktop workspace.
- All workspace unit tests passed; desktop runtime suite passed 5/5.
- PTP simulator, FTP, and multi-room smoke gates passed.
- Full browser/front-desk UI gate passed.
- arm64 and x64 ZIP integrity passed; both `.app` bundles passed deep strict
  `codesign` verification.
- The arm64 packaged binary launched through Launch Services with a new
  isolated profile, spawned only its bundled service, served Med Photo v0.18.0
  and the real UI, wrote only to the temporary Application Support capture
  path, and stopped its child/listener on quit.
- Independent agent reproduced the clean-profile packaged launch and shutdown.

## Honest boundary / next loop

This completes “download a real standalone app to another Mac” for controlled
internal testing. It does not complete the distributed-clinic promise. The
current window runs a local Capture Hub and uses local PIN profiles. Next wire
the already-built desktop-connect/hub-transport contracts to real macOS OIDC,
Keychain, mDNS, pinned TLS, and authorized Hub viewer routes.

Gatekeeper rejects the ad-hoc-signed app as a normal public download. Until a
Developer ID certificate and notarization are available, a tester must use the
explicit Finder Control-click → Open approval. Hosted warning-free downloads
and trusted auto-update remain separate acceptance gates.
