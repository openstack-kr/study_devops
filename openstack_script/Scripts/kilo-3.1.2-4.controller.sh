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

# openssl rand -hex 10
# (2) To install and configure the Identity service components
# [root계정]
# Run the following command to install the packages:
yum -y install openstack-keystone httpd mod_wsgi python-openstackclient memcached python-memcached
# Start the Memcached service and configure it to start when the system boots:
systemctl enable memcached.service
systemctl start memcached.service
echo "[CONTROLLER]===================================> start memcached.service"
while ! systemctl is-active memcached.service >/dev/null 2>&1; do :; done
echo "[CONTROLLER]===================================> start memcached.service Done!"
# sleep 2
# Edit the /etc/keystone/keystone.conf file and complete the following actions:

crudini --set /etc/keystone/keystone.conf  DEFAULT admin_token ${ADMIN_TOKEN}

crudini --set /etc/keystone/keystone.conf database connection mysql://keystone:${KEYSTONE_DBPASS}@controller/keystone

crudini --set /etc/keystone/keystone.conf memcache servers localhost:11211

crudini --set /etc/keystone/keystone.conf token provider keystone.token.providers.uuid.Provider
crudini --set /etc/keystone/keystone.conf token driver keystone.token.persistence.backends.memcache.Token

crudini --set /etc/keystone/keystone.conf revoke driver keystone.contrib.revoke.backends.sql.Revoke

crudini --set /etc/keystone/keystone.conf DEFAULT verbose True

# Populate the Identity service database:
su -s /bin/sh -c "keystone-manage db_sync" keystone

# (3) To configure the Apache HTTP server
# Edit the /etc/httpd/conf/httpd.conf file and configure the ServerName option to reference the controller node:
#crudini --set /etc/httpd/conf/httpd.conf  DEFAULT ServerName controller
echo "ServerName controller" >> /etc/httpd/conf/httpd.conf
  
# Create the /etc/httpd/conf.d/wsgi-keystone.conf file with the following content:
cat > /etc/httpd/conf.d/wsgi-keystone.conf << EOF
Listen 5000
Listen 35357

<VirtualHost *:5000>
    WSGIDaemonProcess keystone-public processes=5 threads=1 user=keystone group=keystone display-name=%{GROUP}
    WSGIProcessGroup keystone-public
    WSGIScriptAlias / /var/www/cgi-bin/keystone/main
    WSGIApplicationGroup %{GLOBAL}
    WSGIPassAuthorization On
    LogLevel info
    ErrorLogFormat "%{cu}t %M"
    ErrorLog /var/log/httpd/keystone-error.log
    CustomLog /var/log/httpd/keystone-access.log combined
</VirtualHost>

<VirtualHost *:35357>
    WSGIDaemonProcess keystone-admin processes=5 threads=1 user=keystone group=keystone display-name=%{GROUP}
    WSGIProcessGroup keystone-admin
    WSGIScriptAlias / /var/www/cgi-bin/keystone/admin
    WSGIApplicationGroup %{GLOBAL}
    WSGIPassAuthorization On
    LogLevel info
    ErrorLogFormat "%{cu}t %M"
    ErrorLog /var/log/httpd/keystone-error.log
    CustomLog /var/log/httpd/keystone-access.log combined
</VirtualHost>
EOF

# Create the directory structure for the WSGI components:
mkdir -p /var/www/cgi-bin/keystone

#Copy the WSGI components from the upstream repository into this directory:
curl http://git.openstack.org/cgit/openstack/keystone/plain/httpd/keystone.py?h=stable/kilo \
  | tee /var/www/cgi-bin/keystone/main /var/www/cgi-bin/keystone/admin

# Adjust ownership and permissions on this directory and the files in it:
chown -R keystone:keystone /var/www/cgi-bin/keystone
chmod 755 /var/www/cgi-bin/keystone/*

# (4) To finalize installation
# Restart the Apache HTTP server:
systemctl enable httpd.service
systemctl start httpd.service
echo "[CONTROLLER]===================================> start httpd.service"
while ! systemctl is-active httpd.service >/dev/null 2>&1; do :; done
echo "[CONTROLLER]===================================> start httpd.service Done!"
# sleep 2
