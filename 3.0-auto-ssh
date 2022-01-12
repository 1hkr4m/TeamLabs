#!/bin/bash

#fun for new keys
setup_ssh() {
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/$HOSTNAME-key
    sshpass -p "password" ssh-copy-id -i ~/.ssh/$HOSTNAME-key.pub $1@$2
    ssh $1@$2 sudo 'grep -v "PertmitRootLogin" /etc/ssh/sshd_config > temp; echo "PermitRootLogin no" >> temp; sudo mv temp /etc/ssh/sshd_config'
    ssh $1@$2 sudo 'grep -v "PasswordAuthentication" /etc/ssh/sshd_config > temp; echo "PasswordAuthentication no" >> temp; sudo mv temp /etc/ssh/sshd_config'
}

setup_ssh $1 $2
