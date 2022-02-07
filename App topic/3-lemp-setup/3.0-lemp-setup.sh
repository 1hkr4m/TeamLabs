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

# Install LEMP
install_lemp() {
    apt-get update
    apt install -y nginx  php-fpm  mariadb-server mariadb-client php-common php-mbstring php-xmlrpc php-soap php-gd php-xml php-intl php-mysql php-cli php-ldap php-zip php-curl
 >> $LOG_FILE
    if [[ "$?" -eq 0 ]]
    then
        tput setaf 2; echo "Installation of LEMP successfully complete!" 
        nginx -v
        tput sgr0
    else
        tput setaf 1; echo "LEMP installation failed!"; tput sgr0
        exit 1
    fi
}

wordpress_install() {
    #wget https://wordpress.org/latest.tar.gz
    tar -xf latest.tar.gz -C /var/www/html/
    
}

all_configs() {

        # Configs for nginx
        cp ./nginx_conf/nginx.conf /etc/nginx
        cp ./nginx_conf/wp.conf /etc/nginx/sites-available/
        ln -s /etc/nginx/sites-available/wp.conf /etc/nginx/sites-enabled/
        rm /etc/nginx/sites-available/default
        rm /etc/nginx/sites-enabled/default

        # Confing for MySql 
        cp ./mysql_conf/mysql.cnf /etc/mysql
        mysql --user="root" --password="vagrant" --database="mysql" --execute="CREATE USER 'admin'@'localhost' IDENTIFIED BY 'admin';"
        mysql --user="root" --password="vagrant" --database="mysql" --execute="GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost' WITH GRANT OPTION;"
        mysql --user="root" --password="vagrant" --database="mysql" --execute="CREATE DATABASE wp_database;"

        # Configs for PHP
        cp ./php_conf/php.ini /etc/php/7.2/fpm/

        # Configs for Wordpress
        cp ./wp_conf/wp-config.php /var/www/html/wordpress
        chown www-data:www-data -R /var/www/html/wordpress/
        
        # SSL keys copy
        cp ./nginx_conf/*.key /etc/ssl/private/

        systemctl reload nginx.service
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

mysql_secure_ins() {
    mysql_secure_installation
}


install_lemp
wordpress_install
all_configs
firewall_config
mysql_secure_installation
