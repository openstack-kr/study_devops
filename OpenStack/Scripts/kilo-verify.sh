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
# Verify operation
# 3. Add the Identity service Verify
# 3.4 Verify operation
ssh root@10.0.0.11 "cd ~student/scripts/; ~student/scripts/kilo-3.4.controller.sh"

# 4. Add the Image service
# 4.2 Verify operation
# (1) In each client environment script, configure the Image service client to use API version 2.0:
ssh student@10.0.0.11 "cd ~student/scripts/; ~student/scripts/kilo-4.2.controller.sh"

# 5. Add the Compute service
# # 5.3 Verify operation
ssh student@10.0.0.11 "cd ~student/scripts/; ~student/scripts/kilo-5.3.1-4.controller.sh"

# 6 Add a networking component
# 6.1.3 Install and configure controller node
# (7) Verify operation
ssh student@10.0.0.11 "cd ~student/scripts/; ~student/scripts/kilo-6.1.3.7.controller.sh"

# 6 Add a networking component
# 6.1.4 Install and configure network node
# (11) Verify operation
ssh student@10.0.0.11 "cd ~student/scripts/; ~student/scripts/kilo-6.1.4.11.controller.sh"


# 6.1.5 Install and configure compute node
# 6.1.6 Create initial networks
# 6.2 Legacy networking (nova-network)
# 6.2.1 Configure controller node
# 6.2.2 Configure compute node
# 6.2.3 Create initial network
# 6.3 Next steps
