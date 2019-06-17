#! /usr/bin/env bash

 echo "LANG=en_US.UTF-8" >> /etc/environment
 echo "LANGUAGE=en_US.UTF-8" >> /etc/environment
 echo "LC_ALL=en_US.UTF-8" >> /etc/environment
 echo "LC_CTYPE=en_US.UTF-8" >> /etc/environment

echo debconf shared/accepted-oracle-license-v1-1 select true |  debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true |  debconf-set-selections
# echo "--- Adding Oracle JDK repository"
# echo 'deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main' |  tee -a /etc/apt/sources.list.d/java.list  > /dev/null 2>&1
#  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key EEA14886 > /dev/null 2>&1
#  apt-get update > /dev/null 2>&1



# echo "--- Installing Oracle JDK"
#  apt-get install -y oracle-java8-installer > /dev/null 2>&1


echo "--- Installing OpenJDK"

add-apt-repository ppa:openjdk-r/ppa -y > /dev/null 2>&1 
apt-get update > /dev/null 2>&1
apt-get install -y openjdk-8-jre-headless > /dev/null 2>&1


echo "--- Adding Elasticsearch repository"


# PGP key installation
#apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key D88E42B4 
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch |  apt-key add - > /dev/null 2>&1
echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" |  tee -a /etc/apt/sources.list.d/elastic-6.x.list > /dev/null 2>&1
# Install https support for apt
 apt-get install apt-transport-https > /dev/null 2>&1

# ElasticSearch installation
echo "--- Installing Elasticsearch"
 apt-get update > /dev/null 2>&1
 apt-get install elasticsearch > /dev/null 2>&1

 mkdir -p /opt/backup
 chown elasticsearch:elasticsearch /opt/backup

echo "--- Configuring Elasticsearch"
 cat >> /etc/elasticsearch/elasticsearch.yml <<EOF
http.host: 127.0.0.1
transport.host: 127.0.0.1
cluster.name: hive
thread_pool.index.queue_size: 100000
thread_pool.search.queue_size: 100000
thread_pool.bulk.queue_size: 100000
path.repo: ["/opt/backup"]
EOF
echo "--- Starting Elasticsearch"
 systemctl enable elasticsearch.service > /dev/null 2>&1
 systemctl start elasticsearch.service > /dev/null 2>&1
#  systemctl status elasticsearch.service


echo "--- Adding TheHive and Cortex repository"
 apt-get -qq update > /dev/null 2>&1
echo 'deb https://dl.bintray.com/thehive-project/debian-beta any main' |  tee -a /etc/apt/sources.list.d/thehive-project.list > /dev/null 2>&1

 wget -O- "https://raw.githubusercontent.com/TheHive-Project/TheHive/master/PGP-PUBLIC-KEY" | apt-key add -
 apt-get update > /dev/null 2>&1


# Cortex

## install docker
echo "--- Installing Docker"
apt-get install -y docker.io git  > /dev/null 2>&1

##  Install Cortex
echo "--- Installing Cortex"
apt-get install -y  cortex > /dev/null 2>&1
sleep 20

## Install TheHive
echo "--- Installing TheHive"
apt-get install -y  thehive > /dev/null 2>&1

sleep 20

# Cortex-Analyzers
## Giving user cortex rights to run docker
usermod -a -G docker cortex

# echo "--- Installing python tools"
# apt-get install -y  git > /dev/null 2>&1
apt-get install -y python-pip python2.7-dev python3-pip ssdeep libfuzzy-dev libfuzzy2 libimage-exiftool-perl libmagic1 build-essential libssl-dev >  /dev/null 2>&1
/usr/bin/python2 -m pip install -U pip > /dev/null 2>&1
pip install thehive4py > /dev/null 2>&1
pip3 install thehive4py > /dev/null 2>&1
pip install cortex4py > /dev/null 2>&1
pip3 install cortex4py > /dev/null 2>&1

