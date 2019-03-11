## Cheat sheet with DISK and LVM commands to execute on node
#### Tested on Redhat 7.6 ES
1) Below commands provides info about SCSI devices on the node
```
lsscsi
lsscsi -s    << Disk size
lsscsi -Ht   << Disk type
lsscsi -g 
```
2) Basic DISK partitions utility commands
```
sudo fdisk -l  << Basic command to check partitions on a disk
sudo sfdisk -l -uM
sudo parted -l
df -h << Mounted file system
df -T
df -hT
lsblk << Lists all storage blocks, includes disk partitions
blkid << Prints block device attributes UUID, FS type etc.
```
3) Check the root disk on host
```
cat /proc/cmdline | grep root
Check the UUID using the command blkid to which device its mapped
``` 
4) LVM commands
During CC13 deployment of controller which are installed as VM's, admin
has option to create LVM's out of the logical disks to provide enough storage
for the controller VMs, below commands can be useful.
```
###Directories
/etc/lvm
/etc/lvm/backup
/etc/lvm/archive
```


## Reference
[lsscsi command List](http://sg.danny.cz/scsi/lsscsi.html)

[Hard Disk Commands](https://www.binarytides.com/linux-command-check-disk-partitions/)

