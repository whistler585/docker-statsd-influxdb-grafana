#!/bin/bash

wget -qO- https://repos.influxdata.com/influxdb.key |  apt-key add -
source /etc/lsb-release

echo "deb https://repos.influxdata.com/ubuntu xenial stable" | tee /etc/apt/sources.list.d/influxdb.list

apt-get -y update && apt-get -y install kapacitor

sleep 5

kapacitor define DeviceHealth -tick /etc/kapacitor/snmp_devicehealth.tick -type batch -dbrp "telegraf"."autogen"
kapacitor define DownloadSpeed -tick /etc/kapacitor/snmp_download.tick -type batch -dbrp "telegraf"."autogen"
kapacitor define UploadSpeed -tick /etc/kapacitor/snmp_upload.tick -type batch -dbrp "telegraf"."autogen"
kapacitor define Throughput -tick /etc/kapacitor/snmp_throughput.tick -type batch -dbrp "telegraf"."autogen"

exit 0