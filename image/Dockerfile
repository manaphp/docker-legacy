FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update\
   &&apt-get install -y --no-install-recommends bash-completion telnet net-tools iputils-ping iproute2 lsof strace htop ca-certificates curl vim-tiny dos2unix cron logrotate busybox-syslogd\
   &&echo '. /etc/bash_completion' >> /root/.bashrc\
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
        php5-fpm\
        php5-mcrypt\
        php5-xdebug\
        php5-stomp\
        php5-redis\
#        php-mbstring\
        php5-intl\
        php5-gd\
        php5-imagick\
        php5-mysql\
        php5-pgsql\
        php5-odbc\
        php5-sqlite\
        php5-curl\
        php5-msgpack\
#        php-xml\
        php5-xmlrpc\
        php5-apcu\
        php5-memcache\
        php5-memcached\
#        php-bcmath\
        php5-gmp\
        php5-ldap\
        php-soap\
        php5-imap\
#        php-bz2\
        php5-geoip\
        php5-tidy\
        php5-apcu\
        php5-xsl\
        php5-xdebug\
        librabbitmq1\
    &&php5dismod xdebug\
    &&mkdir -p /run/php\
    &&mkdir -p /var/log/php\
    &&ln -s /etc/php5 /etc/php\
    &&mkdir -p /etc/php/conf.d\
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
    &&ln -s /usr/sbin/php5-fpm /usr/sbin/php-fpm\        
    &&rm -rf /var/lib/apt/lists/* && apt-get clean

COPY docker-entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/docker-entrypoint.sh
ENTRYPOINT ["/usr/bin/docker-entrypoint.sh"]
CMD ["run","fpm"]

COPY ext/* /usr/lib/php5/20121212/
RUN echo 'extension=swoole.so'>/etc/php5/mods-available/swoole.ini && php5enmod swoole\
    &&echo 'extension=amqp.so'>/etc/php5/mods-available/amqp.ini && php5enmod amqp\
    &&echo 'extension=igbinary.so'>/etc/php5/mods-available/igbinary.ini && php5enmod igbinary\
    &&echo 'extension=mongodb.so'>/etc/php5/mods-available/mongodb.ini && php5enmod mongodb\
    &&echo 'extension=solr.so'>/etc/php5/mods-available/solr.ini && php5enmod solr\
    &&php -r "copy('https://getcomposer.org/download/1.6.5/composer.phar', '/usr/bin/composer');"&&chmod a+x /usr/bin/composer