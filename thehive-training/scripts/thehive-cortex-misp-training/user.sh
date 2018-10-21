#! /usr/bin/env bash

echo "--- Creating misp user"
useradd -U -G sudo -m -s /bin/bash -p Password1234 misp

echo "--- Configuring sudo "
# echo %thehive ALL=NOPASSWD:ALL > /etc/sudoers.d/thehive
echo %misp ALL=NOPASSWD:ALL > /etc/sudoers.d/misp
# chmod 0440 /etc/sudoers.d/thehive
chmod 0440 /etc/sudoers.d/misp
# usermod -a -G sudo thehive
