## Below steps to create appformix VM's in RHOSP10+Contrail 4.1.1 Environment

### Execute below steps to run on undercloud VM
```
export LIBGUESTFS_BACKEND=direct
qemu-img create -f qcow2 -o preallocation=metadata appformix001.qcow2 100G
virt-resize --expand /dev/sda1 rhel-server-7.5-x86_64-kvm.qcow2 appformix001.qcow2 
```
