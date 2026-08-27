# Patient-record desktop release v0.18.15 — 2026-08-27

## Outcome

Released the local clinic patient-record organization work as desktop
**v0.18.15**. The release commit is SDK `c06855e` on the repository default
branch `claude/camera-sdk-adapter-pattern-4pj5r8`; the feature commit is
`154c2b5`.

## Release proof

- Built and packaged the arm64 macOS ZIP and DMG from a clean clone at
  `c06855e`; the clinic build, focused tests, UI gate, and camera smoke gates
  had passed before release.
- Published a signed `darwin-arm64` update manifest to the persistent Railway
  release volume. Final service deployment: `37e9af6a-2c8e-4548-aaaa-48c379209982`.
- Live `/healthz` returned `ok`; the live manifest identifies `0.18.15`, has
  `minSupportedVersion` `0.18.0`, and verified against the release public key.
- Downloaded artifacts matched their published SHA-256 values: ZIP
  `c464ef3b624b8cfde23bb1c0db7aca01f945888e284853d737a1996c636eda26`; DMG
  `05c35391664db688c265850484674ca821d0dbf3109f3c66370d73f53acd3d7e`.

## Scope and safety

- This is a local/Electron patient-record release only: editable name, DOB,
  optional photo-workflow note, review-role protection, honest consent
  placeholder, timeline and Compare continuity.
- No cloud clinical-library/AWS code, capture data, or PHI was included in the
  release. The cloud foundation remains synthetic and unreleased.
- The running installed copy was still v0.18.14 when release verification
  completed. Its ordinary update route requires the signed-in app capability;
  no browser session or authorization control was bypassed.
