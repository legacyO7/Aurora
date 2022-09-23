#!/bin/bash

brightness_path=/sys/devices/platform/faustus/leds/asus::kbd_backlight/brightness
kbbl_red_path=/sys/devices/platform/faustus/kbbl/kbbl_red
kbbl_green_path=/sys/devices/platform/faustus/kbbl/kbbl_green
kbbl_blue_path=/sys/devices/platform/faustus/kbbl/kbbl_blue
kbbl_mode_path=/sys/devices/platform/faustus/kbbl/kbbl_mode
kbbl_speed_path=/sys/devices/platform/faustus/kbbl/kbbl_speed
kbbl_flags_path=/sys/devices/platform/faustus/kbbl/kbbl_flags
kbbl_set_path=/sys/devices/platform/faustus/kbbl/kbbl_set



setcolor(){
    echo $1 > $kbbl_red_path
    echo $2 > $kbbl_green_path
    echo $3 > $kbbl_blue_path
    setmode $4
}

setmode(){
    echo $1 > $kbbl_mode_path
}

setspeed(){
    echo $1 > $kbbl_speed_path
}

setbrightness(){
    echo $1 > $brightness_path
}

savesettings(){
  echo 2a > $kbbl_flags_path &&
  echo 1 > $kbbl_set_path &&
  echo
}

setaccess(){
  chmod -R o+rwx $brightness_path
  chmod -R o+rwx $kbbl_red_path
  chmod -R o+rwx $kbbl_green_path
  chmod -R o+rwx $kbbl_blue_path
  chmod -R o+rwx $kbbl_mode_path
  chmod -R o+rwx $kbbl_speed_path
  chmod -R o+rwx $kbbl_flags_path
  chmod -R o+rwx $kbbl_set_path
}

if [ $# -ne 0 ]
  then
    case "$1" in
    init)
    setaccess
    chmod -R o+rwx $2/battery_manager.sh
    sudo $2/battery_manager.sh $3
    ;;
    color)
    setcolor $2 $3 $4 $5
    savesettings
    ;;
    mode)
    setmode $2
    savesettings
    ;;
    speed)
    setspeed $2
    savesettings
    ;;
    brightness)
    setbrightness $2
    ;;
    save)
    savesettings
    ;;
    esac

fi

