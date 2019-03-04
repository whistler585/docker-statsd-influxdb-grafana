#!/bin/bash

echo "Starting Kapacitor"
/etc/init.d/kapacitor start

sleep 3

echo "Setting up Device Health TICK"
kapacitor define DeviceHealth -tick /etc/kapacitor/snmp_devicehealth.tick -type batch -dbrp "telegraf"."autogen"
kapacitor enable DeviceHealth
sleep 2

echo "Setting up Download Speed TICK"
kapacitor define DownloadSpeed -tick /etc/kapacitor/snmp_download.tick -type batch -dbrp "telegraf"."autogen"
kapacitor enable DownloadSpeed
sleep 2

echo "Setting up Upload Speed TICK"
kapacitor define UploadSpeed -tick /etc/kapacitor/snmp_upload.tick -type batch -dbrp "telegraf"."autogen"
kapacitor enable UploadSpeed
sleep 2

echo "Setting up Throughput TICK"
kapacitor define Throughput -tick /etc/kapacitor/snmp_throughput.tick -type batch -dbrp "telegraf"."autogen"
kapacitor enable Throughput
sleep 2

echo "TICK tasks loaded"

exit 0