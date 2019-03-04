#!/bin/bash

echo "deb http://cz.archive.ubuntu.com/ubuntu xenial main multiverse" >> /etc/apt/sources.list

apt-get -y update && apt-get -y install snmp && apt-get -y install snmp-mibs-downloader

sleep 5

service telegraf restart

exit 0