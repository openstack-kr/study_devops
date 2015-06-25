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

# Init Network VM 
VBoxManage controlvm cent7-network poweroff
VBoxManage unregistervm cent7-network --delete

# Init Compute VM 
VBoxManage controlvm cent7-compute poweroff
VBoxManage unregistervm cent7-compute --delete

# Init Block1 VM 
VBoxManage controlvm cent7-block1 poweroff
VBoxManage unregistervm cent7-block1 --delete

# ============================================================================================
# VirtualBox 저장 파일 Import 
VBoxManage import ~/OpenStack/OpenStack_VM/cent7-controller.ova
VBoxManage import ~/OpenStack/OpenStack_VM/cent7-network.ova
VBoxManage import ~/OpenStack/OpenStack_VM/cent7-compute.ova
VBoxManage import ~/OpenStack/OpenStack_VM/cent7-block1.ova

# ============================================================================================
# Run VM controller, network, compute
vboxmanage startvm cent7-controller
vboxmanage startvm cent7-network
vboxmanage startvm cent7-compute
vboxmanage startvm cent7-block1

# ============================================================================================
# Controller server ssh password 생략
# Server가 살아 날때 까지 대기
while ! ping -c1 10.0.0.11 &>/dev/null; do :; done
sleep 1

# ssh-copy-id root@10.0.0.11

# Network server ssh password 생략
# Server가 살아 날때 까지 대기
while ! ping -c1 10.0.0.21 &>/dev/null; do :; done
sleep 1

# Compute server ssh password 생략
# Server가 살아 날때 까지 대기
while ! ping -c1 10.0.0.31 &>/dev/null; do :; done
sleep 1

# Compute server ssh password 생략
# Server가 살아 날때 까지 대기
while ! ping -c1 10.0.0.41 &>/dev/null; do :; done
sleep 1


ssh-copy-id student@10.0.0.11
ssh-copy-id root@10.0.0.11
ssh-copy-id student@10.0.0.21
ssh-copy-id root@10.0.0.21
ssh-copy-id student@10.0.0.31
ssh-copy-id root@10.0.0.31
ssh-copy-id student@10.0.0.41
ssh-copy-id root@10.0.0.41


ssh root@10.0.0.11 "hostnamectl set-hostname controller"
ssh root@10.0.0.21 "hostnamectl set-hostname network"
ssh root@10.0.0.31 "hostnamectl set-hostname compute"
ssh root@10.0.0.41 "hostnamectl set-hostname block1"

# ============================================================================================
# Copy OpenStack Install Script Controller
ssh student@10.0.0.11 "mkdir scripts"
scp ~/OpenStack/Scripts/kilo-0.0.all.sh  student@10.0.0.11:~/scripts
scp ~/OpenStack/Scripts/kilo-perform-vars.common.sh  student@10.0.0.11:~/scripts
scp ~/OpenStack/Scripts/kilo-2.*.controller.sh  student@10.0.0.11:~/scripts
scp ~/OpenStack/Scripts/kilo-3.*.controller.sh  student@10.0.0.11:~/scripts
scp ~/OpenStack/Scripts/kilo-4.*.controller.sh  student@10.0.0.11:~/scripts
scp ~/OpenStack/Scripts/kilo-5.*.controller.sh  student@10.0.0.11:~/scripts
scp ~/OpenStack/Scripts/kilo-6.*.controller.sh  student@10.0.0.11:~/scripts
scp ~/OpenStack/Scripts/kilo-7.*.controller.sh  student@10.0.0.11:~/scripts
scp ~/OpenStack/Scripts/kilo-8.*.controller.sh  student@10.0.0.11:~/scripts
ssh student@10.0.0.11 "chmod +x ~/scripts/*.sh"



# ============================================================================================
# Copy OpenStack Install Script Network
ssh student@10.0.0.21 "mkdir scripts"
scp ~/OpenStack/Scripts/kilo-0.0.all.sh  student@10.0.0.21:~/scripts
scp ~/OpenStack/Scripts/kilo-perform-vars.common.sh  student@10.0.0.21:~/scripts
scp ~/OpenStack/Scripts/kilo-6.*.network.sh  student@10.0.0.21:~/scripts
ssh student@10.0.0.21 "chmod +x ~/scripts/*.sh"

# ============================================================================================
# Copy OpenStack Install Script Compute
ssh student@10.0.0.31 "mkdir scripts"
scp ~/OpenStack/Scripts/kilo-0.0.all.sh  student@10.0.0.31:~/scripts
scp ~/OpenStack/Scripts/kilo-perform-vars.common.sh  student@10.0.0.31:~/scripts
scp ~/OpenStack/Scripts/kilo-5.*.compute.sh  student@10.0.0.31:~/scripts
scp ~/OpenStack/Scripts/kilo-6.*.compute.sh  student@10.0.0.31:~/scripts
ssh student@10.0.0.31 "chmod +x ~/scripts/*.sh"


# ============================================================================================
# Copy OpenStack Install Script Block1
ssh student@10.0.0.41 "mkdir scripts"
scp ~/OpenStack/Scripts/kilo-0.0.all.sh  student@10.0.0.41:~/scripts
scp ~/OpenStack/Scripts/kilo-perform-vars.common.sh  student@10.0.0.41:~/scripts
scp ~/OpenStack/Scripts/kilo-8.*.block1.sh  student@10.0.0.41:~/scripts
ssh student@10.0.0.41 "chmod +x ~/scripts/*.sh"



