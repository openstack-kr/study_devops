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
# export DATABASE_ADMIN_PASS=pass_for_db
# export GLANCE_DBPASS=pass_for_db_glance
# export GLANCE_PASS=pass_for_glance

# (1-2) Source the admin credentials to gain access to admin-only CLI commands:
source ~student/env/admin-openrc.sh

# (1-3) To create the service credentials, complete these steps:
# Create the glance user:
# openstack user create --password-prompt glance
openstack user create --password ${GLANCE_PASS} glance
# openstack user create --project service --password ${GLANCE_PASS} glance 
# Add the admin role to the glance user and service project:
openstack role add --project service --user glance admin

# Create the glance service entity:
openstack service create --name glance --description "OpenStack Image service" image


# (1-4) Create the Image service API endpoint:
openstack endpoint create \
  --publicurl http://controller:9292 \
  --internalurl http://controller:9292 \
  --adminurl http://controller:9292 \
  --region RegionOne \
  image
