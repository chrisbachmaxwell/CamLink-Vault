# 2026-09-10 — iPhone Canon relay privacy foundation

Request: all Canon coverage through iPhone, with nothing patient-related stored
on phones. Removed the proposed phone offline queue from the design. Camera
card is the retry source; RAM transit remains necessary. No universal camera
support or HIPAA certification claim.

Added Swift bounded chunk relay, Apple ImageCaptureCore reader primitive, and
standalone synthetic verification. Library compiled and all seven new relay
checks passed. Existing XCTest suite could not run: this Mac has Command Line
Tools, not full Xcode/XCTest. Corrected missing Foundation import in the new
standalone runner before its passing run. iOS build, signed app, actual Canon
adapter/receiver integration, storage-residue proof and field matrix remain open.

Caught stale local Vault checkout (dirty and divergent); fetched remote and
used a clean dedicated worktree based on origin/main, preserving all prior
local changes. Read current HIPAA/cloud/camera-catalog pages. The current
task's supplied local/LAN instructions govern this slice; cloud library was
not changed or deployed. SDK work stays on the user's explicitly named branch.

See [[iphone-canon-relay]] and SDK `docs/IPHONE-CANON-RELAY.md` for sources,
decisions, verification command, and exact remaining gates.

Validation complete: SDK commit `477dfd1`; `npm run build`, `npm test`, PTP
simulator smoke, FTP smoke, multi-room smoke, and browser UI gate all passed.
New native relay verification passed all seven synthetic checks. Existing
Swift XCTest and all iPhone/device checks remain blocked on full Xcode; no
production or patient-data release was made.


## Cloud implementation continuation

Chris explicitly chose cloud and delegated implementation choices. Work moved
into an isolated fresh-main worktree, preserving unrelated shared-checkout
changes. Foundation cherry-pick `6865fc7`; implementation `dcd36f5`; simulator
launch/expiry checks `2677cd5`; final recovery/reconciliation `dc1defb`.
SDK PR 18 is open, unmerged and undeployed. Vault PR 20 records this work.

Added native Canon adapter and foreground iPhone app, ephemeral QR enrollment,
bounded streaming upload, server-side immutable visit checks and completion
reconciliation. Fixed the camera-picker disabled Continue guard, visit-start
bootstrap for newly paired cameras, fractional expiry parsing and explicit
re-pair UX. Replaced an error-swallowing reconciliation probe with an explicit
completed-grant flag. A static clinic copy assertion failed in intermediate
CI; restored its expected wording and the clinic suite passed again.

Local build/workspace checks and all three transport smokes/UI gate passed;
55 API tests and eight native synthetic checks passed. GitHub Xcode CI proved
XCTest with real HTTP streaming, unsigned simulator build and launch. Visually
inspected native launch and desktop/mobile QR pairing with synthetic data.
Latest PR CI must be checked before integration. No real patient data used.

Remaining external gates: AWS deployment access, Apple signing, physical
Canon/iPhone capture tests and device storage audit, plus existing cloud
security/BAA/operational readiness. No deploy, installed-device, universal
Canon or HIPAA-compliance claim. Camera originals are preserved. Existing
dirty vault checkout was untouched; these changes use its isolated PR worktree.
