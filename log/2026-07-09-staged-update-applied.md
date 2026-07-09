# 2026-07-09 — staged vault update applied; flaky session test fixed

- Applied `vault-updates/2026-07-09` from CamLink-SDK into this vault
  (entities/decisions, project-status, roadmap + vault-created log note) and
  removed the emptied staging area from the SDK repo. Branch
  `claude/staged-vault-update-exxodq` in both repos; vault PR #1, SDK PR #2.
  Confirms the roadmap's "grant Claude GitHub App access to CamLink-Vault
  and select both repos" — a cloud session reached both repos.
- Mistake caught (in SDK, surfaced by CI on PR #2): two tests asserted
  photo order after concurrent transfers, but completion order is
  timing-dependent — they flaked on CI while passing locally 5/5.
  `packages/sdk` session test (fixed in 8ce8666), then the
  `packages/adapter-mock` e2e test failed the same way on the next run
  (fixed in 74f5e89). Swept every array-order assertion in the repo;
  those two were the only ones asserting order of concurrent results.
  Pattern confirmed: order-assert only what the code guarantees — sort
  first, as the dedup test already did.
- Commits: vault d83dcf7 (apply update), SDK 1aeef12 (remove staging),
  SDK 8ce8666 + 74f5e89 (flaky-test fixes).
