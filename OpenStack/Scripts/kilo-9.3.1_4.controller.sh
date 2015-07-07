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
# export OBJECT_NODE_DEVICE_NAME1=sdb1
# export OBJECT_NODE_DEVICE_NAME2=sdc1
# export OBJECT_NODE_DEVICE_WEIGHT=100

# export HASH_PATH_SUFFIX=3f7729b4cc8e1678c281
# export HASH_PATH_PREFIX=1f41c1c706040713ffcf

# ============================================================================================
# 9. Add Object Storage
# 9.2 Install and configure the storage nodes
# 9.3 Create initial rings
# 9.3.1 Account ring
# (1) To create the ring
# (1-1) Change to the /etc/swift directory.
cd /etc/swift
# (1-2) Create the base account.builder file::
swift-ring-builder account.builder create 10 3 1

# (1-3) Add each storage node to the ring:

swift-ring-builder account.builder \
	add r1z1-${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT1}:6002/${OBJECT_NODE_DEVICE_NAME1} ${OBJECT_NODE_DEVICE_WEIGHT}

swift-ring-builder account.builder \
	add r1z2-${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT1}:6002/${OBJECT_NODE_DEVICE_NAME2} ${OBJECT_NODE_DEVICE_WEIGHT}

# (1-4) Verify the ring contents:

swift-ring-builder account.builder
# (1-5) Rebalance the ring:

swift-ring-builder account.builder rebalance
# Reassigned 1024 (100.00%) partitions. Balance is now 0.00.  Dispersion is now 0.00

# 9.3.2 Container ring
# (1) To create the ring
# (1-1) Change to the /etc/swift directory.
cd /etc/swift
# (1-2) Create the base container.builder file::
swift-ring-builder container.builder create 10 3 1

# (1-3) Add each storage node to the ring:

swift-ring-builder container.builder \
	add r1z1-${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT1}:6002/${OBJECT_NODE_DEVICE_NAME1} ${OBJECT_NODE_DEVICE_WEIGHT}

swift-ring-builder container.builder \
	add r1z2-${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT1}:6002/${OBJECT_NODE_DEVICE_NAME2} ${OBJECT_NODE_DEVICE_WEIGHT}

# (1-4) Verify the ring contents:

swift-ring-builder container.builder
# (1-5) Rebalance the ring:

swift-ring-builder container.builder rebalance
# Reassigned 1024 (100.00%) partitions. Balance is now 0.00.  Dispersion is now 0.00


# 9.3.3 Object ring
# (1) To create the ring
# (1-1) Change to the /etc/swift directory.
cd /etc/swift
# (1-2) Create the base object.builder file::
swift-ring-builder object.builder create 10 3 1

# (1-3) Add each storage node to the ring:

swift-ring-builder object.builder \
	add r1z1-${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT1}:6002/${OBJECT_NODE_DEVICE_NAME1} ${OBJECT_NODE_DEVICE_WEIGHT}

swift-ring-builder object.builder \
	add r1z2-${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT1}:6002/${OBJECT_NODE_DEVICE_NAME2} ${OBJECT_NODE_DEVICE_WEIGHT}

# (1-4) Verify the ring contents:

swift-ring-builder object.builder
# (1-5) Rebalance the ring:

swift-ring-builder object.builder rebalance
# Reassigned 1024 (100.00%) partitions. Balance is now 0.00.  Dispersion is now 0.00

# 9.3.4 Distribute ring configuration files
# Copy the account.ring.gz, container.ring.gz, and object.ring.gz files to the /etc/swift directory on each storage node and any additional nodes running the proxy service.
# kilo-step-09.sh에서 수행
