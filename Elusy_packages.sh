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

function PBS-chmlu7()
{
    if [ "$Host" = "hpc" ]; then
        for file in "$@"; do
           file_name=${file%.*}
           sed -i "s/colo-chmlu-08/colo-chmlu-07/g" "$file_name.sh"
        done
    fi

}

function PBS-chmlu4()
{
    if [ "$Host" = "hpc" ]; then
        for file in "$@"; do
           file_name=${file%.*}
           sed -i "s/colo-chmlu-08/colo-chmlu-04/g" "$file_name.sh"
        done
    fi

}

