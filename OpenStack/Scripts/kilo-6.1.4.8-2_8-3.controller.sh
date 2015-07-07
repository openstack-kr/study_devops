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

# export DATABASE_ADMIN_PASS=pass_for_db
# export NEUTRON_DBPASS=pass_for_db_neutron
# export NEUTRON_PASS=pass_for_neutron
# export RABBIT_PASS=pass_for_mq
# export NOVA_PASS=pass_for_nova
# export INSTANCE_TUNNELS_INTERFACE_IP_ADDRESS=10.0.1.21
# export METADATA_SECRET=metadata_secret

# ============================================================================================
# 6 Add a networking component
# 6.1 OpenStack Networking (neutron)
# 6.1.1 OpenStack Networking
# 6.1.2 Networking concepts
# 6.1.3 Install and configure controller node
# 6.1.4 Install and configure network node
# (8-2) On the controller node, edit the /etc/nova/nova.conf file and complete the following action:
# (8-2-1) In the [neutron] section, enable the metadata proxy and configure the secret:
# [neutron]
crudini --set /etc/nova/nova.conf neutron service_metadata_proxy True
crudini --set /etc/nova/nova.conf neutron metadata_proxy_shared_secret ${METADATA_SECRET}

# (8-3) On the controller node, restart the Compute API service:
systemctl restart openstack-nova-api.service
echo "[CONTROLLER]===================================> restart openstack-nova-api.service"
sleep 2
while ! (systemctl is-active openstack-nova-api.service >/dev/null 2>&1)  do :; done
echo "[CONTROLLER]===================================> restart openstack-nova-api.service Done!"
