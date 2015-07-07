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
# 9.5 Verify operation

# (1) Source the demo credentials:
source ~student/env/demo-openrc.sh

# (2) Show the service status:
swift -V 3 stat

# (3) Upload a test file:
cat << EOF >>  ~student/testfile.txt
testdata
EOF

swift -V 3 upload demo-container1 ~student/testfile.txt
#Replace FILE with the name of a local file to upload to the demo-container1 container.

# (4) List containers:
swift -V 3 list

# (5) Download a test file:
swift -V 3 download demo-container1 testfile.txt
# Replace FILE with the name of the file uploaded to the demo-container1 container.
