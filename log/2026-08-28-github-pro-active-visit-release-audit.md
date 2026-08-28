# 2026-08-28 — GitHub Pro and active-visit release audit

Chris confirmed the GitHub account has been upgraded to GitHub Pro. The prior
private-repository plan blocker is therefore removed, but a read-only GitHub
API request still returned **Branch not protected** for CamLink-SDK `main`.
No GitHub repository setting was changed. Server-side protection for both code
and Vault `main` remains a separately authorized and verifiable next action;
the local pre-push hooks, PR-only rule and single integration owner remain the
current enforcement boundary.

Chris also flagged screenshots showing the old dead `camera already has an
active visit` banner and a Home page that did not show the cloud visit. The
screenshots were timestamped around 09:23, while signed arm64 v0.19.4 was
issued around 09:53. Read-only release tracing proved:

- SDK `aae5b4467411a629681735bd01689f3d4290b1fb` is an ancestor of both code
  `main` and the v0.19.4 source commit;
- the live Railway manifest is v0.19.4 with signed ZIP SHA-256
  `e3a96484976dc93496c5f9994c0c42e60e01daf5f5cad47dfa7d5ac538073a9d`;
- the exact released ZIP contains the three-second cloud room refresh, Home
  refresh, immediate conflict-state update, **Go to ...'s visit**, and
  **End it & start...** actions;
- the focused cloud onboarding/active-visit test passed 3/3 and the clinic
  TypeScript check passed.

Conclusion: the agent's fix was not stranded on a feature branch. It is merged
and published in v0.19.4; the field screenshots show v0.19.3 behavior. The next
human proof is to update both Macs, start a synthetic visit on one, then verify
the other Mac shows it on Home and can open or end it from the actionable
conflict notice. No code, deployment, patient data or GitHub setting changed
during this audit.
