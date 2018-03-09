FROM debian:8

ENV OTRS_VERSION 6.0.x
ENV OTRS_HOME /opt/otrs

RUN apt-get update \
	&& apt-get upgrade -y \
	&& apt-get install -y --no-install-recommends \
		wget \
		git \
		vim \
		apache2 \
		cron \
		libapache2-mod-perl2 \
		libarchive-zip-perl \
		libauthen-sasl-perl \
		libcrypt-eksblowfish-perl \
		libcrypt-ssleay-perl \
		libdbd-mysql-perl \
		libdbd-pg-perl \
		libdbi-perl \
		libdigest-md5-perl \
		libio-socket-ssl-perl \
		libjson-xs-perl \
		libmail-imapclient-perl \
		libmime-base64-perl \
		libnet-dns-perl \
		libnet-ldap-perl \
		libtemplate-perl \
		libtext-csv-xs-perl \
		libtimedate-perl \
		libxml-libxml-perl \
		libxml-libxslt-perl \
		libxml-parser-perl \
		libyaml-libyaml-perl \
		libdatetime-perl \
	&& rm -rf /var/lib/apt/lists/*

RUN  cd /opt \
	&& git clone -b rel-6_0_3_bsg https://github.com/Bundesschiedsgericht/otrs

ENV ENTRYPOINT_FILE /usr/local/sbin/entrypoint.sh

RUN a2dismod mpm_event mpm_prefork \
	&& a2enmod mpm_worker perl filter deflate headers \
	&& ln -s ${OTRS_HOME}/scripts/apache2-httpd.include.conf /etc/apache2/sites-available/zzz_otrs.conf \
	&& a2ensite zzz_otrs


COPY Config.pm ${OTRS_HOME}/Kernel/Config.pm
COPY entrypoint.sh ${ENTRYPOINT_FILE}
COPY 000-default.conf /etc/apache2/sites-available/
COPY cron_apache_restart_workers /tmp


RUN useradd -G www-data -d ${OTRS_HOME} otrs \

	&& cp /opt/otrs/var/cron/aaa_base.dist /opt/otrs/var/cron/aaa_base \
	&& cp /opt/otrs/var/cron/otrs_daemon.dist /opt/otrs/var/cron/otrs_daemon \
	&& mkdir /opt/otrs/var/tmp \
	&& /opt/otrs/bin/Cron.sh start otrs \

	&& cat /tmp/cron_apache_restart_workers | crontab - \
	&& rm /tmp/cron_apache_restart_workers \
	
	&& ${OTRS_HOME}/bin/otrs.SetPermissions.pl --web-group=otrs \
	&& chown www-data:www-data ${ENTRYPOINT_FILE} \
	&& chmod 554 ${ENTRYPOINT_FILE} \
	&& ln -s ${ENTRYPOINT_FILE} /entrypoint.sh

VOLUME /opt/otrs
RUN mkdir /opt/otrs/.gnupg

EXPOSE 80
CMD ["entrypoint.sh"]
