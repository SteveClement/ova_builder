#! /usr/bin/env bash

cp /tmp/issue /etc/issue

# package
echo "--- Cleaning packages"
apt-get clean > /dev/null 2>&1

# End Cleaning
echo "VM cleaned"

