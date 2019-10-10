# On gluster nodes
yum update -y

yum search centos-release-gluster
yum install centos-release-gluster6.noarch -y
yum install glusterfs-server -y

# Create partition
wipefs /dev/sdb -a
fdisk /dev/sdb # Following by n-p-1-t-8e-p-w

# Create LV using LVM
pvcreate /dev/sdb1
vgcreate vg_gluster /dev/sdb1
lvcreate -L 5G -n database1 vg_gluster

# Format the LV using xfs
mkfs.xfs /dev/vg_gluster/database1

# Mount LV
mkdir -p /data/glusterfs/database/brick1
mount /dev/vg_gluster/database1 /data/glusterfs/database/brick1

# Persist mount on booting
echo '/dev/vg_gluster/database1 /data/glusterfs/database/brick1 xfs defaults 0 0' >> /etc/fstab

# Start glusterfs systemd
systemctl enable glusterd
systemctl start glusterd

# Add peer
gluster peer probe gluster-2

# Create volume
gluster volume create database replica 2 gluster-1:/data/glusterfs/database/brick1/brick gluster-2:/data/glusterfs/database/brick2/brick

# Start volume
gluster volume start database

##############################

# On worker node
yum update -y

yum search centos-release-gluster
yum install centos-release-gluster6.noarch -y
yum install glusterfs-fuse -y

# Enable fuse kernel module
modprobe fuse

# By default, SELinux does not allow writing from a pod to a remote GlusterFS server
setsebool -P virt_sandbox_use_fusefs on
setsebool -P virt_use_fusefs on
