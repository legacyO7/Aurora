#!/bin/bash

 permission_checker(){
    count=0

    files=(
    "/sys/devices/platform/faustus/leds/asus::kbd_backlight/brightness"
    "/sys/devices/platform/faustus/kbbl/kbbl_red"
    "/sys/devices/platform/faustus/kbbl/kbbl_green"
    "/sys/devices/platform/faustus/kbbl/kbbl_blue"
    "/sys/devices/platform/faustus/kbbl/kbbl_mode"
    "/sys/devices/platform/faustus/kbbl/kbbl_speed"
    "/sys/devices/platform/faustus/kbbl/kbbl_flags"
    "/sys/devices/platform/faustus/kbbl/kbbl_set"
    "/sys/class/power_supply/BAT1/charge_control_end_threshold"
    "/etc/systemd/system/"
    )


    for file in ${files[*]}; do

      if [ -w $file ]; then
        let "count+=1"

      elif [ $file == "/etc/systemd/system/" ] && [ ! -d "/etc/systemd/system/" ]; then
         let "count+=1"
      fi

    done

    if [ "${#files[@]}" -eq $count ]; then
      echo true
    else
      echo false
    fi
}

permission_checker_file(){
   if [ -w $1 ];  then
             echo true
           else
             echo false
   fi
}

if [ $# -ne 0 ];  then
    permission_checker_file $1
else
  permission_checker
fi
