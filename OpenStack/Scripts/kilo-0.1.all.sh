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

# (2) crudini : 2.6.2이후에 만 설치 가능 하므로 뒤로 뺐다.
# yum -y install crudini

# ======================================================================================================
# 2. Basic environment
# 2.5 Network Time Protocol (NTP) SKIP


# 2.6 OpenStack packages
# (1) To configure prerequisites
echo '2.6.1 ===============> yum -y install http://10.0.0.100/repos/epel/7/x86_64/e/epel-release-7-5.noarch.rpm'
yum -y install http://10.0.0.100/repos/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
# Out으로 /etc/yum.repo.d/epel*.repo가 생긴다.

# (2) To enable the OpenStack repository
echo '2.6.2 ===============> yum -y install  http://http://10.0.0.100/repos/openstack-kilo/openstack-kilo/rdo-release-kilo-1.noarch.rpm'
yum -y install  http://http://10.0.0.100/repos/openstack-kilo/openstack-kilo/rdo-release-kilo-1.noarch.rpm
# Out으로 /etc/yum.repo.d/rdo*.repo가 생긴다.

# 이부분은 별도 모둘로 분리 필요
# ======================================================================================================
# Setting for Using CentOS7 Local Repository
cd /etc/yum.repos.d
for i in $(ls *.repo); do mv $i $i.orig; done

# create "/etc/yum.repos.d/CentOS7.repo" and insert :
cat << EOF > /etc/yum.repos.d/CentOS7.repo
[base]
name=CentOS-\$releasever - Base
baseurl=http://10.0.0.100/repos/centos/\$releasever/os/\$basearch/
gpgcheck=0
gpgkey=http://10.0.0.100/repos/centos/RPM-GPG-KEY-CentOS-7

[updates]
name=CentOS-\$releasever - Updates
baseurl=http://10.0.0.100/repos/centos/\$releasever/updates/\$basearch/
gpgcheck=0
gpgkey=http://10.0.0.100/repos/centos/RPM-GPG-KEY-CentOS-7

[extras]
name=CentOS-\$releasever - Extras
baseurl=http://10.0.0.100/repos/centos/\$releasever/extras/\$basearch/
gpgcheck=0
gpgkey=http://10.0.0.100/repos/centos/RPM-GPG-KEY-CentOS-7

[centosplus]
name=CentOS-\$releasever - Plus
baseurl=http://10.0.0.100/repos/centos/\$releasever/centosplus/\$basearch/
gpgcheck=0
gpgkey=http://10.0.0.100/repos/centos/RPM-GPG-KEY-CentOS-7
EOF

cat << EOF > /etc/yum.repos.d/epel7.repo
[epel]
name=Extra Packages for Enterprise Linux 7 - \$basearch
baseurl=http://10.0.0.100/repos/epel/7/\$basearch/
gpgkey=http://10.0.0.100/repos/epel/RPM-GPG-KEY-EPEL-7
failovermethod=priority
enabled=1
gpgcheck=0

[epel-debuginfo]
name=Extra Packages for Enterprise Linux 7 - \$basearch - Debug
baseurl=http://10.0.0.100/repos/epel/7/\$basearch/debug/
gpgkey=http://10.0.0.100/repos/epel/RPM-GPG-KEY-EPEL-7
failovermethod=priority
enabled=1
gpgcheck=0

[epel-source]
name=Extra Packages for Enterprise Linux 7 - \$basearch - Source
baseurl=http://10.0.0.100/repos/epel/7/SRPMS/
gpgkey=http://10.0.0.100/repos/epel/RPM-GPG-KEY-EPEL-7
failovermethod=priority
enabled=1
gpgcheck=0
EOF

cat << EOF > /etc/yum.repos.d/openstack-kilo.repo
[openstack-kilo]
name=OpenStack Kilo Repository
baseurl=http://10.0.0.100/repos/openstack-kilo/openstack-kilo/el7/
gpgkey=http://10.0.0.100/repos/openstack-kilo/openstack-kilo/RPM-GPG-KEY-EPEL-7
skip_if_unavailable=0
enabled=1
gpgcheck=0

[openstack-kilo-testing]
name=OpenStack Kilo Testing
baseurl=http://10.0.0.100/repos/openstack-kilo/openstack-kilo-testing/el7/
gpgkey=http://10.0.0.100/repos/openstack-kilo/openstack-kilo-testing/RPM-GPG-KEY-EPEL-7
skip_if_unavailable=0
gpgcheck=0
enabled=1
EOF

# 검증
cat /etc/yum.repos.d/CentOS7.repo
cat /etc/yum.repos.d/epel7.repo
cat /etc/yum.repos.d/openstack-kilo.repo

ls -l /etc/yum.repos.d


# fastestmirror 설정 취소
yum -y  --disableplugin=fastestmirror update
sed -i -e "s/^enabled=1/enabled=0/g" /etc/yum/pluginconf.d/fastestmirror.conf 

yum clean all

yum -y update

# 필요 Package 설치
# node : ALL
# (1) wget

echo '0.0.0.0 =============> yum -y install wget'
yum -y install wget

# (3) To finalize installation
echo '2.6.3 ===============> yum -y install  openstack-selinux'
yum -y install  openstack-selinux
echo '0.0.0.0 =============> yum -y install crudini'
yum -y install crudini

# ======================================================================================================
cat << EOF >> /etc/hosts 
# controller
10.0.0.11               controller
# network
10.0.0.21               network
# compute
10.0.0.31               compute
10.0.0.31               compute1
# block1
10.0.0.41               block1
# object1
10.0.0.51               object1
EOF
