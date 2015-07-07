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

# 8. Add the Block Storage service

# 8.2 Install and configure a storage node
# (1) To configure prerequisites
# (1-1)Configure the management interface:
# IP address: 10.0.0.41
# Network mask: 255.255.255.0 (or /24)
# Default gateway: 10.0.0.1

# (1-2) Set the hostname of the node to block1.

# (1-3) Copy the contents of the /etc/hosts file from the controller node to the storage node and add the following to it:
#3# block1
# 10.0.0.41       block1

# (1-4) Install and configure NTP using the instructions in the section called “Other nodes”.

# (1-5) If you intend to use non-raw image types such as QCOW2 and VMDK, install the QEMU support package:
# yum install qemu-kvm qemu-img virt-manager libvirt libvirt-python python-virtinst libvirt-client virt-install virt-viewer
# yum -y install qemu
yum -y install qemu

# (1-6) Install the LVM packages:
yum -y install lvm2

# [Note]	Note
# Some distributions include LVM by default.

# (1-7) Start the LVM metadata service and configure it to start when the system boots:
systemctl enable lvm2-lvmetad.service
systemctl start lvm2-lvmetad.service


parted -s -a optimal /dev/sdb mklabel gpt -- mkpart extended ext4 1 -1 set 1 lvm on

mkfs -t ext4 /dev/sdb1 

# (1-8) Create the LVM physical volume /dev/sdb1:
pvcreate /dev/sdb1 <<!
y
!
# WARNING: ext4 signature detected on /dev/sdb1 at offset 1080. Wipe it? [y/n]:
# Y로 자동 처리

#  Physical volume "/dev/sdb1" successfully created

# (1-9) Create the LVM volume group cinder-volumes:
vgcreate cinder-volumes /dev/sdb1
#  Volume group "cinder-volumes" successfully created


# (1-10) Only instances can access Block Storage volumes. However, the underlying operating system manages the devices associated with the volumes. By default, the LVM volume scanning tool scans the /dev directory for block storage devices that contain volumes. If projects use LVM on their volumes, the scanning tool detects these volumes and attempts to cache them which can cause a variety of problems with both the underlying operating system and project volumes. You must reconfigure LVM to scan only the devices that contain the cinder-volume volume group. 
# Edit the /etc/lvm/lvm.conf file and complete the following actions:

# (1-10-a) In the devices section, add a filter that accepts the /dev/sdb device and rejects all other devices:
# devices {
# ...
# filter = [ "a/sdb/", "r/.*/"]

sed -i -e "s/devices {/devices {\n\tfilter = [ \"a\/sdb\/\"\, \"r\/\.\*\/\"\]/g" /etc/lvm/lvm.conf


# Each item in the filter array begins with a for accept or r for reject and includes a regular expression for the device name. The array must end with r/.*/ to reject any remaining devices. You can use the vgs -vvvv command to test filters.

# [Warning]	Warning
# If your storage nodes use LVM on the operating system disk, you must also add the associated device to the filter. For example, if the /dev/sda device contains the operating system:

# filter = [ "a/sda/", "a/sdb/", "r/.*/"]
# Similarly, if your compute nodes use LVM on the operating system disk, you must also modify the filter in the /etc/lvm/lvm.conf file on those nodes to include only the operating system disk. For example, if the /dev/sda device contains the operating system:

# filter = [ "a/sda/", "r/.*/"]
 

##################################################################################################################
# (2) Install and configure Block Storage volume components
# (2-1) Install the packages:
yum -y install openstack-cinder targetcli python-oslo-db python-oslo-log MySQL-python
#=================================================================================================
# (2-2) Edit the /etc/cinder/cinder.conf file and complete the following actions:
if [ ! -f /etc/cinder/cinder.conf ]; then
    touch /etc/cinder/cinder.conf
fi
# Add a [database] section, and configure database access:
crudini --set /etc/cinder/cinder.conf database connection mysql://cinder:${CINDER_DBPASS}@controller/cinder

# In the [DEFAULT] and [oslo_messaging_rabbit] sections, configure RabbitMQ message queue access:
# [DEFAULT]
crudini --set /etc/cinder/cinder.conf DEFAULT rpc_backend rabbit

# [oslo_messaging_rabbit]
crudini --set /etc/cinder/cinder.conf oslo_messaging_rabbit rabbit_host controller
crudini --set /etc/cinder/cinder.conf oslo_messaging_rabbit rabbit_userid openstack
crudini --set /etc/cinder/cinder.conf oslo_messaging_rabbit rabbit_password ${RABBIT_PASS}

# In the [DEFAULT] and [keystone_authtoken] sections, configure Identity service access:
# [DEFAULT]
crudini --set /etc/cinder/cinder.conf DEFAULT auth_strategy keystone

# [keystone_authtoken]
crudini --del /etc/nova/nova.conf keystone_authtoken

crudini --set /etc/cinder/cinder.conf keystone_authtoken auth_uri http://controller:5000
crudini --set /etc/cinder/cinder.conf keystone_authtoken auth_url http://controller:35357
crudini --set /etc/cinder/cinder.conf keystone_authtoken auth_plugin password
crudini --set /etc/cinder/cinder.conf keystone_authtoken project_domain_id default
crudini --set /etc/cinder/cinder.conf keystone_authtoken user_domain_id default
crudini --set /etc/cinder/cinder.conf keystone_authtoken project_name service
crudini --set /etc/cinder/cinder.conf keystone_authtoken username cinder
crudini --set /etc/cinder/cinder.conf keystone_authtoken password ${CINDER_PASS}

# In the [DEFAULT] section, configure the my_ip option to use the management interface IP address of the controller node:
# [DEFAULT]
crudini --set /etc/cinder/cinder.conf DEFAULT my_ip ${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_BLOCK1}

# In the [lvm] section, configure the LVM back end with the LVM driver, cinder-volumes volume group, iSCSI protocol, and appropriate iSCSI service:
# [lvm]
crudini --set /etc/cinder/cinder.conf lvm volume_driver cinder.volume.drivers.lvm.LVMVolumeDriver
crudini --set /etc/cinder/cinder.conf lvm volume_group cinder-volumes
crudini --set /etc/cinder/cinder.conf lvm iscsi_protocol iscsi
crudini --set /etc/cinder/cinder.conf lvm iscsi_helper lioadm

# In the [DEFAULT] section, enable the LVM back end:
# [DEFAULT]
crudini --set /etc/cinder/cinder.conf DEFAULT enabled_backends lvm

# In the [DEFAULT] section, configure the location of the Image service:
# [DEFAULT]
crudini --set /etc/cinder/cinder.conf DEFAULT glance_host controller


# In the [oslo_concurrency] section, configure the lock path:
crudini --set /etc/cinder/cinder.conf oslo_concurrency lock_path /var/lock/cinder

# (Optional) To assist with troubleshooting, enable verbose logging in the [DEFAULT] section:
crudini --set /etc/cinder/cinder.conf DEFAULT verbose True

# (3) To finalize installation

# (3-1) Start the Block Storage volume service including its dependencies and configure them to start when the system boots:
systemctl enable openstack-cinder-volume.service target.service
systemctl start openstack-cinder-volume.service target.service
echo "[BLOCK]===================================> start openstack-cinder-volume.service target.service"
while ! ( \
	(systemctl is-active openstack-cinder-volume.service >/dev/null 2>&1) && \
	(systemctl is-active target.service >/dev/null 2>&1) \
	)  do :; done
echo "[BLOCK]===================================> start openstack-cinder-volume.service target.service Done!"
# sleep 5
