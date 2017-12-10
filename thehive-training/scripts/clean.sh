#! /usr/bin/env bash 
# package
echo "--- Cleaning packages"
apt-get clean > /dev/null 2>&1


# Files
echo "--- Cleaning files"
rm /home/thehive/cortex_training-application.conf 
rm /home/thehive/cortex-application.conf
rm /home/thehive/thehive_training-application.conf
rm /home/thehive/thehive-application.conf 
rm /home/thehive/VBoxGuestAdditions.iso
