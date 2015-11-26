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


# =========================================================================
# 기본적으로 OS Setup 및 Network Setup이 완료되어야만 한다.
# =========================================================================

# Load Env global variables
. ./kilo-perform-vars.common.sh

# (2) crudini : 2.6.2이후에 만 설치 가능 하므로 뒤로 뺐다.
# yum -y install crudini

# ======================================================================================================
# 2. Basic environment
# 2.5 Network Time Protocol (NTP) SKIP

# 2.6 OpenStack packages
# (1) To configure prerequisites
echo '2.6.1 ===============> yum -y install http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm'
yum -y install http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm


# (2) To enable the OpenStack repository
echo '2.6.2 ===============> yum -y install  http://rdo.fedorapeople.org/openstack-kilo/rdo-release-kilo-1.noarch.rpm'
yum -y install http://rdo.fedorapeople.org/openstack-kilo/rdo-release-kilo.rpm



yum -y upgrade

# 필요 Package 설치
# node : ALL
# (1) wgetyum install http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm

echo '0.0.0.0 =============> yum -y install wget'
yum -y install wget

# (3) To finalize installation
echo '2.6.3 ===============> yum -y install  openstack-selinux'
yum -y install  openstack-selinux
echo '0.0.0.0 =============> yum -y install crudini'
yum -y install crudini

# ======================================================================================================
cat << EOF >> /etc/hosts 
# controller
10.0.0.11               controller
# network
10.0.0.21               network
# compute
10.0.0.31               compute
10.0.0.31               compute1
# block1
10.0.0.41               block1
# object1
10.0.0.51               object1
EOF
