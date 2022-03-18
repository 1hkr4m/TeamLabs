#!/bin/bash

sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config    
sudo systemctl restart sshd.service
sudo yum -y update
sudo hostnamectl set-hostname $1