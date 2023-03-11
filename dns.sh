# Configuring DNS Server
echo ""
echo -e "[INFO] : Configuring DNS Server"
sleep 3

DOMAIN=`hostname -d`;
HOSTNAME=`hostname -f`;
IPADDRESS=`hostname -I`;

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

sh -c 'echo nameserver `hostname -i` >> /etc/resolv.conf'


# Restart Service & Check results configuring DNS Server

/etc/init.d/dnsmasq restart
nslookup `hostname -f`
nslookup `hostname -d`
dig $DOMAIN mx
