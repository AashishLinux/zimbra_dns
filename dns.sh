# Configuring DNS Server ## DNSMASQ
echo ""
echo -e "[INFO] : Configuring DNS Server"
sleep 2

# Update and Upgrade Ubuntu
apt-get update -y && \
apt-get upgrade -y && apt-get install sudo -y

# Enable install resolvconf
echo 'resolvconf resolvconf/linkify-resolvconf boolean false' | debconf-set-selections

# Install dependencies
apt-get install -y dnsmasq bind9utils ssh netcat-openbsd sudo libidn11 libpcre3 libgmp10 libexpat1 libstdc++6 libaio1 resolvconf unzip pax sysstat sqlite3 dnsutils iputils-ping w3m gnupg less lsb-release rsyslog net-tools vim tzdata wget iproute2 locales curl


DOMAIN=`hostname -d`;
HOSTNAME=`hostname -f`;
IPADDRESS=`curl -s ifconfig.me`;

echo "
port=53
domain-needed
bogus-priv
strict-order
server=8.8.8.8
listen-address=$IPADDRESS
expand-hosts
domain=$DOMAIN
mx-host=$DOMAIN,$HOSTNAME,0
mx-host=$HOSTNAME,$HOSTNAME,0 
address=/$HOSTNAME/$IPADDRESS
address=/$DOMAIN/$IPADDRESS
" >> /etc/dnsmasq.conf

sh -c "echo nameserver $IPADDRESS  >> /etc/resolv.conf"


# Restart Service & Check results configuring DNS Server

/etc/init.d/dnsmasq restart
nslookup `hostname -f`
nslookup `hostname -d`
dig $DOMAIN mx
