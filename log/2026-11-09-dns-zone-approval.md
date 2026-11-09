# 2026-11-09 DNS zone approval and installed app verification

Chris explicitly approved creating the medphoto.pictureline.com public Route53
zone at the previously disclosed approximately $0.50/month plus query charges.
This approval persists; do not ask again. It does not approve a new recurring
practice-server budget or imply that dedicated stacks are deployed.

AWS console showed signed out. Opened Sign in again and left the existing
CloudShell browser tab for Chris to authenticate. No zone created and no four
NS values issued yet. After sign-in, list exact-name hosted zones first to
avoid duplicates, create only if absent, read back its four nameservers and
provide NS records named medphoto for the parent pictureline.com DNS at Nexcess.
Do not change the parent domain nameservers, website, email or unrelated records.

Chris reported updating Med Photo. Local /Applications/Med Photo.app/Contents/
Info.plist CFBundleShortVersionString independently verified 0.20.8. This is
installed-version proof, not live practice isolation or camera validation.
No code changes or deployment this session. Current SDK release remains PR31,
main 9341f62. Authentication is the immediate DNS blocker.
