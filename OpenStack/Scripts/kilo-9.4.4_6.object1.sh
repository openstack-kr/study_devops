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

# export INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT1=10.0.0.51
# export OBJECT_NODE_DEVICE_NAME=sdb1
# export OBJECT_NODE_DEVICE_WEIGHT=100
# export HASH_PATH_SUFFIX=143-12-e234-fa448a3
# export HASH_PATH_PREFIX=233-72-4ea4-23fe442
# ============================================================================================
# 9. Add Object Storage

# 9.4 Finalize installation
# 9.4.1 Configure hashes and default storage policy

# (4)On all nodes, ensure proper ownership of the configuration directory:
chown -R swift:swift /etc/swift


# JSW : 방화벽 포트 열기 필요
firewall-cmd --zone=public --add-port=8080/tcp --permanent
firewall-cmd --zone=public --add-port=6000-6002/tcp --permanent
systemctl reload firewalld

# (6) On the storage nodes, start the Object Storage services and configure them to start when the system boots:

systemctl enable openstack-swift-account.service openstack-swift-account-auditor.service \
  openstack-swift-account-reaper.service openstack-swift-account-replicator.service
systemctl start openstack-swift-account.service openstack-swift-account-auditor.service \
  openstack-swift-account-reaper.service openstack-swift-account-replicator.service
systemctl enable openstack-swift-container.service openstack-swift-container-auditor.service \
  openstack-swift-container-replicator.service openstack-swift-container-updater.service
systemctl start openstack-swift-container.service openstack-swift-container-auditor.service \
  openstack-swift-container-replicator.service openstack-swift-container-updater.service
systemctl enable openstack-swift-object.service openstack-swift-object-auditor.service \
  openstack-swift-object-replicator.service openstack-swift-object-updater.service
systemctl start openstack-swift-object.service openstack-swift-object-auditor.service \
  openstack-swift-object-replicator.service openstack-swift-object-updater.service
