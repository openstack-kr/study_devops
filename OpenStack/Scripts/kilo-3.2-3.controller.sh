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

# 3.2 Create the service entity and API endpoint
# (1) To configure prerequisites

# Configure the authentication token:
export OS_TOKEN=${ADMIN_TOKEN}

# Configure the endpoint URL:
export OS_URL=http://controller:35357/v2.0

# (2) To create the service entity and API endpoint
# Create the service entity for the Identity service:
openstack service create \
  --name keystone --description "OpenStack Identity" identity

# Create the Identity service API endpoint:
openstack endpoint create \
  --publicurl http://controller:5000/v2.0 \
  --internalurl http://controller:5000/v2.0 \
  --adminurl http://controller:35357/v2.0 \
  --region RegionOne \
  identity

# 3.3 Create projects, users, and roles
# (1) To create tenants, users, and roles

# Create the admin project:
openstack project create --description "Admin Project" admin

# Create the admin user:
# echo openstack user create --password-prompt admin
# openstack user create --password-prompt admin
# openstack user create --project admin --password ${ADMIN_PASS} admin
openstack user create --password ${ADMIN_PASS} admin
# User Password:
# Repeat User Password:

# Create the admin role:
openstack role create admin

# Add the admin role to the admin project and user:
openstack role add --project admin --user admin admin

# (2) This guide uses a service project that contains a unique user for each service that you add to your environment.
# Create the service project:
openstack project create --description "Service Project" service

# (3) Regular (non-admin) tasks should use an unprivileged project and user. As an example, this guide creates the demo project and user.
# Create the demo project:
openstack project create --description "Demo Project" demo

# Create the demo user:
# openstack user create --password-prompt demo
# openstack user create --project demo --password ${DEMO_PASS} demo
openstack user create --password ${DEMO_PASS} demo
# User Password:
# Repeat User Password:

# Create the user role:
openstack role create user

# Add the user role to the demo project and user:
openstack role add --project demo --user demo user
