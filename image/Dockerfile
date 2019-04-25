FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update\
   &&apt-get install -y --no-install-recommends bash-completion telnet net-tools iputils-ping iproute2 lsof strace htop ca-certificates curl vim-tiny dos2unix mongodb mongo-tools\
   &&echo '. /etc/bash_completion' >> /root/.bashrc\
   &&ln -s /usr/share/bash-completion/completions /etc/bash_completion.d\
   &&ln -s /usr/bin/vim.tiny /usr/bin/vim && cp /etc/vim/vimrc.tiny /root/.vimrc&&echo "set nocompatible\nset backspace=2\nset number" >> /root/.vimrc\
   &&ln -s -f /usr/share/zoneinfo/PRC /etc/localtime\
   &&rm -rf /var/lib/apt/lists/* && apt-get clean\
   &&sed -i 's/^bind_ip = 127.0.0.1/bind_ip = 0.0.0.0/g' /etc/mongodb.conf

COPY ./docker-initdb.d /docker-entrypoint-initdb.d
RUN chmod a+x /docker-entrypoint-initdb.d/init.sh;mongod -f /etc/mongodb.conf --fork;/docker-entrypoint-initdb.d/init.sh
CMD mongod -f /etc/mongodb.conf