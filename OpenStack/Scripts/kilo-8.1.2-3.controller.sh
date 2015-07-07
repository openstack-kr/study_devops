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

# 8. Add the Block Storage service
# 8.1 Install and configure controller node
 
# (2) To install and configure Block Storage controller components
# (2-1) Install the packages:
yum -y install openstack-cinder python-cinderclient python-oslo-db
# (2-2) Copy the /usr/share/cinder/cinder-dist.conf file to /etc/cinder/cinder.conf.
cp /usr/share/cinder/cinder-dist.conf /etc/cinder/cinder.conf
chown -R cinder:cinder /etc/cinder/cinder.conf

# (2-3) Edit the /etc/cinder/cinder.conf file and complete the following actions:
# if [ ! -f /etc/cinder/cinder.conf ]; then
#     touch /etc/cinder/cinder.conf
# fi

# In the [database] section, configure database access:
# [database]
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
crudini --del /etc/cinder/cinder.conf keystone_authtoken

crudini --set /etc/cinder/cinder.conf keystone_authtoken auth_uri http://controller:5000
crudini --set /etc/cinder/cinder.conf keystone_authtoken auth_url http://controller:35357
crudini --set /etc/cinder/cinder.conf keystone_authtoken auth_plugin password
crudini --set /etc/cinder/cinder.conf keystone_authtoken project_domain_id default
crudini --set /etc/cinder/cinder.conf keystone_authtoken user_domain_id default
crudini --set /etc/cinder/cinder.conf keystone_authtoken project_name service
crudini --set /etc/cinder/cinder.conf keystone_authtoken username cinder
crudini --set /etc/cinder/cinder.conf keystone_authtoken password ${CINDER_PASS}

 
# In the [DEFAULT] section, configure the my_ip option to use the management interface IP address of the controller node:
crudini --set /etc/cinder/cinder.conf DEFAULT my_ip 10.0.0.11

# In the [oslo_concurrency] section, configure the lock path:
crudini --set /etc/cinder/cinder.conf oslo_concurrency lock_path /var/lock/cinder

# (Optional) To assist with troubleshooting, enable verbose logging in the [DEFAULT] section:
crudini --set /etc/cinder/cinder.conf DEFAULT verbose True

# (2-4) To finalize installation
su -s /bin/sh -c "cinder-manage db sync" cinder

# (3) To finalize installation
systemctl enable openstack-cinder-api.service openstack-cinder-scheduler.service

systemctl start openstack-cinder-api.service openstack-cinder-scheduler.service
echo "[CONTROLLER]===================================> start openstack-cinder-api.service openstack-cinder-scheduler.service"
while ! ( \
	(systemctl is-active openstack-cinder-api.service >/dev/null 2>&1) && \
	(systemctl is-active openstack-cinder-scheduler.service >/dev/null 2>&1) \
	)  do :; done
echo "[CONTROLLER]===================================> start openstack-cinder-api.service openstack-cinder-scheduler.service Done!"
# sleep 5
