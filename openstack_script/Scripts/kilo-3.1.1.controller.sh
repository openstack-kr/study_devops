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

# ======================================================================================================
# 3. Add the Identity service
# export ADMIN_TOKEN=3986891fe916bc6dd730
# export DATABASE_ADMIN_PASS=pass_for_db
# export KEYSTONE_DBPASS=pass_for_db_keystone
# 3.1 Install and configure
# (1) To configure prerequisites
# Create the keystone database:
mysql -u root -p${DATABASE_ADMIN_PASS} -e "CREATE DATABASE keystone;"
# Grant proper access to the keystone database:
mysql -u root -p${DATABASE_ADMIN_PASS} -e \
"GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY '${KEYSTONE_DBPASS}';"
mysql -u root -p${DATABASE_ADMIN_PASS} -e \
"GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY '${KEYSTONE_DBPASS}';"
