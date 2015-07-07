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
. ./kilo-perform-vars.common.sh

export DATABASE_ADMIN_PASS=pass_for_db
export NEUTRON_DBPASS=pass_for_db_neutron
export NEUTRON_PASS=pass_for_neutron

# ============================================================================================
# 6 Add a networking component
# 6.1 OpenStack Networking (neutron)
# 6.1.1 OpenStack Networking
# 6.1.2 Networking concepts
# 6.1.3 Install and configure controller node
# (1) To configure prerequisites
# (1-1) To create the database, complete these steps:
# Create the neutron database:
mysql -u root -p${DATABASE_ADMIN_PASS} -e "CREATE DATABASE neutron;"
# Grant proper access to the nova database:
mysql -u root -p${DATABASE_ADMIN_PASS} -e \
"GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' IDENTIFIED BY '${NEUTRON_DBPASS}';"
mysql -u root -p${DATABASE_ADMIN_PASS} -e \
"GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' IDENTIFIED BY '${NEUTRON_DBPASS}';"
