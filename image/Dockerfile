FROM ubuntu:18.04 as builder

ENV DEBIAN_FRONTEND noninteractive
WORKDIR /tmp

RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list\
    &&apt-get update && apt-get -y dist-upgrade && apt-get install -y apt-utils software-properties-common\
    &&add-apt-repository -y  ppa:ondrej/nginx-mainline; add-apt-repository -y ppa:ondrej/php\
	&& apt-get install -y --no-install-recommends curl build-essential
RUN  apt-get install -y --no-install-recommends php7.0-dev
RUN curl -o swoole.tar.gz https://github.com/swoole/swoole-src/archive/v4.3.6.tar.gz -L && \
    tar zxvf swoole.tar.gz && \
    mv swoole-src* swoole-src && \
    cd swoole-src && \
    phpize && \
    ./configure \
    --enable-openssl  \
    --enable-http2  \
    --enable-sockets \
    --enable-mysqlnd && \
    make clean && make && make install && \
    strip /usr/lib/php/20151012/swoole.so


FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list\
    &&apt-get update && apt-get -y dist-upgrade && apt-get install -y apt-utils software-properties-common\
    &&add-apt-repository -y  ppa:ondrej/nginx-mainline; add-apt-repository -y ppa:ondrej/php\
    &&apt-get install -y --no-install-recommends bash-completion telnet net-tools iputils-ping iproute2 lsof strace htop ca-certificates curl wget vim-tiny dos2unix cron logrotate busybox-syslogd\
    &&echo '. /etc/bash_completion' >> /root/.bashrc\
    &&ln -s /usr/bin/vim.tiny /usr/bin/vim && cp /etc/vim/vimrc.tiny /root/.vimrc&&echo "set nocompatible\nset backspace=2\nset number" >> /root/.vimrc\
    &&ln -s -f /usr/share/zoneinfo/PRC /etc/localtime\
    &&sed -i\
        -e 's|@include common|#@include common|'\
        -e 's|session       required   pam_env.so envfile=/etc/default/locale|#session       required   pam_env.so envfile=/etc/default/locale|'\
        /etc/pam.d/cron\
    &&mkdir -p /var/log/cron

WORKDIR "/var/www/html"

RUN apt-get install -y --no-install-recommends\ 
        php7.0-fpm\
        php7.0-xdebug\
        php7.0-amqp\
        php7.0-stomp\
        php7.0-mongodb\
        php7.0-redis\
        php7.0-mbstring\
        php7.0-intl\
        php7.0-gd\
        php7.0-imagick\
        php7.0-mysql\
        php7.0-pgsql\
        php7.0-odbc\
        php7.0-sqlite3\
        php7.0-curl\
        php7.0-igbinary\
        php7.0-msgpack\
        php7.0-xml\
        php7.0-xmlrpc\
        php7.0-apcu\
        php7.0-memcache\
        php7.0-memcached\
        php7.0-bcmath\
        php7.0-gmp\
        php7.0-ldap\
        php7.0-soap\
        php7.0-imap\
        php7.0-bz2\
        php7.0-solr\
        php7.0-geoip\
        php7.0-tidy\
        php7.0-zip\
    &&mkdir -p /run/php\
    &&mkdir -p /var/log/php\
    &&mkdir -p /etc/php/conf.d
RUN ln -s /etc/php/7.0/cli /etc/php/cli && ln -s /etc/php/7.0/fpm /etc/php/fpm\
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
    &&ln -s /usr/sbin/php-fpm7.0 /usr/sbin/php-fpm

COPY docker-entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/docker-entrypoint.sh
ENTRYPOINT ["/usr/bin/docker-entrypoint.sh"]

COPY --from=builder /usr/lib/php/20151012/swoole.so /usr/lib/php/20151012/

RUN echo 'extension=swoole.so'>/etc/php/7.0/mods-available/swoole.ini && phpenmod swoole&&phpdismod xdebug