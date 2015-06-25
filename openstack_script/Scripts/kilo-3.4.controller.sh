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



# 3.4 Verify operation
# or security reasons, disable the temporary authentication token mechanism:
sed -ie "s/ admin_token_auth / /" /usr/share/keystone/keystone-dist-paste.ini
# 일반 사용자 계정인 경우 - sed: couldn't open temporary file /usr/share/keystone/sedUIKPhN: 허가 거부

# Unset the temporary OS_TOKEN and OS_URL environment variables:
unset OS_TOKEN OS_URL

#As the admin user, request an authentication token from the Identity version 2.0 API:
# openstack --os-auth-url http://controller:35357 \
#   --os-project-name admin --os-username admin --os-auth-type password \
#   token issue
# # Password:
openstack --os-auth-url http://controller:35357 \
  --os-project-name admin --os-username admin   --os-password pass_for_admin \
  token issue  

# openstack --os-auth-url http://controller:35357 \
#   --os-project-domain-id default --os-user-domain-id default \
#   --os-project-name admin --os-username admin --os-auth-type password \
#   token issue
# # Password:
openstack --os-auth-url http://controller:35357 \
  --os-project-domain-id default --os-user-domain-id default \
  --os-project-name admin --os-username admin  --os-password pass_for_admin \
  token issue

# openstack --os-auth-url http://controller:35357 \
#   --os-project-name admin --os-username admin --os-auth-type password \
#   project list
# # Password:
openstack --os-auth-url http://controller:35357 \
  --os-project-name admin --os-username admin --os-password pass_for_admin \
  project list

# openstack --os-auth-url http://controller:35357 \
#   --os-project-name admin --os-username admin --os-auth-type password \
#   user list
# # Password:
openstack --os-auth-url http://controller:35357 \
  --os-project-name admin --os-username admin --os-password pass_for_admin \
  user list

# openstack --os-auth-url http://controller:35357 \
#   --os-project-name admin --os-username admin --os-auth-type password \
#   role list
# # Password:
openstack --os-auth-url http://controller:35357 \
  --os-project-name admin --os-username admin --os-password pass_for_admin \
  role list


# openstack --os-auth-url http://controller:5000 \
#   --os-project-domain-id default --os-user-domain-id default \
#   --os-project-name demo --os-username demo --os-auth-type password \
#   token issue
# # Password:  
openstack --os-auth-url http://controller:5000 \
  --os-project-domain-id default --os-user-domain-id default \
  --os-project-name demo --os-username demo --os-password pass_for_demo \
  token issue

# openstack --os-auth-url http://controller:5000 \
#   --os-project-domain-id default --os-user-domain-id default \
#   --os-project-name demo --os-username demo --os-auth-type password \
#   user list
# # Password:  

# As the demo user, attempt to list users to verify that it cannot execute admin-only CLI commands:
openstack --os-auth-url http://controller:5000 \
  --os-project-domain-id default --os-user-domain-id default \
  --os-project-name demo --os-username demo --os-password pass_for_demo \
  user list

# ERROR: openstack You are not authorized to perform the requested action, admin_required. (HTTP 403)
