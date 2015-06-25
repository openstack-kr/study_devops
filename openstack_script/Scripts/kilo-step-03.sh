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
# 3. Add the Identity service
# 3.1 Install and configure
# (1) To configure prerequisites
# Create the keystone database:
# Grant proper access to the keystone database:
ssh student@10.0.0.11 "cd ~student/scripts/; ~student/scripts/kilo-3.1.1.controller.sh"
# (2) To install and configure the Identity service components
# (3) To configure the Apache HTTP server
# (4) To finalize installation
ssh root@10.0.0.11 "cd ~student/scripts/; ~student/scripts/kilo-3.1.2-4.controller.sh"
# 3.2 Create the service entity and API endpoint
# (1) To configure prerequisites
# (2) To create the service entity and API endpoint
# (3) Regular (non-admin) tasks should use an unprivileged project and user. As an example, this guide creates the demo project and user.
ssh student@10.0.0.11 "cd ~student/scripts/; ~student/scripts/kilo-3.2-3.controller.sh"
# 3.4 Verify operation
ssh root@10.0.0.11 "cd ~student/scripts/; ~student/scripts/kilo-3.4.controller.sh"
# 3.5 Create OpenStack client environment scripts
ssh student@10.0.0.11 "cd ~student/scripts/; ~student/scripts/kilo-3.5.controller.sh"

