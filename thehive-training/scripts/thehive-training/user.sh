#! /usr/bin/env bash

echo "--- Configuring sudo "
echo %thehive ALL=NOPASSWD:ALL > /etc/sudoers.d/thehive
chmod 0440 /etc/sudoers.d/thehive
usermod -a -G sudo thehive

