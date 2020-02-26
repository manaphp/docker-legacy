FROM ubuntu:18.04 as builder

ENV DEBIAN_FRONTEND noninteractive
WORKDIR /tmp

RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list\
    &&apt-get update && apt-get -y dist-upgrade && apt-get install -y apt-utils software-properties-common\
    &&add-apt-repository -y  ppa:ondrej/nginx-mainline; add-apt-repository -y ppa:ondrej/php\
	&& apt-get install -y --no-install-recommends curl build-essential
RUN  apt-get install -y --no-install-recommends php7.4-dev
RUN curl -o swoole.tar.gz https://github.com/swoole/swoole-src/archive/v4.4.16.tar.gz -L && \
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
    strip /usr/lib/php/20190902/swoole.so


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
        php7.4-fpm\
        php7.4-xdebug\
        php7.4-amqp\
        php7.4-stomp\
        php7.4-mongodb\
        php7.4-redis\
        php7.4-mbstring\
        php7.4-intl\
        php7.4-gd\
        php7.4-imagick\
        php7.4-mysql\
        php7.4-pgsql\
        php7.4-odbc\
        php7.4-sqlite3\
        php7.4-curl\
        php7.4-igbinary\
        php7.4-msgpack\
        php7.4-xml\
        php7.4-xmlrpc\
        php7.4-apcu\
        php7.4-memcache\
        php7.4-memcached\
        php7.4-bcmath\
        php7.4-gmp\
        php7.4-ldap\
        php7.4-soap\
        php7.4-imap\
        php7.4-bz2\
        php7.4-solr\
        php7.4-geoip\
        php7.4-tidy\
        php7.4-zip\
    &&mkdir -p /run/php\
    &&mkdir -p /var/log/php\
    &&mkdir -p /etc/php/conf.d
RUN ln -s /etc/php/7.4/cli /etc/php/cli && ln -s /etc/php/7.4/fpm /etc/php/fpm\
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
    &&ln -s /usr/sbin/php-fpm7.4 /usr/sbin/php-fpm

COPY docker-entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/docker-entrypoint.sh
ENTRYPOINT ["/usr/bin/docker-entrypoint.sh"]

COPY --from=builder /usr/lib/php/20190902/swoole.so /usr/lib/php/20190902/

RUN echo 'extension=swoole.so'>/etc/php/7.4/mods-available/swoole.ini && phpenmod swoole&&phpdismod xdebug