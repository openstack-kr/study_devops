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
# export METADATA_SECRET=metadata_secret
# export NETWORK_EXTERNAL_IF_NAME = enp0s8

# ============================================================================================
# 6 Add a networking component
# 6.1 OpenStack Networking (neutron)
# 6.1.1 OpenStack Networking
# 6.1.2 Networking concepts
# 6.1.3 Install and configure controller node
# 6.1.4 Install and configure network node

# (9) To configure the Open vSwitch (OVS) service
# (9-1) Start the OVS service and configure it to start when the system boots:
systemctl enable openvswitch.service
systemctl start openvswitch.service
echo "[NETWORK]===================================> start openvswitch.service"
while ! (systemctl is-active openvswitch.service >/dev/null 2>&1)  do :; done
echo "[NETWORK]===================================> start openvswitch.service Done!"
# (9-2) Add the external bridge:
ovs-vsctl add-br br-ex
# (9-3) Add a port to the external bridge that connects to the physical external network interface:
ovs-vsctl add-port br-ex ${NETWORK_EXTERNAL_IF_NAME}


# (10) To finalize the installation
# (10-1) The Networking service initialization scripts expect a symbolic link /etc/neutron/plugin.ini pointing to the ML2 plug-in configuration file, /etc/neutron/plugins/ml2/ml2_conf.ini. If this symbolic link does not exist, create it using the following command:
ln -s /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugin.ini

cp /usr/lib/systemd/system/neutron-openvswitch-agent.service \
  /usr/lib/systemd/system/neutron-openvswitch-agent.service.orig
sed -i 's,plugins/openvswitch/ovs_neutron_plugin.ini,plugin.ini,g' \
  /usr/lib/systemd/system/neutron-openvswitch-agent.service

# (10-2) Start the Networking services and configure them to start when the system boots:
systemctl enable neutron-openvswitch-agent.service neutron-l3-agent.service \
  neutron-dhcp-agent.service neutron-metadata-agent.service \
  neutron-ovs-cleanup.service
systemctl start neutron-openvswitch-agent.service neutron-l3-agent.service \
  neutron-dhcp-agent.service neutron-metadata-agent.service
echo "[NETWORK]===================================> start neutron-openvswitch-agent.service neutron-l3-agent.service neutron-dhcp-agent.service neutron-metadata-agent.service"
while ! ( \
	(systemctl is-active neutron-openvswitch-agent.service >/dev/null 2>&1) && \
	(systemctl is-active neutron-l3-agent.service >/dev/null 2>&1) && \
	(systemctl is-active neutron-dhcp-agent.service >/dev/null 2>&1) && \
	(systemctl is-active neutron-metadata-agent.service >/dev/null 2>&1) \
	)  do :; done
echo "[NETWORK]===================================> start neutron-openvswitch-agent.service neutron-l3-agent.service neutron-dhcp-agent.service neutron-metadata-agent.service Done!"
