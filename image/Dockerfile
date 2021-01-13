FROM ubuntu:20.04 as builder

ENV DEBIAN_FRONTEND noninteractive

WORKDIR /tmp

RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list\
    &&apt-get update && apt-get install -y software-properties-common\
    &&add-apt-repository -y ppa:ondrej/php\
	&&apt-get install -y --no-install-recommends curl build-essential

RUN  apt-get install -y --no-install-recommends php7.2-dev

RUN curl -o swoole.tar.gz https://github.com/swoole/swoole-src/archive/v4.5.11.tar.gz -L\
    &&tar zxvf swoole.tar.gz\
    &&mv swoole-src* swoole-src\
    &&cd swoole-src\
    &&phpize\
    &&./configure\
        --enable-openssl\
        --enable-http2\
        --enable-sockets\
        --enable-mysqlnd\
    &&make && make install\
    &&strip /usr/lib/php/20170718/swoole.so

RUN curl -o seaslog.tar.gz https://github.com/SeasX/SeasLog/archive/SeasLog-2.1.0.tar.gz -L\
    &&tar zxvf seaslog.tar.gz\
    &&mv SeasLog-* seaslog\
    &&cd seaslog\
    &&phpize &&./configure &&make &&make install\
    &&strip /usr/lib/php/20170718/seaslog.so

########################################################################################################################
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive

RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list\
    &&apt-get update  && apt-get install -y software-properties-common\
    &&add-apt-repository -y ppa:ondrej/php\
    &&apt-get install -y --no-install-recommends bash-completion telnet net-tools iputils-ping iproute2 lsof strace htop ca-certificates curl wget vim-tiny dos2unix cron logrotate busybox-syslogd\
    &&echo '. /etc/bash_completion' >> /root/.bashrc\
    &&ln -s /usr/bin/vim.tiny /usr/bin/vim && cp /etc/vim/vimrc.tiny /root/.vimrc&&echo "set nocompatible\nset backspace=2\nset number" >> /root/.vimrc\
    &&ln -s -f /usr/share/zoneinfo/PRC /etc/localtime\
    &&sed -i\
        -e 's|@include common|#@include common|'\
        -e 's|session       required   pam_env.so envfile=/etc/default/locale|#session       required   pam_env.so envfile=/etc/default/locale|'\
        /etc/pam.d/cron\
    &&mkdir -p /var/log/cron

RUN curl -o composer.phar https://install.phpcomposer.com/composer.phar -L\
    &&chmod a+x composer.phar\
    &&mv composer.phar /usr/local/bin/composer

WORKDIR "/var/www/html"

RUN apt-get install -y --no-install-recommends\ 
        php7.2-fpm\
        php7.2-xdebug\
        php7.2-amqp\
        php7.2-stomp\
        php7.2-mongodb\
        php7.2-redis\
        php7.2-mbstring\
        php7.2-intl\
        php7.2-gd\
        php7.2-imagick\
        php7.2-mysql\
        php7.2-pgsql\
        php7.2-odbc\
        php7.2-sqlite3\
        php7.2-curl\
        php7.2-igbinary\
        php7.2-msgpack\
        php7.2-xml\
        php7.2-xmlrpc\
        php7.2-apcu\
        php7.2-memcache\
        php7.2-memcached\
        php7.2-bcmath\
        php7.2-gmp\
        php7.2-ldap\
        php7.2-soap\
        php7.2-imap\
        php7.2-bz2\
        php7.2-solr\
        php7.2-geoip\
        php7.2-tidy\
        php7.2-zip\
    &&mkdir -p /run/php\
    &&mkdir -p /var/log/php\
    &&mkdir -p /etc/php/conf.d

RUN ln -s /etc/php/7.2/cli /etc/php/cli && ln -s /etc/php/7.2/fpm /etc/php/fpm\
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
    &&ln -s /usr/sbin/php-fpm7.2 /usr/sbin/php-fpm

COPY docker-entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/docker-entrypoint.sh
ENTRYPOINT ["/usr/bin/docker-entrypoint.sh"]

COPY --from=builder /usr/lib/php/20170718/swoole.so /usr/lib/php/20170718/
COPY --from=builder /usr/lib/php/20170718/seaslog.so /usr/lib/php/20170718/

RUN echo 'extension=swoole.so'>/etc/php/7.2/mods-available/swoole.ini && phpenmod swoole\
    &&echo 'extension=seaslog.so'>/etc/php/7.2/mods-available/seaslog.ini && phpenmod seaslog\
    &&phpdismod xdebug