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

# 5. Add the Compute service


# 5.2 Install and configure a compute node
# (1) To install and configure the Compute hypervisor components
# (1-1) Install the packages:
yum -y install openstack-nova-compute sysfsutils

# (1-2) Edit the /etc/nova/nova.conf file and complete the following actions:
if [ ! -f /etc/nova/nova.conf ]; then
    touch /etc/nova/nova.conf
fi
# Add a [database] section, and configure database access:
crudini --set /etc/nova/nova.conf database connection mysql://nova:${NOVA_DBPASS}@controller/nova
# In the [DEFAULT] and [oslo_messaging_rabbit] sections, configure RabbitMQ message queue access:
# [DEFAULT]
crudini --set /etc/nova/nova.conf DEFAULT rpc_backend rabbit

# [oslo_messaging_rabbit]
crudini --set /etc/nova/nova.conf oslo_messaging_rabbit rabbit_host controller
crudini --set /etc/nova/nova.conf oslo_messaging_rabbit rabbit_userid openstack
crudini --set /etc/nova/nova.conf oslo_messaging_rabbit rabbit_password ${RABBIT_PASS}

# In the [DEFAULT] and [keystone_authtoken] sections, configure Identity service access:
# [DEFAULT]
crudini --set /etc/nova/nova.conf DEFAULT auth_strategy keystone

# [keystone_authtoken]
crudini --del /etc/nova/nova.conf keystone_authtoken

crudini --set /etc/nova/nova.conf keystone_authtoken auth_uri http://controller:5000
crudini --set /etc/nova/nova.conf keystone_authtoken auth_url http://controller:35357
crudini --set /etc/nova/nova.conf keystone_authtoken auth_plugin password
crudini --set /etc/nova/nova.conf keystone_authtoken project_domain_id default
crudini --set /etc/nova/nova.conf keystone_authtoken user_domain_id default
crudini --set /etc/nova/nova.conf keystone_authtoken project_name service
crudini --set /etc/nova/nova.conf keystone_authtoken username nova
crudini --set /etc/nova/nova.conf keystone_authtoken password ${NOVA_PASS}

# In the [DEFAULT] section, configure the my_ip option to use the management interface IP address of the controller node:
crudini --set /etc/nova/nova.conf DEFAULT my_ip 10.0.0.31

# In the [DEFAULT] section, configure the VNC proxy to use the management interface IP address of the controller node:
crudini --set /etc/nova/nova.conf DEFAULT vnc_enabled True
crudini --set /etc/nova/nova.conf DEFAULT vncserver_listen 0.0.0.0
crudini --set /etc/nova/nova.conf DEFAULT vncserver_proxyclient_address 10.0.0.31
crudini --set /etc/nova/nova.conf DEFAULT novncproxy_base_url http://controller:6080/vnc_auto.html

# In the [glance] section, configure the location of the Image service:
crudini --set /etc/nova/nova.conf glance host controller

# In the [oslo_concurrency] section, configure the lock path:
crudini --set /etc/nova/nova.conf oslo_concurrency lock_path /var/lib/nova/tmp

# (Optional) To assist with troubleshooting, enable verbose logging in the [DEFAULT] section:
crudini --set /etc/nova/nova.conf DEFAULT verbose True

# (2) To finalize installation
# (2-1) Determine whether your compute node supports hardware acceleration for virtual machines:
egrep -c '(vmx|svm)' /proc/cpuinfo

## If this command returns a value of zero, your compute node does not support hardware acceleration and you must configure libvirt to use QEMU instead of KVM.
## crudini --set /etc/nova/nova.conf libvirt virt_type qemu

# (2-2) Start the Compute service including its dependencies and configure them to start automatically when the system boots:
systemctl enable libvirtd.service openstack-nova-compute.service
systemctl start libvirtd.service openstack-nova-compute.service
echo "[COMPUTE]===================================> start libvirtd.service openstack-nova-compute.service"
while ! ( \
	(systemctl is-active libvirtd.service >/dev/null 2>&1) && \
	(systemctl is-active openstack-nova-compute.service >/dev/null 2>&1) \
	)  do :; done
echo "[COMPUTE]===================================> start libvirtd.service openstack-nova-compute.service Done!"
# sleep 5
