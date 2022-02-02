#!/bin/bash

LOG_FILE="/var/log/mysql_backups_log.txt"
BACKUP_DIR="/home/vagrant/db_backup"

if [[ "${UID}" -ne 0 ]]
then
    tput setaf 3; echo "Plese run as sudo user!"; tput sgr0
    exit 1
else
    echo "$(date) - You run mysql backup script." >> $LOG_FILE
fi

help_f() {
tput setaf 3
cat <<eof
You must enter at least one database name!

Example: root@localhost:~# 5.0-backup.sh db_name1 db_name2...
eof
tput sgr0
exit 1
}

selectdb_backup() {
    
    if [[ ! -d "${BAKUP_DIR}" ]]
    then
        mkdir $BACKUP_DIR
        echo "Dir db_backup created!"
    fi

    mysqldump -u root -p --databases $@ > $BACKUP_DIR/mydb.sql
    
    if [[ "${?}" -eq 0 ]]
    then
        tput setaf 2; echo "$(date) - Backups operations finish succesfully!"; tput sgr0
        echo "$(date) - Backups operations finish succesfully!" >> $LOG_FILE
    else
        tput setaf 1; echo "$(date) - ERROR! Cant backup you database(s)! Check databases names!"; tput sgr0
        echo "$(date) - Backups operations filed!" >> $LOG_FILE
        exit 1
    fi
}

if [[ "${#}" -lt 1 ]]
then
    help_f
else
    selectdb_backup $@
fi
