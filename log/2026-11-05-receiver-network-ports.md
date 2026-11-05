# Receiver network path and ports — 2026-11-05

Chris asks whether an app receiver would still use the camera's network to go
straight to the internet or need another port opened by the administrator.

Both architectures use ports. With the app only selecting/viewing visits, the
camera continues initiating outbound cloud uploads. With the app receiving,
the camera's configured destination becomes a LAN computer/iPad; the app then
initiates HTTPS cloud upload. A different numeric port is not inherently
required, but the receiver address and local access permissions change.

Ordinary allowed LAN traffic may work without administrator changes. Restricted
networks can need narrow camera-to-receiver internal rules or isolation/routing
adjustments, plus host firewall/local-network app permission. No WAN port
forwarding is needed for this same-office design. The app cannot bypass office
network policy. Do not prescribe broadly disabling firewall/client isolation.

Source at SDK main `8bdefe1` and vault main `d5dd9bb`: current hosted synthetic
FTP multiplexes control and passive data onto one public endpoint. Implemented
but undeployed FTPS uses a control port plus a configured separate passive
range. These passive connections originate at the camera. A restrictive office
may therefore need outbound FTPS permission even for direct cloud ingest;
that does not mean inbound internet exposure of an office computer. Local app
port numbers are not finalized or hardware-tested. No live firewall audit.

Sources checked 2026-11-05 (verify after: 2026-12):
- SDK docs/FTPS-SETUP.md; packages/adapter-ftp-push/src/ftp-server.ts.
- Vault [[med-photo-relay]], [[macos-networking-traps]], [[ftp-push-transfer]].
- https://documentation.meraki.com/Wireless/Operate_and_Maintain/How_Tos/Firewall_and_Traffic_Shaping/Wireless_Client_Isolation
- https://support.apple.com/guide/mac-help/block-connections-to-your-mac-with-a-firewall-mh34041/mac
- https://docs.aws.amazon.com/transfer/latest/userguide/create-server-ftps.html
  (AWS's service-specific port numbers are not Med Photo's deployment settings.)

Delivery: continue owned receiver-feasibility branch/PR 34, update this log,
FTP concept, project status and roadmap; review diff and whitespace before
push. No code, camera, network, AWS, installation or release changes. No runtime
tests for documentation-only explanation. No human test requested. Current
cloud-first priority preserved. Push/PR does not mean merged or deployed.
