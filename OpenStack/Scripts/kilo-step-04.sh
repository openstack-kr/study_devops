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

# ============================================================================================
# 4. Add the Image service
# 4.1 Install and configure
# (1) To configure prerequisites
# (1-1) To create the database, complete these steps:
# Create the keystone database:
# Grant proper access to the keystone database:
echo "[CALL kilo-4.1.1-1.controller.sh]========================================================"
ssh student@10.0.0.11 "cd ~student/scripts/; ~student/scripts/kilo-4.1.1-1.controller.sh"
# (1-2) Source the admin credentials to gain access to admin-only CLI commands:
# (1-3) To create the service credentials, complete these steps:
# (1-4) Create the Image service API endpoint:
echo "[CALL kilo-4.1.1-2-4.controller.sh]======================================================"
ssh student@10.0.0.11 "cd ~student/scripts/; ~student/scripts/kilo-4.1.1-2-4.controller.sh"
# (2) To install and configure the Image service components
# (2-1) Install the packages:
# (2-2) Edit the /etc/glance/glance-api.conf file and complete the following actions:
# (2-3) Edit the /etc/glance/glance-registry.conf file and complete the following actions:
# (2-4) Populate the Image service database:
# (3) To finalize installation
echo "[CALL kilo-4.1.2-1-3.controller.sh]========================================================"
ssh root@10.0.0.11 "cd ~student/scripts/; ~student/scripts/kilo-4.1.2-1-3.controller.sh"
# 4.2 Verify operation
# (1) In each client environment script, configure the Image service client to use API version 2.0:
echo "[CALL kilo-4.2.controller.sh]========================================================"
ssh student@10.0.0.11 "cd ~student/scripts/; ~student/scripts/kilo-4.2.controller.sh"
