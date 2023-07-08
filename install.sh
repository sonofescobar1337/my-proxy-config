#!/bin/bash

if [ "$(id -u)" != "0" ]; then
    echo "ERROR: You need to run the script as user root or add sudo before command."
    exit 1
fi

/usr/bin/apt update
/usr/bin/apt -y install apache2-utils squid
touch /etc/squid/passwd
mv /etc/squid/squid.conf /etc/squid/squid.conf.bak
/usr/bin/touch /etc/squid/blacklist.acl
/usr/bin/wget --no-check-certificate -O /etc/squid/squid.conf https://raw.githubusercontent.com/sonofescobar1337/my-proxy-config/main/squid.conf

 if [ -f /sbin/iptables ]; then
        echo "allowing proxies port"
        /sbin/iptables -I INPUT -p tcp --dport 3128 -j ACCEPT
        /sbin/iptables-save
        echo "port 3128 success opened"
    fi

    service squid restart
    systemctl enable squid
echo "Squid Proxy installation and configuration complete. Your proxy port is 3128"
