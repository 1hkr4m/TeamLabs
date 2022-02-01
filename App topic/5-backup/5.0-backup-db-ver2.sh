#!/bin/bash

LOG_FILE="/var/log/mysql_backups_log.txt"
BACKUP_DIR="/home/vagrant/db_backup"

if [[ "${UID}" -ne 0 ]]
then
    echo "Plese run as sudo user!"
    exit 1
else
    echo "$(date) - You run mysql backup script."
fi

selectdb_backup() {
    
    if [[ ! -d "${BAKUP_DIR}" ]]
    then
        mkdir $BACKUP_DIR
        echo "Dir db_backup created!"
    fi

    echo "Enter names of dababases, that you want to backup!"
    read SELECTED_DB

    mysqldump -u root -p --databases $SELECTED_DB > $BACKUP_DIR/mydb.sql
    
    if [[ "${?}" -eq 0 ]]
    then
        echo "$(date) - Backups operations finish succesfully!"
    else
        echo "$(date) - ERROR! Cant backup you database(s)!"
        exit 1
    fi
}

selectdb_backup