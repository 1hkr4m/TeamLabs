#!/bin/bash

LOG_FILE="/var/log/mysql_backups_log.txt"
BACKUP_DIR="/tmp"

if [[ "${UID}" -ne 0 ]]
then
    echo "Plese run as sudo user!"
    exit 1
else
    echo "$(date) - You run mysql backup script." >> $LOG_FILE
    menu_sc
fi

menu_sc() {

    echo "          List"
    echo "          ------"
    echo "What you want to backup?:"
    echo "1. Backup all databases!"
    echo "2. Backup only selected databases!"
    echo "3. Exit."
    echo

    read OPTION

    case ${OPTION} in
        1) alldb_backup ;;
        2) selectdb_backup ;;
        3) exit 0 ;;
    esac
}

alldb_backup() {

    mysqldump -u root -p --all-databases > $BACKUP_DIR/alldb_dump_$(date).sql

    if [[ "${?}" -eq 0 ]]
        echo "$(date) - Backups operations finish succesfully!" >> $LOG_FILE
    else
        echo "$(date) - ERROR! Cant backup you databases!" >> $LOG_FILE
        exit 1
    fi
}

selectdb_backup() {
    
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