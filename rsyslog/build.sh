#!/bin/sh

# Build a patched version of rsyslog
set -e
BUILD_REQS="
	autoconf-archive
	bison
	flex
	git
	libcurl4-gnutls-dev
	libgnutls28-dev
	libtool
	libestr-dev
	libfastjson-dev
	libgcrypt20-dev
	make
	pkg-config
	uuid-dev
	zlib1g-dev
"

apt-get update
apt-get install -y $BUILD_REQS

rm -rf /var/tmp/rsyslog/rsyslog
cd /var/tmp/rsyslog
git clone https://github.com/rsyslog/rsyslog.git
cd rsyslog
git checkout v$(cat ../VERSION)
# Apply Blumira patches
patch -p1 < ../mmescapelf.patch
patch -p1 < ../cert_request.patch

autoreconf -fi
./configure \
	--sysconfdir=/etc \
	\
	--disable-generate-man-pages \
	--disable-rfc3195 \
	--enable-largefile \
	--disable-gssapi-krb5 \
	--disable-mysql \
	--disable-pgsql \
	--disable-libdbi \
	--disable-snmp \
	--disable-elasticsearch \
	--disable-omhttp \
	--disable-clickhouse \
	--enable-gnutls \
	--disable-mail \
	--disable-imdiag \
	--disable-mmnormalize \
	--disable-mmjsonparse \
	--disable-mmaudit \
	--disable-mmanon \
	--disable-mmrm1stspace \
	--disable-mmutf8fix \
	--disable-mmcount \
	--disable-mmsequence \
	--disable-mmdblookup \
	--disable-mmfields \
	--disable-mmpstrucdata \
	--disable-relp \
	--disable-imfile \
	--enable-imptcp \
	--disable-impstats \
	--disable-omprog \
	--disable-omudpspoof \
	--enable-omstdout \
	--disable-pmlastmsg \
	--disable-pmaixforwardedfrom \
	--disable-pmsnare \
	--disable-omuxsock \
	--disable-mmsnmptrapd \
	--disable-omrabbitmq \
	--disable-imczmq \
	--disable-omczmq \
	--disable-omhiredis \
	--disable-imdocker \
	--disable-hiredis \
	--disable-libsystemd \
	--enable-mmescapelf
make install
rm -rf /var/tmp/rsyslog
apt-get remove -y $BUILD_REQS
apt-get autoremove -y
apt-get clean
rm -rf /var/lib/apt/lists/* /var/cache/*
