*******************************************************
* CodeTree 님께서 정리하신 OpenStack Kilo 설치 스크립트파일
* Update : 2015-06-24
*******************************************************

*OS : CentOS 7 Minimal
*Account(ID/PW) : root/orootroot
                  student/123qwe

*Virtualization : VMware 
*Install_Script : /Scripts/kilo-step-01.sh
                  /Scripts/kilo-step-02.sh
                  /Scripts/kilo-step-03.sh
                  /Scripts/kilo-step-04.sh
                  /Scripts/kilo-step-05.sh
                  /Scripts/kilo-step-06.sh
                  /Scripts/kilo-step-07.sh
                  /Scripts/kilo-step-08.sh
                  /Scripts/kilo-step-all.sh
                  
*VirtualBox Host Network
--------------------------------------------------------
| HOST Network0    |    203.0.113.1    
| HOST Network1    |    10.0.0.1
| HOST Network2    |    10.0.1.1
| HOST Network7    |    10.0.4.1    <- 10.0.2.1 Network는 Virtual Box에서 예약 사용중
| HOST Network3    |    88.11.11.1
| HOST Network4    |    88.22.22.1
| HOST Network5    |    88.33.33.1
| HOST Network6    |    192.168.62.1
-----------------------------------------------------------

------------------------------------------------------------------------------------------
|     Node       |                                     Network                           |  
-----------------------------------------------------------------------------------------|
|                | enp0s3 |       enp0s8  |     enp0s9    |    enp0s10    |     enp0s8   | 
|                |   NAT  |      External |   Management  |     Tunnel    |     Storage  |
-----------------------------------------------------------------------------------------|
| Controller     |   NAT  |               |  10.0.0.11/24 |               |              |
| Network        |   NAT  |    Unnumbered |  10.0.0.21/24 |  10.0.1.21/24 |              | 
| Compute1       |   NAT  |               |  10.0.0.31/24 |  10.0.1.31/24 | 10.0.4.31/24 |
| Block Storage1 |   NAT  |               |  10.0.0.41/24 |               | 10.0.4.41/24 |
| Object Storage1|   NAT  |               |  10.0.0.52/24 |               | 10.0.4.52/24 |
-----------------------------------------------------------------------------------------|
| HOST           |        | HOST Network0 | HOST Network1 | HOST Network2 |              |
|                |        | 203.0.113.1/24|  10.0.1.0/24  | 10.0.1.0/24   |              |
------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------
|     Node       |               Hardware Requirements       |            |            |
-------------------------------------------------------------|   Host     |   Hosts    |
|                |   CPU   |      RAM   |  Storage    | NIC  |   name     |            |
|                |   (min) |     (min)  |     (min)   | (min)|            |            |    
---------------------------------------------------------------------------------------|
| Controller     | 1-2(1)  | 8GB(2GB)   | 100GB(5GB)  | 1    | controller | controller |
| Network        | 1-2(1)  | 2GB(512MB) | 50GB(5GB)   | 3    | network    | network    |  
| Compute1       | 2-4+(1) | 8+GB(2GB)  | 100+GB(10GB)| 2    | compute    | compute    | 
| Block Storage1 |  1-2    | 2GB        | 100+GB      | 1    | block1     | block1     |
| Object Storage1|  1-2    | 4+GB       | 100+GB      | 1    | object1    | object1    |
----------------------------------------------------------------------------------------
