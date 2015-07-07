#!/bin/bash
#
# Werite by: Jeon.sungwook 
# Create Date : 2015-06-02
# Update Date : 2015-06-02
#
# OS : CentOS-7-x86_64 1503-01
# Node : network 
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

# 필요 Package 설치
# node : ALL
# (1) wget

yum -y install wget

# (2) crudini
pushd .
cd ~student
mkdir rpm
cd rpm
wget http://dl.fedoraproject.org/pub/epel/7/x86_64/c/crudini-0.5-1.el7.noarch.rpm
rpm -Uvh crudini-0.5-1.el7.noarch.rpm
popd

# 2.5 Network Time Protocol (NTP) ------------------------------------------SKIP


# 2.6 OpenStack packages
# (1) To configure prerequisites
yum install -y http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm

# (2) To enable the OpenStack repository
yum install -y  http://rdo.fedorapeople.org/openstack-kilo/rdo-release-kilo.rpm

# (3) To finalize installation
yum upgrade -y
yum install -y openstack-selinux

# 2.7 SQL database --------------------------------------------------------- SKIP

# 2.8 Message queue  ------------------------------------------------------- SKIP



