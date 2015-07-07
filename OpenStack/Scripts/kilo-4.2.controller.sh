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

# 4.2 Verify operation
# (1) In each client environment script, configure the Image service client to use API version 2.0:

echo "export OS_IMAGE_API_VERSION=2" | tee -a ~student/env/admin-openrc.sh ~student/env/demo-openrc.sh
# (2) Source the admin credentials to gain access to admin-only CLI commands:
source ~student/env/admin-openrc.sh

# (3) Create a temporary local directory:
mkdir /tmp/images

# (4) Download the source image into it:

#wget -P /tmp/images http://download.cirros-cloud.net/0.3.4/cirros-0.3.4-x86_64-disk.img
wget -P  /tmp/images http://10.0.0.100/cirros-cloud/0.3.4/cirros-0.3.4-x86_64-disk.img

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
