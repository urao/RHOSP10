#!/bin/env bash
set -xv

source /home/stack/overcloudrc.v3

echo "Install openstack pkgs"
yum install -y gcc python-devel
pip install python-openstackclient

echo "Install wget packages"
yum install -y wget
cd /home/stack/images/
wget http://download.cirros-cloud.net/0.4.0/cirros-0.4.0-x86_64-disk.img
openstack image create "cirros" --disk-format qcow2 --container-format bare --public --file /home/stack/images/cirros-0.4.0-i386-disk.img 

glance image-list
openstack flavor create --ram 1024 --disk 20 --vcpus 1 --public small

#provide virutal-network name
VN_NAME="vn1"
VMNET=`neutron net-list | grep ${VN_NAME} | awk '{print $2}'`
echo $VMNET

echo "Boot cirros VM"
nova boot --image cirros --flavor small --nic net-id=$VMNET vm1
sleep 10s

nova list
