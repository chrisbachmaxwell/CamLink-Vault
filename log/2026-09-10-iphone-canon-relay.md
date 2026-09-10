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
