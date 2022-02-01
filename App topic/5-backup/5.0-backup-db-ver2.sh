#!/bin/bash

LOG_FILE="/var/log/mysql_backups_log.txt"
BACKUP_DIR="~/Backup"

if [[ "${UID}" -ne 0 ]]
then
    echo "Plese run as sudo user!"
    exit 1
else
    echo "$(date) - You run mysql backup script." >> $LOG_FILE
    menu_sc
fi

selectdb_backup() {
    
    if [[ ! -d /var/db_backup ]]
    then
        mkdir /var/db_backup
    fi

    echo "Enter names of dababases, that you want to backup! Plese, use only space key between names that db1_name db2_name... !"
    read SELECTED_DB

    mysqldump -u root -p --databases $SELECTED_DB > $BACKUP_DIR/selected_dump_$(date).sql
    
    if [[ "${?}" -eq 0 ]]
        echo "$(date) - Backups operations finish succesfully!" >> $LOG_FILE
    else
        echo "$(date) - ERROR! Cant backup you database(s)!" >> $LOG_FILE
        exit 1
    fi
}