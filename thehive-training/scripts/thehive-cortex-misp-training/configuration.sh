#! /usr/bin/env bash

INSTALL_USER = misp

# Cortex

## Configure Cortex
echo "--- Configuring  Cortex"
cp -f /tmp/cortex_training-application.conf /home/$INSTALL_USER/
echo "--- Generating random"                        
random=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 64 | head -n 1)                                
echo "--- Changing secret"                          
sed  -r  "s/^#(play.http.secret.key=).*/\1\"$random\"/" /home/$INSTALL_USER/cortex_training-application.conf | tee /home/$INSTALL_USER/cortex-application.conf > /dev/null 2>&1 
sleep 10
cp -f /home/$INSTALL_USER/cortex-application.conf /etc/cortex/application.conf

## Restart Cortex service
echo "--- Restarting Cortex" 
systemctl enable cortex  > /dev/null 2>&1
service cortex restart > /dev/null 2>&1


# TheHive
## Configure TheHive
echo "--- Configuring TheHive" 
cp -f /tmp/thehive_training-application.conf /home/$INSTALL_USER/


echo "--- Generating random"  
random=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 64 | head -n 1)
echo "--- Changing secret"                          
sed  -r  "s/^#(play.http.secret.key=).*/\1\"$random\"/" /home/$INSTALL_USER/thehive_training-application.conf | tee /home/$INSTALL_USER/thehive-application.conf > /dev/null 2>&1
sleep 10
cp -f /home/$INSTALL_USER/thehive-application.conf /etc/thehive/application.conf

## Restart Thehive service
echo "--- Restarting  TheHive" 
systemctl enable thehive > /dev/null 2>&1
service thehive restart > /dev/null 2>&1
