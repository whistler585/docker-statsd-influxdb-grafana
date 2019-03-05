#!/bin/bash

echo "Starting Influx - remove from supervisord if solved"
/etc/init.d/influxdb start && sleep 5

echo "Starting KapacitorD"
/usr/bin/kapacitord &

echo "Starting Kapcitor"
/etc/init.d/kapacitor start && sleep 5

echo "Setting up Device Health TICK"
sleep 5 && kapacitor define DeviceHealth -tick /etc/kapacitor/snmp_devicehealth.tick -type batch -dbrp "telegraf"."autogen" && kapacitor enable DeviceHealth && sleep 2

echo "Setting up Download Speed TICK"
sleep 5 && kapacitor define DownloadSpeed -tick /etc/kapacitor/snmp_download.tick -type batch -dbrp "telegraf"."autogen" && kapacitor enable DownloadSpeed && sleep 2

echo "Setting up Upload Speed TICK"
sleep 5 && kapacitor define UploadSpeed -tick /etc/kapacitor/snmp_upload.tick -type batch -dbrp "telegraf"."autogen" && kapacitor enable UploadSpeed && sleep 2

echo "Setting up Throughput TICK"
sleep 5 && kapacitor define Throughput -tick /etc/kapacitor/snmp_throughput.tick -type batch -dbrp "telegraf"."autogen" && kapacitor enable Throughput && sleep 2

echo "TICK tasks loaded"

exit 0