#!/usr/bin/env bash
set -e

#############################################################################################################
work_path=/var/www/html
if [[ -f $work_path/manacli ]]; then
	if [[ ! -e /etc/bash_completion.d/manacli ]]; then
	cat << EOF > /etc/bash_completion.d/manacli
#!/bin/bash

_manacli(){
   COMPREPLY=( \$($work_path/manacli.php bash_completion complete \$COMP_CWORD "\${COMP_WORDS[@]}") )
   return 0;
}

complete -F _manacli manacli
EOF
	chmod a+x /etc/bash_completion.d/manacli
	fi

	dos2unix -q $work_path/manacli
	chmod a+x $work_path/manacli
	dos2unix -q $work_path/manacli.php
	chmod a+x $work_path/manacli.php
	if [[ ! -e /bin/manacli ]]; then
		ln -s $work_path/manacli /bin/manacli
	fi
fi

#############################################################################################################
for dir in data tmp runtime; do
dst=/var/www/html/${dir};
if [ -d "$dst" ]; then
  chmod a+rw $dst;
fi
done

#############################################################################################################
for f in /docker-entrypoint.d/*; do
	case "$f" in
		*.sh)  echo "$0: running $f"; . "$f" ;;
		*.php) echo "$0: running php $f"; /usr/bin/php "$f" ;;
		*)     echo "$0: ignoring $f" ;;
	esac
	echo
done

#############################################################################################################
if [ $# == 0 ]; then
	exec php-fpm7.0 --nodaemonize
elif [ $1 == "run" ]; then
  case ${2:-'--help'} in
	fpm)
		exec php-fpm7.0 --nodaemonize;;
	cron)
	    syslogd -O /var/log/cron/cron.log; cron -L 15;exec tail -f -n 1 /var/log/cron/cron.log;;
	cli)
	    exec tail -f -n 0 /bin/bash;;
	-h|--help)
		echo " run fpm";
		echo " run cron";;
	esac
else	
	exec "$@"
fi
