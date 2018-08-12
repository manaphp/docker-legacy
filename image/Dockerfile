FROM ubuntu:18.10

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update\
   &&apt-get install -y --no-install-recommends bash-completion telnet net-tools iputils-ping iproute2 lsof strace htop ca-certificates curl vim-tiny dos2unix cron logrotate busybox-syslogd\
   &&echo '. /etc/bash_completion' >> /root/.bashrc\
   &&ln -s /usr/share/bash-completion/completions /etc/bash_completion.d\
   &&ln -s /usr/bin/vim.tiny /usr/bin/vim && cp /etc/vim/vimrc.tiny /root/.vimrc&&echo "set nocompatible\nset backspace=2\nset number" >> /root/.vimrc\
   &&ln -s -f /usr/share/zoneinfo/PRC /etc/localtime\
   &&sed -i\
        -e 's|@include common|#@include common|'\
        -e 's|session       required   pam_env.so envfile=/etc/default/locale|#session       required   pam_env.so envfile=/etc/default/locale|'\
        /etc/pam.d/cron\
   &&mkdir -p /var/log/cron\        
   &&rm -rf /var/lib/apt/lists/* && apt-get clean

WORKDIR "/var/www/html"

RUN apt-get update\
    &&apt-get install -y --no-install-recommends\ 
        php7.3-fpm\
#        php7.3-mcrypt\
#        php7.3-xdebug\
#        php7.3-amqp\
#        php7.3-stomp\
#        php7.3-mongodb\
#        php7.3-redis\
        php7.3-mbstring\
        php7.3-intl\
        php7.3-gd\
#        php7.3-imagick\
        php7.3-mysql\
        php7.3-pgsql\
        php7.3-odbc\
        php7.3-sqlite3\
        php7.3-curl\
#        php7.3-igbinary\
#        php7.3-msgpack\
        php7.3-xml\
        php7.3-xmlrpc\
#        php7.3-apcu\
#        php7.3-memcache\
#        php7.3-memcached\
        php7.3-bcmath\
        php7.3-gmp\
        php7.3-ldap\
        php7.3-soap\
        php7.3-imap\
        php7.3-bz2\
#        php7.3-solr\
#        php7.3-geoip\
        php7.3-tidy\
	libmcrypt4\
	libmagickwand-6.q16-6\
    &&mkdir -p /run/php\
    &&mkdir -p /var/log/php\
    &&mkdir -p /etc/php/conf.d\
    &&ln -s /etc/php/7.3/cli /etc/php/cli && ln -s /etc/php/7.3/fpm /etc/php/fpm && rm -rf /etc/php/mods-available\
    &&touch /etc/php/conf.d/fpm.conf && echo 'include=/etc/php/conf.d/fpm.conf'>>/etc/php/fpm/php-fpm.conf\
    &&touch /etc/php/conf.d/php.ini && ln -s /etc/php/conf.d/php.ini /etc/php/cli/conf.d/custom.ini && ln -s /etc/php/conf.d/php.ini /etc/php/fpm/conf.d/custom.ini\
    &&sed -i \
        -e 's|listen =.*|listen = 9000|'\
        -e 's|;access.log.*|access.log = /var/log/php/access.log|'\
        -e 's|;access.format|access.format|'\
        /etc/php/fpm/pool.d/www.conf\
    &&sed -i\
        -e 's|error_log =.*|error_log = /var/log/php/fpm-error.log|'\
        /etc/php/fpm/php-fpm.conf\
    &&sed -i\
        -e 's|;error_log = php_errors.log|error_log = /var/log/php/error.log|'\
        /etc/php/fpm/php.ini\
    &&rm -rf /var/lib/apt/lists/* && apt-get clean

COPY docker-entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/docker-entrypoint.sh
ENTRYPOINT ["/usr/bin/docker-entrypoint.sh"]
CMD ["run","fpm"]

COPY ext/* /usr/lib/php/20180606/

RUN echo 'extension=apcu.so'>/etc/php/7.3/mods-available/apcu.ini && phpenmod apcu\
    &&echo 'extension=igbinary.so'>/etc/php/7.3/mods-available/igbinary.ini && phpenmod igbinary\
    &&echo 'extension=redis.so'>/etc/php/7.3/mods-available/redis.ini && phpenmod redis\
    &&echo 'extension=imagick.so'>/etc/php/7.3/mods-available/imagick.ini && phpenmod imagick\
    &&echo 'extension=mongodb.so'>/etc/php/7.3/mods-available/mongodb.ini && phpenmod mongodb\
    &&echo 'extension=redis.so'>/etc/php/7.3/mods-available/redis.ini && phpenmod redis\
    &&echo 'extension=mcrypt.so'>/etc/php/7.3/mods-available/mcrypt.ini && phpenmod mcrypt