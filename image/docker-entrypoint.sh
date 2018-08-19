#!/usr/bin/env bash
set -e

#############################################################################################################
work_path=/var/www/html
if [[ -f ${work_path}/manacli ]] && [[ ! -e /etc/bash_completion.d/manacli ]]; then
    cat << EOF > /etc/bash_completion.d/manacli
#!/bin/bash

_manacli(){
   COMPREPLY=( \$(php ${work_path}/manacli.php bash_completion complete \$COMP_CWORD "\${COMP_WORDS[@]}") )
   return 0;
}

complete -F _manacli manacli
EOF
    chmod a+x /etc/bash_completion.d/manacli ${work_path}/manacli
    dos2unix -q ${work_path}/manacli
    ln -s ${work_path}/manacli /bin/manacli
fi

function run_fpm {
    chmod --silent a+rw /var/www/html/{data,tmp,public/uploads} || true
    exec php-fpm --nodaemonize;
}

function run_cli {
    exec tail -f -n 0 /bin/bash
}

function run_cron {
    chmod -R 0644 /etc/cron.d;chown -R root:root /etc/cron.d
    syslogd -O /var/log/cron/cron.log; cron -L 15;exec tail -f -n 1 /var/log/cron/cron.log
}

function run_help {
    echo " run fpm";
    echo " run cron"
}

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
if [ $# == 0 ]; then
    run_fpm
elif [ $1 == "run" ]; then
  case ${2:-'--help'} in
    fpm)
        run_fpm;;
    cron)
        run_cron;;
    cli)
        run_cli;;
    -h|--help)
        run_help;;
    esac
else	
    exec "$@"
fi
