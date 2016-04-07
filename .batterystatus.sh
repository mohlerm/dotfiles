#!/bin/bash
battery='/sys/class/power_supply/BAT0';
battery_status=`cat $battery/status`
battery_level=`cat $battery/capacity`
if (( $battery_status=="Discharging")); then
  if (( $battery_level <= 50 )); then
    /usr/bin/notify-send "50% battery left"
  elif (( $battery_level <= 15 )); then
    /usr/bin/notify-send "15% battery left"
  elif (( $battery_level <= 10 )); then
    /usr/bin/notify-send "10% battery left"
  elif (( $battery_level <= 5 )); then
    /usr/bin/notify-send "5% battery left"
    systemctl suspend
  fi
else
  /usr/bin/notify-send $battery_level
fi
#echo $battery_status
#echo $battery_level
