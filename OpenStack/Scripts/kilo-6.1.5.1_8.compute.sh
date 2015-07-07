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

# ============================================================================================
# 6 Add a networking component
# 6.1 OpenStack Networking (neutron)
# 6.1.1 OpenStack Networking
# 6.1.2 Networking concepts
# 6.1.3 Install and configure controller node
# 6.1.4 Install and configure network node
# 6.1.5 Install and configure compute node
# (1) Install and configure network node
# (2) To configure prerequisites
# (2-1) Edit the /etc/sysctl.conf file to contain the following parameters:
# 아래 처럼 하면 타이틀 커멘트 위에 설정이 붙는다.
echo "net.ipv4.conf.all.rp_filter=0" >> /etc/sysctl.conf
echo "net.ipv4.conf.default.rp_filter=0" >> /etc/sysctl.conf
echo "net.bridge.bridge-nf-call-iptables=1" >> /etc/sysctl.conf
echo "net.bridge.bridge-nf-call-ip6tables=1" >> /etc/sysctl.conf

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
crudini --set /etc/neutron/neutron.conf keystone_authtoken password #{NEUTRON_PASS}

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

# (5-1-2) In the [ml2_type_gre] section, configure the tunnel identifier (id) range:
# [ml2_type_gre]
crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini ml2_type_gre tunnel_id_ranges 1:1000

# (5-1-3) In the [securitygroup] section, enable security groups, enable ipset, and configure the OVS iptables firewall driver:
# [securitygroup]
crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini securitygroup enable_security_group True
crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini securitygroup enable_ipset True
crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini securitygroup firewall_driver neutron.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver

# (5-1-4) In the [ovs] section, enable tunnels, configure the local tunnel endpoint, and map the external flat provider network to the br-ex external network bridge:
# [ovs]
crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini ovs local_ip ${INSTANCE_TUNNELS_INTERFACE_IP_ADDRESS_COMPUTE}

# (5-1-5) In the [agent] section, enable GRE tunnels:
# [agent]
crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini agent tunnel_types gre

# (6) To configure the Open vSwitch (OVS) service
# (6-1) Start the OVS service and configure it to start when the system boots:
systemctl enable openvswitch.service
systemctl start openvswitch.service
echo "[COMPUTE]===================================> start openvswitch.service"
while ! (systemctl is-active openvswitch.service >/dev/null 2>&1)  do :; done
echo "[COMPUTE]===================================> start openvswitch.service Done!"

# (7) To configure Compute to use Networking
# (7-1) Edit the /etc/nova/nova.conf file and complete the following actions:
# (7-1-1) In the [DEFAULT] section, configure the APIs and drivers:
# [DEFAULT]
crudini --set /etc/nova/nova.conf DEFAULT network_api_class nova.network.neutronv2.api.API
crudini --set /etc/nova/nova.conf DEFAULT security_group_api neutron
crudini --set /etc/nova/nova.conf DEFAULT linuxnet_interface_driver nova.network.linux_net.LinuxOVSInterfaceDriver
crudini --set /etc/nova/nova.conf DEFAULT firewall_driver nova.virt.firewall.NoopFirewallDriver

# Note
# By default, Compute uses an internal firewall service. Since Networking includes a firewall service, you must disable the Compute firewall service by using the nova.virt.firewall.NoopFirewallDriver firewall driver.
systemctl disable firewalld.service
systemctl stop firewalld.service
echo "[COMPUTE]===================================> stop firewalld.service"
while (systemctl is-active stop firewalld.service >/dev/null 2>&1)  do :; done
echo "[COMPUTE]===================================> stop firewalld.service Done!"

# (7-1-2) In the [neutron] section, configure access parameters:
# [neutron]
crudini --set /etc/nova/nova.conf neutron url http://controller:9696
crudini --set /etc/nova/nova.conf neutron auth_strategy keystone
crudini --set /etc/nova/nova.conf neutron admin_auth_url http://controller:35357/v2.0
crudini --set /etc/nova/nova.conf neutron admin_tenant_name service
crudini --set /etc/nova/nova.conf neutron admin_username neutron
crudini --set /etc/nova/nova.conf neutron admin_password ${NEUTRON_PASS}

# (8) To finalize the installation
# (8-1) The Networking service initialization scripts expect a symbolic link /etc/neutron/plugin.ini pointing to the ML2 plug-in configuration file, /etc/neutron/plugins/ml2/ml2_conf.ini. If this symbolic link does not exist, create it using the following command:
ln -s /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugin.ini

cp /usr/lib/systemd/system/neutron-openvswitch-agent.service \
  /usr/lib/systemd/system/neutron-openvswitch-agent.service.orig
sed -i 's,plugins/openvswitch/ovs_neutron_plugin.ini,plugin.ini,g' \
  /usr/lib/systemd/system/neutron-openvswitch-agent.service

# (8-2) Restart the Compute service:
systemctl restart openstack-nova-compute.service
echo "[COMPUTE]===================================> restart openstack-nova-compute.service"
sleep 2
while ! (systemctl is-active openstack-nova-compute.service >/dev/null 2>&1)  do :; done
echo "[COMPUTE]===================================> restart openstack-nova-compute.service Done!"

# (8-3) Start the Open vSwitch (OVS) agent and configure it to start when the system boots:
systemctl enable neutron-openvswitch-agent.service
systemctl start neutron-openvswitch-agent.service
echo "[COMPUTE]===================================> start neutron-openvswitch-agent.service"
while ! (systemctl is-active neutron-openvswitch-agent.service >/dev/null 2>&1)  do :; done
echo "[COMPUTE]===================================> start neutron-openvswitch-agent.service Done!"
sleep 2
# (9) Verify operation


# 6.1.6 Create initial networks
# 6.2 Legacy networking (nova-network)
# 6.2.1 Configure controller node
# 6.2.2 Configure compute node
# 6.2.3 Create initial network
# 6.3 Next steps
