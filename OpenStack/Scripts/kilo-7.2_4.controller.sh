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

# export DATABASE_ADMIN_PASS=pass_for_db
# export NEUTRON_DBPASS=pass_for_db_neutron
# export NEUTRON_PASS=pass_for_neutron
# export RABBIT_PASS=pass_for_mq
# export NOVA_PASS=pass_for_nova
# export INSTANCE_TUNNELS_INTERFACE_IP_ADDRESS=10.0.1.21
# export INSTANCE_TUNNELS_INTERFACE_IP_ADDRESS_NETWORK=10.0.1.21
# export INSTANCE_TUNNELS_INTERFACE_IP_ADDRESS_COMPUTE=10.0.1.31
# export METADATA_SECRET=metadata_secret
export TIME_ZONE=Asia/Seoul



# ============================================================================================
# 7 Add the dashboard
# 7.1 System requirements
# 7.2 Install and configure
# (1) To install the dashboard components
# (1-1) Install the packages:
yum -y install openstack-dashboard httpd mod_wsgi memcached python-memcached

# (2) To configure the dashboard
# (2-1) Edit the /etc/openstack-dashboard/local_settings file and complete the following actions:
# (2-1-1) Configure the dashboard to use OpenStack services on the controller node:
# crudini --set /etc/openstack-dashboard/local_settings '' OPENSTACK_HOST '"controller"'
sed -i -e "s,^OPENSTACK_HOST =.*,OPENSTACK_HOST = \"controller\"," /etc/openstack-dashboard/local_settings

# (2-1-2) Allow all hosts to access the dashboard:
#crudini --set /etc/openstack-dashboard/local_settings '' ALLOWED_HOSTS "'*'"
sed -i -e "s,^ALLOWED_HOSTS = .*,ALLOWED_HOSTS = '\*'," /etc/openstack-dashboard/local_settings

# (2-1-3) Configure the memcached session storage service:
#crudini --set /etc/openstack-dashboard/local_settings '' CACHES "{ 'default': {  'BACKEND': 'django.core.cache.backends.memcached.MemcachedCache', 'LOCATION': '127.0.0.1:11211', } }"
sed -i -e "s,locmem.LocMemCache'.*,memcached.MemcachedCache'\,\n\t'LOCATION' : '127.0.0.1:1211'\,," /etc/openstack-dashboard/local_settings

# (2-1-4) Configure user as the default role for users that you create via the dashboard:
# crudini --set /etc/openstack-dashboard/local_settings '' OPENSTACK_KEYSTONE_DEFAULT_ROLE '"user"'
sed -i -e "s,^OPENSTACK_KEYSTONE_DEFAULT_ROLE = .*,OPENSTACK_KEYSTONE_DEFAULT_ROLE = \"user\"," /etc/openstack-dashboard/local_settings

# (2-1-5) Optionally, configure the time zone:
# crudini --set /etc/openstack-dashboard/local_settings '' TIME_ZONE '"${TIME_ZONE}"'
sed -i -e "s,^TIME_ZONE = .*,TIME_ZONE = \"${TIME_ZONE}\"," /etc/openstack-dashboard/local_settings
# (3) To finalize installation
# (3-1) On RHEL and CentOS, configure SELinux to permit the web server to connect to OpenStack services:
setsebool -P httpd_can_network_connect on

# (3-2) Due to a packaging bug, the dashboard CSS fails to load properly. Run the following command to resolve this issue:
chown -R apache:apache /usr/share/openstack-dashboard/static


# Firewall 80 Port Open

firewall-cmd --add-service=http --permanent		## Port 80
firewall-cmd --zone=public --add-port=80/tcp --permanent
# firewall-cmd --reload
systemctl restart firewalld.service
sleep 3

# (3-3) Start the web server and session storage service and configure them to start when the system boots:
# 이미 kilo-3.1.2-4.controller.sh 에서 서비스 등록및 서비스 기동 했음 
# 그러므로 지금은 서비스 제기동이 필요함.
# systemctl enable httpd.service memcached.service
# systemctl start httpd.service memcached.service
systemctl restart httpd.service memcached.service
echo "[CONTROLLER]===================================> start httpd.service memcached.service"
sleep 3
while ! (systemctl is-active httpd.service memcached.service >/dev/null 2>&1)  do :; done
echo "[CONTROLLER]===================================> start httpd.service memcached.service Done!"


# 7.3 Verify operation
# Access the dashboard using a web browser: http://controller/dashboard
# Authenticate using admin or demo user credentials.
# 7.3 Next steps
