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
# export INSTANCE_TUNNELS_INTERFACE_IP_ADDRESS_NETWORK=10.0.1.21
# export INSTANCE_TUNNELS_INTERFACE_IP_ADDRESS_COMPUTE=10.0.1.31
# export METADATA_SECRET=metadata_secret

# ============================================================================================
# 6 Add a networking component
# 6.1 OpenStack Networking (neutron)
# 6.1.1 OpenStack Networking
# 6.1.2 Networking concepts
# 6.1.3 Install and configure controller node
# 6.1.4 Install and configure network node
# (1) Install and configure network node
# (2) To configure prerequisites
# (2-1) Edit the /etc/sysctl.conf file to contain the following parameters:
# 아래 처럼 하면 타이틀 커멘트 위에 설정이 붙는다.
# crudini --set /etc/sysctl.conf '' net.ipv4.ip_forward 1
# crudini --set /etc/sysctl.conf '' net.ipv4.conf.all.rp_filter 0
# crudini --set /etc/sysctl.conf '' net.ipv4.conf.default.rp_filter 0

echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
echo "net.ipv4.conf.all.rp_filter=0" >> /etc/sysctl.conf
echo "net.ipv4.conf.default.rp_filter=0" >> /etc/sysctl.conf

# (2-2) Implement the changes:
sysctl -p

# (3) To install the Networking components
yum -y install openstack-neutron openstack-neutron-ml2 openstack-neutron-openvswitch

# (4) To configure the Networking common components
# (4-1) Edit the /etc/neutron/neutron.conf file and complete the following actions:
# (4-1-1) In the [database] section, comment out any connection options because network nodes do not directly access the database.
# crudini --del /etc/neutron/neutron.conf database

# (4-1-2) In the [DEFAULT] and [oslo_messaging_rabbit] sections, configure RabbitMQ message queue access:
# [DEFAULT]
crudini --set /etc/neutron/neutron.conf DEFAULT rpc_backend rabbit
# [oslo_messaging_rabbit]
crudini --set /etc/neutron/neutron.conf oslo_messaging_rabbit rabbit_host controller
crudini --set /etc/neutron/neutron.conf oslo_messaging_rabbit rabbit_userid openstack
crudini --set /etc/neutron/neutron.conf oslo_messaging_rabbit rabbit_password ${RABBIT_PASS}

# (4-1-3) In the [DEFAULT] and [keystone_authtoken] sections, configure Identity service access:
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

# (4-1-4) IIn the [DEFAULT] section, enable the Modular Layer 2 (ML2) plug-in, router service, and overlapping IP addresses:
# [DEFAULT]
crudini --set /etc/neutron/neutron.conf DEFAULT core_plugin ml2
crudini --set /etc/neutron/neutron.conf DEFAULT service_plugins router
crudini --set /etc/neutron/neutron.conf DEFAULT allow_overlapping_ips True

# (5) To configure the Modular Layer 2 (ML2) plug-in
# (5-1) Edit the /etc/neutron/plugins/ml2/ml2_conf.ini file and complete the following actions:
# (5-1-1) In the [ml2] section, enable the flat, VLAN, generic routing encapsulation (GRE), and virtual extensible LAN (VXLAN) network type drivers, GRE tenant networks, and the OVS mechanism driver:
# [ml2]
crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini ml2 type_drivers flat,vlan,gre,vxlan
crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini ml2 tenant_network_types gre
crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini ml2 mechanism_drivers openvswitch

# (5-1-2) In the [ml2_type_flat] section, configure the external flat provider network:
# [ml2_type_flat]
crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini ml2_type_flat flat_networks external

# (5-1-3) In the [ml2_type_gre] section, configure the tunnel identifier (id) range:
# [ml2_type_gre]
crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini ml2_type_gre tunnel_id_ranges 1:1000

# (5-1-4) In the [securitygroup] section, enable security groups, enable ipset, and configure the OVS iptables firewall driver:
# [securitygroup]
crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini securitygroup enable_security_group True
crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini securitygroup enable_ipset True
crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini securitygroup firewall_driver neutron.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver

# (5-1-5) In the [ovs] section, enable tunnels, configure the local tunnel endpoint, and map the external flat provider network to the br-ex external network bridge:
# [ovs]
crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini ovs local_ip ${INSTANCE_TUNNELS_INTERFACE_IP_ADDRESS_NETWORK}
crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini ovs bridge_mappings external:br-ex

# (5-1-6) In the [agent] section, enable GRE tunnels:
# [agent]
crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini agent tunnel_types gre

# (6) To configure the Layer-3 (L3) agent
# (6-1) Edit the /etc/neutron/l3_agent.ini file and complete the following actions:
# (6-1-1) In the [DEFAULT] section, configure the interface driver, external network bridge, and enable deletion of defunct router namespaces:
# [DEFAULT]
crudini --set /etc/neutron/l3_agent.ini DEFAULT interface_driver neutron.agent.linux.interface.OVSInterfaceDriver
crudini --set /etc/neutron/l3_agent.ini DEFAULT external_network_bridge ''
crudini --set /etc/neutron/l3_agent.ini DEFAULT router_delete_namespaces True

# (7) To configure the DHCP agent
# (7-1) Edit the /etc/neutron/dhcp_agent.ini file and complete the following actions:
# (7-1-1) In the [DEFAULT] section, configure the interface and DHCP drivers and enable deletion of defunct DHCP namespaces:
#[DEFAULT]
crudini --set /etc/neutron/dhcp_agent.ini DEFAULT interface_driver neutron.agent.linux.interface.OVSInterfaceDriver
crudini --set /etc/neutron/dhcp_agent.ini DEFAULT dhcp_driver neutron.agent.linux.dhcp.Dnsmasq
crudini --set /etc/neutron/dhcp_agent.ini DEFAULT dhcp_delete_namespaces True

# (8) To configure the metadata agent
# (8-1) Edit the /etc/neutron/metadata_agent.ini file and complete the following actions:
# (8-1-1) In the [DEFAULT] section, configure access parameters:
# [DEFAULT]
crudini --set /etc/neutron/metadata_agent.ini DEFAULT auth_uri http://controller:5000
crudini --set /etc/neutron/metadata_agent.ini DEFAULT auth_url http://controller:35357
crudini --set /etc/neutron/metadata_agent.ini DEFAULT auth_region RegionOne
crudini --set /etc/neutron/metadata_agent.ini DEFAULT auth_plugin password
crudini --set /etc/neutron/metadata_agent.ini DEFAULT project_domain_id default
crudini --set /etc/neutron/metadata_agent.ini DEFAULT user_domain_id default
crudini --set /etc/neutron/metadata_agent.ini DEFAULT project_name service
crudini --set /etc/neutron/metadata_agent.ini DEFAULT username neutron
crudini --set /etc/neutron/metadata_agent.ini DEFAULT password ${NEUTRON_PASS}


# (8-1-2) In the [DEFAULT] section, configure the metadata host:
# [DEFAULT]
crudini --set /etc/neutron/metadata_agent.ini DEFAULT nova_metadata_ip controller

# (8-1-3) In the [DEFAULT] section, configure the metadata proxy shared secret:
# [DEFAULT]
crudini --set /etc/neutron/metadata_agent.ini DEFAULT metadata_proxy_shared_secret ${METADATA_SECRET}
