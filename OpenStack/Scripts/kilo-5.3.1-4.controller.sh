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
# 5.3 Verify operation
# (1) Source the admin credentials to gain access to admin-only CLI commands:
source ~student/env/admin-openrc.sh
# (2) List service components to verify successful launch and registration of each process:
nova service-list
# (3) List API endpoints in the Identity service to verify connectivity with the Identity service:
nova endpoints
# (4) List images in the Image service catalog to verify connectivity with the Image service:
nova image-list
