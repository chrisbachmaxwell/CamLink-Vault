# Desktop app as office receiver — 2026-11-05

## Request and conclusion
Chris pasted the FTPS/local-receiver discussion and asked whether Med Photo
running on an office computer could create its own receiver. Reviewed as a
feasibility question, not authorization to implement or change a live route.
Yes: the native app can bundle a background receiving service and forward over
HTTPS. Separate receiver hardware is optional. Cloud remains the shared library.

## Evidence and mistakes caught
- Local SDK checkout is the historical branch at `477dfd1`; inspected fresh
  SDK `origin/main` at `6eb0552` for current behavior.
- Primary local vault is divergent with unrelated dirty/untracked work. Read
  fresh vault `origin/main` at `1f27baf` and used a separate feature worktree;
  preserved all primary-checkout work.
- Existing `FtpPushAdapter` is a plain-FTP component. Corrected this concept
  page's stale proposed embedded-FTPS description.
- Current cloud mode explicitly suppresses local receiver startup and rejects
  old setup endpoints (apps/clinic/src/server.ts). Desktop window close quits
  the app and terminates the clinic child (apps/desktop/src/main.mjs).
- No automatic login startup, sleep control or production-ready local receiver
  was found in the reviewed desktop path. Capability metadata does not turn
  either planned production route on.

## Design implications
Offer a future “Use this computer as a receiver” enrollment. Start automatically
at login, or build a separate managed service if pre-login availability is
needed. Closing a window should not stop an explicitly enabled receiver. Keep
the computer awake while receiving, with clear status and outage explanations.
The camera needs a stable LAN address and its own scoped credential; another
computer opening the app is not transparent camera failover. One designated
computer can receive for several cameras. LAN client isolation must be checked.
Use protected keys, an encrypted bounded queue, durable receipt confirmation,
safe retries and practice/location/camera authorization; no permanent duplicate
local patient library. Local FTPS is preferred. Plain local FTP retains the
existing reviewed-exception requirements and is not made encrypted by HTTPS
on the second hop. Performance is unmeasured; no speed guarantee.

## Sources checked 2026-11-05 (verify after: 2026-12)
- SDK main `6eb0552`: docs/CAMERA-TRANSFER-SECURITY.md,
  packages/adapter-ftp-push/src/index.ts and ftp-server.ts,
  apps/clinic/src/server.ts, apps/desktop/src/main.mjs and runtime.mjs.
- https://www.electronjs.org/docs/latest/api/app#appsetloginitemsettingssettings-macos-windows
- https://www.electronjs.org/docs/latest/api/power-save-blocker
- https://www.hhs.gov/hipaa/for-professionals/faq/is-the-use-of-encryption-mandatory-in-the-security-rule/index.html

## Delivery and validation
Owned files: this log, concepts/ftp-push-transfer.md,
entities/project-status.md, entities/roadmap.md.
Vault feature branch: `codex/desktop-receiver-feasibility-20261105`; documentation
diff reviewed and whitespace checked before push/PR. No SDK source changes or
new SDK commit; no runtime gates rerun for this explanatory documentation.
No merge, release, installation, AWS change, camera-profile change or PHI use.
No hands-on test is requested from Chris by this review. Future implementation
must pass all six repository gates plus sleep/restart/network-change,
revocation, queue-recovery and actual-camera acceptance. Existing direct-FTPS-
first priority remains unchanged; implementation belongs to its authorized loop.
