# 2026-11-05 — Canon FTPS implementation, FTP retained

Chris authorized FTPS implementation with protocol-specific instructions and
explicitly asked to retain FTP instructions. Production AWS setup remains
deferred; this work authorizes no patient data.

## Changes
- Opt-in explicit FTPS in the shared receiver using Node TLS/OpenSSL, TLS 1.2+.
  Reject plaintext login, CCC, PROT C and unprotected data. Each control session
  has unique ticket keys; passive data must resume that control TLS session,
  preventing another client behind the same NAT injecting a photo.
- Separate passive ports required; existing single-port FTP demux cannot carry
  this FTPS path. Existing FTP remains default. Invalid/incomplete secure
  configuration fails rather than downgrading.
- Camera login removal/rotation disconnects existing sessions. Durable receiver
  acceptance still precedes success; incomplete uploads remain rejected.
- Authenticated relay activation reports actual protocol to clinical profiles.
  Old relay responses stay FTP. Capability is never evidence of an encrypted route.
- App retains nine-step FTP guide; FTPS adds root-certificate import before
  setup and certificate-error recovery without fallback to FTP. Browser proof
  uses synthetic profiles. Root certificate distribution is still manual.
- Runbook: SDK docs/FTPS-SETUP.md. Sources: Node TLS API, RFC4217 and Canon
  R6 III C022 UG-07_Network_0070 (root import, filenames and trust bypass).

## Mistakes caught
Foreign-control TLS1.2 rejection can occur before client secureConnect, while
TLS1.3 can complete then close; test now accepts both rejection timing paths
and requires zero accepted files. Existing relay response assertion needed
the new protocol field. Setup error choices had to refresh after constructing
the protocol-specific guide, not before it.

## Evidence and release
All six local gates passed: build, all workspace tests, PTP simulator, FTP,
multi-room and browser UI gate. Eleven FTPS tests cover TLS 1.2/1.3 uploads,
foreign-session rejection, plaintext refusal, trust/hostname failures, rotation
and rejected/truncated acceptance. The raw-data rejection test needed to consume
the TLS alert before waiting for socket close.
SDK feature commit: c885348. PR: https://github.com/chrisbachmaxwell/CamLink-SDK/pull/25
Source merge is pending Node 20/22 CI; not yet merged or released.
Installed/published desktop remains 0.20.7. No relay/API deployment or camera
credential change; current synthetic FTP route stays operational.

## Next gate
Provision a separate synthetic FTPS endpoint with certificate and reachable
passive ports. Supply verified public root to the camera. Prove actual Canon
TLS session reuse, trusted/untrusted/expired certificates, hostname, first/
subsequent photos, reconnect, power-cycle, interruption/backlog, revocation
and latency. Do not relax binding or certificate checks for compatibility.
Production practice-isolation/BAA/recovery/security review gates remain open;
Pi/office receiver is deferred.
