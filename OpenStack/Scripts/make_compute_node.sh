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
# Init Controller VM 
#VBoxManage controlvm cent7-controller poweroff
#VBoxManage unregistervm cent7-controller --delete

# # Init Network VM 
#VBoxManage controlvm cent7-network poweroff
#VBoxManage unregistervm cent7-network --delete

# Init Compute VM 
VBoxManage controlvm cent7-compute poweroff
VBoxManage unregistervm cent7-compute --delete

# ============================================================================================
# VirtualBox 저장 파일 Import 
#VBoxManage import ~/OpenStack/OpenStack_VM/cent7-controller.ova
#VBoxManage import ~/OpenStack/OpenStack_VM/cent7-network.ova
VBoxManage import ~/OpenStack/OpenStack_VM/cent7-compute.ova

# ============================================================================================
# Run VM controller, network, compute
#vboxmanage startvm cent7-controller
#vboxmanage startvm cent7-network
vboxmanage startvm cent7-compute

# ============================================================================================
# Controller server ssh password 생략
# Server가 살아 날때 까지 대기
#while ! ping -c1 10.0.0.11 &>/dev/null; do :; done
#sleep 1

# ssh-copy-id root@10.0.0.11

# Network server ssh password 생략
# Server가 살아 날때 까지 대기
#while ! ping -c1 10.0.0.21 &>/dev/null; do :; done
#sleep 1

# Compute server ssh password 생략
# Server가 살아 날때 까지 대기
while ! ping -c1 10.0.0.31 &>/dev/null; do :; done
sleep 1

# ssh-copy-id student@10.0.0.11
# ssh-copy-id root@10.0.0.11
# ssh-copy-id student@10.0.0.21
# ssh-copy-id root@10.0.0.21
ssh-copy-id student@10.0.0.31
ssh-copy-id root@10.0.0.31

# # ============================================================================================
# # Copy OpenStack Install Script
# ssh student@10.0.0.11 "mkdir scripts"
# scp ~/OpenStack/Scripts/kilo-*.sh  student@10.0.0.11:~/scripts
# ssh student@10.0.0.11 "chmod +x ~/scripts/*.sh"


# # ============================================================================================
# # Copy OpenStack Install Script
# ssh student@10.0.0.21 "mkdir scripts"
# scp ~/OpenStack/Scripts/kilo-*.sh student@10.0.0.21:~/scripts
# ssh student@10.0.0.21 "chmod +x ~/scripts/*.sh"

# ============================================================================================
# Copy OpenStack Install Script
ssh student@10.0.0.31 "mkdir scripts"
scp ~/OpenStack/Scripts/kilo-*.sh student@10.0.0.31:~/scripts
ssh student@10.0.0.31 "chmod +x ~/scripts/*.sh"

# # ============================================================================================
# # Run Install

# # ============================================================================================
# # 2. Basic environment
# # 2.2 Before you begin
# # 2.3 Security (NOP)
# # 2.4 Networking (NOP)
# # 2.5 Network Time Protocol (NTP) (NOP)
# # 
# # 2.6 OpenStack packages & 필요 Package 설치
# ssh root@10.0.0.11 "cd ~student/scripts/; ~student/scripts/kilo-0.0.all.sh"
# ssh root@10.0.0.21 "cd ~student/scripts/; ~student/scripts/kilo-0.0.all.sh"
ssh root@10.0.0.31 "cd ~student/scripts/; ~student/scripts/kilo-0.0.all.sh"
# # 2.7 SQL database
# #(1) To install and configure the database server
# # (1-1) Install the packages:
# # (1-2) Create and edit the /etc/my.cnf.d/mariadb_openstack.cnf file and complete the following actions:
# # (2) To finalize installation
# # (2-1) Start the database service and configure it to start when the system boots:
# ssh root@10.0.0.11 "cd ~student/scripts/; ~student/scripts/kilo-2.7.1.controller.sh"
# # (2-2) Secure the database service including choosing a suitable password for the root account:
# ssh root@10.0.0.11 "cd ~student/scripts/; ~student/scripts/kilo-2.7.2.controller.sh"
# # 2.8 Message queue
# # (1) To install the message queue service
# ssh root@10.0.0.11 "cd ~student/scripts/; ~student/scripts/kilo-2.8.1.controller.sh"

# # ============================================================================================
# # 3. Add the Identity service
# # 3.1 Install and configure
# # (1) To configure prerequisites
# # Create the keystone database:
# # Grant proper access to the keystone database:
# ssh student@10.0.0.11 "cd ~student/scripts/; ~student/scripts/kilo-3.1.1.controller.sh"
# # (2) To install and configure the Identity service components
# # (3) To configure the Apache HTTP server
# # (4) To finalize installation
# ssh root@10.0.0.11 "cd ~student/scripts/; ~student/scripts/kilo-3.1.2-4.controller.sh"
# # 3.2 Create the service entity and API endpoint
# # (1) To configure prerequisites
# # (2) To create the service entity and API endpoint
# # (3) Regular (non-admin) tasks should use an unprivileged project and user. As an example, this guide creates the demo project and user.
# ssh student@10.0.0.11 "cd ~student/scripts/; ~student/scripts/kilo-3.2-3.controller.sh"
# # 3.4 Verify operation
# ssh student@10.0.0.11 "cd ~student/scripts/; ~student/scripts/kilo-3.4.controller.sh"
# # 3.5 Create OpenStack client environment scripts
# ssh student@10.0.0.11 "cd ~student/scripts/; ~student/scripts/kilo-3.5.controller.sh"

# # ============================================================================================
# # 4. Add the Image service
# # 4.1 Install and configure
# # (1) To configure prerequisites
# # (1-1) To create the database, complete these steps:
# # Create the keystone database:
# # Grant proper access to the keystone database:
# ssh student@10.0.0.11 "cd ~student/scripts/; ~student/scripts/kilo-4.1.1-1.controller.sh"
# # (1-2) Source the admin credentials to gain access to admin-only CLI commands:
# # (1-3) To create the service credentials, complete these steps:
# # (1-4) Create the Image service API endpoint:
# ssh student@10.0.0.11 "cd ~student/scripts/; ~student/scripts/kilo-4.1.1-2-4.controller.sh"
# # (2) To install and configure the Image service components
# # (2-1) Install the packages:
# # (2-2) Edit the /etc/glance/glance-api.conf file and complete the following actions:
# # (2-3) Edit the /etc/glance/glance-registry.conf file and complete the following actions:
# # (2-4) Populate the Image service database:
# # (3) To finalize installation
# ssh root@10.0.0.11 "cd ~student/scripts/; ~student/scripts/kilo-4.1.2-1-3.controller.sh"
# # 4.2 Verify operation
# # (1) In each client environment script, configure the Image service client to use API version 2.0:
# ssh student@10.0.0.11 "cd ~student/scripts/; ~student/scripts/kilo-4.2.controller.sh"

# # ============================================================================================
# # 5. Add the Compute service
# # 5.1 Install and configure controller node
# # (1) To configure prerequisites
# # (1-1) To create the database, complete these steps:
# ssh root@10.0.0.11 "cd ~student/scripts/; ~student/scripts/kilo-5.1.1-1.controller.sh"
# # (1-2) Source the admin credentials to gain access to admin-only CLI commands:
# # (1-3) To create the service credentials, complete these steps:
# # (1-4) Create the Compute service API endpoint:
# ssh root@10.0.0.11 "cd ~student/scripts/; ~student/scripts/kilo-5.1.1-2-4.controller.sh"
# # (2) To install and configure Compute controller components
# # (3) To finalize installation
# ssh root@10.0.0.11 "cd ~student/scripts/; ~student/scripts/kilo-5.1.2-3.controller.sh"

# # 5.2 Install and configure a compute node
# # (1) To install and configure the Compute hypervisor components
# # (2) To finalize installation
ssh root@10.0.0.31 "cd ~student/scripts/; ~student/scripts/kilo-5.2.1-2.compute.sh"

# # 5.3 Verify operation
# ssh student@10.0.0.11 "cd ~student/scripts/; ~student/scripts/kilo-5.3.1-4.controller.sh"

