# 2026-07-10 — Phase B visit-compare worker loop

Worker (Cursor cloud agent) on CamLink-SDK branch
`cursor/visit-compare-6345` + vault branch of the same name.

## What landed (agent-verifiable Done-when all checked)
- `GET /api/visit-photos` + disk/API fixtures (`f50b8a9`)
- Patient-page / photo-display shaping + UI (`8d60797`)
- Compare pairing + keyboard stepping (`ae1c05f`)
- Empty/failed, large-view, grouped history, storage-path, nav, smoke
  visit-photos extension (`eba9194`)
- Vault [[clinic-app]] updated; goal Status left **IN PROGRESS** for
  architect re-review of the actual diff (per goal instructions).

## Constraints obeyed
- No Playwright/Puppeteer — jsdom only as clinic-app devDependency
- 40 MB CR3 rule: grids/large/compare never put CR3 in `<img>`
- Adapter packages untouched; `packages/sdk` untouched (so
  `assertSafeSessionFolder('.')` debt left for a future SDK-touching goal)
- HIPAA: local only, no PHI in logs/commits, no hard-deletes
- Scope guard: no editing/annotations/export/printing

## Gates
`npm run build`, `npm test`, `node apps/clinic/test/smoke.mjs ptp-simulator`
all green before each push.

## Waiting on
- Architect re-review → flip goal DONE if diff is clean
- Chris: show a real ortho/front-desk person; fold complaints into roadmap
