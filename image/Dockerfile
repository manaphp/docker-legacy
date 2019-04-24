FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

COPY docker-initdb.d/manaphp.sql /tmp/
COPY conf/* /etc/mysql/conf.d/

RUN apt-get update\
   &&apt-get install -y --no-install-recommends bash-completion telnet net-tools iputils-ping iproute2 lsof strace htop ca-certificates curl vim-tiny mysql-server\
   &&rm -rf /var/lib/apt/lists/* && apt-get clean\
   &&usermod -d /var/lib/mysql/ mysql\
   &&chmod 644 /etc/mysql/conf.d/my.cnf\
   &&sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf\
   &&/etc/init.d/mysql start\
   &&mysql -uroot</tmp/manaphp.sql\
   &&echo "grant all on *.* to root@'%' identified by '123456';"|mysql\
   &&service mysql stop
   
WORKDIR "/var/lib/mysql"

EXPOSE 3306
CMD mysqld