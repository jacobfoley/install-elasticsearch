#!/usr/bin/env bash
#Install Java
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get -y install oracle-java8-installer
sudo apt-get -y install oracle-java8-set-default
#Add JAVA_HOME system variable
echo export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/javac::") >> ~/.basrc
source ~/.bashrc
#Add elasticsearch source to packagelist
wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb http://packages.elastic.co/elasticsearch/2.x/debian stable main" | sudo tee -a /etc/apt/sources.list.d/elasticsearch-2.x.list
#Install Elasticsearch
apt-get update
#didn't include -y due to unsolved install issue requiring --force-yes
apt-get install elasticsearch
#Hardcode IP in elasticsearch config
ip=`/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`
sed -i.bak s/localhost/$ip/g  /etc/elasticsearch/elasticsearch.yml
sudo service elasticsearch restart
#Start elasticsearch on boot
sudo update-rc.d elasticsearch defaults 95 10
#Now lets install kibana
#Add the key first
wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb http://packages.elastic.co/kibana/4.4/debian stable main" | sudo tee -a /etc/apt/sources.list.d/kibana-4.4.x.list
sudo apt-get update
sudo apt-get -y install kibana
sudo service kibana restart
