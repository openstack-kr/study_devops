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


# 2.7 SQL database
#(1) To install and configure the database server
# (1-1) Install the packages:
echo '2.7.1-1 =============> yum  -y install mariadb mariadb-server MySQL-python'
yum  -y install mariadb mariadb-server MySQL-python

# (1-2) Create and edit the /etc/my.cnf.d/mariadb_openstack.cnf file and complete the following actions:
if [ ! -f /etc/my.cnf.d/mariadb_openstack.cnf ]; then
    touch /etc/my.cnf.d/mariadb_openstack.cnf
fi

echo '2.7.1-2 =============> crudini --set /etc/my.cnf.d/mariadb_openstack.cnf [section] [param] [value]'
crudini --set /etc/my.cnf.d/mariadb_openstack.cnf mysqld bind-address 10.0.0.11

crudini --set /etc/my.cnf.d/mariadb_openstack.cnf mysqld default-storage-engine innodb
crudini --set /etc/my.cnf.d/mariadb_openstack.cnf mysqld innodb_file_per_table
crudini --set /etc/my.cnf.d/mariadb_openstack.cnf mysqld collation-server utf8_general_ci
crudini --set /etc/my.cnf.d/mariadb_openstack.cnf mysqld init-connect  "'SET NAMES utf8'"
crudini --set /etc/my.cnf.d/mariadb_openstack.cnf mysqld character-set-server utf8


# (2) To finalize installation
# (2-1) Start the database service and configure it to start when the system boots:
echo '2.7.2-1 =============> systemctl enable mariadb.service'
systemctl enable mariadb.service
echo '2.7.2-1 =============> systemctl start mariadb.service'
systemctl start mariadb.service
echo "[CONTROLLER]===================================> start mariadb.service"
while ! systemctl is-active  mariadb.service >/dev/null 2>&1; do :; done
echo "[CONTROLLER]===================================> start mariadb.service Done!"
# sleep 5
