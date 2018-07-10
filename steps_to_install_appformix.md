## Below steps will create appformix VM's in RHOSP10+Contrail 4.1.1 Environment

# Execute below steps on undercloud VM
```
export LIBGUESTFS_BACKEND=direct
qemu-img create -f qcow2 -o preallocation=metadata /var/lib/libvirt/images/appformix001.qcow2 100G
virt-resize --expand /dev/sda1 rhel-server-7.5-x86_64-kvm.qcow2 /var/lib/libvirt/instances/appformix001.qcow2 
```
