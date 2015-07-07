*******************************************************

* CodeTree 님께서 정리하신 OpenStack Kilo 설치 스크립트 파일
* First upload : 2015-06-24
* Last updated : 2015-07-08

*******************************************************

# TOC

* [Virtualization](#virtualization)
    * [VirtualBox Host Network](#virtualBox-host-network)
    * [Node Configuration](#node-configuration)
    * [Node Specification](#node-specification)
* [Script](#script)
    * [Start Script](#start-script)
    * [Install Script](#install-script)


# Virtualization

* VirtualBox with Extension Pack
* OS : CentOS 7 Minimal
* Account (ID/PW)
    - root/0rootroot
    - student/123qwe

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

## Install Script

* `OpenStack/Scripts/kilo-step-all.sh`
    - `OpenStack/Scripts/kilo-step-01.sh`
    - `OpenStack/Scripts/kilo-step-02.sh`
        + `kilo-perform-vars.common.sh`
        + if `LOCAL_REPOSITORY = 0`
            - `kilo-0.0.all.sh`
        + else 
            - `kilo-0.1.all.sh`
        + `kilo-2.7.1.controller.sh`
        + `kilo-2.7.2.controller.sh`
        + `kilo-2.8.1.controller.sh`
    - `OpenStack/Scripts/kilo-step-03.sh`
        + `kilo-3.1.1.controller.sh`
        + `kilo-3.1.2-4.controller.sh`
        + `kilo-3.2-3.controller.sh`
        + `kilo-3.4.controller.sh`
        + `kilo-3.5.controller.sh`
    - `OpenStack/Scripts/kilo-step-04.sh`
        + `kilo-4.1.1-1.controller.sh`
        + `kilo-4.1.1-2-4.controller.sh`
        + `kilo-4.1.2-1-3.controller.sh`
        + `kilo-4.2.controller.sh`
    - `OpenStack/Scripts/kilo-step-05.sh`
        + `kilo-5.1.1-1.controller.sh`
        + `kilo-5.1.1-2-4.controller.sh`
        + `kilo-5.1.2-3.controller.sh`
        + `kilo-5.2.1-2.compute.sh`
        + `kilo-5.3.1-4.controller.sh`
    - `OpenStack/Scripts/kilo-step-06.sh`
        + `kilo-6.1.3.1-1.controller.sh`
        + `kilo-6.1.3.1-2-4.controller.sh`
        + `kilo-6.1.3.2-6.controller.sh`
        + `kilo-6.1.3.7.controller.sh`
        + `kilo-6.1.4.1_8-1.network.sh`
        + `kilo-6.1.4.8-2_8-3.controller.sh`
        + `kilo-6.1.4.9_10.network.sh`
        + `kilo-6.1.4.10-1.network.sh`
        + `kilo-6.1.4.11.controller.sh`
        + `kilo-6.1.5.1_8.compute.sh`
        + `kilo-6.1.5.9.controller.sh`
    - `OpenStack/Scripts/kilo-step-07.sh`
        + `kilo-7.2_4.controller.sh`
    - `OpenStack/Scripts/kilo-step-08.sh`
        + `kilo-8.1.1-1.controller.sh`
        + `kilo-8.1.1-2-4.controller.sh`
        + `kilo-8.1.2-3.controller.sh`
        + `kilo-8.2.1-3.block1.sh`
        + `kilo-8.3.1_6.controller.sh`
    - `OpenStack/Scripts/kilo-step-09.sh`
        + `kilo-9.1.1.controller.sh`
        + `kilo-9.1.2.controller.sh`
        + `kilo-9.2.object1.sh`
        + `kilo-9.3.1_4.controller.sh`
        + `kilo-9.4.1_2.controller.sh`
        + `kilo-9.4.4_5.controller.sh`
        + `kilo-9.4.4_6.object1.sh`
        + `kilo-9.5.controller.sh`
