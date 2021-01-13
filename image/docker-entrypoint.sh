#!/usr/bin/env bash
set -e

#############################################################################################################
work_path=/var/www/html
if [[ -f ${work_path}/manacli ]] && [[ ! -e /usr/share/bash-completion/completions/manacli ]]; then
    cat << EOF > /usr/share/bash-completion/completions/manacli
#!/bin/bash

_manacli(){
   COMPREPLY=( \$(php ${work_path}/manacli.php bash_completion complete \$COMP_CWORD "\${COMP_WORDS[@]}") )
   return 0;
}

complete -F _manacli manacli
EOF
    chmod a+x /usr/share/bash-completion/completions/manacli ${work_path}/manacli
    dos2unix -q ${work_path}/manacli
    ln -s ${work_path}/manacli /bin/manacli
fi

#############################################################################################################
if [ -d /docker-entrypoint.d ]; then
    for f in /docker-entrypoint.d/*; do
        case "$f" in
            *.sh)  echo "$0: running $f"; . "$f" ;;
            *.php) echo "$0: running php $f"; /usr/bin/php "$f" ;;
        esac
        echo
    done
fi

#############################################################################################################
if [ $# != 0 ]; then
    exec "$@"
else
    if [ -d /tmp/cron.d ]; then
      rm -rf /etc/cron.d
      cp -r /tmp/cron.d /etc/cron.d
      chmod -R 0644 /etc/cron.d &&chown -R root:root /etc/cron.d
    elif [ -d /etc/cron.d ]; then
      echo "---------------------------------------------------------"
      echo "cron command needs permission as follows:"
      echo "chmod -R 0644 /etc/cron.d; chown -R root:root /etc/cron.d"
      echo "---------------------------------------------------------"
    else
      exec tail -f /dev/null
    fi

    if [ -d /etc/cron.d ]; then
      syslogd -O /var/log/cron/cron.log\
        &&cron -L 15\
        &&exec tail -f -n 1 /var/log/cron/cron.log
    fi
fi