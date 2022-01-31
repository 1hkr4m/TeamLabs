#!/bin/bash
cpu_mon() {
    cores_count=$(cat /proc/stat | grep cpu | tail -n +2 | wc -l)
    cpuuse=$(cat /proc/loadavg | awk '{print $3}')
    #echo "$cpuuse and $cores_count"

    if [[ $cpuuse > $cores_count ]]; then
        echo "+----------------------------------------+" >> ~/log-mon.txt
        date >> ~/log-mon.txt
        echo "ATTENTION: CPU load is high on $(hostname)" >> ~/log-mon.txt
    fi
}

mem_mon() {
    #all RAM in system 
    ram_all="$(free | grep Mem | awk '{print $2}')"
    #Only using RAM by system in that moment
    ram_usg="$(free| grep Mem | awk '{print $3}')"
    va1=$(awk "BEGIN {print $ram_usg/$ram_all*100}")
    code_red $va1 "RAM"
}

storage_mon() {
    str_var="$(df -h / | awk '/dev/{print $5}' | cut -c-2)"
    code_red $str_var "Root storage"
}

code_red() {
    if [[ $1 >  60 ]] && [[ $1 < 80 ]]; then
        echo "+----------------------------------------+" >> ~/log-mon.txt
        date >> ~/log-mon.txt
        echo "Warning! $2 usage is high - $1 %">>  ~/log-mon.txt
    elif [[ $1 > 80 ]]; then
        echo "+----------------------------------------+" >> ~/log-mon.txt
        date >> ~/log-mon.txt
        echo "CRITICAL! $2 usage is - $1 %" >> ~/log-mon.txt
    fi
}

cpu_mon
mem_mon
storage_mon
