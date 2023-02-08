#!/bin/bash

battery_threshold_path=/sys/class/power_supply/BAT1/charge_control_end_threshold
service_path=/usr/lib/systemd/system/
service=aurora-controller.service

setthreshold() {

 if [ -d "$service_path" ]; then
  echo Setting charging threshold to $1 %...
  echo $1 | tee $battery_threshold_path >/dev/null
  cd $service_path

  echo "[Unit]
Description=To set charging threshold
After=multi-user.target suspend.target hibernate.target hybrid-sleep.target suspend-then-hibernate.target
StartLimitBurst=0

[Service]
Type=oneshot
Restart=on-failure
User=root
ExecStart= /bin/bash -c 'echo $1 > $battery_threshold_path'

[Install]
WantedBy=multi-user.target suspend.target hibernate.target hybrid-sleep.target suspend-then-hibernate.target" >$service

fi
}

setaccess() {
  chmod -R o+rwx $battery_threshold_path
  chmod -R o+rwx $service_path

  if [ -f $service_path$service ]; then
    sudo systemctl disable $service
    sudo systemctl enable $service
  else
    setthreshold $1
    chmod -R o+rwx $service_path$service
    sudo systemctl enable $service
  fi
}

disablethreshold() {
  #uninstall battery manager
  echo -e "\033[1;34m Removing battery manager\033[0m"
  echo 100 | tee $battery_threshold_path >/dev/null
  sudo systemctl disable $service
  sudo rm $service_path$service
}

if [ $# -ne 0 ]; then

  echo $1
  if [ "$EUID" -ne 0 ]; then
    setthreshold $1
  else
    if [[ $1 == disablethreshold ]]; then
      disablethreshold
    else
      setaccess $1
    fi
  fi

fi
