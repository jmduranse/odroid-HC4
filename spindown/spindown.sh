#!/bin/bash
# Spindown the drives

# Storage drives only
DRIVE1="/dev/sda"
DRIVE2="/dev/sdb"
mail="jmduran"
CHECK_DRIVES=("$DRIVE1" "$DRIVE2")

function spindown() {
   local drive="$1"
   if hdparm -C "$drive" | grep -q "standby"; then
       echo "Drive $drive is already in standby"
   else
       if hdparm -y "$drive"; then
           echo "Spinning down: $drive"
           echo "$(date): Spun down $drive" >> /var/log/drive_spindown.log
       else
           echo "Error spinning down $drive"
       fi
   fi
}


function check_use() {
   local drive="$1"
   local fileuse
   fileuse="$(lsof "$drive")"

   if [[ -n "$fileuse" ]]; then
       echo "Unable to spin down disk $drive"
       mail -s "Unable to spin down disk $drive" $mail <<<"The following processes are using the disk: $fileuse"
       return 1
   else
       return 0
   fi
}
sync #probably unnecesary

# Spin down drives
for d in "${CHECK_DRIVES[@]}"; do
  check_use "$d" && spindown "$d"
done
