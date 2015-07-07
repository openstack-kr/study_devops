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

# 2.8 Message queue
# (1) To install the message queue service
yum -y install rabbitmq-server

# (2) To configure the message queue service
# (2-1) Start the message queue service and configure it to start when the system boots:
systemctl enable rabbitmq-server.service
systemctl start rabbitmq-server.service
echo "[CONTROLLER]===================================> start rabbitmq-server.service"
while ! systemctl is-active rabbitmq-server.service >/dev/null 2>&1; do :; done
echo "[CONTROLLER]===================================> start rabbitmq-server.service Done!"
# sleep 2

# (2-2) Add the openstack user:
RABBIT_PASS=pass_for_mq
rabbitmqctl add_user openstack ${RABBIT_PASS}

# (2-3) Permit configuration, write, and read access for the openstack user:
rabbitmqctl set_permissions openstack ".*" ".*" ".*"

# Firewall을 연다.
# HTTP : OpenStack dashboard (Horizon) when it is not configured to use secure access.
firewall-cmd --zone=public --add-port=80/tcp --permanent
# HTTP alternate : OpenStack Object Storage (swift) service.
firewall-cmd --zone=public --add-port=8080/tcp --permanent
# HTTPS : Any OpenStack service that is enabled for SSL, especially secure-access dashboard.
firewall-cmd --zone=public --add-port=443/tcp --permanent
# rsync : OpenStack Object Storage. Required.
firewall-cmd --zone=public --add-port=873/tcp --permanent
# iSCSI target : OpenStack Block Storage. Required.
firewall-cmd --zone=public --add-port=873/tcp --permanent
# iSCSI target	3260 OpenStack Block Storage. Required.
firewall-cmd --zone=public --add-port=3260/tcp --permanent
# MySQL database service	3306	Most OpenStack components.
firewall-cmd --zone=public --add-port=3306/tcp --permanent
# Message Broker (AMQP traffic)	5672	OpenStack Block Storage, Networking, Orchestration, and Compute.
firewall-cmd --zone=public --add-port=5672/tcp --permanent

# Block Storage (cinder)	8776	publicurl and adminurl
firewall-cmd --zone=public --add-port=8776/tcp --permanent
# Compute (nova) endpoints	8774	publicurl and adminurl
firewall-cmd --zone=public --add-port=8774/tcp --permanent
# Compute API (nova-api)	8773, 8775	
firewall-cmd --zone=public --add-port=8773/tcp --add-port=8775/tcp --permanent
# Compute ports for access to virtual machine consoles	5900-5999	
firewall-cmd --zone=public --add-port=5900-5999/tcp --permanent
# Compute VNC proxy for browsers ( openstack-nova-novncproxy)	6080
firewall-cmd --zone=public --add-port=6080/tcp --permanent
# Compute VNC proxy for traditional VNC clients (openstack-nova-xvpvncproxy)	6081	
firewall-cmd --zone=public --add-port=6081/tcp --permanent
# Proxy port for HTML5 console used by Compute service	6082	
firewall-cmd --zone=public --add-port=6082/tcp --permanent
# Data processing service (sahara) endpoint	8386	publicurl and adminurl
firewall-cmd --zone=public --add-port=8386/tcp --permanent
# Identity service (keystone) administrative endpoint	35357	adminurl
firewall-cmd --zone=public --add-port=35357/tcp --permanent
# Identity service public endpoint	5000	publicurl
firewall-cmd --zone=public --add-port=5000/tcp --permanent
# Image service (glance) API	9292	publicurl and adminurl
firewall-cmd --zone=public --add-port=9292/tcp --permanent
# Image service registry	9191	
firewall-cmd --zone=public --add-port=9191/tcp --permanent
# Networking (neutron)	9696	publicurl and adminurl
firewall-cmd --zone=public --add-port=9696/tcp --permanent
# Object Storage (swift)	6000, 6001, 6002	
firewall-cmd --zone=public --add-port=6000-6002/tcp --permanent
# Orchestration (heat) endpoint	8004	publicurl and adminurl
firewall-cmd --zone=public --add-port=8004/tcp --permanent
# Orchestration AWS CloudFormation-compatible API (openstack-heat-api-cfn)	8000	
firewall-cmd --zone=public --add-port=8000/tcp --permanent
# Orchestration AWS CloudWatch-compatible API (openstack-heat-api-cloudwatch)	8003	
firewall-cmd --zone=public --add-port=8003/tcp --permanent
# Telemetry (ceilometer)	8777	publicurl and adminurl
firewall-cmd --zone=public --add-port=8777/tcp --permanent

# 재기동 중복 
# firewall-cmd --reload

firewall-cmd --zone=public --list-ports

systemctl restart firewalld.service
sleep 2
echo "[CONTROLLER]===================================> restart firewalld.service"
while ! systemctl is-active firewalld.service >/dev/null 2>&1; do :; done
echo "[CONTROLLER]===================================> restart firewalld.service Done!"
