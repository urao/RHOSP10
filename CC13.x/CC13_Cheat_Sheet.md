## Cheat sheet to run useful commands on CC13.x deployment cluster 
#### Tested on Redhat 7.6 ES + RHOSP13 + CN 5.x

1) Below are some of the useful commands 
```
/var/log/contrail_cloud/*         << Log location on undercloud VM
/var/log/contrail_cloud/*         << Ansible logs on Jumphost 
sudo vbmc list                    << Run on controller hosts to check port#
yum list installed | grep cloud   << Version of CC installed
/var/log/mistral/*.log            << Mistral logs on undercloud
tailf /var/log/contrail_cloud/create-stack.log  << Check progress of the stack creation on undercloud VM
```
2) Introspection data for all the nodes is saved, check in
```
ls -l /var/lib/contrail_cloud/introspection/*.introspection
yum install jq -y
Example: 
cat ceph-host003.introspection |  jq .inventory.disks
cat ceph-host003.introspection |  jq .root_disk
```
3) Cleanup the overcloud, step by step from jumphost
```
/var/lib/contrail_cloud/scripts/openstack-deploy.sh -c
/var/lib/contrail_cloud/scripts/storage-nodes-assign.sh -c
/var/lib/contrail_cloud/scripts/compute-nodes-assign.sh -c
/var/lib/contrail_cloud/scripts/control-vms-deploy.sh -c
/var/lib/contrail_cloud/scripts/control-hosts-deploy.sh -c
/var/lib/contrail_cloud/scripts/inventory-assign.sh -c
```

## Reference
[CC13 Deployment](https://www.juniper.net/documentation/en_US/contrail5.0/information-products/pathway-pages/contrail-cloud-deployment-guide-13.0.pdf)
