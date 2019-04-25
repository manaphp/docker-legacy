#!/bin/bash
set -xe
#execute *.js files
if [ -d /docker-entrypoint-initdb.d/js/ ]; then
    for file in /docker-entrypoint-initdb.d/js/*
    do
        echo --------------------------------------------------------------------------------;
        case $file in
            *.js) echo "mongo execute js: $file"; mongo --quiet <$file;;
            *) echo  "don't extention with .js, ignore $file" ;;
        esac
    done
fi

#import *.json data
for dir in /docker-entrypoint-initdb.d/data/*
do
    db=`basename $dir`;
    if [ -d $dir ]; then
        for file in $dir/*.json
        do
            collection=`basename $file .json`;
            cmd="mongoimport --type json --db $db --collection $collection $file";
            echo "executing $cmd";
            $cmd;
        done
    fi
done

