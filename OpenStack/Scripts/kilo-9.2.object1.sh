#!/bin/bash
#
# Werite by: Jeon.sungwook 
# Create Date : 2015-06-02
# Update Date : 2015-06-02
#
# OS : CentOS-7-x86_64 1503-01
# Node : controller 
# Text : OPENSTACK INSTALLATION GUIDE FOR RED HAT ENTERPRISE LINUX 7, CENTOS 7, AND FEDORA 21  - KILO
#
# Perform script for for the chapter 2. Basic environment
# 
# This script is to be installed and run on OpenStack Kilo
# 
# Set environment and declare global variables
# ============================================================================================

# =========================================================================
# 기본적으로 OS Setup 및 Network Setup이 완료되어야만 한다.
# =========================================================================
. ./kilo-perform-vars.common.sh

# ======================================================================================================
# export DATABASE_ADMIN_PASS=pass_for_db
# export NOVA_DBPASS=pass_for_db_nova
# export NOVA_PASS=pass_for_nova
# export RABBIT_PASS=pass_for_mq

# 9.2 Install and configure the storage nodes
# 9.2.1 To configure prerequisites
# (1) Configure unique items on the first storage node:
# (2) Configure unique items on the second storage node:
# (3) Configure shared items on both storage nodes:
# (3-1) Copy the contents of the /etc/hosts file from the controller node and add the following to it:
# (3-2) Install and configure NTP using the instructions in the section called “Other nodes”.
# (3-3) Install the supporting utility packages:
yum -y install xfsprogs rsync

parted -s -a optimal /dev/sdb mklabel gpt -- mkpart extended ext4 1 -1 set 1 lvm on
parted -s -a optimal /dev/sdc mklabel gpt -- mkpart extended ext4 1 -1 set 1 lvm on

# (3-4) Format the /dev/sdb1 and /dev/sdc1 partitions as XFS:
mkfs.xfs /dev/sdb1
mkfs.xfs /dev/sdc1

# (3-5) Create the mount point directory structure:
mkdir -p /srv/node/sdb1
mkdir -p /srv/node/sdc1

# (3-6) Edit the /etc/fstab file and add the following to it:
cat << EOF >> /etc/fstab 
/dev/sdb1 /srv/node/sdb1 xfs noatime,nodiratime,nobarrier,logbufs=8 0 2
/dev/sdc1 /srv/node/sdc1 xfs noatime,nodiratime,nobarrier,logbufs=8 0 2
EOF

# (3-7) Mount the devices:
mount /srv/node/sdb1
mount /srv/node/sdc1


# (4) Edit the /etc/rsyncd.conf file and add the following to it:
cat << EOF >> /etc/rsyncd.conf
uid = swift
gid = swift
log file = /var/log/rsyncd.log
pid file = /var/run/rsyncd.pid
address = ${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT1}
 
[account]
max connections = 2
path = /srv/node/
read only = false
lock file = /var/lock/account.lock
 
[container]
max connections = 2
path = /srv/node/
read only = false
lock file = /var/lock/container.lock
 
[object]
max connections = 2
path = /srv/node/
read only = false
lock file = /var/lock/object.lock
EOF



# (5) Start the rsyncd service and configure it to start when the system boots:
systemctl enable rsyncd.service
systemctl start rsyncd.service
echo "[OBJECT]===================================> start rsyncd.service"
while ! (systemctl is-active rsyncd.service >/dev/null 2>&1)  do :; done
echo "[OBJECT]===================================> start rsyncd.service Done!"

# 9.2.2 Install and configure storage node components
# (1) Install the packages:
yum -y install openstack-swift-account openstack-swift-container openstack-swift-object
# (2) Obtain the accounting, container, object, container-reconciler, and object-expirer service configuration files from the Object Storage source repository:
curl -o /etc/swift/account-server.conf \
  https://git.openstack.org/cgit/openstack/swift/plain/etc/account-server.conf-sample?h=stable/kilo

curl -o /etc/swift/container-server.conf \
  https://git.openstack.org/cgit/openstack/swift/plain/etc/container-server.conf-sample?h=stable/kilo

curl -o /etc/swift/object-server.conf \
  https://git.openstack.org/cgit/openstack/swift/plain/etc/object-server.conf-sample?h=stable/kilo 

curl -o /etc/swift/container-reconciler.conf \
  https://git.openstack.org/cgit/openstack/swift/plain/etc/container-reconciler.conf-sample?h=stable/kilo

curl -o /etc/swift/object-expirer.conf \
  https://git.openstack.org/cgit/openstack/swift/plain/etc/object-expirer.conf-sample?h=stable/kilo

# (3) Edit the /etc/swift/account-server.conf file and complete the following actions:
# (3-1) In the [DEFAULT] section, configure the bind IP address, bind port, user, configuration directory, and mount point directory:
# [DEFAULT]
crudini --set /etc/swift/account-server.conf DEFAULT bind_ip ${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT1}
crudini --set /etc/swift/account-server.conf DEFAULT bind_port 6002
crudini --set /etc/swift/account-server.conf DEFAULT user swift
crudini --set /etc/swift/account-server.conf DEFAULT swift_dir /etc/swift
crudini --set /etc/swift/account-server.conf DEFAULT devices /srv/node

# (3-2) In the [pipeline:main] section, enable the appropriate modules:
# [pipeline:main]
crudini --set /etc/swift/account-server.conf pipeline:main pipeline 'healthcheck recon account-server'

# (3-3) In the [filter:recon] section, configure the recon (metrics) cache directory:
# [filter:recon]
crudini --set /etc/swift/account-server.conf filter:recon recon_cache_path /var/cache/swift

# (4) Edit the /etc/swift/container-server.conf file and complete the following actions:
# (4-1) In the [DEFAULT] section, configure the bind IP address, bind port, user, configuration directory, and mount point directory:
# [DEFAULT]
crudini --set /etc/swift/container-server.conf DEFAULT bind_ip ${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT1}
crudini --set /etc/swift/container-server.conf DEFAULT bind_port 6001
crudini --set /etc/swift/container-server.conf DEFAULT user swift
crudini --set /etc/swift/container-server.conf DEFAULT swift_dir /etc/swift
crudini --set /etc/swift/container-server.conf DEFAULT devices /srv/node

# (4-2) In the [pipeline:main] section, enable the appropriate modules:
#[pipeline:main]
crudini --set /etc/swift/container-server.conf pipeline:main pipeline 'healthcheck recon container-server'

# (4-3) IIn the [filter:recon] section, configure the recon (metrics) cache directory:
# [filter:recon]
crudini --set /etc/swift/container-server.conf filter:recon recon_cache_path /var/cache/swift

# (5) Edit the /etc/swift/object-server.conf file and complete the following actions:
# (5-1) In the [DEFAULT] section, configure the bind IP address, bind port, user, configuration directory, and mount point directory:
# [DEFAULT]
crudini --set /etc/swift/object-server.conf DEFAULT bind_ip ${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT1}
crudini --set /etc/swift/object-server.conf DEFAULT bind_port 6000
crudini --set /etc/swift/object-server.conf DEFAULT user swift
crudini --set /etc/swift/object-server.conf DEFAULT swift_dir /etc/swift
crudini --set /etc/swift/object-server.conf DEFAULT devices /srv/node

# (5-2) In the [pipeline:main] section, enable the appropriate modules:
# [pipeline:main]

crudini --set /etc/swift/object-server.conf pipeline:main pipeline 'healthcheck recon object-server'

# (5-3) In the [filter:recon] section, configure the recon (metrics) cache and lock directories:
# [filter:recon]
crudini --set /etc/swift/object-server.conf filter:recon recon_cache_path /var/cache/swift
crudini --set /etc/swift/object-server.conf filter:recon recon_lock_path /var/lock

# (6) Ensure proper ownership of the mount point directory structure:
chown -R swift:swift /srv/node

# (7) Create the recon directory and ensure proper ownership of it:
mkdir -p /var/cache/swift
chown -R swift:swift /var/cache/swift

# SELinux restore context 
restorecon -R /srv
restorecon -R /var/cache/swift

# 9.3 Create initial rings
# 9.4 Finalize installation
# 9.5 Verify operation
