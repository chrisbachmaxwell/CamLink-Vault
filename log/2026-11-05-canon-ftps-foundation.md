# Canon FTPS and local-transfer foundation — 2026-11-05

## Scope and decisions
Chris requests security implementation preparation but explicitly defers
production AWS/HIPAA setup. Wants Canon FTPS list and a way to retain older
cameras. Corrected earlier shorthand: local FTP is not inherently a HIPAA
violation; office Wi-Fi does not make an internet FTP upload local. HHS
addressable-encryption guidance requires risk assessment/documented decisions,
not a checkbox waiver. No PHI, AWS setting or provider agreement changes.

## Evidence and implementation
Canon manuals C004/C012/C022/C003/C017/C010/C018/C001 and the Canon 5D IV Wi-Fi
manual document FTPS. SDK docs/CAMERA-TRANSFER-SECURITY.md carries exact URLs.
Not exhaustive of Canon's fleet; no inference for R5 C, accessories, Cinema EOS,
SFTP or untested firmware/TLS compatibility. No hardware FTPS test this session.

SDK owns new camera-transfer-capabilities.js, catalog metadata integration,
focused tests and transfer-security specification. Exact model evidence is
separate from actual service support; immutable records stay not-validated for
Med Photo FTPS. Unknown/combined families do not inherit support. Current
working camera routes, credentials, app version and AWS setup are unchanged.

Design: direct FTPS preferred; local receiver compatibility route requires
practice/receiver scoped, expiring, revocable IT review plus network restrictions,
encrypted bounded spool, HTTPS forward, digest receipt and no shared local
library. Server-side enforcement and physical network validation still need
implementation. Never treat client secureNetwork=true as authority. Both paths
remain subject to the overall production PHI gate.

Validation: build, 497 workspace tests (one existing skip), PTP/FTP/multi-room
smokes and UI gate pass. The first browser run caught the new module missing
from both server static registrations; fixed and reran all six gates.
SDK feature `b9dab2e570b428b01986a49b867262a0cd75bdbb` pushed; PR 24
passed Node 20/22 CI and merged to main
`6eb0552b23a27d957cf5792741215a6d0c5e8d64`. No release/deployment; installed 0.20.7
remains unchanged. This is an initial foundation,
not completion of the security roadmap or a deployable production receiver.

## Receiver and performance clarification — 2026-11-05
Current documented synthetic path is camera → office router → internet plain-FTP
Railway relay → authenticated AWS ingest. A controlled office receiver is a
planned local bridge, not the current route: camera → restricted LAN receiver
→ HTTPS cloud upload; it must stay running, protect queued copies, and retain
practice/camera scope. Direct FTPS-capable cameras need not use this local bridge.
FTPS adds TLS connection negotiation and encryption work; no measured Canon
FTP-versus-FTPS latency exists yet. Do not promise a percentage or imperceptible
slowdown. Plan same-camera/network/JPEG comparisons for first shot, subsequent
shots, idle reconnect, bursts and time-to-display. Source: AWS Transfer Family
FTPS guide https://docs.aws.amazon.com/transfer/latest/userguide/create-server-ftps.html
(checked 2026-11-05; verify after 2026-12). No code or deployment change.
