# Security readiness and brain verification — 2026-11-05

Chris asked whether the brain is current and whether practices are isolated in
the planned AWS-hosted product. Verified the installed 0.20.7 record was pushed
and merged in Vault PR 29/main `2c3d46b`; SDK release main remains `2e536da`.
Reviewed INDEX/status/roadmap, HIPAA/cloud/access pages, active goal, clinical
API/domain code/tests and AWS sandbox template. No live AWS security settings,
BAA acceptance or actual two-practice production behavior were verified.

Findings and acceptance requirements are in [[hipaa-local-first]]. Reran
clinical-cloud-api (57 tests) and clinical-cloud-domain (13 tests), all passed.
These use synthetic fixtures and do not constitute deployment or penetration
proof. No SDK change, permissions change, deployment or clinical record access.
AWS/HHS official guidance confirms BAAs and customer safeguards remain required.

Corrected overclaims: camera routing is not structurally infallible; old local
location enforcement text is superseded by cloud membership checks; FTPS is
production direction, not the current plain-FTP relay. Marked old 0.20.5 install
checkpoint historical and updated current two-Mac instructions to 0.20.7.
Reaffirmed no real PHI until documented production gate sign-off. Next work is
a scoped production security implementation/acceptance effort, not permission
to silently enable PHI or alter provider agreements.
