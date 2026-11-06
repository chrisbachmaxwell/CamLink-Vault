# 2026-11-06 practice launch preparation

Chris requested launch of the integrated synthetic practice platform. Production
PHI/compliance acceptance remains deferred. SDK launch branch
`codex/practice-launch-20261106`, feature `91adaddf1cf3005e06c241881859b615d686cc31`,
PR31: https://github.com/chrisbachmaxwell/CamLink-SDK/pull/31.

Prepared desktop/clinic 0.20.8 and corrected Lambda artifact build instructions.
All six local gates passed; template structural check and cfn-lint passed.
Arm64 ZIP and DMG built and archive/code-signature verification passed.
ZIP SHA256: `81eca274d8913eba71f58619fd12644f99f3a23000db1eae4d65fd5672a89572`.
DMG SHA256: `28b13b88db68e7be7e1dc030b14ae75a269b653d78b84689a5f0d06d39bc63bf`.
Deployment artifacts: `/Users/chrismaxwell/MedPhoto-Launch-0.20.8`.

Live AWS inventory confirmed the old four-hour FTPS trial instance is stopped.
Existing retained storage remains; no deletion was performed. Only existing
public Route53 zone was rentals.pictureline.com. Chris chose
medphoto.pictureline.com for the new deployment and requested DNS instructions.
Parent authoritative nameservers are ns1.nexcess.net and ns2.nexcess.net.
The planned delegation is four NS records named medphoto in that parent zone;
exact values must come from the new Route53 zone, never be guessed. Do not
replace pictureline.com's nameservers or unrelated website/email records.

DNS zone creation awaits specific recurring-charge approval. Dedicated stack
costs/security access still require a concrete reviewed launch plan. No new
practice stack or DNS zone created at this checkpoint. Public and installed
release remain 0.20.7; 0.20.8 is not published merely because its package exists.
Next: create approved DNS zone and supply NS values; review scoped stack change
sets and budget; run live two-practice isolation and enroll synthetic owners.
