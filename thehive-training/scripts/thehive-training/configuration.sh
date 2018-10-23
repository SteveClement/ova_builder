#! /usr/bin/env bash
# Cortex

## Configure Cortex
echo "--- Configuring  Cortex"
cp -f /tmp/cortex_training-application.conf /home/$INSTALLUSER/
echo "--- Generating random"                        
random=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 64 | head -n 1)                                
echo "--- Changing secret"                          
sed  -r  "s/^#(play.http.secret.key=).*/\1\"$random\"/" /tmp/cortex_training-application.conf | tee /tmp/cortex-application.conf > /dev/null 2>&1 
sleep 10
cp -f /tmp/cortex-application.conf /etc/cortex/application.conf
chown -R cortex /etc/cortex

## Restart Cortex service
echo "--- Restarting Cortex" 
systemctl enable cortex  > /dev/null 2>&1
service cortex restart > /dev/null 2>&1


# TheHive
## Configure TheHive
echo "--- Configuring TheHive" 
cp -f /tmp/thehive_training-application.conf /home/$INSTALLUSER/


echo "--- Generating random"  
random=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 64 | head -n 1)
echo "--- Changing secret"                          
sed  -r  "s/^#(play.http.secret.key=).*/\1\"$random\"/" /tmp/thehive_training-application.conf | tee /tmp/thehive-application.conf > /dev/null 2>&1
sleep 10
cp -f /tmp/thehive-application.conf /etc/thehive/application.conf
chown -R thehive /etc/thehive

## Restart Thehive service
echo "--- Restarting  TheHive" 
systemctl enable thehive > /dev/null 2>&1
service thehive restart > /dev/null 2>&1

