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
# 8.3 Verify operation
# (1) In each client environment script, configure the Block Storage client to use API version 2.0:
echo "export OS_VOLUME_API_VERSION=2" | tee -a ~student/env/admin-openrc.sh ~student/env/demo-openrc.sh
# (2) Source the admin credentials to gain access to admin-only CLI commands:
source ~student/env/admin-openrc.sh
# (3) List service components to verify successful launch of each process:
cinder service-list
# (4) Source the demo credentials to perform the following steps as a non-administrative project:
source ~student/env/demo-openrc.sh
# (5) Create a 1 GB volume:
cinder create --name demo-volume1 1
# (6) Verify creation and availability of the volume:
cinder list
