#!/bin/bash

LOG_FILE="/var/log/mysql-install.txt"

if [[ "${UID}" -ne 0 ]]
then
    echo "Plese enter like sudo user!"
    exit 1
fi

# Install MySql
mysql_install() {
    apt-get install -y mysql-server >> $LOG_FILE
    if [[ "${?}" -ne 0 ]]
    then
        echo "ERROR to install my sql! Check repos config!" >> $LOG_FILE
        exit 1
    fi
}

mysql_test() {
    if [[ "$(systemctl status mysql.service | grep Active | cut -d ":" -f2 | cut -d " " -f2)" -eq "active" ]]
    then
        mysql --version >> $LOG_FILE
    else
        echo "mysql is down" >> $LOG_FILE
        systemctl enable mysql.service
        systemctl start mysql.service
}
# copy my my.cnf files
mysql_cnf_replace() {
    my_cnf="my.cnf"
    mysql_cnf="mysql.cnf"
    mysqld_cnf="mysqld.cnf"

    if [[ -f "$(pwd)/${my_cnf}" ]] || [[ -f "$(pwd)/${mysql_cnf}"]] || [[ -f "$(pwd)/${mysqld_cnf}" ]]
    then
        cp ${my_cnf} /etc/mysql
        cp ${mysql_cnf} /etc/mysql/mysql.conf.d
        cp ${mysqld_cnf} /etc/mysql/mysql.conf.d
    else
        echo "ERROR to copy confgiguration file. Check it they exist and all cnf files must be in the same dir with script file."
    fi
}

# mysql secure install
mysql_secure_ins() {
    mysql_secure_installation
}

mysql_install
mysql_test
mysql_cnf_replace
mysql_secure_ins
