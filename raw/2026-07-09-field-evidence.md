# 2026-07-09 — Key field evidence (verbatim), R10 + R6 III debugging

## Port squatter (lsof, home network)
```
COMMAND   PID         USER   FD   TYPE             DEVICE SIZE/OFF NODE NAME
Spotify   668 chrismaxwell   88u  IPv4 ...      0t0  UDP *:1900
node    65813 chrismaxwell   18u  IPv4 ...      0t0  UDP *:1900
```
Later, after quitting Spotify (still no packets heard — led to TCC discovery):
```
node    70047 chrismaxwell   18u  IPv4 0x83612408f2302e77      0t0  UDP *:1900
```

## Firewall state
```
% /usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate
Firewall is disabled. (State = 0)
```

## macOS version
```
% sw_vers -productVersion
26.5.1
```

## Router filter (ping to gateway from 192.168.16.191)
```
92 bytes from 10.128.128.128: Communication prohibited by filter
Vr HL TOS  Len   ID Flg  off TTL Pro  cks      Src      Dst
 4  5  00 5400 26f9   0 0000  40  01 b19f 192.168.16.191  192.168.16.1
3 packets transmitted, 0 packets received, 100.0% packet loss
```

## tcpdump (earlier session): camera M-SEARCH arriving, unanswered
```
192.168.16.110.59177 > 239.255.255.250.1900: UDP, length 171   (every ~1s)
```

## R10/R6 III startup event chatter (both bodies)
```
[canon-ptp] unhandled EOS event 0xc1f6 (12B) payload: 00000000
[canon-ptp] unhandled EOS event 0xc18a (228B) payload: 02d10000030000003400...
[canon-ptp] unhandled EOS event 0xc18b (12B) payload: 01000000
[canon-ptp] unhandled EOS event 0xc185 (12B) payload: 01000200
```

## R6 Mark III object-added record (THE 0xc1b6 discovery)
```
[canon-ptp] unhandled EOS event 0xc1b6 (75B) payload:
c13420a30100020008b100000000000020000000d40e680200000000000020a3c03420a3f86f4e6a0d46003900310041
```
Decoded: oid 0xa32034c1 · storage 0x00020001 · format 0xb108 (CR3) ·
size 0x02680ed4 (~40.4 MB, u64) · parent 0xa3200000 · unix time 0x6a4e6ff8 ·
PTP-string filename "F91A..." → shipped as EosEvent.ObjectAddedEx3.

## First R6 III session proof (app screenshot, transcribed)
Session "r6 test" → captures/r6-test/2026-07-08T22-53-23/ ·
F91A0429.CR3 ✓ · F91A0430.CR3 ✓ · F91A0431.CR3 ✓ · F91A0433.CR3 transferring
