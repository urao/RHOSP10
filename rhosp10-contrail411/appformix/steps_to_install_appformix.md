### Steps to create Appformix VM's in RHOSP10+Contrail 4.1.1 Environment

1. Execute on the host on which you want to create Appformix VM
```
export LIBGUESTFS_BACKEND=direct
qemu-img create -f qcow2 -o preallocation=metadata appformix001.qcow2 100G
virt-resize --expand /dev/sda1 rhel-server-7.5-x86_64-kvm.qcow2 appformix001.qcow2 
virt-customize -a appformix001.qcow2 --hostname appformix001 --timezone America/Los_Angeles \
--run-command 'xfs_growfs /' --root-password password:test123! \
--run-command 'sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config' \
--run-command 'systemctl enable sshd' --run-command 'yum remove -y cloud-init' 
--selinux-relabel

#Create interface configuration, for controlplane, internal_api, external networks
virt-customize -a appformix001.qcow2 --run-command 'cat << EOF /etc/sysconfig/network-scripts/ifcfg-eth0
DEVICE=eth0
ONBOOT=yes
HOTPLUG=no
NM_CONTROLLED=no
PEERDNS=no
BOOTPROTO=static
IPADDR=10.74.255.10
NETMASK=255.255.255.224
EOF'
virt-install --ram 32768 --vcpus 4 --os-variant rhel7 \
 --disk path=/var/lib/libvirt/images/appformix001.qcow2,device=disk,bus=virtio,format=qcow2 \
 --noautoconsole --vnc --bridge br-eno1 --bridge br_bond0 --name appformix001 \
 --cpu SandyBridge,+vmx --dry-run --print-xml > /tmp/appformix001.xml
virsh define /tmp/appformix001.xml 
virsh start appformix001
```
2. After VM boots up, set environment variables http_proxy and https_proxy with IP:port information if overcloud
   deployment is behind proxy
```
export http_proxy=http://<IP>:Port
```
3. Do RHEL subscription
```
subscription-manager register --username <user_name> --password <password>
sudo subscription-manager attach --pool=<pool_id>
sudo subscription-manager repos --disable=*
sudo subscription-manager repos --enable=rhel-7-server-rpms --enable=rhel-7-server-extras-rpms --enable=rhel-7-server-rh-common-rpms --enable=rhel-ha-for-rhel-7-server-rpms --enable=rhel-7-server-openstack-10-rpms --enable=rhel-7-server-openstack-10-devtools-rpms
```
4. Install required packages
```
sudo rpm -Uvh --replacepkgs https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum install -y python-pip python-devel
sudo yum groupinstall 'Development Tools'
pip install ansible==2.3 markupsafe httplib2
```
5. Download [appformix packages](https://www.juniper.net/support/downloads/?p=appformix) and copy license file under images folder
```
mkdir ~/images
appformix-platform-images-2.15.3.tar.gz
appformix-2.15.3-license.sig
appformix-2.15.3.tar.gz
appformix-dependencies-images-2.15.3.tar.gz packages
appformix-openstack-images-2.15.3.tar.gz
```
6. Create inventory files (sample [here](https://github.com/urao/RHOSP/tree/master/rhosp10-contrail411/appformix/inventory))
```
mkdir ~/inventory/
mkdir ~/inventory/group_vars/
touch ~/inventory/hosts
touch ~/inventory/group_vars/all
```
7. Run ansible-playbooks
```
yes y |ssh-keygen -q -t rsa -N '' >/dev/null
copy id_rsa, id_rsa.pub keys from undercloud VM on to this VM under ~/.ssh/ folder
ssh-copy-id root@<external-ip>
tar -zxvf appformix-2.15.3.tar.gz
cd appformix-2.15.3
copy overcloudrc file from undercloud VM on to this VM ~/
egrep 'OS_PASSWORD|OS_AUTH_URL|OS_USERNAME|OS_IDENTITY_API_VERSION' overcloudrc > ~/openrc
echo 'export OS_TENANT_NAME=admin' >> ~/openrc
source ~/openrc
ansible-playbook -i ~/inventory/ appformix_openstack.yml  
ansible-playbook -i ~/inventory/ appformix_openstack_ha.yml   <======== Appformix in HA cluster
```
8. Access Appformix UI
```
http://<external_ip>:9000
```
8. Cleanup Appformix install
```
cd appformix-2.15.3
ansible-playbook -i ~/inventory/ clean_appformix_openstack.yml  
```
