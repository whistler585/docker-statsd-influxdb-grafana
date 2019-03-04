#!/bin/bash

echo "deb http://cz.archive.ubuntu.com/ubuntu xenial main multiverse" >> /etc/apt/sources.list

wget -qO- https://repos.influxdata.com/influxdb.key | sudo apt-key add -
source /etc/lsb-release

echo "deb https://repos.influxdata.com/ubuntu xenial stable" | tee /etc/apt/sources.list.d/influxdb.list

apt-get -y update && apt-get -y install snmp && apt-get -y install snmp-mibs-downloader && apt-get -y install kapacitor

sleep 5

service telegraf restart

sleep 2

exit 0