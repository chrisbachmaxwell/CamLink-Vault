# Multi-agent delivery — isolation before speed

Decision: 2026-08-28. Applies to the Med Photo code repository and this project
brain. The full code-repository command reference is
`docs/MULTI-AGENT-WORKFLOW.md` in CamLink-SDK.

## Integration truth

- `main` is the only branch that means integrated. A feature commit or pushed
  branch is not merged, released, deployed or live.
- GitHub's default CamLink-SDK branch changed to `main` on 2026-08-28 from the
  exact then-current shared head `f9531c8`. The former default branch remains
  intact only to avoid destroying active work.
- Code and brain merge independently. A code merge does not prove its vault
  handoff merged, and a vault merge does not prove code or deployment.
- The code workflow entered `main` through PR 6 at merge commit `c0affc0`;
  both Node 20 and Node 22 CI jobs passed before the integration-owner merge.

## Ownership model

```text
one task -> one owner -> one worktree -> one branch -> one PR
                                                   |
                                one integration owner merges serially
```

Every task declares its owned paths before editing. Two live tasks may not own
the same path. If scopes overlap, the integration owner sequences them; the
second task updates from the first merge and re-runs affected gates.

The primary checkouts are coordination surfaces, not development worktrees.
Unknown modifications are someone else's work: never reset, clean, stash,
overwrite or delete them. Never use `git add .`; stage exact owned files.

## Agent lifecycle

1. Fetch fresh `origin/main`.
2. Create a unique tool/task branch in an isolated worktree.
3. Record branch, clean status, base SHA and owned paths.
4. Implement only within that ownership boundary.
5. Run the repository's complete required gates.
6. Update this brain without PHI/secrets/raw provider payloads.
7. Push feature branches and open PRs to `main`.
8. Hand off; do not merge unless designated integration owner.

The integration owner merges one PR at a time, re-fetches `main` immediately
before the merge, verifies CI/gates and path ownership, then records the PR's
actual merge commit. Conflicts return to the owning agent; force-push and
destructive cleanup are never conflict-resolution tools.

## Required evidence lines

```text
Owned paths:
Feature commit:
PR:
CI and local gates:
Main merge SHA: not merged | SHA
Release/package: not performed | evidence
Deployment/live proof: not performed | evidence
Vault commit/PR:
Remaining gate or next owner:
```

## Enforcement boundary

CamLink-SDK's committed helper creates clean worktrees from `origin/main`. Its
clone-installed pre-push hook blocks direct pushes to `main` and detectable
non-fast-forward rewrites. The vault carries the same local guard.

GitHub reported on 2026-08-28 that branch protection/rulesets for this private
repository require a plan upgrade (or public visibility). Until that changes,
the hooks, PR-only contract and single integration owner are strong workflow
guards but not server-side enforcement; a user can bypass a local hook. When
private branch protection becomes available, require PRs, required CI, current
branches, no force pushes and no branch deletion on `main`.
