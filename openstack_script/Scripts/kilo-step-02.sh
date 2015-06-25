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
# Run Install

# ============================================================================================
# 2. Basic environment
# 2.2 Before you begin
# 2.3 Security (NOP)
# 2.4 Networking (NOP)
# 2.5 Network Time Protocol (NTP) (NOP)
# 
# 2.6 OpenStack packages & 필요 Package 설치
ssh root@10.0.0.11 "cd ~student/scripts/; ~student/scripts/kilo-0.0.all.sh"
ssh root@10.0.0.21 "cd ~student/scripts/; ~student/scripts/kilo-0.0.all.sh"
ssh root@10.0.0.31 "cd ~student/scripts/; ~student/scripts/kilo-0.0.all.sh"
ssh root@10.0.0.41 "cd ~student/scripts/; ~student/scripts/kilo-0.0.all.sh"
# 2.7 SQL database
#(1) To install and configure the database server
# (1-1) Install the packages:
# (1-2) Create and edit the /etc/my.cnf.d/mariadb_openstack.cnf file and complete the following actions:
# (2) To finalize installation
# (2-1) Start the database service and configure it to start when the system boots:
ssh root@10.0.0.11 "cd ~student/scripts/; ~student/scripts/kilo-2.7.1.controller.sh"
# (2-2) Secure the database service including choosing a suitable password for the root account:
ssh root@10.0.0.11 "cd ~student/scripts/; ~student/scripts/kilo-2.7.2.controller.sh"
# 2.8 Message queue
# (1) To install the message queue service
ssh root@10.0.0.11 "cd ~student/scripts/; ~student/scripts/kilo-2.8.1.controller.sh"




