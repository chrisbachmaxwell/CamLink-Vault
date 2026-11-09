# 2026-11-09 Med Photo public DNS zone created

Chris signed in and the prior explicit zone/billing approval was used. Exact-name
list found no existing zone. Created public medphoto.pictureline.com in the
existing AWS account, zone Z0004499HWAP61J9XKQS, caller reference
medphoto-dns-approved-20261109, change C00853071WW4VM5YW3RAU.
GetHostedZone readback and direct authoritative DNS lookup agree on:

- ns-69.awsdns-08.com
- ns-1191.awsdns-20.org
- ns-1765.awsdns-28.co.uk
- ns-552.awsdns-05.net

Handoff: add four NS records to the existing pictureline.com DNS zone at Nexcess,
name medphoto, TTL 3600 (or provider default), one value per record above.
Do not replace the parent domain's ns1.nexcess.net / ns2.nexcess.net delegation.
If the UI takes an absolute record name, use medphoto.pictureline.com.
Parent DNS delegation remains pending; no public server address configured.
No dedicated practice servers launched, clinical migration performed or PHI used.
Current installed app remains 0.20.8 (independently verified earlier today).
No SDK changes; SDK main release remains 9341f62 / PR31.

Final AWS change readback: INSYNC. Screenshot evidence saved outside the vault
at /Users/chrismaxwell/MedPhoto-Launch-0.20.8/dns-zone-created.png.
