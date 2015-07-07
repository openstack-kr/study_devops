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

# ============================================================================================
# Init  VM 
echo "[kilo-step-01.sh]===========================================================================>>START>>"
./kilo-step-01.sh
echo "[kilo-step-01.sh]==============================================================================>>END>>"
# ============================================================================================
# Run Install

# ============================================================================================
# 2. Basic environment
# 2.2 Before you begin
# 2.3 Security (NOP)
# 2.4 Networking (NOP)
# 2.5 Network Time Protocol (NTP) (NOP)
# 
# 2.6 OpenStack packages & 필요 Package 설치
# 2.7 SQL database
#(1) To install and configure the database server
# (1-1) Install the packages:
# (1-2) Create and edit the /etc/my.cnf.d/mariadb_openstack.cnf file and complete the following actions:
# (2) To finalize installation
# (2-1) Start the database service and configure it to start when the system boots:
# (2-2) Secure the database service including choosing a suitable password for the root account:
# 2.8 Message queue
# (1) To install the message queue service
echo "[kilo-step-02.sh]===========================================================================>>START>>"
./kilo-step-02.sh
echo "[kilo-step-02.sh]==============================================================================>>END>>"
# ============================================================================================
# 3. Add the Identity service
# 3.1 Install and configure
# (1) To configure prerequisites
# Create the keystone database:
# Grant proper access to the keystone database:
# (2) To install and configure the Identity service components
# (3) To configure the Apache HTTP server
# (4) To finalize installation
# 3.2 Create the service entity and API endpoint
# (1) To configure prerequisites
# (2) To create the service entity and API endpoint
# (3) Regular (non-admin) tasks should use an unprivileged project and user. As an example, this guide creates the demo project and user.
# 3.4 Verify operation
# 3.5 Create OpenStack client environment scripts
echo "[kilo-step-03.sh]===========================================================================>>START>>"
./kilo-step-03.sh
echo "[kilo-step-03.sh]==============================================================================>>END>>"

# ============================================================================================
# 4. Add the Image service
# 4.1 Install and configure
# (1) To configure prerequisites
# (1-1) To create the database, complete these steps:
# Create the keystone database:
# Grant proper access to the keystone database:
# (1-2) Source the admin credentials to gain access to admin-only CLI commands:
# (1-3) To create the service credentials, complete these steps:
# (1-4) Create the Image service API endpoint:
# (2) To install and configure the Image service components
# (2-1) Install the packages:
# (2-2) Edit the /etc/glance/glance-api.conf file and complete the following actions:
# (2-3) Edit the /etc/glance/glance-registry.conf file and complete the following actions:
# (2-4) Populate the Image service database:
# (3) To finalize installation
# 4.2 Verify operation
# (1) In each client environment script, configure the Image service client to use API version 2.0:
echo "[kilo-step-04.sh]===========================================================================>>START>>"
./kilo-step-04.sh
echo "[kilo-step-04.sh]==============================================================================>>END>>"

# ============================================================================================
# 5. Add the Compute service
# 5.1 Install and configure controller node
# (1) To configure prerequisites
# (1-1) To create the database, complete these steps:
# (1-2) Source the admin credentials to gain access to admin-only CLI commands:
# (1-3) To create the service credentials, complete these steps:
# (1-4) Create the Compute service API endpoint:
# (2) To install and configure Compute controller components
# (3) To finalize installation
# # 5.2 Install and configure a compute node
# # (1) To install and configure the Compute hypervisor components
# # (2) To finalize installation
# # 5.3 Verify operation
echo "[kilo-step-05.sh]===========================================================================>>START>>"
./kilo-step-05.sh
echo "[kilo-step-05.sh]==============================================================================>>END>>"

# ============================================================================================
# 6 Add a networking component
# 6.1 OpenStack Networking (neutron)
# 6.1.1 OpenStack Networking
# 6.1.2 Networking concepts
# 6.1.3 Install and configure controller node
# 6.1.4 Install and configure network node
# 6.1.5 Install and configure compute node
# 6.1.6 Create initial networks
# 6.2 Legacy networking (nova-network)
# 6.2.1 Configure controller node
# 6.2.2 Configure compute node
# 6.2.3 Create initial network
# 6.3 Next steps
echo "[kilo-step-06.sh]===========================================================================>>START>>"
./kilo-step-06.sh
echo "[kilo-step-06.sh]==============================================================================>>END>>"
# ============================================================================================
# 7 Add the dashboard
# 7.1 System requirements
# 7.2 Install and configure
# (1) To install the dashboard components
# (2) To configure the dashboard
# (3) To finalize installation
# 7.3 Verify operation
# 7.4 Next steps
echo "[kilo-step-07.sh]===========================================================================>>START>>"
./kilo-step-07.sh
echo "[kilo-step-07.sh]==============================================================================>>END>>"

# ============================================================================================
# ======================================================================================================
# 8.  Add the Block Storage service
# 8.1 Install and configure controller node
# 8.2 Install and configure a storage node
# 8.3 Verify operation
# 8.4 Next steps
echo "[kilo-step-08.sh]===========================================================================>>START>>"
./kilo-step-08.sh
echo "[kilo-step-08.sh]==============================================================================>>END>>"


# ============================================================================================
# 9. Add Object Storage
# 9.1 Install and configure the controller node
# 9.2 Install and configure the storage nodes
# 9.3 Create initial rings
# 9.4 Finalize installation
# 9.5 Verify operation
echo "[kilo-step-09.sh]===========================================================================>>START>>"
./kilo-step-09.sh
echo "[kilo-step-09.sh]==============================================================================>>END>>"






