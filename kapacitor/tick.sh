#!/bin/bash

echo "Setting up Device Health TICK"
kapacitor define DeviceHealth -tick /etc/kapacitor/snmp_devicehealth.tick -type batch -dbrp "telegraf"."autogen"

echo "Setting up Dowload Speed TICK"
kapacitor define DownloadSpeed -tick /etc/kapacitor/snmp_download.tick -type batch -dbrp "telegraf"."autogen"

echo "Setting up Upload Speed TICK"
kapacitor define UploadSpeed -tick /etc/kapacitor/snmp_upload.tick -type batch -dbrp "telegraf"."autogen"

echo "Setting up Throughput TICK"
kapacitor define Throughput -tick /etc/kapacitor/snmp_throughput.tick -type batch -dbrp "telegraf"."autogen"

cho "TICK tasks loaded"

exit 0