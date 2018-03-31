#! /usr/bin/env bash

 echo "LANG=en_US.UTF-8" >> /etc/environment
 echo "LANGUAGE=en_US.UTF-8" >> /etc/environment
 echo "LC_ALL=en_US.UTF-8" >> /etc/environment
 echo "LC_CTYPE=en_US.UTF-8" >> /etc/environment

echo debconf shared/accepted-oracle-license-v1-1 select true |  debconf-set-selections 
echo debconf shared/accepted-oracle-license-v1-1 seen true |  debconf-set-selections
echo "--- Adding Oracle JDK repository"
echo 'deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main' |  tee -a /etc/apt/sources.list.d/java.list  > /dev/null 2>&1
 apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key EEA14886 > /dev/null 2>&1
 apt-get update > /dev/null 2>&1



echo "--- Installing Oracle JDK"
 apt-get install -y oracle-java8-installer > /dev/null 2>&1

echo "--- Adding Elasticsearch repository"


# PGP key installation
 apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key D88E42B4 > /dev/null 2>&1

# Alternative PGP key installation
# wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch |  apt-key add -
# Debian repository configuration
echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" |  tee -a /etc/apt/sources.list.d/elastic-5.x.list > /dev/null 2>&1

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
script.inline: on
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
echo 'deb https://dl.bintray.com/cert-bdf/debian any main' |  tee -a /etc/apt/sources.list.d/thehive-project.list > /dev/null 2>&1
#apt-key adv --keyserver hkp://pgp.mit.edu --recv-key 562CBC1C  >  /dev/null 2>&1
 wget -O- "https://raw.githubusercontent.com/TheHive-Project/TheHive/master/PGP-PUBLIC-KEY" | apt-key add -
 apt-get update > /dev/null 2>&1


# Cortex
##  Install Cortex
echo "--- Installing Cortex" 
apt-get install -y  cortex > /dev/null 2>&1
sleep 20
echo "--- Installing TheHive"
apt-get install -y  thehive > /dev/null 2>&1

sleep 20 

# Cortex-Analyzers
echo "--- Installing Cortex-Analyzers"
 apt-get install -y  git > /dev/null 2>&1 
 cd /opt && git clone https://github.com/CERT-BDF/Cortex-Analyzers.git > /dev/null 2>&1
 apt-get install -y python-pip python2.7-dev python3-pip ssdeep libfuzzy-dev libfuzzy2 libimage-exiftool-perl libmagic1 build-essential libssl-dev >  /dev/null 2>&1
 pip install -U pip > /dev/null 2>&1
 cd /opt/Cortex-Analyzers/analyzers && pip install $(sort -u */requirements.txt) && pip3 install $(sort -u */requirements.txt) >  /dev/null 2>&1
 pip install thehive4py > /dev/null 2>&1 
 pip install cortex4py > /dev/null 2>&1

