#!/bin/bash

if [[ $(hostname) == *"atlas"* ]]; then
  Host="hpc"
  scratch=/hpctmp/e0732532
  echo "atlas"
  echo $scratch
elif [[ $(hostname) == *"asp2a"* ]]; then
  Host="nscc"
  scratch=/home/users/nus/$USER
  echo "nscc"
elif [[ $(hostname) == *"Precision"* ]]; then
  Host="bohr"
  scratch=/home/scratch/hanqi/orca
  echo "bohr"
fi



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

function PBS-chmlu5()
{
    if [ "$Host" = "hpc" ]; then
        for file in "$@"; do
           file_name=${file%.*}
           sed -i "s/colo-chmlu-08/colo-chmlu-05/g" "$file_name.sh"
        done
    fi

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
