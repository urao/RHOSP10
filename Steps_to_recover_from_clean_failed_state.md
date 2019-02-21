## Steps to recover from clean_failed state
1.)openstack baremetal node list
2.)openstack baremetal node maintenance unset <node_uuid> 
3.)ironic --ironic-api-version 1.16 node-set-provision-state <node_uuid> abort
4.)ironic --ironic-api-version 1.16 node-set-provision-state <node_uuid> manage
5.)ironic --ironic-api-version 1.16 node-set-provision-state <node_uuid> available
6.)ironic --ironic-api-version 1.16 node-set-provision-state <node_uuid> provide
7.)openstack baremetal node list

