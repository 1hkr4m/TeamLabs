#!/bin/bash

# Centos
for i in CentOS-1 CentOS-2 CentOS-3; do vmrun -T ws stop /home/ihor/VMware/$i/$i.vmx; done

# Ubuntu
for i in Ubuntu2 Ubuntu-2 Ubuntu-3; do vmrun -T ws stop /home/ihor/VMware/$i/$i.vmx; done