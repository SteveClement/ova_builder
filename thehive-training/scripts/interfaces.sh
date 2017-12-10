#! /usr/bin/env bash

echo "--- Using old style name (ethX) for interfaces"
sed  -r  's/^(GRUB_CMDLINE_LINUX=).*/\1\"net\.ifnames=0\ biosdevname=0\"/' /etc/default/grub | sudo tee /etc/default/grub > /dev/null

# enable eth0
echo "--- Configuring eth0"
cat > /etc/network/interfaces.d/eth0 << EOF
# The primary network interface
auto eth0
iface eth0 inet dhcp
EOF


update-grub  > /dev/null 2>&1
