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
# 9. Add Object Storage
# 9.1 Install and configure the controller node
# (1) To configure prerequisites
# (1-1) To create the Identity service credentials, complete these steps:
echo "[CALL scripts/kilo-9.1.1.controller.sh]============================================"
ssh student@10.0.0.11 "cd ~student/scripts/; ~student/scripts/kilo-9.1.1.controller.sh"

# (1-2) Create the Object Storage service API endpoint:

# (2) To install and configure the controller node components
# (2-1) Install the packages:
# (2-2) Obtain the proxy service configuration file from the Object Storage source repository:
# (2-3) Edit the /etc/swift/proxy-server.conf file and complete the following actions:
echo "[CALL scripts/kilo-9.1.2.controller.sh]============================================"
ssh root@10.0.0.11 "cd ~student/scripts/; ~student/scripts/kilo-9.1.2.controller.sh"

# 9.2 Install and configure the storage nodes
# (1) Configure unique items on the first storage node:
# (2) Configure unique items on the second storage node:
# (3) Configure shared items on both storage nodes:
# (4) Edit the /etc/rsyncd.conf file and add the following to it:
# (5) Start the rsyncd service and configure it to start when the system boots:
echo "[CALL scripts/kilo-9.2.object1.sh]============================================"
ssh root@10.0.0.51 "cd ~student/scripts/; ~student/scripts/kilo-9.2.object1.sh"

# 9.3 Create initial rings
echo "[CALL scripts/kilo-9.3.1_4.controller.sh]============================================"
ssh root@10.0.0.11 "cd ~student/scripts/; ~student/scripts/kilo-9.3.1_4.controller.sh"


# 9.3.4 Distribute ring configuration files
# Copy the account.ring.gz, container.ring.gz, and object.ring.gz files to the /etc/swift directory on each storage node and any additional nodes running the proxy service.
mkdir ~/OpenStack/Scripts/object1
scp root@10.0.0.11:/etc/swift/account.ring.gz   ~/OpenStack/Scripts/object1/
scp root@10.0.0.11:/etc/swift/container.ring.gz   ~/OpenStack/Scripts/object1/
scp root@10.0.0.11:/etc/swift/object.ring.gz   ~/OpenStack/Scripts/object1/

scp ~/OpenStack/Scripts/object1/account.ring.gz  root@10.0.0.51:/etc/swift/
scp ~/OpenStack/Scripts/object1/container.ring.gz  root@10.0.0.51:/etc/swift/
scp ~/OpenStack/Scripts/object1/object.ring.gz  root@10.0.0.51:/etc/swift/



# 9.4 Finalize installation
echo "[CALL scripts/kilo-9.4.1_2.controller.sh]============================================"
ssh root@10.0.0.11 "cd ~student/scripts/; ~student/scripts/kilo-9.4.1_2.controller.sh"

# (3) Copy the swift.conf file to the /etc/swift directory on each storage node and any additional nodes running the proxy service.
scp root@10.0.0.11:/etc/swift/swift.conf   ~/OpenStack/Scripts/object1/
scp ~/OpenStack/Scripts/object1/swift.conf  root@10.0.0.51:/etc/swift/
rm -rf  ~/OpenStack/Scripts/object1/

echo "[CALL scripts/kilo-9.4.4_5.controller.sh]============================================"
ssh root@10.0.0.11 "cd ~student/scripts/; ~student/scripts/kilo-9.4.4_5.controller.sh"

echo "[CALL scripts/kilo-9.4.4_6.object1.sh]============================================"
ssh root@10.0.0.51 "cd ~student/scripts/; ~student/scripts/kilo-9.4.4_6.object1.sh"

# 9.5 Verify operation
echo "[CALL scripts/kilo-9.5.controller.sh]============================================"
ssh student@10.0.0.11 "cd ~student/scripts/; ~student/scripts/kilo-9.5.controller.sh"
