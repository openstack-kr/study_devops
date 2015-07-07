#!/bin/bash

vboxmanage startvm cent7-controller --type headless
vboxmanage startvm cent7-network --type headless
vboxmanage startvm cent7-compute --type headless
vboxmanage startvm cent7-block1  --type headless
vboxmanage startvm cent7-object1 --type headless

