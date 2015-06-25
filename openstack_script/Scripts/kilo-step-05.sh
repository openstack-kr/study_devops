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
# 5. Add the Compute service
# 5.1 Install and configure controller node
# (1) To configure prerequisites
# (1-1) To create the database, complete these steps:
ssh root@10.0.0.11 "cd ~student/scripts/; ~student/scripts/kilo-5.1.1-1.controller.sh"
# (1-2) Source the admin credentials to gain access to admin-only CLI commands:
# (1-3) To create the service credentials, complete these steps:
# (1-4) Create the Compute service API endpoint:
ssh root@10.0.0.11 "cd ~student/scripts/; ~student/scripts/kilo-5.1.1-2-4.controller.sh"
# (2) To install and configure Compute controller components
# (3) To finalize installation
ssh root@10.0.0.11 "cd ~student/scripts/; ~student/scripts/kilo-5.1.2-3.controller.sh"

# # 5.2 Install and configure a compute node
# # (1) To install and configure the Compute hypervisor components
# # (2) To finalize installation
ssh root@10.0.0.31 "cd ~student/scripts/; ~student/scripts/kilo-5.2.1-2.compute.sh"

# # 5.3 Verify operation
ssh student@10.0.0.11 "cd ~student/scripts/; ~student/scripts/kilo-5.3.1-4.controller.sh"


