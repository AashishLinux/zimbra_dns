#################################################################
# Dockerfile for Zimbra Ubuntu
# Based on Ubuntu 20.04
# Created by Aashish Chaurasiya
#################################################################

FROM ubuntu:20.04

MAINTAINER Aashish Chaurasiya <aashishchaurasiya999@gmail.com>

ARG DEBIAN_FRONTEND=noninteractive
RUN apt update && apt upgrade -y 
RUN apt-get install  vim net-tools sudo wget rsync network-manager -y
RUN echo 'resolvconf resolvconf/linkify-resolvconf boolean false' | debconf-set-selections
RUN apt-get install -y bind9 bind9utils ssh netcat-openbsd sudo libidn11 libpcre3 libgmp10 libexpat1 libstdc++6 libaio1 resolvconf unzip pax sysstat sqlite3 dnsutils iputils-ping w3m gnupg less lsb-release rsyslog net-tools vim tzdata wget iproute2 locales curl wget nano make  sudo sysstat  perl libtool ntp gcc gnupg nmap netcat  
RUN apt-get install -yq tzdata && \
    ln -fs /usr/share/zoneinfo/Asia/Kolkata  /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

RUN echo 'export LC_ALL="en_US.UTF-8"' >> /root/.bashrc
RUN locale-gen en_US.UTF-8

WORKDIR /root/
RUN wget https://files.zimbra.com/downloads/8.8.15_GA/zcs-8.8.15_GA_4179.UBUNTU20_64.20211118033954.tgz
RUN tar -xvzf zcs-8.8.15_GA_4179.UBUNTU20_64.20211118033954.tgz
# Copy rsyslog services
RUN mv /etc/init.d/rsyslog /tmp/
RUN curl -k https://raw.githubusercontent.com/AashishLinux/zimbra_dns/main/rsyslog > /etc/init.d/rsyslog
RUN chmod +x /etc/init.d/rsyslog
RUN apt autoremove
RUN curl -k https://raw.githubusercontent.com/AashishLinux/zimbra_dns/main/dns2.sh > /root/dns_setup.sh && chmod +x /root/dns_setup.sh
# Crontab for rsyslog
RUN (crontab -l 2>/dev/null; echo "1 * * * * /etc/init.d/rsyslog restart > /dev/null 2>&1") | crontab -


# Startup service
RUN echo 'cat /etc/resolv.conf > /tmp/resolv.ori' > /services.sh
RUN echo 'echo "nameserver 127.0.0.1" > /tmp/resolv.add' >> /services.sh
RUN echo 'cat /tmp/resolv.add /tmp/resolv.ori > /etc/resolv.conf' >> /services.sh
RUN echo '/etc/init.d/named restart' >> /services.sh
RUN echo '/etc/init.d/rsyslog restart' >> /services.sh
#RUN echo '/etc/init.d/zimbra restart' >> /services.sh
RUN chmod +x /services.sh
RUN mkdir /opt/zimbra
# Entrypoint
ENTRYPOINT /services.sh && /bin/bash

