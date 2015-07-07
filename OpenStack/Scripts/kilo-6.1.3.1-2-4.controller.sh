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

# (1-2) Source the admin credentials to gain access to admin-only CLI commands:
source ~student/env/admin-openrc.sh
# (1-3) To create the service credentials, complete these steps:
# Create the neutron user:
#openstack user create --password-prompt neutron
#User Password:
#Repeat User Password:
openstack user create --password ${NEUTRON_PASS} neutron

# Add the admin role to the neutron user:
openstack role add --project service --user neutron admin
# Create the neutron service entity:
openstack service create --name neutron --description "OpenStack Networking" network

# (1-4) Create the Networking service API endpoint:
openstack endpoint create \
  --publicurl http://controller:9696 \
  --adminurl http://controller:9696 \
  --internalurl http://controller:9696 \
  --region RegionOne \
  network

# 6.1.4 Install and configure network node
# 6.1.5 Install and configure compute node
# 6.1.6 Create initial networks
