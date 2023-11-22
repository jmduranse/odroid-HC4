#!/bin/bash
# Spindown the drives

# Storage drives only
DRIVE1=/dev/sda
DRIVE2=/dev/sdb


CHECK_DRIVES=("$DRIVE1" "$DRIVE2")

function spindown() {

    if hdparm -C "$1" | grep -q "standby"
    then
	echo "Drive $1 is already in standby"
    else
	hdparm -y "$1"; echo "Spinning down: $1"
    fi
}


function check_use() {

    local fileuse
    fileuse="$(lsof "$1")"

    if  [[ -n  "$fileuse" ]]
    then
        mail -s "Unable to spin down disk $1"  jmduran <<<"$fileuse"
	return 1

    else
	return 0
    fi
}


sync

# Spin down drives
for d in "${CHECK_DRIVES[@]}"; do
    spindown "$d"
done
