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


# ============================================================================================
# 9. Add Object Storage
# 9.1 Install and configure the controller node
# (1) To configure prerequisites
source ~student/env/admin-openrc.sh
# (1-1) To create the Identity service credentials, complete these steps:
# (1-1-1) Create the swift user:
openstack user create --password ${SWIFT_PASS} swift

# (1-1-2) Add the admin role to the swift user:
openstack role add --project service --user swift admin

# (1-1-3) Create the swift service entity:
openstack service create --name swift --description "OpenStack Object Storage" object-store

# (1-2) Create the Object Storage service API endpoint:
openstack endpoint create \
  --publicurl 'http://controller:8080/v1/AUTH_%(tenant_id)s' \
  --internalurl 'http://controller:8080/v1/AUTH_%(tenant_id)s' \
  --adminurl http://controller:8080 \
  --region RegionOne \
  object-store

  

# (2) To install and configure the controller node components
# (2-1) Install the packages:
# (2-2) Obtain the proxy service configuration file from the Object Storage source repository:
# (2-3) Edit the /etc/swift/proxy-server.conf file and complete the following actions:


# 9.2 Install and configure the storage nodes
# 9.3 Create initial rings
# 9.4 Finalize installation
# 9.5 Verify operation
