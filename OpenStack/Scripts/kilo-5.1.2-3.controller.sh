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

# 5. Add the Compute service
# 5.1 Install and configure controller node
 
# (2) To install and configure Compute controller components
# (2-1) Install the packages:
yum -y install openstack-nova-api openstack-nova-cert openstack-nova-conductor \
  openstack-nova-console openstack-nova-novncproxy openstack-nova-scheduler \
  python-novaclient
# (2-2) Edit the /etc/nova/nova.conf file and complete the following actions:
if [ ! -f /etc/nova/nova.conf ]; then
    touch /etc/nova/nova.conf
fi
# Add a [database] section, and configure database access:
crudini --set /etc/nova/nova.conf database connection mysql://nova:${NOVA_DBPASS}@controller/nova
# In the [DEFAULT] and [oslo_messaging_rabbit] sections, configure RabbitMQ message queue access:
crudini --set /etc/nova/nova.conf DEFAULT rpc_backend rabbit

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
crudini --set /etc/nova/nova.conf DEFAULT my_ip 10.0.0.11

# In the [DEFAULT] section, configure the VNC proxy to use the management interface IP address of the controller node:
crudini --set /etc/nova/nova.conf DEFAULT vncserver_listen 10.0.0.11
crudini --set /etc/nova/nova.conf DEFAULT vncserver_proxyclient_address 10.0.0.11

# In the [glance] section, configure the location of the Image service:
crudini --set /etc/nova/nova.conf glance host controller

# In the [oslo_concurrency] section, configure the lock path:
crudini --set /etc/nova/nova.conf oslo_concurrency lock_path /var/lib/nova/tmp

# (Optional) To assist with troubleshooting, enable verbose logging in the [DEFAULT] section:
crudini --set /etc/nova/nova.conf DEFAULT verbose True

# (2-3) To finalize installation
su -s /bin/sh -c "nova-manage db sync" nova

# (3) To finalize installation
systemctl enable openstack-nova-api.service openstack-nova-cert.service \
  openstack-nova-consoleauth.service openstack-nova-scheduler.service \
  openstack-nova-conductor.service openstack-nova-novncproxy.service

systemctl start openstack-nova-api.service openstack-nova-cert.service \
  openstack-nova-consoleauth.service openstack-nova-scheduler.service \
  openstack-nova-conductor.service openstack-nova-novncproxy.service
echo "[CONTROLLER]===================================> start openstack-nova-api.service openstack-nova-cert.service openstack-nova-consoleauth.service openstack-nova-scheduler.service openstack-nova-conductor.service openstack-nova-novncproxy.service"
while ! ( \
	(systemctl is-active openstack-nova-api.service >/dev/null 2>&1) && \
	(systemctl is-active openstack-nova-cert.service >/dev/null 2>&1) && \
	(systemctl is-active openstack-nova-consoleauth.service >/dev/null 2>&1) && \
	(systemctl is-active openstack-nova-scheduler.service >/dev/null 2>&1) && \
	(systemctl is-active openstack-nova-conductor.service >/dev/null 2>&1) && \
	(systemctl is-active openstack-nova-novncproxy.service >/dev/null 2>&1) \
	)  do :; done
echo "[CONTROLLER]===================================> start openstack-nova-api.service openstack-nova-cert.service openstack-nova-consoleauth.service openstack-nova-scheduler.service openstack-nova-conductor.service openstack-nova-novncproxy.service Done!"
# sleep 5
