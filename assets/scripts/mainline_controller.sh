#!/bin/bash

kbd_state=/sys/class/leds/asus::kbd_backlight/kbd_rgb_state
kbd_mode=/sys/class/leds/asus::kbd_backlight/kbd_rgb_mode
brightness_path=/sys/class/leds/asus::kbd_backlight/brightness


savemode(){
  echo $@ | tee $kbd_mode
  echo "saved"
}

savestate(){
  echo $@ | tee $kbd_state
  echo "saved"
}

setbrightness(){
    echo $1 > $brightness_path
}

setaccess(){
  modprobe -r faustus
  modprobe asus-nb-wmi

  chmod -R o+rwx $brightness_path
  chmod -R o+rwx $kbd_state
  chmod -R o+rwx $kbd_mode
}

if [ $# -ne 0 ]
  then
    case "$1" in
    init)
    setaccess
    chmod -R o+rwx $2/battery_manager.sh
    sudo $2/battery_manager.sh $3
    ;;
    mode)
    shift
    savemode $@
    ;;
    state)
    shift
    savestate $@
    ;;
    brightness)
    setbrightness $2
    ;;
    esac

fi

