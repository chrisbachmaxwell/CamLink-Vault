# PTP/IP (the activation-free camera protocol)

ISO 15740 Picture Transfer Protocol over TCP port **15740** (CIPA DC-X005).
This is what Canon's "Remote control (EOS Utility)" mode speaks, what
Tether Tools-style products use, and what makes CamLink work on every EOS
body with **zero Canon accounts, activation, or vendor software**.

## Wire shape (implemented in `packages/ptp`)
- TWO TCP sockets: command/data + event, joined by an init handshake:
  InitCommandRequest (our GUID + friendly name, UTF-16) → InitCommandAck
  (camera's GUID + name) → InitEventRequest → InitEventAck.
- The camera holds the InitCommandAck until the user confirms pairing on
  the camera screen — a "hang" here means "look at the camera"
  (our pairing timeout message says exactly that).
- After init: length-prefixed packets, little-endian, transactions =
  OperationRequest [+ Data] + Response, serialized one-at-a-time.
- Packets fragment across TCP reads — the codec has a reassembly buffer
  (PtpIpPacketAssembler).

## EOS vendor layer (`EosOp`)
- SetRemoteMode 0x9114, SetEventMode 0x9115 — the session "modes"
  ([[remote-shutter-degraded-mode]] for when 0x9114 refuses)
- GetEvent 0x9116 — poll the event queue (we poll every 300 ms)
- RemoteRelease 0x910f — fire the shutter
- Standard PTP: OpenSession/GetDeviceInfo/GetObjectInfo/GetObject/GetThumb

## Identity rule
The GUID in the init handshake must equal the GUID in our UPnP announcement
([[eos-utility-pairing]]) and must persist across runs — the camera pairs
to it once and reconnects silently forever after.

## Hard-won rules
- Never open a bare TCP probe and hang up on a camera in pairing mode — it
  aborts the camera's search ("connection target not found"). Probes must
  be graceful-FIN, and reach checks were folded into pairing entirely.
- Never disconnect and redial ([[session-handoff]]).
- The camera's port answers RST until the user presses SET — ECONNREFUSED
  during pairing is EXPECTED, not a failure.
