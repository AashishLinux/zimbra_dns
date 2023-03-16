# Configuring DNS Server
echo ""
echo -e "[INFO] : Configuring DNS Server"
sleep 2

# Update and Upgrade Ubuntu
apt-get update -y && \
apt-get upgrade -y && apt-get install sudo -y

# Enable install resolvconf
echo 'resolvconf resolvconf/linkify-resolvconf boolean false' | debconf-set-selections

# Install dependencies
apt-get install -y bind9 bind9utils ssh netcat-openbsd sudo libidn11 libpcre3 libgmp10 libexpat1 libstdc++6 libperl5.26 libaio1 resolvconf unzip pax sysstat sqlite3 dnsutils iputils-ping w3m gnupg less lsb-release rsyslog net-tools vim tzdata wget iproute2 locales curl


DOMAIN=`hostname -d`;
HOSTNAME=`hostname -s`;
IPADDRESS=`hostname -I`;
FQDN=`hostname -f`


BIND=`ls /etc/bind/ | grep named.conf.local.back`;

        if [ "$BIND" == "named.conf.local.back" ]; then
        cp /etc/bind/named.conf.local.back /etc/bind/named.conf.local
        else
        cp /etc/bind/named.conf.local /etc/bind/named.conf.local.back
        fi

## HOSTNAME
echo 'zone "'$FQDN'" IN {' >> /etc/bind/named.conf.local
echo "type master;" >> /etc/bind/named.conf.local
echo 'file "/etc/bind/'db.$FQDN'";' >> /etc/bind/named.conf.local
echo "};" >> /etc/bind/named.conf.local

## DOMAIN
echo 'zone "'$DOMAIN'" IN {' >> /etc/bind/named.conf.local
echo "type master;" >> /etc/bind/named.conf.local
echo 'file "/etc/bind/'db.$DOMAIN'";' >> /etc/bind/named.conf.local
echo "};" >> /etc/bind/named.conf.local



touch /etc/bind/db.$FQDN
touch /etc/bind/db.$DOMAIN
chgrp bind /etc/bind/db.$DOMAIN
chgrp bind /etc/bind/db.$FQDN

## HOSTNAME

echo '$TTL 1D' > /etc/bind/db.$FQDN
echo "@       IN SOA  ns1.$FQDN. root.$FQDN. (" >> /etc/bind/db.$FQDN
echo '                                        0       ; serial' >> /etc/bind/db.$FQDN
echo '                                        1D      ; refresh' >> /etc/bind/db.$FQDN
echo '                                        1H      ; retry' >> /etc/bind/db.$FQDN
echo '                                        1W      ; expire' >> /etc/bind/db.$FQDN
echo '                                        3H )    ; minimum' >> /etc/bind/db.$FQDN
echo "@         IN      NS      ns1.$FQDN." >> /etc/bind/db.$FQDN
echo "@         IN      MX      0 $FQDN." >> /etc/bind/db.$FQDN
echo "ns1       IN      A       $IPADDRESS" >> /etc/bind/db.$FQDN
echo "$FQDN. IN      A       $IPADDRESS" >> /etc/bind/db.$FQDN

## DOMAIN

echo '$TTL 1D' > /etc/bind/db.$DOMAIN
echo "@       IN SOA  ns1.$DOMAIN. root.$DOMAIN. (" >> /etc/bind/db.$DOMAIN
echo '                                        0       ; serial' >> /etc/bind/db.$DOMAIN
echo '                                        1D      ; refresh' >> /etc/bind/db.$DOMAIN
echo '                                        1H      ; retry' >> /etc/bind/db.$DOMAIN
echo '                                        1W      ; expire' >> /etc/bind/db.$DOMAIN
echo '                                        3H )    ; minimum' >> /etc/bind/db.$DOMAIN
echo "@         IN      NS      ns1.$DOMAIN." >> /etc/bind/db.$DOMAIN
echo "@         IN      MX      0 $HOSTNAME.$DOMAIN." >> /etc/bind/db.$DOMAIN
echo "ns1       IN      A       $IPADDRESS" >> /etc/bind/db.$DOMAIN
echo "$HOSTNAME. IN      A       $IPADDRESS" >> /etc/bind/db.$DOMAIN

sed -i 's/dnssec-validation yes/dnssec-validation no/g' /etc/bind/named.conf.options

# Restart Service & Check results configuring DNS Server

/etc/init.d/named restart
nslookup $HOSTNAME.$DOMAIN
dig $DOMAIN mx
