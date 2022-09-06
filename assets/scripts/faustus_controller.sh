#!/bin/bash

setcolor(){

    echo $1 > /sys/devices/platform/faustus/kbbl/kbbl_red
    echo $2 > /sys/devices/platform/faustus/kbbl/kbbl_green
    echo $3 > /sys/devices/platform/faustus/kbbl/kbbl_blue
    setmode $4

}

setmode(){
    echo $1 > /sys/devices/platform/faustus/kbbl/kbbl_mode
}

setspeed(){
    echo $1 > /sys/devices/platform/faustus/kbbl/kbbl_speed
}

if [ $# -ne 0 ]
  then

    case "$1" in
    color)
    setcolor $2 $3 $4 $5
    ;;
    mode)
    setmode $2
    ;;
    speed)
    setspeed $2
    ;;
    esac

echo 2a > /sys/devices/platform/faustus/kbbl/kbbl_flags
echo 1 > /sys/devices/platform/faustus/kbbl/kbbl_set

fi

