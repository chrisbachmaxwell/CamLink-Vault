# 2026-08-25 — Non-PHI release service

SDK commit `6092011` adds `@medphoto/release-service`, the first runnable
release-delivery component. It has only three read-only surfaces:

- `/healthz`
- `GET /v1/releases/<platform>/latest.json`
- `GET /v1/packages/<immutable-package-name>`

It serves a pre-staged signed manifest and immutable app package from a local
release directory. It carries no clinic/device/user/patient/visit/photo/capture
data, accepts no writes, rejects query strings and path traversal, and refuses
symlinks so a malformed release directory cannot expose an arbitrary local
file.

## Independent test evidence

A Terra test agent generated an Ed25519-signed non-PHI manifest in a temporary
directory, served it, verified it with the trusted public key, fetched the
package and matched SHA-256. It also verified rejection of write methods,
queries, encoded traversal, invalid platforms, general data routes and a
symlink escape. The local service test suite is green (3 tests); root build and
typecheck are green.

## Still blocked by explicit gates

The clinic updater is not yet switched to this service: package installation
needs signed/notarized artifacts, atomic replacement, health-check rollback,
and a deployed TLS endpoint. No clinical data plane or patient synchronisation
has been started.
