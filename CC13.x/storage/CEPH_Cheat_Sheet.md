## Cheat sheet with CEPH commands to execute on controller
#### Tested on Redhat 7.6 ES
1) Check cluster health
```
ceph version
ceph health
ceph status || ceph -w
ceph quorum_status --format json-pretty
ceph -s
```
2) Check cluster usage stats
```
ceph df
```
3) Check placement group (pg) stats 
```
ceph pg dump
ceph pg stat
``` 
4) View CRUSH map
```
ceph osd tree
ceph osd stat
ceph osd dump
```
5) List cluster keys
```
ceph auth list
```
6) List all pools
```
ceph osd lspools
ceph osd ls
```
7) Ceph Monitor Maps 
```
ceph mon stat
ceph mon dump
```
8) Check OSD is encrypted 
```
lsblk -i
```
