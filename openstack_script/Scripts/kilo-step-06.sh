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
# 6 Add a networking component
# 6.1 OpenStack Networking (neutron)
# 6.1.1 OpenStack Networking
# 6.1.2 Networking concepts
# 6.1.3 Install and configure controller node
# (1) To configure prerequisites
ssh student@10.0.0.11 "cd ~student/scripts/; ~student/scripts/kilo-6.1.3.1-1.controller.sh"
# (1-2) Source the admin credentials to gain access to admin-only CLI commands:
ssh student@10.0.0.11 "cd ~student/scripts/; ~student/scripts/kilo-6.1.3.1-2-4.controller.sh" 
# (2) To install the Networking components
# (3) To configure the Networking server component
# (4) To configure the Modular Layer 2 (ML2) plug-in
# (5) To configure Compute to use Networking
# (6) To finalize installation
ssh root@10.0.0.11 "cd ~student/scripts/; ~student/scripts/kilo-6.1.3.2-6.controller.sh"
# (7) Verify operation
ssh root@10.0.0.11 "cd ~student/scripts/; ~student/scripts/kilo-6.1.3.7.controller.sh"

# 6.1.4 Install and configure network node
# (1) Install and configure network node
# (2) To configure prerequisites
# (3) To install the Networking components
# (4) To configure the Networking common components
# (5) To configure the Modular Layer 2 (ML2) plug-in
# (6) To configure the Layer-3 (L3) agent
# (7) To configure the DHCP agent
# (8) To configure the metadata agent
# (8-1) Edit the /etc/neutron/metadata_agent.ini file and complete the following actions:
ssh root@10.0.0.21 "cd ~student/scripts/; ~student/scripts/kilo-6.1.4.1_8-1.network.sh"
# (8-2) On the controller node, edit the /etc/nova/nova.conf file and complete the following action:
ssh root@10.0.0.11 "cd ~student/scripts/; ~student/scripts/kilo-6.1.4.8-2_8-3.controller.sh"
# (9) To configure the Open vSwitch (OVS) service
# (10) To finalize the installation
ssh root@10.0.0.21 "cd ~student/scripts/; ~student/scripts/kilo-6.1.4.9_10.network.sh"
ssh student@10.0.0.21 "cd ~student/scripts/; ~student/scripts/kilo-6.1.4.10-1.network.sh"

# (11) Verify operation
ssh student@10.0.0.11 "cd ~student/scripts/; ~student/scripts/kilo-6.1.4.11.controller.sh"
# ssh student@10.0.0.21 "cd ~student/scripts/; ~student/scripts/kilo-6.1.4.11.network.sh"

# 6.1.5 Install and configure compute node
# (1) Install and configure network node
# (2) To configure prerequisites
# (3) To install the Networking components
# (4) To configure the Networking common components
# (5) To configure the Modular Layer 2 (ML2) plug-in
# (6) To configure the Open vSwitch (OVS) service
# (7) To configure Compute to use Networking
# (8) To finalize the installation
ssh root@10.0.0.31 "cd ~student/scripts/; ~student/scripts/kilo-6.1.5.1_8.compute.sh"

# (9) Verify operation
ssh student@10.0.0.11 "cd ~student/scripts/; ~student/scripts/kilo-6.1.5.9.controller.sh"

# 6.1.6 Create initial networks
# 6.2 Legacy networking (nova-network)
# 6.2.1 Configure controller node
# 6.2.2 Configure compute node
# 6.2.3 Create initial network
# 6.3 Next steps
