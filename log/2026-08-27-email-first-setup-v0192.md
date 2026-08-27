# Email-first setup and v0.19.2 password policy

Date: 2026-08-27

Chris required every human login to use email so staff can recover passwords.
SDK `27d1ce1` delivered email-first clinic onboarding and People, verified-email
Cognito accounts, pre-sign-in email-code recovery, and a mandatory one-time
migration that preserves a legacy Owner's organization/location/role/library.
The server returns a minimal state and blocks library, People and camera APIs
until that migration finishes. Adversarial tests cover account enumeration,
reset throttling, response loss, rollback/retry, and cross-tenant orphan races.

Chris then removed the 12-character usability rule. SDK `6f6dd70` changes the
minimum to 8 in renderer validation, packaged runtime, cloud API and the AWS
Cognito template while retaining uppercase, lowercase, number and symbol
checks. Seven characters is rejected and an 8-character strong password is
accepted in focused tests.

Deployment evidence:
- CloudFormation stack `medphoto-synthetic-clinical-v2` change set modified
  only API integration, IAM role, Lambda and UserPool, all with replacement
  false; status reached `UPDATE_COMPLETE`.
- Live Cognito policy reports `MinimumLength: 8`; API `/v1/health` remains
  `synthetic-only`.
- Exact arm64 v0.19.2 signed manifest is live. CloudFront ZIP SHA-256 is
  `fa9e5dd0272dcc829918b4f82a04ad5911eff1b13908890d5ab3ef1736087d80`;
  Railway latest DMG SHA-256 is
  `8a36689c46d9d25ac2461d959643b446842cb7a059616d6e7dbf4760032f66bb`.
- Root build/workspace tests, PTP simulator, FTP, multi-room and UI gate passed.

Boundary: synthetic photos only. Plain FTP and the unsigned Mac bootstrap still
require the production FTPS/BAA and Developer ID/notarization gates.
