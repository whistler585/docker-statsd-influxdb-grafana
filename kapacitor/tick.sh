#!/bin/bash
echo "Starting Telegraf"
sleep 10 && /etc/init.d/telegraf start && sleep 10

echo "Starting InfluxDB"
sleep 10 && /etc/init.d/influxdb start && sleep 20

echo "Starting Chronograf"
sleep 5 && /usr/bin/chronograf -r --resources-path=/usr/share/chronograf/canned/kapacitor.kap  --resources-path=/usr/share/chronograf/canned/influxdb.src

echo "Starting Kapacitor"
sleep 5 && /etc/init.d/kapacitor start && sleep 5

echo "Setting up Device Health TICK"
sleep 5 && kapacitor define DeviceHealth -tick /etc/kapacitor/snmp_devicehealth.tick -type batch -dbrp "telegraf"."autogen" && kapacitor enable DeviceHealth && sleep 2

echo "Setting up Download Speed TICK"
sleep 5 && kapacitor define DownloadSpeed -tick /etc/kapacitor/snmp_download.tick -type batch -dbrp "telegraf"."autogen" && kapacitor enable DownloadSpeed && sleep 2

echo "Setting up Upload Speed TICK"
sleep 5 && kapacitor define UploadSpeed -tick /etc/kapacitor/snmp_upload.tick -type batch -dbrp "telegraf"."autogen" && kapacitor enable UploadSpeed && sleep 2

echo "Setting up Throughput TICK"
sleep 5 && kapacitor define Throughput -tick /etc/kapacitor/snmp_throughput.tick -type batch -dbrp "telegraf"."autogen" && kapacitor enable Throughput && sleep 2


echo "Influx started, Kapacitor started, Telegraf started, Chronograf started, TICK tasks loaded"

exit 0