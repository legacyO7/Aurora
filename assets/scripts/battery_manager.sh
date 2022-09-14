#!/bin/bash

battery_threshold_path=/sys/class/power_supply/BAT1/charge_control_end_threshold
service_path=/etc/systemd/system/


setthreshold(){

echo Setting battery charge threshold to $1 %...
echo $1 | tee $battery_threshold_path > /dev/null
cd $service_path

echo "[Unit]
Description=To set battery charge threshold
After=multi-user.target suspend.target hibernate.target hybrid-sleep.target suspend-then-hibernate.target
StartLimitBurst=0

[Service]
Type=oneshot
Restart=on-failure
ExecStart= /bin/bash -c 'echo $1 > $battery_threshold_path'

[Install]
WantedBy=multi-user.target suspend.target hibernate.target hybrid-sleep.target suspend-then-hibernate.target" > aurora-controller.service

}


setaccess(){
  chmod -R o+rwx $battery_threshold_path
  chmod -R o+rwx $service_path

  FILE=/etc/resolv.conf
  if [ -f "$service_path/aurora-controller.service" ]; then
      sudo systemctl restart aurora-controller.service

  else
      setthreshold $1
      sudo systemctl enable aurora-controller.service
  fi
}

if [ $# -ne 0 ]
  then
    if [ "$EUID" -ne 0 ]
      then
      setthreshold $1
    else
       setaccess $1
    fi
fi

