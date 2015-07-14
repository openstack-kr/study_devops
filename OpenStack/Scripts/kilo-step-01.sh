#!/bin/bash
#
# Written by: Jeon.sungwook 
# Create Date : 2015-06-02
# Update Date : 2015-06-02
#
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

# BASE_DIR: base directory for our scripts and VMs
BASE_DIR=~/OpenStack
BASE_DIR_SCRIPT=$BASE_DIR/Scripts
BASE_DIR_VM=$BASE_DIR/OpenStack_VM
BASE_DIR_VM_WIN=`echo $BASE_DIR_VM | awk -F/ '{print $NF}'`
cd $BASE_DIR_SCRIPT

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

# Init Object1 VM 
VBoxManage controlvm cent7-object1 poweroff
VBoxManage unregistervm cent7-object1 --delete

# ============================================================================================
# VirtualBox 저장 파일 Import 
if [ "$OS_TYPE_LEFT" = "CYGWIN" ]; then
  VBoxManage import ../$BASE_DIR_VM_WIN/cent7-controller.ova
  VBoxManage import ../$BASE_DIR_VM_WIN/cent7-network.ova
  VBoxManage import ../$BASE_DIR_VM_WIN/cent7-compute.ova
  VBoxManage import ../$BASE_DIR_VM_WIN/cent7-block1.ova
  VBoxManage import ../$BASE_DIR_VM_WIN/cent7-object1.ova
else
  VBoxManage import $BASE_DIR_VM/cent7-controller.ova
  VBoxManage import $BASE_DIR_VM/cent7-network.ova
  VBoxManage import $BASE_DIR_VM/cent7-compute.ova
  VBoxManage import $BASE_DIR_VM/cent7-block1.ova
  VBoxManage import $BASE_DIR_VM/cent7-object1.ova
fi

# ============================================================================================
# Host-only network mapping
# Made by @ianychoi
OS_TYPE_LEFT=`uname -s | cut -c1-6`
if [ "$OS_TYPE_LEFT" = "CYGWIN" ]; then
  VBOX_NET_IF_NAME_PATTERN='VirtualBox Host-Only Ethernet Adapter #[0-9]'
else
  VBOX_NET_IF_NAME_PATTERN='vboxnet[0-9]'
fi

# Function
function check_vboxnet()
{
	IS_NETWORK=`echo $VBOXMANAGE_LIST_VBOXNET_IP | tr ',' '\n' | grep "$1" | awk -F: '{print $1}'`

	if [ -z $IS_NETWORK ]
	then
		TARGET_VBOXNET_NAME=`VBoxManage hostonlyif create | egrep -o "${VBOX_NET_IF_NAME_PATTERN}+"`
		VBoxManage hostonlyif ipconfig "$TARGET_VBOXNET_NAME" --ip $1
	else
		TARGET_VBOXNET_NAME=`echo $VBOXMANAGE_LIST_VBOXNET_NAME | tr ',' '\n' | sed -n "${IS_NETWORK}p" | awk -F: '{print $2}'`
	fi
	echo $TARGET_VBOXNET_NAME
}

NETWORK_1ST_IP_EXTERNAL="203.0.113.1"
NETWORK_1ST_IP_MANAGEMENT="10.0.0.1"
NETWORK_1ST_IP_TUNNEL="10.0.1.1"
NETWORK_1ST_IP_STORAGE="10.0.4.1"

VBOXMANAGE_LIST_VBOXNET_NAME=`VBoxManage list hostonlyifs | egrep -o "Name:[ ]*${VBOX_NET_IF_NAME_PATTERN}*" | awk -F: '{gsub(/^[ \t]+/,"",$2); print NR":"$2","}'`
VBOXMANAGE_LIST_VBOXNET_IP=`VBoxManage list hostonlyifs | egrep -o 'IPAddress:[ ]*[0-9]*.[0-9]*.[0-9]*.[0-9]*' | awk '{print NR":"$2","}'`


VBOXNET_NAME_EXTERNAL=$(check_vboxnet $NETWORK_1ST_IP_EXTERNAL)
VBOXNET_NAME_MANAGEMENT=$(check_vboxnet $NETWORK_1ST_IP_MANAGEMENT)
VBOXNET_NAME_TUNNEL=$(check_vboxnet $NETWORK_1ST_IP_TUNNEL)
VBOXNET_NAME_STORAGE=$(check_vboxnet $NETWORK_1ST_IP_STORAGE)

VBoxManage modifyvm cent7-controller --hostonlyadapter2 "$VBOXNET_NAME_EXTERNAL"
VBoxManage modifyvm cent7-controller --hostonlyadapter3 "$VBOXNET_NAME_MANAGEMENT"

VBoxManage modifyvm cent7-network --hostonlyadapter2 "$VBOXNET_NAME_EXTERNAL"
VBoxManage modifyvm cent7-network --hostonlyadapter3 "$VBOXNET_NAME_MANAGEMENT"
VBoxManage modifyvm cent7-network --hostonlyadapter4 "$VBOXNET_NAME_TUNNEL"

VBoxManage modifyvm cent7-compute --hostonlyadapter3 "$VBOXNET_NAME_MANAGEMENT"
VBoxManage modifyvm cent7-compute --hostonlyadapter4 "$VBOXNET_NAME_TUNNEL"

VBoxManage modifyvm cent7-block1 --hostonlyadapter2 "$VBOXNET_NAME_STORAGE"
VBoxManage modifyvm cent7-block1 --hostonlyadapter3 "$VBOXNET_NAME_MANAGEMENT"

VBoxManage modifyvm cent7-object1 --hostonlyadapter2 "$VBOXNET_NAME_STORAGE"
VBoxManage modifyvm cent7-object1 --hostonlyadapter3 "$VBOXNET_NAME_MANAGEMENT"

# ============================================================================================
# Run VM controller, network, compute
vboxmanage startvm cent7-controller --type headless
vboxmanage startvm cent7-network --type headless
vboxmanage startvm cent7-compute --type headless
vboxmanage startvm cent7-block1  --type headless
vboxmanage startvm cent7-object1 --type headless

# virtualbox startvm cent7-controller
# virtualbox startvm cent7-network
# virtualbox startvm cent7-compute
# virtualbox startvm cent7-block1
# virtualbox startvm cent7-object1



if [ "$OS_TYPE_LEFT" = "CYGWIN" ]; then

while ! ping -n 1 10.0.0.11 &>/dev/null; do :; done
echo "== Controller node etwork is okay =="
sleep 1

while ! ping -n 1 10.0.0.21 &>/dev/null; do :; done
echo "== Network node network is okay =="
sleep 1

while ! ping -n 1 10.0.0.31 &>/dev/null; do :; done
echo "== Compute node network is okay =="
sleep 1

while ! ping -n 1 10.0.0.41 &>/dev/null; do :; done
echo "== Block storage node network is okay =="
sleep 1

while ! ping -n 1 10.0.0.51 &>/dev/null; do :; done
echo "== Object storage node network is okay =="
sleep 1

else
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

# Block1 server ssh password 생략
# Server가 살아 날때 까지 대기
while ! ping -c1 10.0.0.41 &>/dev/null; do :; done
sleep 1


# Object1 server ssh password 생략
# Server가 살아 날때 까지 대기
while ! ping -c1 10.0.0.51 &>/dev/null; do :; done
sleep 1

fi


ssh-copy-id student@10.0.0.11
ssh-copy-id root@10.0.0.11
ssh-copy-id student@10.0.0.21
ssh-copy-id root@10.0.0.21
ssh-copy-id student@10.0.0.31
ssh-copy-id root@10.0.0.31
ssh-copy-id student@10.0.0.41
ssh-copy-id root@10.0.0.41
ssh-copy-id student@10.0.0.51
ssh-copy-id root@10.0.0.51

ssh root@10.0.0.11 "hostnamectl set-hostname controller"
ssh root@10.0.0.21 "hostnamectl set-hostname network"
ssh root@10.0.0.31 "hostnamectl set-hostname compute"
ssh root@10.0.0.41 "hostnamectl set-hostname block1"
ssh root@10.0.0.51 "hostnamectl set-hostname object1"

# ============================================================================================
# Copy OpenStack Install Script Controller
ssh student@10.0.0.11 "mkdir scripts"
scp $BASE_DIR_SCRIPT/kilo-0.0.all.sh  student@10.0.0.11:~/scripts
scp $BASE_DIR_SCRIPT/kilo-0.1.all.sh  student@10.0.0.11:~/scripts
scp $BASE_DIR_SCRIPT/kilo-perform-vars.common.sh  student@10.0.0.11:~/scripts
scp $BASE_DIR_SCRIPT/kilo-2.*.controller.sh  student@10.0.0.11:~/scripts
scp $BASE_DIR_SCRIPT/kilo-3.*.controller.sh  student@10.0.0.11:~/scripts
scp $BASE_DIR_SCRIPT/kilo-4.*.controller.sh  student@10.0.0.11:~/scripts
scp $BASE_DIR_SCRIPT/kilo-5.*.controller.sh  student@10.0.0.11:~/scripts
scp $BASE_DIR_SCRIPT/kilo-6.*.controller.sh  student@10.0.0.11:~/scripts
scp $BASE_DIR_SCRIPT/kilo-7.*.controller.sh  student@10.0.0.11:~/scripts
scp $BASE_DIR_SCRIPT/kilo-8.*.controller.sh  student@10.0.0.11:~/scripts
scp $BASE_DIR_SCRIPT/kilo-9.*.controller.sh  student@10.0.0.11:~/scripts
ssh student@10.0.0.11 "chmod +x ~/scripts/*.sh"



# ============================================================================================
# Copy OpenStack Install Script Network
ssh student@10.0.0.21 "mkdir scripts"
scp $BASE_DIR_SCRIPT/kilo-0.0.all.sh  student@10.0.0.21:~/scripts
scp $BASE_DIR_SCRIPT/kilo-0.1.all.sh  student@10.0.0.21:~/scripts
scp $BASE_DIR_SCRIPT/kilo-perform-vars.common.sh  student@10.0.0.21:~/scripts
scp $BASE_DIR_SCRIPT/kilo-6.*.network.sh  student@10.0.0.21:~/scripts
ssh student@10.0.0.21 "chmod +x ~/scripts/*.sh"

# ============================================================================================
# Copy OpenStack Install Script Compute
ssh student@10.0.0.31 "mkdir scripts"
scp $BASE_DIR_SCRIPT/kilo-0.0.all.sh  student@10.0.0.31:~/scripts
scp $BASE_DIR_SCRIPT/kilo-0.1.all.sh  student@10.0.0.31:~/scripts
scp $BASE_DIR_SCRIPT/kilo-perform-vars.common.sh  student@10.0.0.31:~/scripts
scp $BASE_DIR_SCRIPT/kilo-5.*.compute.sh  student@10.0.0.31:~/scripts
scp $BASE_DIR_SCRIPT/kilo-6.*.compute.sh  student@10.0.0.31:~/scripts
scp $BASE_DIR_SCRIPT/kilo-9.*.compute.sh  student@10.0.0.31:~/scripts
ssh student@10.0.0.31 "chmod +x ~/scripts/*.sh"


# ============================================================================================
# Copy OpenStack Install Script Block1
ssh student@10.0.0.41 "mkdir scripts"
scp $BASE_DIR_SCRIPT/kilo-0.0.all.sh  student@10.0.0.41:~/scripts
scp $BASE_DIR_SCRIPT/kilo-0.1.all.sh  student@10.0.0.41:~/scripts
scp $BASE_DIR_SCRIPT/kilo-perform-vars.common.sh  student@10.0.0.41:~/scripts
scp $BASE_DIR_SCRIPT/kilo-8.*.block1.sh  student@10.0.0.41:~/scripts
ssh student@10.0.0.41 "chmod +x ~/scripts/*.sh"

# ============================================================================================
# Copy OpenStack Install Script Object1
ssh student@10.0.0.51 "mkdir scripts"
scp $BASE_DIR_SCRIPT/kilo-0.0.all.sh  student@10.0.0.51:~/scripts
scp $BASE_DIR_SCRIPT/kilo-0.1.all.sh  student@10.0.0.51:~/scripts
scp $BASE_DIR_SCRIPT/kilo-perform-vars.common.sh  student@10.0.0.51:~/scripts
scp $BASE_DIR_SCRIPT/kilo-9.*.object1.sh  student@10.0.0.51:~/scripts
ssh student@10.0.0.51 "chmod +x ~/scripts/*.sh"
