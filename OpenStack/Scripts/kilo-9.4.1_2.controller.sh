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
# export OBJECT_NODE_DEVICE_NAME=/dev/sdb1
# export OBJECT_NODE_DEVICE_WEIGHT=100

# ============================================================================================
# 9. Add Object Storage

# 9.4 Finalize installation
# 9.4.1 Configure hashes and default storage policy

# (1) Obtain the /etc/swift/swift.conf file from the Object Storage source repository:

curl -o /etc/swift/swift.conf \
  https://git.openstack.org/cgit/openstack/swift/plain/etc/swift.conf-sample?h=stable/kilo

# (2) Edit the /etc/swift/swift.conf file and complete the following actions:
# (2-1) In the [swift-hash] section, configure the hash path prefix and suffix for your environment.
# [swift-hash]
crudini --set /etc/swift/swift.conf swift-hash swift_hash_path_suffix $(openssl rand -hex 10)
crudini --set /etc/swift/swift.conf swift-hash swift_hash_path_prefix $(openssl rand -hex 10)
# Replace HASH_PATH_PREFIX and HASH_PATH_SUFFIX with unique values.

# (2-2) In the [storage-policy:0] section, configure the default storage policy:
# [storage-policy:0]
crudini --set /etc/swift/swift.conf storage-policy:0 name Policy-0
crudini --set /etc/swift/swift.conf storage-policy:0 default yes
