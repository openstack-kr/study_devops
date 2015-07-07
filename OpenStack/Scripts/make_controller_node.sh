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
VBoxManage controlvm cent7-controller poweroff
VBoxManage unregistervm cent7-controller --delete
# VirtualBox 저장 파일 Import 
VBoxManage import ~/OpenStack/OpenStack_VM/cent7-controller.ova 

# ============================================================================================
# Run VM controller, network, compute
vboxmanage startvm cent7-controller
vboxmanage startvm cent7-network
vboxmanage startvm cent7-compute

# ============================================================================================
# Controller server ssh password 생략
# Server가 살아 날때 까지 대기
while ! ping -c1 10.0.0.11 &>/dev/null; do :; done
sleep 1

ssh-copy-id student@10.0.0.11
# ssh-copy-id root@10.0.0.11


# ============================================================================================
# Copy OpenStack Install Script
ssh student@10.0.0.11 "mkdir scripts"
scp ~/OpenStack/Scripts/kilo-perform-vars.common.sh  student@10.0.0.11:~/scripts
scp ~/OpenStack/Scripts/kilo-perform-2.controller.sh student@10.0.0.11:~/scripts
ssh student@10.0.0.11 "chmod +x ~/scripts/*.sh"

# ============================================================================================
# Run Install
ssh root@10.0.0.11 "cd ~student/scripts/; ~student/scripts/kilo-perform-2.controller.sh"

# ============================================================================================
# VBoxManage controlvm cent7-controller poweroff
# VBoxManage unregistervm cent7-controller --delete
# # VirtualBox 저장 파일 Import 
# VBoxManage import ~/OpenStack/OpenStack_VM/cent7-controller.ova 

# vboxmanage startvm cent7-controller

# # Server가 살아 날때 까지 대기
# while ! ping -c1 10.0.0.11 &>/dev/null; do :; done
# sleep 1

# ssh-copy-id student@10.0.0.11
# # ssh-copy-id root@10.0.0.11

# # Copy OpenStack Install Script
# ssh student@10.0.0.11 "mkdir scripts"
# scp ~/OpenStack/Scripts/kilo-perform-2.controller.sh student@10.0.0.11:~/scripts
# scp ~/OpenStack/Scripts/kilo-perform-vars.common.sh  student@10.0.0.11:~/scripts
# ssh student@10.0.0.11 "chmod +x ~/scripts/kilo-perform-2.controller.sh"
# ssh root@10.0.0.11 "cd ~student/scripts/; ~student/scripts/kilo-perform-2.controller.sh"
