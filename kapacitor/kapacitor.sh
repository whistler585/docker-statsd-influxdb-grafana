#!/bin/bash

echo "Installing Kapacitor"
wget -qO- https://repos.influxdata.com/influxdb.key |  apt-key add -
source /etc/lsb-release

echo "deb https://repos.influxdata.com/ubuntu xenial stable" | tee /etc/apt/sources.list.d/influxdb.list

apt-get -y update && apt-get -y install kapacitor

sleep 5
echo "Kapacitor Install Finished"

exit 0