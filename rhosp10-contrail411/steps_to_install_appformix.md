### Steps to create Appformix VM's in RHOSP10+Contrail 4.1.1 Environment

#### Steps to run on undercloud VM
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
If the deployment is behind proxy, set environment variables with IP:port information
```
export http_proxy=http://<IP>:Port
```
