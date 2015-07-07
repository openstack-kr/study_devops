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

# 필요 Package 설치
# node : ALL
# (1) wget

yum -y install wget

# (2) crudini
# pushd .
# cd ~student
# mkdir rpm
# cd rpm
# wget http://dl.fedoraproject.org/pub/epel/7/x86_64/c/crudini-0.5-1.el7.noarch.rpm
# rpm -Uvh crudini-0.5-1.el7.noarch.rpm
# popd

yum -y install crudini

# ======================================================================================================
# 2. Basic environment
# 2.5 Network Time Protocol (NTP) SKIP


# 2.6 OpenStack packages
# (1) To configure prerequisites
yum -y install http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm

# (2) To enable the OpenStack repository
yum -y install  http://rdo.fedorapeople.org/openstack-kilo/rdo-release-kilo.rpm

# (3) To finalize installation
yum -y upgrade 
yum -y install  openstack-selinux


# 2.7 SQL database
#(1) To install and configure the database server
# (1-1) Install the packages:
yum  -y install mariadb mariadb-server MySQL-python

# (1-2) Create and edit the /etc/my.cnf.d/mariadb_openstack.cnf file and complete the following actions:
crudini --set /etc/my.cnf.d/mariadb_openstack.cnf mysqld bind-address 10.0.0.11

crudini --set /etc/my.cnf.d/mariadb_openstack.cnf mysqld default-storage-engine innodb
crudini --set /etc/my.cnf.d/mariadb_openstack.cnf mysqld innodb_file_per_table
crudini --set /etc/my.cnf.d/mariadb_openstack.cnf mysqld collation-server utf8_general_ci
crudini --set /etc/my.cnf.d/mariadb_openstack.cnf mysqld init-connect  "'SET NAMES utf8'"
crudini --set /etc/my.cnf.d/mariadb_openstack.cnf mysqld character-set-server utf8

# (2) To finalize installation
# (2-1) Start the database service and configure it to start when the system boots:
systemctl enable mariadb.service
systemctl start mariadb.service


# (2-2) Secure the database service including choosing a suitable password for the root account:
DATABASE_ADMIN_PASS=pass_for_db

# Make sure that NOBODY can access the server without a password
mysql -e "UPDATE mysql.user SET Password = PASSWORD('${DATABASE_ADMIN_PASS}') WHERE User = 'root'"
# Kill the anonymous users
mysql -e "DROP USER ''@'localhost'"
# Because our hostname varies we'll use some Bash magic here.
mysql -e "DROP USER ''@'$(hostname)'"
# Kill off the demo database
mysql -e "DROP DATABASE test"
# Make our changes take effect
mysql -e "FLUSH PRIVILEGES"
# Any subsequent tries to run queries this way will get access denied because lack of usr/pwd param


# 2.8 Message queue
# (1) To install the message queue service
yum -y install rabbitmq-server

# (2) To configure the message queue service
# (2-1) Start the message queue service and configure it to start when the system boots:
systemctl enable rabbitmq-server.service
systemctl start rabbitmq-server.service

# (2-2) Add the openstack user:
RABBIT_PASS=pass_for_mq
rabbitmqctl add_user openstack ${RABBIT_PASS}

# (2-3) Permit configuration, write, and read access for the openstack user:
rabbitmqctl set_permissions openstack ".*" ".*" ".*"

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

# openssl rand -hex 10

# (2) To install and configure the Identity service components
# [root계정]
# Run the following command to install the packages:
yum -y install openstack-keystone httpd mod_wsgi python-openstackclient memcached python-memcached
# Start the Memcached service and configure it to start when the system boots:
systemctl enable memcached.service
systemctl start memcached.service
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

# 3.4 Verify operation
# or security reasons, disable the temporary authentication token mechanism:
sed -ie "s/ admin_token_auth / /" /usr/share/keystone/keystone-dist-paste.ini

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
openstack --os-auth-url http://controller:5000 \
  --os-project-domain-id default --os-user-domain-id default \
  --os-project-name demo --os-username demo --os-password pass_for_demo \
  user list




# 3.5 Create OpenStack client environment scripts
# To create the scripts
mkdir ~student/env
cat > ~student/env/admin-openrc.sh << EOF
export OS_PROJECT_DOMAIN_ID=default
export OS_USER_DOMAIN_ID=default
export OS_PROJECT_NAME=admin
export OS_TENANT_NAME=admin
export OS_USERNAME=admin
export OS_PASSWORD=pass_for_admin
export OS_AUTH_URL=http://controller:35357/v3
EOF

cat > ~student/env/demo-openrc.sh << EOF
export OS_PROJECT_DOMAIN_ID=default
export OS_USER_DOMAIN_ID=default
export OS_PROJECT_NAME=demo
export OS_TENANT_NAME=demo
export OS_USERNAME=demo
export OS_PASSWORD=pass_for_demo
export OS_AUTH_URL=http://controller:5000/v3
EOF

chown -R student:student  ~student/env

# To load client environment scripts
source ~student/env/admin-openrc.sh
openstack token issue

# ======================================================================================================
# 4. Add the Image service
export DATABASE_ADMIN_PASS=pass_for_db
export GLANCE_DBPASS=pass_for_db_glance
export GLANCE_PASS=pass_for_glance
# 4.1 Install and configure
# [일반 user계정]
# (1) To configure prerequisites
# (1-1) To create the database, complete these steps:
# Create the keystone database:
mysql -u root -p${DATABASE_ADMIN_PASS} -e "CREATE DATABASE glance;"
# Grant proper access to the keystone database:
mysql -u root -p${DATABASE_ADMIN_PASS} -e \
"GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY '${GLANCE_DBPASS}';"
mysql -u root -p${DATABASE_ADMIN_PASS} -e \
"GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY '${GLANCE_DBPASS}';"

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
# (2) To install and configure the Image service components
# [root계정]
# (2-1) Install the packages:
yum -y install openstack-glance python-glance python-glanceclient

# (2-2) Edit the /etc/glance/glance-api.conf file and complete the following actions:
# [database]
crudini --set /etc/glance/glance-api.conf database connection mysql://glance:${GLANCE_DBPASS}@controller/glance

# [keystone_authtoken]
crudini --set /etc/glance/glance-api.conf keystone_authtoken auth_uri http://controller:5000
crudini --set /etc/glance/glance-api.conf keystone_authtoken auth_url http://controller:35357
crudini --set /etc/glance/glance-api.conf keystone_authtoken auth_plugin password
crudini --set /etc/glance/glance-api.conf keystone_authtoken project_domain_id default
crudini --set /etc/glance/glance-api.conf keystone_authtoken user_domain_id default
crudini --set /etc/glance/glance-api.conf keystone_authtoken project_name service
crudini --set /etc/glance/glance-api.conf keystone_authtoken username glance
crudini --set /etc/glance/glance-api.conf keystone_authtoken password ${GLANCE_PASS}

# [paste_deploy]
crudini --set /etc/glance/glance-api.conf paste_deploy flavor keystone

# [glance_store]
crudini --set /etc/glance/glance-api.conf glance_store default_store file
crudini --set /etc/glance/glance-api.conf glance_store filesystem_store_datadir /var/lib/glance/images/

# [DEFAULT]
crudini --set /etc/glance/glance-api.conf DEFAULT notification_driver noop
crudini --set /etc/glance/glance-api.conf DEFAULT verbose True

# (2-3) Edit the /etc/glance/glance-registry.conf file and complete the following actions:
#[database]
crudini --set /etc/glance/glance-registry.conf database connection mysql://glance:${GLANCE_DBPASS}@controller/glance

# [keystone_authtoken]
crudini --set /etc/glance/glance-registry.conf keystone_authtoken auth_uri http://controller:5000
crudini --set /etc/glance/glance-registry.conf keystone_authtoken auth_url http://controller:35357
crudini --set /etc/glance/glance-registry.conf keystone_authtoken auth_plugin password
crudini --set /etc/glance/glance-registry.conf keystone_authtoken project_domain_id default
crudini --set /etc/glance/glance-registry.conf keystone_authtoken user_domain_id default
crudini --set /etc/glance/glance-registry.conf keystone_authtoken project_name service
crudini --set /etc/glance/glance-registry.conf keystone_authtoken username glance
crudini --set /etc/glance/glance-registry.conf keystone_authtoken password ${GLANCE_PASS}
 
# [paste_deploy]
crudini --set /etc/glance/glance-registry.conf paste_deploy flavor keystone

# [DEFAULT]
crudini --set /etc/glance/glance-registry.conf DEFAULT notification_driver noop
crudini --set /etc/glance/glance-registry.conf DEFAULT verbose True

# (2-4) Populate the Image service database:
su -s /bin/sh -c "glance-manage db_sync" glance


# (3) To finalize installation
systemctl enable openstack-glance-api.service openstack-glance-registry.service
systemctl start openstack-glance-api.service openstack-glance-registry.service


# 4.2 Verify operation
# (1) In each client environment script, configure the Image service client to use API version 2.0:

echo "export OS_IMAGE_API_VERSION=2" | tee -a ~student/env/admin-openrc.sh ~student/env/demo-openrc.sh
# (2) Source the admin credentials to gain access to admin-only CLI commands:
source ~student/env/admin-openrc.sh

# (3) Create a temporary local directory:
mkdir /tmp/images

# (4) Download the source image into it:

wget -P /tmp/images http://download.cirros-cloud.net/0.3.4/cirros-0.3.4-x86_64-disk.img

# (5) Upload the image to the Image service using the QCOW2 disk format, bare container format, and public visibility so all projects can access it:
glance image-create --name "cirros-0.3.4-x86_64" --file /tmp/images/cirros-0.3.4-x86_64-disk.img \
  --disk-format qcow2 --container-format bare --visibility public --progress


# (6) Confirm upload of the image and validate attributes:
glance image-list

# Delete image
declare -a VM_TEMP_IMAGE=(`glance image-list | grep cirros-0.3.4-x86_64 | awk '{print $2}'`)
echo ${VM_TEMP_IMAGE}
glance image-delete ${VM_TEMP_IMAGE}

# (7) Remove the temporary local directory and source image:
rm -rf /tmp/images

# ======================================================================================================
# 5. Add the Compute service
export DATABASE_ADMIN_PASS=pass_for_db
export NOVA_DBPASS=pass_for_db_nova
export NOVA_PASS=pass_for_nova
# 5.1 Install and configure controller node
# (1) To configure prerequisites
# (1-1)To create the database, complete these steps:
# Create the nova database:
mysql -u root -p${DATABASE_ADMIN_PASS} -e "CREATE DATABASE nova;"
# Grant proper access to the nova database:
mysql -u root -p${DATABASE_ADMIN_PASS} -e \
"GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' IDENTIFIED BY '${NOVA_DBPASS}';"
mysql -u root -p${DATABASE_ADMIN_PASS} -e \
"GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' IDENTIFIED BY '${NOVA_DBPASS}';"

# (1-2) Source the admin credentials to gain access to admin-only CLI commands:
source ~student/env/admin-openrc.sh
# (1-3) To create the service credentials, complete these steps:
# Create the nova user:
#openstack user create --password-prompt nova
#User Password:
#Repeat User Password:
openstack user create --password ${NOVA_PASS} nova

# Add the admin role to the nova user:
openstack role add --project service --user nova admin
# Create the nova service entity:
openstack service create --name nova --description "OpenStack Compute" compute

# (1-4) Create the Compute service API endpoint:
openstack endpoint create \
  --publicurl http://controller:8774/v2/%\(tenant_id\)s \
  --internalurl http://controller:8774/v2/%\(tenant_id\)s \
  --adminurl http://controller:8774/v2/%\(tenant_id\)s \
  --region RegionOne \
  compute

# (2) To install and configure Compute controller components


# (3) To finalize installation


# 5.2 Install and configure a compute node
# (1) To install and configure the Compute hypervisor components

# (2) To finalize installation

# 5.3 Verify operation

































