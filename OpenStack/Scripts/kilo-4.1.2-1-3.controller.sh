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

# Load Env global variables
. ./kilo-perform-vars.common.sh

# export DATABASE_ADMIN_PASS=pass_for_db
# export GLANCE_DBPASS=pass_for_db_glance
# export GLANCE_PASS=pass_for_glance
# (2) To install and configure the Image service components
# (2-1) Install the packages:
yum -y install openstack-glance python-glance python-glanceclient

# (2-2) Edit the /etc/glance/glance-api.conf file and complete the following actions:
# [database]
crudini --set /etc/glance/glance-api.conf database connection mysql://glance:${GLANCE_DBPASS}@controller/glance

# [keystone_authtoken]
crudini --del /etc/glance/glance-api.conf keystone_authtoken

crudini --set /etc/glance/glance-api.conf keystone_authtoken auth_uri http://controller:5000
crudini --set /etc/glance/glance-api.conf keystone_authtoken auth_url http://controller:35357
crudini --set /etc/glance/glance-api.conf keystone_authtoken auth_plugin password
crudini --set /etc/glance/glance-api.conf keystone_authtoken project_domain_id default
crudini --set /etc/glance/glance-api.conf keystone_authtoken user_domain_id default
crudini --set /etc/glance/glance-api.conf keystone_authtoken project_name service
crudini --set /etc/glance/glance-api.conf keystone_authtoken username glance
crudini --set /etc/glance/glance-api.conf keystone_authtoken password ${GLANCE_PASS}

# [paste_deploy]
crudini --set /etc/glance/glance-api.conf paste_deploy flavor keystone

# [glance_store]
crudini --set /etc/glance/glance-api.conf glance_store default_store file
crudini --set /etc/glance/glance-api.conf glance_store filesystem_store_datadir /var/lib/glance/images/

# [DEFAULT]
crudini --set /etc/glance/glance-api.conf DEFAULT notification_driver noop
crudini --set /etc/glance/glance-api.conf DEFAULT verbose True

# (2-3) Edit the /etc/glance/glance-registry.conf file and complete the following actions:
#[database]
crudini --set /etc/glance/glance-registry.conf database connection mysql://glance:${GLANCE_DBPASS}@controller/glance

# [keystone_authtoken]
crudini --del /etc/glance/glance-registry.conf keystone_authtoken

crudini --set /etc/glance/glance-registry.conf keystone_authtoken auth_uri http://controller:5000
crudini --set /etc/glance/glance-registry.conf keystone_authtoken auth_url http://controller:35357
crudini --set /etc/glance/glance-registry.conf keystone_authtoken auth_plugin password
crudini --set /etc/glance/glance-registry.conf keystone_authtoken project_domain_id default
crudini --set /etc/glance/glance-registry.conf keystone_authtoken user_domain_id default
crudini --set /etc/glance/glance-registry.conf keystone_authtoken project_name service
crudini --set /etc/glance/glance-registry.conf keystone_authtoken username glance
crudini --set /etc/glance/glance-registry.conf keystone_authtoken password ${GLANCE_PASS}
 
# [paste_deploy]
crudini --set /etc/glance/glance-registry.conf paste_deploy flavor keystone

# [DEFAULT]
crudini --set /etc/glance/glance-registry.conf DEFAULT notification_driver noop
crudini --set /etc/glance/glance-registry.conf DEFAULT verbose True

# (2-4) Populate the Image service database:
su -s /bin/sh -c "glance-manage db_sync" glance


# (3) To finalize installation
systemctl enable openstack-glance-api.service openstack-glance-registry.service
systemctl start openstack-glance-api.service openstack-glance-registry.service
# while ! systemctl is-active openstack-glance-api.service >/dev/null 2>&1; do :; done
# while ! systemctl is-active openstack-glance-registry.service >/dev/null 2>&1; do :; done
echo "[CONTROLLER]===================================> start openstack-glance-api.service openstack-glance-registry.service"
while ! ( \
	(systemctl is-active openstack-glance-api.service >/dev/null 2>&1) && \
	(systemctl is-active openstack-glance-registry.service >/dev/null 2>&1) \
	)  do :; done
echo "[CONTROLLER]===================================> start openstack-glance-api.service openstack-glance-registry.service Done!"
# sleep 3
