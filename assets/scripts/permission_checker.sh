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
    "/usr/lib/systemd/system/"
    )


    for file in ${files[*]}; do

      if [ -w $file ]; then
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

checkpackages(){

  for package in dkms openssl mokutil git make cmak
  do
    if ! command -v $package &> /dev/null
    then
         packages_to_install="$packages_to_install $package"
    fi
  done
  echo $packages_to_install
}

if [ $# -ne 0 ];  then

  if [ "$1" == "checkpackages" ]; then
      checkpackages
  else
     permission_checker_file $1
  fi
else
  permission_checker
fi
