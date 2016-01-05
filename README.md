# OpenStack_Install_shell_using_virtualbox
Install shell script for OpenStack Kilo
*******************************************************

* Install shell script for OpenStack Kilo (Version 3)
* First upload : 2015-06-24
* Last updated : 2015-12-27

*******************************************************

# TOC

* [Virtualization](#virtualization)
    * [VirtualBox Host Network](#virtualbox-host-network)
    * [Node Configuration](#node-nonfiguration)
    * [Node Specification](#node-specification)
* [Script](#script)
    * [Start Script](#start-script)
    * [Script Env Values](#script-env-values)
    * [Script Functions](#script-functions)
    * [Install Script](#install-script)
    * [Management Script](#management-script)

# Virtualization

* VirtualBox with Extension Pack
* OS : CentOS 7 Minimal , Ubuntu Server 14.01.3
   * Image Down: [Google Drive](https://drive.google.com/open?id=0B3onbEIPVlh3MkhRZjRzM1Y2QmM)
* Account (ID/PW)
    - root/0rootroot
    - student/123qwe

## System Architecture

![OpenStack Minimal Architecture Network Layout](https://cloud.githubusercontent.com/assets/624975/8559854/f0591124-254c-11e5-8a5b-3f4c5a3a7d42.jpg)

## VirtualBox Host Network

| Network name   | AP Address   |
| -------------- | ------------ |
| Host Network 0 | 203.0.113.1  |
| Host Network 1 | 10.0.0.1     |
| Host Network 2 | 10.0.1.1     |
| Host Network 7 | 10.0.4.1 (*) |
| Host Network 3 | 88.11.11.1   |
| Host Network 4 | 88.22.22.1   |
| Host Network 5 | 88.33.33.1   |
| Host Network 6 | 192.168.62.1 |

`*` : 10.0.2.1 Network의 경우  VirtualBox에서 NAT 용도로 예약 사용중

## Node Configuration

```
+----------------+------------------------------------------------------------------------+
|     Node       |                                Network                                 |  
+----------------+--------+----------------+---------------+---------------+--------------+
|                | enp0s3 |     enp0s8     |     enp0s9    |   enp0s10     |    enp0s8    | 
|                |  NAT   |    External    |   Management  |    Tunnel     |    Storage   |
+----------------+--------+----------------+---------------+---------------+--------------+
| Controller     |  NAT   |                |  10.0.0.11/24 |               |              |
| Network        |  NAT   |  Unnumbered    |  10.0.0.21/24 |  10.0.1.21/24 |              | 
| Compute1       |  NAT   |                |  10.0.0.31/24 |  10.0.1.31/24 | 10.0.4.31/24 |
| Block Storage1 |  NAT   |                |  10.0.0.41/24 |               | 10.0.4.41/24 |
| Object Storage1|  NAT   |                |  10.0.0.51/24 |               | 10.0.4.51/24 |
+----------------+--------+----------------+---------------+---------------+--------------+
| HOST           |        | HOST Network0  | HOST Network1 | HOST Network2 |              |
|                |        | 203.0.113.0/24 |  10.0.1.0/24  |  10.0.1.0/24  |              |
+----------------+--------+----------------+---------------+---------------+--------------+
```

## Node Specification

```
+----------------+--------------------------------------------+------------+------------+
|     Node       |               Hardware Requirements        |            |            |
+----------------+---------+------------+-------------+-------|   Host     |   Hosts    |
|                |     CPU |       RAM  |   Storage   |   NIC |   name     |            |
|                |   (min) |     (min)  |     (min)   | (min) |            |            |    
+----------------+---------+------------+-------------+-------+------------+------------+
| Controller     | 1-2(1)  | 8GB(2GB)   | 100GB(5GB)  | 1     | controller | controller |
| Network        | 1-2(1)  | 2GB(512MB) | 50GB(5GB)   | 3     | network    | network    |  
| Compute1       | 2-4+(1) | 8+GB(2GB)  | 100+GB(10GB)| 2     | compute    | compute    | 
| Block Storage1 |  1-2    | 2GB        | 100+GB      | 1     | block1     | block1     |
| Object Storage1|  1-2    | 4+GB       | 100+GB      | 1     | object1    | object1    |
+----------------+---------+------------+-------------+-------+------------+------------+
```

# Script

## Start Script 

* `OpenStack/Scripts/kilo-step-all.sh`

## Script Env Values

* `OpenStack/Scripts/common/kilo-perform-vars.common.sh`

## Script Functions

* `OpenStack/Scripts`
    - `kilo-function.host.sh`
    - `OpenStack/Scripts\common\`
      + `kilo-function.00_common.sh`
      + `kilo-function.02_base.sh`
      + `kilo-function.03_identity.sh`
      + `kilo-function.04_image.sh`
      + `kilo-function.05_compute.sh`
      + `kilo-function.06_network.sh`
      + `kilo-function.07_dashboard.sh`
      + `kilo-function.08_blockstorage.sh`
      + `kilo-function.09_objectstorage.sh`

## Install Script

* `OpenStack/Scripts/kilo-step-all.sh`
    - `OpenStack/Scripts/kilo-step-01.sh`
    - `OpenStack/Scripts/kilo-step-02.sh`
      + `02_Base/kilo-2.1.all.sh`
      + `02_Base/kilo-2.5.controller.sh`
      + `02_Base/kilo-2.5.other-conrtoller.sh`
      + if `LOCAL_REPOSITORY = 0`
        - `02_Base/kilo-2.6.a.all.sh`
      + else
        - `02_Base/kilo-2.6.b.all.sh`
      + `02_Base/kilo-2.7.1.controller.sh`
      + `02_Base/kilo-2.7.2.controller.sh`
      + `02_Base/kilo-2.8.1.controller.sh`

    - `OpenStack/Scripts/kilo-step-03.sh`
      + `03_Identity/kilo-3.1.1.controller.sh`
      + `03_Identity/kilo-3.1.2-4.controller.sh`
      + `03_Identity/kilo-3.2.controller.sh`
      + `03_Identity/kilo-3.3.controller.sh`
      + `03_Identity/kilo-3.4.controller.sh`
      + `03_Identity/kilo-3.5.controller.sh`

    - `OpenStack/Scripts/kilo-step-04.sh`
      + `04_Image/kilo-4.1.1-1.controller.sh`
      + `04_Image/kilo-4.1.1-2-4.controller.sh`
      + `04_Image/kilo-4.1.2-1-3.controller.sh`
      + `04_Image/kilo-4.2.controller.sh`

    - `OpenStack/Scripts/kilo-step-05.sh`
      + `05_Compute/kilo-5.1.1-1.controller.sh`
      + `05_Compute/kilo-5.1.1-2-4.controller.sh`
      + `05_Compute/kilo-5.2.1-2.compute.sh`
      + `05_Compute/kilo-5.3.1-4.controller.sh`

    - `OpenStack/Scripts/kilo-step-06.sh`
      + `06_Network/kilo-6.1.3.1.controller.sh`
      + `06_Network/kilo-6.1.3.2-6.controller.sh`
      + `06_Network/kilo-6.1.3.7.controller.sh`
      + `06_Network/kilo-6.1.4.11.controller.sh`
      + `06_Network/kilo-6.1.4.1_8-1.network.sh`
      + `06_Network/kilo-6.1.4.8-2_8-3.controller.sh`
      + `06_Network/kilo-6.1.4.9_10.network.sh`
      + `06_Network/kilo-6.1.5.compute.sh`
      + `06_Network/kilo-6.1.6.controller.sh`
      + `06_Network/kilo-6.2.1.controller.sh`
      + `06_Network/kilo-6.2.2.compute.sh`
      + `06_Network/kilo-6.2.3.controller.sh`
      + `06_Network/kilo-6.3.controller.sh`

    - `OpenStack/Scripts/kilo-step-07.sh`
      + `07_Dashboard/kilo-7.2_4.controller.sh`

    - `OpenStack/Scripts/kilo-step-08.sh`
      + `08_BlockStorage/kilo-8.1.1.controller.sh`
      + `08_BlockStorage/kilo-8.1.2-3.controller.sh`
      + `08_BlockStorage/kilo-8.2.1-3.block1.sh`
      + `08_BlockStorage/kilo-8.3.1_6.controller.sh`

    - `OpenStack/Scripts/kilo-step-09.sh`
      + `09_ObjectStorage/kilo-9.1.1.controller.sh`
      + `09_ObjectStorage/kilo-9.1.2.controller.sh`
      + `09_ObjectStorage/kilo-9.2.object1.sh`
      + `09_ObjectStorage/kilo-9.2.object2.sh`
      + `09_ObjectStorage/kilo-9.3.1_4.controller.sh`
      + `09_ObjectStorage/kilo-9.4.1_2.controller.sh`
      + `09_ObjectStorage/kilo-9.4.4_5.controller.sh`
      + `09_ObjectStorage/kilo-9.4.4_6.object1.sh`
      + `09_ObjectStorage/kilo-9.4.4_6.object2.sh`
      + `09_ObjectStorage/kilo-9.5.controller.sh`

## Management Script
  * Check service status
      + ALL service : `OpenStack/Scripts/status_services.sh`
      + Keystone Service : `status_keystone_services.sh`
      + Glance Service : `status_glance_services.sh`
      + Nova Service : `status_nova_services.sh`
      + Neutron Service : `status_neutron_services.sh`
      + Cinder Service : `status_cinder_services.sh`
      + Swift Service : `status_swift_services.sh`

  * Restart service
      + ALL service : `restart_services.sh`
      + Glance Service : `restart_glance_services.sh`
      + Nova Service : `restart_nova_services.sh`
      + Neutron Service : `restart_neutron_services.sh`
      + Cinder Service : `restart_cinder_services.sh`
      + Swift Service : `restart_swift_services.sh`
