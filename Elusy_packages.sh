#!/bin/bash

crename() {
    if [[ $# -ne 2 ]]; then
        echo "Usage: crename [oldprefix] [newprefix]"
        return 1
    fi

    oldprefix="$1"
    newprefix="$2"

    shopt -s nullglob
    files=("${oldprefix}"*)
    shopt -u nullglob

    if [[ ${#files[@]} -eq 0 ]]; then
        echo "No files found with prefix '${oldprefix}'"
        return 1
    fi

    for oldfile in "${files[@]}"; do
        suffix="${oldfile#$oldprefix}"
        newfile="${newprefix}${suffix}"
        cp -i -- "$oldfile" "$newfile"
    done
}


function PBS-qstat()
{
    # for id in "$@"; do
    qstat -fx $1 | grep job_stat | awk '{print $3}'
}

function PBS-host()
{
    for id in "$@"; do
        qstat -f "$id" | grep host
    done
}

function qjlist_test(){
    if [ -n "$1" ]; then
        qstat -f | grep -E "Job Id|Job_Name" | awk '
            BEGIN { ORS="\t" } 
            /Job Id/ { printf "\n%-15s\t", substr($3, 1, 15) } 
            /Job_Name/ { job_name = $3 } 
            END { print job_name }' | while read -r line; do
                job_id=$(echo "$line" | awk '{print $1}')
                job_stat=$(qstat -fx "$job_id" | grep job_stat | awk "{print \$3}")
                echo -e "$line\t$job_stat"
            done | grep "$1"
    else
        qstat -f | grep -E "Job Id|Job_Name" | awk '
            BEGIN { ORS="\t" } 
            /Job Id/ { printf "\n%-15s\t", substr($3, 1, 15) } 
            /Job_Name/ { job_name = $3 } 
            END { print job_name }' | while read -r line; do
                job_id=$(echo "$line" | awk '{print $1}')
                job_stat=$(qstat -fx "$job_id" | grep job_stat | awk "{print \$3}")
                echo -e "$line\t$job_stat"
            done
    fi
}
