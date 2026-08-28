# 2026-08-28 — guided camera verification and v0.19.4

Chris's field test showed two trust failures in camera setup: a disable notice
stayed on screen after it had served its purpose, and the app said a cloud
camera was ready before a real camera upload changed anything. The values were
also presented as a settings dump rather than a focused setup sequence.

SDK commit `f9531c830070aa0a193b0537e26b8a1b0c749d7c` ships the correction. Camera
setup now has a values step followed by **Take a test photo**. The app polls for
a completed upload newer than the step baseline and scoped to the exact camera;
success displays the received image and says **Camera verified**. If no visit
is active, the photo remains recoverably Unassigned. Informational camera
disable feedback expires after five seconds.

The cloud API persists `lastUploadAt` and an opaque `lastUploadPhotoId` in the
same DynamoDB transaction that completes the upload/photo metadata. Memory and
AWS repositories share the contract. No historical backfill was attempted, so
existing profiles become verified on their next upload. Three earlier
synthetic photos remained Unassigned; no patient data or local capture library
was changed.

Verification:
- root build and all workspace tests passed;
- PTP simulator, FTP and multi-room smokes passed;
- browser UI gate passed and its guided values screen was visually inspected;
- AWS stack `medphoto-synthetic-clinical-v2` reached `UPDATE_COMPLETE`, with
  reviewed Lambda bundle SHA-256
  `ff10d4cec81e067093b5d8edd37ea654687d4fe0559c56ba13e47e85289d17b8` and
  healthy synthetic-only API;
- exact arm64 v0.19.4 ZIP SHA-256
  `e3a96484976dc93496c5f9994c0c42e60e01daf5f5cad47dfa7d5ac538073a9d` passed
  archive, version, architecture, deep code-signature and native-updater checks;
- signed Railway latest manifest verifies as v0.19.4 and its CloudFront ZIP
  streamed to the signed digest;
- no-store arm64 DMG SHA-256
  `870349212f677d5307a1b12889fabf1e605b54e367d937430f45ce0a71021f41`
  streamed byte-exactly from the latest bootstrap route.

Remaining field gate: update the physical-camera Mac, enter the new short FTP
values, take one synthetic R6 Mark II photo, and confirm the photo proof screen.
Plain FTP and the whole sandbox remain synthetic-only. Reliable public first
install remains gated on Apple Developer ID signing/notarization.
