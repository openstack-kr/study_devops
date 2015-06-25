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
# 7 Add the dashboard
# 7.1 System requirements
# 7.2 Install and configure
# (1) To install the dashboard components
# (2) To configure the dashboard
# (3) To finalize installation
ssh root@10.0.0.11 "cd ~student/scripts/; ~student/scripts/kilo-7.2_4.controller.sh"

# 7.3 Verify operation
# 7.3 Next steps

