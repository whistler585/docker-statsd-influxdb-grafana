#!/bin/bash

echo "deb http://cz.archive.ubuntu.com/ubuntu xenial main multiverse" >> /etc/apt/sources.list

wget -qO- https://repos.influxdata.com/influxdb.key |  apt-key add -
source /etc/lsb-release

echo "deb https://repos.influxdata.com/ubuntu xenial stable" | tee /etc/apt/sources.list.d/influxdb.list

apt-get -y update && apt-get -y install snmp && apt-get -y install snmp-mibs-downloader && apt-get -y install kapacitor

sleep 5

service telegraf start

sleep 2

service kapacitor start

sleep 2 

service influxdb restart

sleep 2

exit 0