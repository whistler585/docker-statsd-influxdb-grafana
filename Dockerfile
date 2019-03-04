FROM ubuntu:16.04
MAINTAINER Samuele Bistoletti <samuele.bistoletti@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8

# Default versions
ENV TELEGRAF_VERSION 1.8.3-1
ENV INFLUXDB_VERSION 1.7.0
ENV GRAFANA_VERSION  5.3.2
ENV CHRONOGRAF_VERSION 1.7.2

# Database Defaults
ENV INFLUXDB_GRAFANA_DB datasource
ENV INFLUXDB_GRAFANA_USER datasource
ENV INFLUXDB_GRAFANA_PW datasource

ENV MYSQL_GRAFANA_USER grafana
ENV MYSQL_GRAFANA_PW grafana

# Fix bad proxy issue
COPY system/99fixbadproxy /etc/apt/apt.conf.d/99fixbadproxy

# Clear previous sources
RUN rm /var/lib/apt/lists/* -vf

# Base dependencies
RUN apt-get -y update && \
 apt-get -y dist-upgrade && \
 apt-get -y --force-yes install \
  apt-utils \
  ca-certificates \
  curl \
  git \
  htop \
  libfontconfig \
  mysql-client \
  mysql-server \
  nano \
  net-tools \
  openssh-server \
  supervisor \
  wget && \
 curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
 apt-get install -y nodejs

# Configure Supervisord, SSH and base env
COPY supervisord/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

WORKDIR /root

RUN mkdir -p /var/log/supervisor && \
    mkdir -p /var/run/sshd && \
    sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    echo 'root:root' | chpasswd && \
    rm -rf .ssh && \
    rm -rf .profile && \
    mkdir .ssh

COPY ssh/id_rsa .ssh/id_rsa
COPY bash/profile .profile

# Configure MySql
COPY scripts/setup_mysql.sh /tmp/setup_mysql.sh

RUN /tmp/setup_mysql.sh

# Install InfluxDB
RUN wget https://dl.influxdata.com/influxdb/releases/influxdb_${INFLUXDB_VERSION}_amd64.deb && \
	dpkg -i influxdb_${INFLUXDB_VERSION}_amd64.deb && rm influxdb_${INFLUXDB_VERSION}_amd64.deb

# Configure InfluxDB
COPY influxdb/influxdb.conf /etc/influxdb/influxdb.conf
COPY influxdb/init.sh /etc/init.d/influxdb

# Install Telegraf
RUN wget https://dl.influxdata.com/telegraf/releases/telegraf_${TELEGRAF_VERSION}_amd64.deb && \
	dpkg -i telegraf_${TELEGRAF_VERSION}_amd64.deb && rm telegraf_${TELEGRAF_VERSION}_amd64.deb

# Configure Telegraf
COPY telegraf/telegraf.conf /etc/telegraf/telegraf.conf
COPY telegraf/init.sh /etc/init.d/telegraf

# Install chronograf & copy influx/kapacitor connection config
RUN wget https://dl.influxdata.com/chronograf/releases/chronograf_${CHRONOGRAF_VERSION}_amd64.deb && \
  dpkg -i chronograf_${CHRONOGRAF_VERSION}_amd64.deb
COPY influxdata/chronograf /etc/default/chronograf  

# Install Grafana
RUN wget https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana_${GRAFANA_VERSION}_amd64.deb && \
	dpkg -i grafana_${GRAFANA_VERSION}_amd64.deb && rm grafana_${GRAFANA_VERSION}_amd64.deb

# Configure Grafana with provisioning
ADD grafana/provisioning /etc/grafana/provisioning
ADD grafana/dashboards /var/lib/grafana/dashboards
COPY grafana/grafana.ini /etc/grafana/grafana.ini
RUN grafana-cli plugins install michaeldmoore-multistat-panel


# Install SNMP install script
COPY telegraf/snmp.sh /tmp/snmp.sh
RUN chmod +x /tmp/snmp.sh
RUN /tmp/snmp.sh

# Install Kapacitor
COPY kapacitor/kapacitor.sh /tmp/kapacitor.sh
RUN chmod +x /tmp/kapacitor.sh
RUN /tmp/kapacitor.sh
COPY kapacitor/kapacitor.conf /etc/kapacitor/kapacitor.conf
COPY kapacitor/snmp_devicehealth.tick /etc/kapacitor/snmp_devicehealth.tick
COPY kapacitor/snmp_throughput.tick /etc/kapacitor/snmp_throughput.tick
COPY kapacitor/snmp_upload.tick /etc/kapacitor/snmp_upload.tick
COPY kapacitor/snmp_download.tick /etc/kapacitor/snmp_download.tick
COPY kapacitor/tick.sh /tmp/tick.sh
RUN chmod +x /tmp/tick.sh
RUN /tmp/tick.sh



# Cleanup
RUN apt-get clean && \
 rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["/usr/bin/supervisord"]