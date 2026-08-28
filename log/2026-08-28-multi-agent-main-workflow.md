# 2026-08-28 — canonical main and multi-agent isolation

## Problem observed

Med Photo's GitHub default branch had a historical Claude task name and there
was no branch named `main`. Multiple agents could share the primary checkout,
intermix files and push directly to the default branch. A feature-branch push
could also be described ambiguously as "main" even when it was not integrated.

## Changes

- Created CamLink-SDK `main` from exact remote commit `f9531c8` and changed
  GitHub's default branch to `main`; no existing branch or commit was deleted.
- Added mandatory one-task/one-owner/one-worktree/one-branch/one-PR rules to
  all code and vault agent entry files.
- Added declared path ownership, one serialized integration owner, exact-file
  staging and separate merge/release/deploy/runtime evidence.
- Added clone-local guards against direct `main` and non-fast-forward pushes,
  a safe worktree helper and a PR evidence template.
- Recorded GitHub's current limit: server-side protection for this private
  repository is unavailable on the current plan. Local hooks are bypassable;
  a plan with private branch protection is the future hard-enforcement gate.

## Verification

- Code workflow helper created a clean disposable branch at exact
  `origin/main`; it was removed after verification.
- Pre-push guard rejected a direct `main` push and a non-fast-forward feature
  push, while allowing a new feature branch.
- Code rule mirrors were byte-compared for their shared section.
- Root build, complete workspace tests, PTP/FTP/multi-room smokes and browser
  UI gate passed before code PR 6 was opened.
- No PHI, patient data, credential or raw provider response entered this log.

## Evidence boundary

- Code feature commit/PR: `742f0c3`, PR 6; both CI jobs passed and the PR
  merged to `main` as `c0affc0` at 2026-08-28T15:49:07Z.
- No package, release, deployment, provider mutation or patient-data mutation
  was performed.
