#!/bin/bash

LOG_FILE="/var/log/nginx-install.txt"

# Run as sudo only
if [[ "${UID}" -ne 0 ]]
then
    echo 'Please run with sudo or as root' >&2
    exit 1
fi

# Install nginx
install_nginx() {
    apt-get update
    apt-get -y install nginx >> $LOG_FILE
    if [[ "$?" -eq 0 ]]
    then
        echo "Installation of nginx successfully complete!"
    else
        echo "Installation failed!"
        exit 1
    fi     
}

# Test of setup
test_nginx() {
    echo "You start your instalation on $(date)" >> $LOG_FILE
    systemctl status nginx >> $LOG_FILE
    var='active'
    if [[ "$(systemctl status nginx.service | grep Active | cut -d ":" -f2 | cut -d " " -f2)" -eq "$(var)" ]]
    then
        ehco "nginx is acive"
        exit 0
    else
        echo "nginx is down"
        systemctl enable nginx.service
        systemctl start nginx.service
    fi
    nginx -t >> $LOG_FILE
    nginx -V >> $LOG_FILE
}


# Add rulles to firewall, if it neeed to
firewall_config() {
    if [[ "$(ufw status | cut -d " " -f2)" -eq "inactive" ]]
    then
        exit 1
    else
        ufw allow 'Nginx HTTP'
        ufw status
    fi
}

install_nginx
test_nginx
firewall_config
