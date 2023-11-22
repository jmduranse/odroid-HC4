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

sync

# Spin down drives
for d in "${CHECK_DRIVES[@]}"; do
    spindown "$d"
done
