#!/bin/bash

LOG_FILE="/var/log/lemp-install.log"

# Run as sudo only
if [[ "${UID}" -ne 0 ]]
then
    tput setaf 3; echo "Please enter like sudo user!"; tput sgr0
    exit 1
else
    echo "$(date) - run lemp install script!"
fi

# Install nginx
install_nginx() {
    apt-get update
    apt-get -y install nginx >> $LOG_FILE
    if [[ "$?" -eq 0 ]]
    then
        tput setaf 2; echo "Installation of nginx successfully complete!" 
        nginx -v
        tput sgr0
    else
        tput setaf 1; echo "Installation failed!"; tput sgr0
        exit 1
    fi
}

# copy my config to nginx folder
nginx_config() {
    nginx_config="nginx.conf"
    my_com_config="ihor.com.conf"

    if [[ -f "./nginx_conf/${nginx_config}" ]] || [[ -f "./nginx_conf/${my_com_config}" ]]; then
        cp ./nginx_conf/${nginx_config} /etc/nginx
        cp ./nginx_conf/${my_com_config} /etc/nginx/sites-available
        cp -r ./ihor.com/ /var/www/html
        ln -s /etc/nginx/sites-available/ihor.com.conf /etc/nginx/sites-enabled/ihor.com.conf

        # SSL keys copy
        cp ./nginx_conf/*.key /etc/ssl/private/
        
        echo "You config successfully copy to nginx folder."
        nginx -t
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
    else
        ufw allow 'Nginx HTTP'
        ufw status >> $LOG_FILE
    fi
}

# Install MySql
mysql_install() {
    apt-get install -y mysql-server >> $LOG_FILE
    if [[ "${?}" -ne 0 ]]
    then
        tput setaf 1; echo "ERROR to install mysql! Check repos config!"
        tput sgr0
        exit 1
    else
        tput setaf 2; echo "Installation of mysql-server successfully complete!" 
        mysql --version
        tput sgr0
    fi
}

# copy my my.cnf files
mysql_cnf_replace() {
    my_cnf="mysql.cnf"

    if [[ -f "./mysql_conf/${my_cnf}" ]]
    then
        echo "mysql.cnf copied successfully!!!"
        cp ./mysql_conf/${my_cnf} /etc/mysql
    else
        echo "ERROR to copy confgiguration file. Check it they exist and all cnf files must be in the same dir with script file."
    fi
}

# mysql secure install
mysql_secure_ins() {
    mysql_secure_installation
}

# php install
php_install() {
    apt-get -y install php-fpm php-common php-mbstring php-xmlrpc php-soap php-gd php-xml php-intl php-mysql php-cli php-ldap php-zip php-curl >> $LOG_FILE
        if [[ "$?" -eq 0 ]]
    then
        tput setaf 2; echo "Installation of php successfully complete!" 
        nginx -v
        tput sgr0
    else
        tput setaf 1; echo "Installation of php failed!"; tput sgr0
        exit 1
    fi
}

wordpress_install() {
    wget https://wordpress.org/latest.tar.gz
    tar -xf *.tar.gz
    mv ./wordpress/* /var/www/html/ihor.com
}

# install_nginx
# nginx_config
# firewall_config
# mysql_install
# mysql_cnf_replace
# mysql_secure_ins
# php_install
wordpress_install

