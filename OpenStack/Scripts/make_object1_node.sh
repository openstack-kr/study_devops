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
VBoxManage controlvm cent7-object1 poweroff
VBoxManage unregistervm cent7-object1 --delete
# VirtualBox 저장 파일 Import 
VBoxManage import ~/OpenStack/OpenStack_VM/cent7-object1.ova 



# ============================================================================================
# Run VM controller, network, compute
vboxmanage startvm cent7-object1 --type headless

# Object1 server ssh password 생략
# Server가 살아 날때 까지 대기
while ! ping -c1 10.0.0.51 &>/dev/null; do :; done
sleep 1

ssh-copy-id student@10.0.0.51
ssh-copy-id root@10.0.0.51

ssh root@10.0.0.51 "hostnamectl set-hostname object1"

ssh student@10.0.0.51 "mkdir scripts"
scp ~/OpenStack/Scripts/kilo-0.0.all.sh  student@10.0.0.51:~/scripts
scp ~/OpenStack/Scripts/kilo-0.1.all.sh  student@10.0.0.51:~/scripts
scp ~/OpenStack/Scripts/kilo-perform-vars.common.sh  student@10.0.0.51:~/scripts
scp ~/OpenStack/Scripts/kilo-9.*.object1.sh  student@10.0.0.51:~/scripts
ssh student@10.0.0.51 "chmod +x ~/scripts/*.sh"

echo "[CALL kilo-0.0.all.sh]================================================================"
if [ "$CODETREE_USE_LOCAL_REPOSITORY" = "0" ];
then
	# 2.6 OpenStack packages & 필요 Package 설치
	ssh root@10.0.0.51 "cd ~student/scripts/; ~student/scripts/kilo-0.0.all.sh"
else
	# 2.6 OpenStack packages & 필요 Package 설치
	ssh root@10.0.0.51 "cd ~student/scripts/; ~student/scripts/kilo-0.1.all.sh"
fi

