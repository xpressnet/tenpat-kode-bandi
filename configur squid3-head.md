Install Squid-3.HEAD

---

# install aplikasi pendukung untuk squid
apt-get install devscripts build-essential openssl libssl-dev fakeroot libcppunit-dev libsasl2-dev cdbs

# Langkah-Langkah Instalasi Squid-3.HEAD

---

# Download Squid-3 HEAD
wget http://www.squid-cache.org/Versions/v3/3.HEAD/squid-3.HEAD-20130911-r13002.tar.gz
tar -xzvf squid-3.HEAD-20130911-[r13002](https://code.google.com/p/tenpat-kode-bandi/source/detail?r=13002).tar.gz
cd squid-3.HEAD-20130911-[r13002](https://code.google.com/p/tenpat-kode-bandi/source/detail?r=13002)

touch SPONSORS.list
./bootstrap.sh

# Compile
./configure --prefix=/usr --bindir=/usr/bin --sbindir=/usr/sbin --libexecdir=/usr/lib/squid --sysconfdir=/etc/squid --localstatedir=/var --libdir=/usr/lib --includedir=/usr/include --datadir=/usr/share/squid --infodir=/usr/share/info --mandir=/usr/share/man --disable-dependency-tracking --enable-storeio=ufs,aufs,diskd --enable-removal-policies=lru,heap --enable-icmp --enable-esi --enable-icap-client --disable-wccp --disable-wccpv2 --enable-kill-parent-hack --enable-cachemgr-hostname=TProxy --enable-ssl --enable-cache-digests --enable-linux-netfilter --enable-follow-x-forwarded-for --enable-x-accelerator-vary --enable-zph-qos --with-default-user=proxy --with-logdir=/var/log/squid --with-pidfile=/var/run/squid.pid --with-large-files --enable-ltdl-convenience --with-filedescriptors=65536 --enable-ssl --enable-ssl-crtd --disable-auth --disable-ipv6

make
make install

# Membuat Sertificat untuk SSL
mkdir /etc/squid/ssl\_certs
cd /etc/squid/ssl\_certs

openssl req -new -newkey rsa:1024 -days 365 -nodes -x509 -keyout myCA.pem -out myCA.pem
openssl x509 -in myCA.pem -outform DER -out myCA.der

# Untuk Pertama kali ketikan perintah berikut
/usr/lib/squid/ssl\_crtd -c -s /etc/squid/ssl\_db