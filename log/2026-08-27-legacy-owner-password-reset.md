# Legacy synthetic Owner password reset — 2026-08-27

- Chris requested an administrative reset for the existing pre-email synthetic
  Owner so it can enter the v0.19.2 mandatory email-upgrade flow.
- Read-only AWS checks first confirmed that clean-clinic onboarding was already
  complete and that exactly one legacy username remained enabled and
  `CONFIRMED`, with no email attribute.
- The Cognito password was replaced with a generated strong value using
  `AdminSetUserPassword --permanent`; the generated value was shown only to
  Chris and was not placed in command history, code, this vault or logs.
- The reset did not change membership, organization, location, cameras,
  patients, photos, storage or infrastructure.
- Expected next field action: sign in once with the legacy username and reset
  value, then use **Add your email** to atomically migrate the same Owner
  membership and choose the lasting email/password login.
- Synthetic-only boundary remains in force; no PHI was used.
