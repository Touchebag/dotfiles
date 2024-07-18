#!/usr/bin/bash

device_name="ETPS/2 Elantech Touchpad"

state=$(xinput list-props "${device_name}" | grep "Device Enabled" | xargs | tail -c 2)

if [[ "${state}" == "1" ]]
then
    # Disable and move cursor out of the way
    xdotool mousemove 5000 0
    xinput disable "${device_name}"
elif [[ "${state}" == "0" ]]
then
    # Enable
    xinput enable "${device_name}"
fi
