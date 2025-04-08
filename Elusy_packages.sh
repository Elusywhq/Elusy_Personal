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
  qstat -fx $1 | grep job_stat | awk '{print $3}'
}

function PBS-host()
{
  qstat -f $1 | grep host
}
