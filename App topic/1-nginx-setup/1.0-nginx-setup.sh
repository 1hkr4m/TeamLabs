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
    if [[ "$(systemctl status nginx.service | grep Active | cut -d ":" -f2 | cut -d " " -f2)" -eq "active" ]]
    then
        echo "nginx is acive"
        nginx -t >>  $LOG_FILE
        nginx -v >> $LOG_FILE
    else
        echo "nginx is down"
        systemctl enable nginx.service
        systemctl start nginx.service
    fi
}

set_config() {
    nginx_config="nginx.conf"
    my_com_config="ihor.com.conf"
    if [[ -f "$(pwd)/${nginx_config}" ]] || [[ -f "$(pwd)/${my_com_config}" ]]; then
        cp ${nginx_config} /etc/nginx
        cp ${my_com_config} /etc/nginx/sites-avalible
    else
        echo "ERROR to exports your config files. Please, check it!"
    fi
}

# Add rulles to firewall, if it neeed to
firewall_config() {
    if [[ "$(ufw status | cut -d " " -f2)" -eq "inactive" ]]
    then
        echo "Firewall is down, but rules added"
        ufw allow 'Nginx HTTP'
        exit 0
    else
        ufw allow 'Nginx HTTP'
        ufw status
    fi
}

install_nginx
test_nginx
set_config
firewall_config
