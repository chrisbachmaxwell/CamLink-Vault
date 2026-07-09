# 2026-07-09 — staged vault update applied; flaky session test fixed

- Applied `vault-updates/2026-07-09` from CamLink-SDK into this vault
  (entities/decisions, project-status, roadmap + vault-created log note) and
  removed the emptied staging area from the SDK repo. Branch
  `claude/staged-vault-update-exxodq` in both repos; vault PR #1, SDK PR #2.
  Confirms the roadmap's "grant Claude GitHub App access to CamLink-Vault
  and select both repos" — a cloud session reached both repos.
- Mistake caught (in SDK, surfaced by CI on PR #2): `packages/sdk`
  session test asserted `photoStored` order for two back-to-back captures,
  but transfers run concurrently so emission order is timing-dependent.
  Flaked on CI, passed locally 5/5. Fixed by sorting before comparison
  (commit 8ce8666). Pattern confirmed: order-assert only what the code
  guarantees; the dedup test already sorted for this reason.
- Commits: vault d83dcf7 (apply update), SDK 1aeef12 (remove staging),
  SDK 8ce8666 (test fix).
