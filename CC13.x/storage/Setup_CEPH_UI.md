## Steps to configure CEPH Dashboard on RHOSP13
#### Tested on Redhat 7.6 ES
0) Assuming that RHOSP13 cluster is UP with CEPH Nodes
1) Following steps to be done the active OpenStack controller if deployed in HA
```
ceph mgr module ls
ceph mgr module enable dashboard
ceph mgr module enable balancer
ceph mgr module enable restful
ceph mgr module ls
```
2) Check the IP and port number(Default 7000)
```
ceph mgr services
```
3) Debug command
```
ceph mgr dump
```
4) If no specific address has been configured, the web app will bind to ::
   which corresponds to all available IPv4 and IPv6 address
5) You can change to specify IP address and port, by following on single instance
   of manager
```
ceph config set mgr mgr/dashboard/server_addr $IP
ceph config set mgr mgr/dashboard/server_port $PORT
```
6) Set Login credentials
```
ceph dashboard set-login-credentials <username> <password>
```
7) Test UI
```
curl -g -6 http://[fd00:fd00:fd00:3001::15]:7000 | wc -l
```

## Reference
[CEPH DASHBOARD](http://docs.ceph.com/docs/mimic/mgr/dashboard/)
