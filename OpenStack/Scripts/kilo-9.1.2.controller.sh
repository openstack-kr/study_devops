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
# (2) To install and configure the controller node components
# (2-1) Install the packages:
yum -y install openstack-swift-proxy python-swiftclient python-keystone-auth-token python-keystonemiddleware memcached

# (2-2) Obtain the proxy service configuration file from the Object Storage source repository:
curl -o /etc/swift/proxy-server.conf \
  https://git.openstack.org/cgit/openstack/swift/plain/etc/proxy-server.conf-sample?h=stable/kilo
# (2-3) Edit the /etc/swift/proxy-server.conf file and complete the following actions:
# (2-3-1) In the [DEFAULT] section, configure the bind port, user, and configuration directory:
# [DEFAULT]
crudini --set /etc/swift/proxy-server.conf DEFAULT bind_port 8080
crudini --set /etc/swift/proxy-server.conf DEFAULT user swift
crudini --set /etc/swift/proxy-server.conf DEFAULT swift_dir /etc/swift

# (2-3-2) In the [pipeline:main] section, enable the appropriate modules:
# [pipeline:main]
crudini --set /etc/swift/proxy-server.conf pipeline:main pipeline 'catch_errors gatekeeper healthcheck proxy-logging cache container_sync bulk ratelimit authtoken keystoneauth container-quotas account-quotas slo dlo proxy-logging proxy-server'


# (2-3-3) In the [app:proxy-server] section, enable automatic account creation:
# [app:proxy-server]
crudini --set /etc/swift/proxy-server.conf app:proxy-server account_autocreate true

# (2-3-4) In the [filter:keystoneauth] section, configure the operator roles:
# [filter:keystoneauth]
crudini --set /etc/swift/proxy-server.conf filter:keystoneauth use egg:swift#keystoneauth
crudini --set /etc/swift/proxy-server.conf filter:keystoneauth operator_roles admin,user

# (2-3-5) In the [filter:authtoken] section, configure Identity service access:
# [filter:authtoken]
crudini --del /etc/swift/proxy-server.conf filter:authtoken

crudini --set /etc/swift/proxy-server.conf filter:authtoken paste.filter_factory keystonemiddleware.auth_token:filter_factory

crudini --set /etc/swift/proxy-server.conf filter:authtoken auth_uri http://controller:5000
crudini --set /etc/swift/proxy-server.conf filter:authtoken auth_url http://controller:35357
crudini --set /etc/swift/proxy-server.conf filter:authtoken auth_plugin password
crudini --set /etc/swift/proxy-server.conf filter:authtoken project_domain_id default
crudini --set /etc/swift/proxy-server.conf filter:authtoken user_domain_id default
crudini --set /etc/swift/proxy-server.conf filter:authtoken project_name service
crudini --set /etc/swift/proxy-server.conf filter:authtoken username swift
crudini --set /etc/swift/proxy-server.conf filter:authtoken password ${SWIFT_PASS}
crudini --set /etc/swift/proxy-server.conf filter:authtoken delay_auth_decision true

# (2-3-6) In the [filter:cache] section, configure the memcached location:
# [filter:cache]
crudini --set /etc/swift/proxy-server.conf filter:cache memcache_servers 127.0.0.1:11211
