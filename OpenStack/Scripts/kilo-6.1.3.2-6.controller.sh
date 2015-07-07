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

export DATABASE_ADMIN_PASS=pass_for_db
export NEUTRON_DBPASS=pass_for_db_neutron
export NEUTRON_PASS=pass_for_neutron
export RABBIT_PASS=pass_for_mq
export NOVA_PASS=pass_for_nova

# ============================================================================================
# 6 Add a networking component
# 6.1 OpenStack Networking (neutron)
# 6.1.1 OpenStack Networking
# 6.1.2 Networking concepts
# 6.1.3 Install and configure controller node

# (2) To install the Networking components
# (2-1) Install the packages:
yum -y install which
yum -y install openstack-neutron openstack-neutron-ml2 python-neutronclient

# (3) To configure the Networking server component
# (3-1) Edit the /etc/neutron/neutron.conf file and complete the following actions:
if [ ! -f /etc/neutron/neutron.conf ]; then
    touch /etc/neutron/neutron.conf
fi
# In the [database] section, configure database access:
# [database]
crudini --set /etc/neutron/neutron.conf database connection mysql://neutron:${NEUTRON_DBPASS}@controller/neutron
# In the [DEFAULT] and [oslo_messaging_rabbit] sections, configure RabbitMQ message queue access:
# [DEFAULT]
crudini --set /etc/neutron/neutron.conf DEFAULT rpc_backend rabbit
# [oslo_messaging_rabbit]
crudini --set /etc/neutron/neutron.conf oslo_messaging_rabbit rabbit_host controller
crudini --set /etc/neutron/neutron.conf oslo_messaging_rabbit rabbit_userid openstack
crudini --set /etc/neutron/neutron.conf oslo_messaging_rabbit rabbit_password ${RABBIT_PASS}

# In the [DEFAULT] and [keystone_authtoken] sections, configure Identity service access:
# [DEFAULT]
crudini --set /etc/neutron/neutron.conf DEFAULT auth_strategy keystone

# [keystone_authtoken]
crudini --del /etc/neutron/neutron.conf keystone_authtoken

crudini --set /etc/neutron/neutron.conf keystone_authtoken auth_uri http://controller:5000
crudini --set /etc/neutron/neutron.conf keystone_authtoken auth_url http://controller:35357
crudini --set /etc/neutron/neutron.conf keystone_authtoken auth_plugin password
crudini --set /etc/neutron/neutron.conf keystone_authtoken project_domain_id default
crudini --set /etc/neutron/neutron.conf keystone_authtoken user_domain_id default
crudini --set /etc/neutron/neutron.conf keystone_authtoken project_name service
crudini --set /etc/neutron/neutron.conf keystone_authtoken username neutron
crudini --set /etc/neutron/neutron.conf keystone_authtoken password ${NEUTRON_PASS}

# In the [DEFAULT] section, enable the Modular Layer 2 (ML2) plug-in, router service, and overlapping IP addresses:
crudini --set /etc/neutron/neutron.conf DEFAULT core_plugin ml2
crudini --set /etc/neutron/neutron.conf DEFAULT service_plugins router
crudini --set /etc/neutron/neutron.conf DEFAULT allow_overlapping_ips True

# In the [DEFAULT] and [nova] sections, configure Networking to notify Compute of network topology changes:

crudini --set /etc/neutron/neutron.conf DEFAULT notify_nova_on_port_status_changes True
crudini --set /etc/neutron/neutron.conf DEFAULT notify_nova_on_port_data_changes True
crudini --set /etc/neutron/neutron.conf DEFAULT nova_url http://controller:8774/v2

crudini --set /etc/neutron/neutron.conf nova auth_url http://controller:35357
crudini --set /etc/neutron/neutron.conf nova auth_plugin password
crudini --set /etc/neutron/neutron.conf nova project_domain_id default
crudini --set /etc/neutron/neutron.conf nova user_domain_id default
crudini --set /etc/neutron/neutron.conf nova region_name RegionOne
crudini --set /etc/neutron/neutron.conf nova project_name service
crudini --set /etc/neutron/neutron.conf nova username nova
crudini --set /etc/neutron/neutron.conf nova password ${NOVA_PASS}

# (4) To configure the Modular Layer 2 (ML2) plug-in
# (4-1) Edit the /etc/neutron/plugins/ml2/ml2_conf.ini file and complete the following actions:
if [ ! -f /etc/neutron/plugins/ml2/ml2_conf.ini ]; then
    touch /etc/neutron/plugins/ml2/ml2_conf.ini
fi

# In the [ml2] section, enable the flat, VLAN, generic routing encapsulation (GRE), and virtual extensible LAN (VXLAN) network type drivers, GRE tenant networks, and the OVS mechanism driver:
crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini ml2 type_drivers flat,vlan,gre,vxlan
crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini ml2 tenant_network_types gre
crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini ml2 mechanism_drivers openvswitch

# In the [ml2_type_gre] section, configure the tunnel identifier (id) range:
crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini ml2_type_gre tunnel_id_ranges 1:1000

# In the [securitygroup] section, enable security groups, enable ipset, and configure the OVS iptables firewall driver:
crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini securitygroup enable_security_group True
crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini securitygroup enable_ipset True
crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini securitygroup firewall_driver neutron.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver

# (5) To configure Compute to use Networking
# (5-1) Edit the /etc/nova/nova.conf file on the controller node and complete the following actions:
if [ ! -f /etc/nova/nova.conf ]; then
    touch /etc/nova/nova.conf
fi

# In the [DEFAULT] section, configure the APIs and drivers:
crudini --set /etc/nova/nova.conf DEFAULT network_api_class nova.network.neutronv2.api.API
crudini --set /etc/nova/nova.conf DEFAULT security_group_api neutron
crudini --set /etc/nova/nova.conf DEFAULT linuxnet_interface_driver nova.network.linux_net.LinuxOVSInterfaceDriver
crudini --set /etc/nova/nova.conf DEFAULT firewall_driver nova.virt.firewall.NoopFirewallDriver

# In the [neutron] section, configure access parameters:
crudini --set /etc/nova/nova.conf neutron url http://controller:9696
crudini --set /etc/nova/nova.conf neutron auth_strategy keystone
crudini --set /etc/nova/nova.conf neutron admin_auth_url http://controller:35357/v2.0
crudini --set /etc/nova/nova.conf neutron admin_tenant_name service
crudini --set /etc/nova/nova.conf neutron admin_username neutron
crudini --set /etc/nova/nova.conf neutron admin_password ${NEUTRON_PASS}


# (6) To finalize installation
# (6-1) The Networking service initialization scripts expect a symbolic link...
ln -s /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugin.ini
# (6-2) Populate the database:
su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf \
  --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron
sleep 5

# (6-3) Restart the Compute services:
systemctl restart openstack-nova-api.service openstack-nova-scheduler.service \
  openstack-nova-conductor.service
echo "[CONTROLLER]===================================> restart openstack-nova-api.service openstack-nova-scheduler.service openstack-nova-conductor.service"
sleep 2
while ! ( \
	(systemctl is-active openstack-nova-api.service >/dev/null 2>&1) && \
	(systemctl is-active openstack-nova-scheduler.service >/dev/null 2>&1) \
	)  do :; done
echo "[CONTROLLER]===================================> restart openstack-nova-api.service openstack-nova-scheduler.service openstack-nova-conductor.service Done!"
# (6-4) Start the Networking service and configure it to start when the system boots:
systemctl enable neutron-server.service
systemctl start neutron-server.service
echo "[CONTROLLER]===================================> start neutron-server.service"
while ! (systemctl is-active neutron-server.service >/dev/null 2>&1)  do :; done
echo "[CONTROLLER]===================================> start neutron-server.service Done!"
# sleep 5
