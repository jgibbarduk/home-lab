#!/bin/bash

apt-get update
apt-get -y upgrade

# Disable firewall
/usr/sbin/netfilter-persistent stop
/usr/sbin/netfilter-persistent flush

systemctl stop netfilter-persistent.service
systemctl disable netfilter-persistent.service