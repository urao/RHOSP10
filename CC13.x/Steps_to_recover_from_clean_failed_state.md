## Steps to recover a node from clean_failed state
```
openstack baremetal node list
openstack baremetal node maintenance unset <node_uuid> 
ironic --ironic-api-version 1.16 node-set-provision-state <node_uuid> abort
ironic --ironic-api-version 1.16 node-set-provision-state <node_uuid> manage
ironic --ironic-api-version 1.16 node-set-provision-state <node_uuid> available
ironic --ironic-api-version 1.16 node-set-provision-state <node_uuid> provide
openstack baremetal node list
```
