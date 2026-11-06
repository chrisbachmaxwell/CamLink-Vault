# First physical Canon FTPS connection and transfer — 2026-11-06

Chris reports "It connects now" on the unchanged R6 II saved FTPS connection.
This follows deployed feature 85f8b0d (SDK PR28), per-control session-ID support
and graceful protected listing shutdown. This resolves the observed connection
failure in this test without weakening TLS/session binding or changing camera
credentials. Does not isolate which fix alone was sufficient on hardware.

Sanitized journal shows LIST/150 → protected data session accepted →226 at
19:54:56–57 UTC, subsequent successful LIST/NLST and STOR. One STOR at19:55:13
completed226 at19:55:16 (roughly3s); later19:55:22→27 and19:55:28→37 took roughly
5s and9s. Second-resolution times only. File sizes, shutter times and visual
arrival were not measured; these are not encryption overhead or end-to-end
benchmark results. They may include backlog, so use fresh controlled shots next.

Native app shows one photo in the open synthetic visit. Selected camera's
DynamoDB lastUploadPhotoId exactly matches native image ID, with lastUploadAt
19:56:08.654 UTC. Identifiers and patient metadata deliberately omitted here.
No need to inspect any actual photo content or change/end the active visit.

Asked Chris to take one fresh object JPEG with auto transfer enabled and report
appearance/delay. Await response. Then matched FTP/FTPS first/steady/burst/idle
and reconnect tests remain. Physical unknown/expired-root rejection, interruption,
revocation and long-run reliability still required before broader readiness.

Code evidence: SDK PR27 merged d4bc559. SDK PR28 feature85f8b0d remains open;
all six local gates,15 focused FTPS and3 infra/privacy checks passed; Node22 CI
passed, Node20 browser gate still running at checkpoint. Separate synthetic
receiver deployment is verified. Desktop still0.20.7, no general production
rollout or HIPAA claim. Stop timer still22:53:37UTC /3:53PM Mountain today;
encrypted disk remains billable after stop. Existing working FTP stays saved.
