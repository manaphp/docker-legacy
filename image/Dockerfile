FROM ubuntu:16.04

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
    &&mkdir -p /etc/php/7.0/mods-available\
    &&echo 'extension=amqp.so'>/etc/php/7.0/mods-available/amqp.ini\
    &&apt-get install -y --no-install-recommends\ 
        php-fpm\
        php-mcrypt\
        php-xdebug\
        php-amqp\
        php-stomp\
        php-mongodb\
        php-redis\
        php-mbstring\
        php-intl\
        php-gd\
        php-imagick\
        php-mysql\
        php-pgsql\
        php-odbc\
        php-sqlite3\
        php-curl\
        php-igbinary\
        php-msgpack\
        php-xml\
        php-xmlrpc\
        php-apcu\
        php-memcache\
        php-memcached\
        php-bcmath\
        php-gmp\
        php-ldap\
        php-soap\
        php-imap\
        php-bz2\
        php-solr\
        php-geoip\
        php-tidy\
        php-zip\
    &&phpdismod xdebug\
    &&mkdir -p /run/php\
    &&mkdir -p /var/log/php\
    &&mkdir -p /etc/php/conf.d\
    &&ln -s /etc/php/7.0/cli /etc/php/cli && ln -s /etc/php/7.0/fpm /etc/php/fpm && rm -rf /etc/php/mods-available\
    &&touch /etc/php/conf.d/fpm.conf && echo 'include=/etc/php/conf.d/fpm.conf'>>/etc/php/fpm/php-fpm.conf\
    &&touch /etc/php/conf.d/php.ini && ln -s /etc/php/conf.d/php.ini /etc/php/cli/conf.d/custom.ini && ln -s /etc/php/conf.d/php.ini /etc/php/fpm/conf.d/custom.ini\
    &&sed -i \
        -e 's|listen =.*|listen = 9000|'\
        -e 's|;access.log.*|access.log = /var/log/php/access.log|'\
        -e 's|;access.format|access.format|'\
        -e 's|;catch_workers_output|catch_workers_output|'\
        /etc/php/fpm/pool.d/www.conf\
    &&sed -i\
        -e 's|error_log =.*|error_log = /var/log/php/error.log|'\
        /etc/php/fpm/php-fpm.conf\
    &&sed -i\
        -e 's|;error_log = php_errors.log|error_log = /var/log/php/error.log|'\
        /etc/php/fpm/php.ini\
    &&ln -s /usr/sbin/php-fpm7.0 /usr/sbin/php-fpm\
    &&rm -rf /var/lib/apt/lists/* && apt-get clean

COPY docker-entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/docker-entrypoint.sh
ENTRYPOINT ["/usr/bin/docker-entrypoint.sh"]
CMD ["run","fpm"]

COPY ext/* /usr/lib/php/20151012/
RUN echo 'extension=swoole.so'>/etc/php/7.0/mods-available/swoole.ini && phpenmod swoole\
    &&php -r "copy('https://getcomposer.org/download/1.6.5/composer.phar', '/usr/bin/composer');"&&chmod a+x /usr/bin/composer
