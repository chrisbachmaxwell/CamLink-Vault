# Canon ping support clarification — 2026-11-04

Chris asks whether Canon actually allows ping. Clarified that being able to
send an ordinary network ping from the Mac does not establish that this R6 II
answers while using FTP or asleep. Do not imply either guaranteed support or
that Canon prohibits it. A targeted search of Canon sources did not establish
this model's ICMP response behavior; results for printers, other cameras or
users' forum reports are not proof for this body.

The official R6 II FTP manual documents Confirm Wi-Fi settings and FTP power
saving, but does not establish ping support in the material reviewed:
https://cam.start.canon/en/C012/manual/html/UG-07_Network_0070.html
(checked 2026-11-04; verify after 2026-12).

Requested the camera's current Wi-Fi IP address through the user-input tool.
This is the missing prerequisite to a short local ping test; it is not a
request for credentials or permission. No network scan, ping test, camera
setting change, source change or release was performed in this clarification.
A reply would prove only network reachability; absence of reply remains
ambiguous without controlling awake/sleep state and network filtering.

Previous delivery-status work remains SDK local feature 2c40c15, all six gates
passed, SDK branch writes blocked, no PR/merge/release. Published/installed
remains 0.20.4. The prior notes merged via vault PR 24 as de15945.
This follow-up changes only the R6 II page, status/roadmap and this log.
Documentation diff checked; no code tests required for this note-only change.
